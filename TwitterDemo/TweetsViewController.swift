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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeLine(_:)), for: UIControlEvents.valueChanged)

        tableView.insertSubview(refreshControl, at: 0)

        
        tableView.delegate=self
        tableView.dataSource=self
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
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
        if segue.identifier == "showTweet" {
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
        }
    }
    


}
