//
//  TweetViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/15/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var reTweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    


    var tweet : Tweet!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameLabel.text = tweet.userName!
        tweetTextLabel.text = tweet.tweetText
        userHandleLabel.text = tweet.userHandle
        if tweet.profilePictureUrl != nil {
            profilePictureView.setImageWith(tweet.profilePictureUrl!)
        }
        
        
        if tweet.retweeted {
            let retweeted = UIImage(named: "retweet-action-on")
            retweetButton.imageView?.image = retweeted
        }
        
        
        if tweet.favorited {
            let favorited = UIImage(named: "like-action-on")
            favoriteButton.imageView?.image = favorited
        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myStringafd = formatter.string(from: tweet.timeStamp!)
        timeStampLabel.text = myStringafd
        
        reTweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favCount)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = tweet.userName!
        tweetTextLabel.text = tweet.tweetText
        userHandleLabel.text = tweet.userHandle
        if tweet.profilePictureUrl != nil {
            profilePictureView.setImageWith(tweet.profilePictureUrl!)
        }
        
        
        if tweet.retweeted {
            let retweeted = UIImage(named: "retweet-action-on")
            retweetButton.imageView?.image = retweeted
        }
        
        
        if tweet.favorited {
            let favorited = UIImage(named: "like-action-on")
            favoriteButton.imageView?.image = favorited
        }

        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myStringafd = formatter.string(from: tweet.timeStamp!)
        timeStampLabel.text = myStringafd

        reTweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favCount)

        // Do any additional setup after loading the view.
    }

    
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(tweetId: tweet.id, success: { (response: NSDictionary) in
            self.tweet.favorited = true
            let favorited = UIImage(named: "like-action-on")
            self.favoriteButton.imageView?.image = favorited

        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })

    }

    @IBAction func onRetweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(tweetId: tweet.id, success: { (response: NSDictionary) in
            self.tweet.retweeted = true
            let retweeted = UIImage(named: "retweet-action-on")
            self.retweetButton.imageView?.image = retweeted

        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! UINavigationController
        let vc = nvc.topViewController as! ReplyViewController
        vc.tweet = tweet
    }

}
