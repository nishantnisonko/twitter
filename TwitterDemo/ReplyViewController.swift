//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/16/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit


class ReplyViewController: UIViewController {

    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var replyUserLabel: UILabel!
    
    var refreshTimeLine: (() -> Void)?

    
    var tweet : Tweet!

    @IBAction func onReply(_ sender: Any) {
        TwitterClient.sharedInstance?.tweet(status: statusTextView.text, inReplyTo: tweet.id, success: { (response: NSDictionary) in
            self.dismiss(animated: true, completion: nil)
            if self.refreshTimeLine != nil{
                self.refreshTimeLine!()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyUserLabel.text = tweet.userHandle
        statusTextView.text = "\(tweet.userHandle!) "
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
