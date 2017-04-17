//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/15/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "rM9OhsO8WL5FM0oPJa4uJ4JJ8", consumerSecret: "KNBw0d9xBU5gcY7Gtx72AL9NQYxPf1R6BsM7w8iB8ZZdDYIkdB")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func favorite(tweetId:Int, success : @escaping (NSDictionary)-> (), failure: @escaping (Error)->()){
        
        let parameters: [String : AnyObject] = ["id": tweetId as AnyObject]
        post("/1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            let responseData = response as! NSDictionary
            success(responseData)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweetId:Int, success : @escaping (NSDictionary)-> (), failure: @escaping (Error)->()){        
        post("1.1/statuses/retweet/\(String(tweetId)).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            let responseData = response as! NSDictionary
            success(responseData)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func tweet(status: String, inReplyTo: Int?, success : @escaping (NSDictionary)-> (), failure: @escaping (Error)->()){
        var parameters: [String : AnyObject] = ["status": status as AnyObject]
        
        if inReplyTo != nil {
           parameters["in_reply_to_status_id"] = inReplyTo as AnyObject
        }
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            let responseData = response as! NSDictionary
            success(responseData)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (taskl:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)

            success (tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure (error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (taskl:URLSessionDataTask, response:Any?) in
            let userDictonary = response as! NSDictionary
            
            let user = User(dictionary:userDictonary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://auth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token="+requestToken.token)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error!) in
            print("error")
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    
    func handleOpenUrl (url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()

            }, failure: { (error: Error) in
                self.loginFailure!(error)
            })
            
            
        }, failure: { (error:Error!) in
            self.loginFailure!(error)
        })
        
    }

}
