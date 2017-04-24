//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/15/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onLogOut(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        
    }
    var tweets: [Tweet] = []
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeLine(_:)), for: UIControlEvents.valueChanged)

        tableView.insertSubview(refreshControl, at: 0)

        
        tableView.delegate=self
        tableView.dataSource=self
        let cellNib = UINib(nibName: "TweetViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "TweetViewCell")

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        reloadTimeLine(refreshControl)
    }
    
    func reloadTimeLine(_ refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
        cell.tweet = tweets[indexPath.row]
        cell.accessoryType = .none
        cell.refreshTimeLine = {() -> Void in
            self.refreshTimeLine()
        }
        cell.showProfile = { (user:User) in
            self.user = user
            self.performSegue(withIdentifier: "showProfileSegue", sender: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        let cell = tableView.cellForRow(at: indexPath)

        self.performSegue(withIdentifier: "tweetDetailSegue", sender: cell)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshTimeLine(){
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            let cell = sender as! UITableViewCell
            var indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let destinationViewController = segue.destination as! TweetViewController
            destinationViewController.tweet = tweet

        }else if (segue.identifier == "replyFromHome"){
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                let indexPath = self.tableView.indexPath(for: cell)
                let tweet = tweets[(indexPath?.row)!]
                let nvc = segue.destination as! UINavigationController
                let vc = nvc.topViewController as! ReplyViewController
                vc.refreshTimeLine = {() -> Void in
                    self.refreshTimeLine()
                }
                vc.tweet = tweet
            }
        }else if (segue.identifier == "composeTweet"){
            
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.topViewController as! ComposeViewController
            vc.refreshTimeLine = {() -> Void in
                self.refreshTimeLine()
            }
        }else if (segue.identifier == "showProfileSegue"){
            let vc = segue.destination as! ProfileViewController
            
            vc.user = user
        }
    }
    


}
