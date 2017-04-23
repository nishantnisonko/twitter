//
//  TweetViewCell.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/15/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var userHandleLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetImageView: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
//    @IBOutlet weak var profilePictureView: UIImageView!
//    
//    @IBOutlet weak var userNameLabel: UILabel!
//    
//    @IBOutlet weak var tweetTextLabel: UILabel!
//    
//    @IBOutlet weak var userHandleLabel: UILabel!
//    
//    @IBOutlet weak var timeStampLabel: UILabel!
//    
//    @IBOutlet weak var retweetImageView: UIButton!
//    
//    @IBOutlet weak var favouriteButton: UIButton!
    
    var refreshTimeLine: (() -> Void)?

    
    var tweet : Tweet!{
        didSet{
            userNameLabel.text = tweet.userName
            tweetTextLabel.text = tweet.tweetText
            userHandleLabel.text = tweet.userHandle
            if tweet.profilePictureUrl != nil {
               profilePictureView.setImageWith(tweet.profilePictureUrl!)
            }
            
            if tweet.retweeted {
                let retweeted = UIImage(named: "retweet-action-on")
                retweetImageView.imageView?.image = retweeted
            }
            
            if tweet.favorited {
                let favorited = UIImage(named: "like-action-on")
                favouriteButton.imageView?.image = favorited

            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myStringafd = formatter.string(from: tweet.timeStamp!)
            timeStampLabel.text = myStringafd
            
        }
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(tweetId: tweet.id, success: { (response: NSDictionary) in
            print(response)
            if self.refreshTimeLine != nil{
                self.refreshTimeLine!()
            }
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(tweetId: tweet.id, success: { (response: NSDictionary) in
            print(response)
            if self.refreshTimeLine != nil{
                self.refreshTimeLine!()
            }
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(profilePictureView != nil){
            profilePictureView.layer.cornerRadius = 3
        }
        if userNameLabel != nil {
            userNameLabel.preferredMaxLayoutWidth = userNameLabel.frame.size.width
        }
        // Initialization code
    }
    
    
//    @IBAction func onReplyButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "replyTweetSegue", sender: sender)
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
