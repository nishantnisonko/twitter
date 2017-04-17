//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/14/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var retweetCount: Int = 0
    var favCount: Int = 0
    
    var retweeted:Bool = false
    var favorited:Bool = false
    
    var userName: String!
    var tweetText: String!
    var userHandle: String!
    var timeStamp: Date?
    var profilePictureUrl: URL!
    var id: Int!

    
    
    init(dictionary: NSDictionary){
        tweetText = dictionary["text"] as? String
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favorited = (dictionary["favorited"] as? Bool) ?? false

        id = dictionary["id"] as? Int
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        let user = dictionary["user"] as! NSDictionary
        userName = user["name"] as? String
        favCount = (user["favourites_count"] as? Int) ?? 0

        let profileUrlString = user["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
             profilePictureUrl = URL(string: profileUrlString)
        }
        
        let tsStrng = dictionary["created_at"] as? String
        
        
        if let tsStrng = tsStrng{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeStamp = formatter.date(from: tsStrng)
        }
        let userHandleStr = user["screen_name"] as? String
        userHandle = "@\(userHandleStr!)"
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()

        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
        
    }
}
