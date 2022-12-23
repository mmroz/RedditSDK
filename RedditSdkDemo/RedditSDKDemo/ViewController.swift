//
//  ViewController.swift
//  RedditSDKDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import UIKit
import Combine
import RedditSDK

class ViewController: UIViewController {
    
    let sdk = RedditSDK(clientID: "5ACYamWeKBbuKhbwvCd-UQ", redirectURI: "rsdk://com.sampleapp")
    
    private var dataSource: [SDKAction] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var textArea = makeTextArea()
    private lazy var tableView = makeTableView()
    
    private var cancellables: Set<AnyCancellable> = Set()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(textArea)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            textArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textArea.heightAnchor.constraint(equalToConstant: 200),
            tableView.topAnchor.constraint(equalTo: textArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        registerSubscriptionHandlers()
    }
    
    private func registerSubscriptionHandlers() {
        sdk.$isLoggedIn.sink { [weak self] isLoggedIn in
            self?.updateViewState(isLoggedIn: isLoggedIn == true)
        }.store(in: &cancellables)
    }
    
    private func updateViewState(isLoggedIn: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = self.makeBarButton(isLoggedIn: isLoggedIn)
            self.dataSource = self.makeDataSource(isLoggedIn: isLoggedIn)
        }
    }
}

// MARK: - View Building

extension ViewController {
    private func makeTextArea() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func makeBarButton(isLoggedIn: Bool) -> UIBarButtonItem {
        if isLoggedIn {
            return UIBarButtonItem(title: "Logout", image: nil, primaryAction: UIAction { [weak self] _ in
                self?.sdk.signOut()
            }, menu: nil)
        } else {
            return UIBarButtonItem(title: "Login", image: nil, primaryAction: UIAction { [weak self] _ in
                self?.sdk.authenticate(duration: .permanent, scope: [.identity, .mysubreddits])
            }, menu: nil)
        }
    }
}

// MARK: - TableView

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = dataSource[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = action.route
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = dataSource[indexPath.row]
        action.action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func makeDataSource(isLoggedIn: Bool) -> [SDKAction] {
        guard isLoggedIn else { return [] }
        return [
            SDKAction(route: "/api/v1/me", action: { [weak self] in Task { self?.textArea.text = try! await self?.sdk.me().get().name } }),
            SDKAction(route: "/api/v1/me/karma", action: { [weak self] in Task { self?.textArea.text = try! await self?.sdk.karma().get().kind } }),
            SDKAction(route: "/api/v1/me/prefs", action: { [weak self] in Task { self?.textArea.text = try! await self?.sdk.accountPreferences().get().lang } }),
            SDKAction(route: "/api/v1/me/trophies", action: { [weak self] in Task { self?.textArea.text = try! await self?.sdk.trophies().get().kind } }),
        ]
    }
}

struct SDKAction {
    let route: String
    let action: () -> Void
}
