//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/22/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self

        let cellNib = UINib(nibName: "TweetViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "TweetViewCell")

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.accountTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
        
        })

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.performSegue(withIdentifier: "profileTweetDetailSegue", sender: cell)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileTweetDetailSegue" {
            let cell = sender as! UITableViewCell
            var indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let destinationViewController = segue.destination as! TweetViewController
            destinationViewController.tweet = tweet
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return tweets.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
            cell.user = User.currentUser
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
            cell.tweet = tweets[indexPath.row]
            cell.accessoryType = .none
            return cell
        }
        
        
    }
    
    
}
