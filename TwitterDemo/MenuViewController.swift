//
//  MenuViewController.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/22/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    private var homeTimeLineNavigationController : UIViewController!
    private var profileNavigationController : UIViewController!
    private var mentionsNavigationController : UIViewController!
    var menus = ["Timeline","Profile","Mentions"]
    
    var viewControllers : [UIViewController] = []
    var hamBurgerViewController : HamBurgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeTimeLineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        viewControllers.append(homeTimeLineNavigationController)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        viewControllers.append(profileNavigationController)
        
        hamBurgerViewController.contentViewController = homeTimeLineNavigationController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamBurgerViewController.contentViewController = viewControllers[indexPath.row]
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
