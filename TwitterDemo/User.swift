//
//  User.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/14/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagline : String?
    var tweetCount : Int
    var followingCount : Int
    var followersCount: Int
    
    var dictionary: NSDictionary?
    static var userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileURL = URL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
        
        let userHandleStr = dictionary["screen_name"] as? String
        screenName = "@\(userHandleStr!)"
        
        tweetCount = (dictionary["statuses_count"] as? Int)!
        followingCount = (dictionary["friends_count"] as? Int)!
        followersCount = (dictionary["followers_count"] as? Int)!

    }
    
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }

            }
                return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")

            }
            defaults.synchronize()

        }
    }
    
}
