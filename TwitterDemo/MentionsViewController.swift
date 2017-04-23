//
//  MentionsViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/23/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        let cellNib = UINib(nibName: "TweetViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "TweetViewCell")
                tableView.estimatedRowHeight = 100
                tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            
        })

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.performSegue(withIdentifier: "mentionsDetailsTweetSegue", sender: cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mentionsDetailsTweetSegue" {
            let cell = sender as! UITableViewCell
            var indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let destinationViewController = segue.destination as! TweetViewController
            destinationViewController.tweet = tweet
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
            cell.tweet = tweets[indexPath.row]
            cell.accessoryType = .none
            return cell
        }
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
