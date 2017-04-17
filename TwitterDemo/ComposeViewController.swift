//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/15/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    
    var refreshTimeLine: (() -> Void)?

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.tweet(status: statusTextView.text, inReplyTo: nil, success: { (response: NSDictionary) in
            self.dismiss(animated: true, completion: nil)
            if self.refreshTimeLine != nil{
                self.refreshTimeLine!()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = User.currentUser
        userHandleLabel.text = currentUser?.screenName!
        userNameLabel.text = currentUser?.name!
        
        if currentUser?.profileURL != nil {
            profilePictureImageView.setImageWith((currentUser?.profileURL!)!)
        }
        
        
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
