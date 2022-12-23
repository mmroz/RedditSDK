# RedditSDK

This package provides OAuth2 for Reddit and methods from the Reddit API with erganomic Swift bindings.

See more about Oauth2:
https://github.com/reddit-archive/reddit/wiki/OAuth2

# Usage Instructions

In XCode allow deep linking into your app:
Project > Info > URL Types and make sure that you use the same redirect URI that you used to create your application on Reddit.

You will need an Application on Reddit so go to https://www.reddit.com/prefs/apps and create an app with the same deep link URL.

In code construct the RedditSDK with the `redirectUR`L and the `ClientID` and you can call `authenticate`.
