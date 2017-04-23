//
//  ProfileViewCell.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/22/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user : User! {
        didSet{
            profileNameLabel.text = user.name
            screenNameLabel.text = user.screenName
            tweetCountLabel.text = String(describing: user.tweetCount)
            followingCountLabel.text = String(describing: user.followingCount)
            followersCountLabel.text = String(describing: user.followersCount)
            if user.profileURL != nil {
                profileImageView.setImageWith(user.profileURL!)
            }
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
