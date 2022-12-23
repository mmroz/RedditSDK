//
//  Router.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) async -> Result<Data, RouterError>
}

public enum RouterError: Error {
    case urlError
    case unauthorized
    case decodingError(Error)
    case transportError(Error)
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var urlSession = URLSession.shared
    
    func request(_ route: EndPoint) async -> Result<Data, RouterError> {
        guard let request = buildRequest(route) else {
            return .failure(RouterError.urlError)
        }
        do {
            let (data, response) = try await urlSession.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                return .failure(.unauthorized)
            }
            return .success(data)
        } catch {
            return .failure(.transportError(error))
        }
    }
    
    private func buildRequest(_ route: EndPoint) -> URLRequest? {
        var components = URLComponents(url: route.baseURL, resolvingAgainstBaseURL: false)
        components?.path = route.path
        guard let url = components?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = route.httpMethod.rawValue
        request.allHTTPHeaderFields = route.headers
        request.httpBody = try? route.body?.encode()
        return request
    }
}
