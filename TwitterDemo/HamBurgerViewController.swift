//
//  HamBurgerViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/22/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class HamBurgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuview: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin : CGFloat!
    var menuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuViewController.willMove(toParentViewController: self)
            menuview.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    var contentViewController : UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 1
            contentView.layer.shadowOffset = CGSize.zero
            contentView.layer.shadowRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(menuViewController == nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mvc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            mvc.hamBurgerViewController = self
            self.menuViewController = mvc
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanConent(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originalLeftMargin+translation.x
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 160
                }else{
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })

        }
        
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
