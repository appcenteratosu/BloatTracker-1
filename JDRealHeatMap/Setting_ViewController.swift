//
//  Setting_ViewController.swift
//  BloatTracker
//
//  Created by osuappcenter on 11/18/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit

class Setting_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Contact OSU Extension.
    @IBAction func OSUExtension_Button(_ sender: Any) {
        let url1 = NSURL(string: "http://countyext2.okstate.edu/")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url1! as URL)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tab_Bar") as! TabBar_ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // open web page of the Data Privacy
    @IBAction func Data_Privacy(_ sender: Any) {
        let url1 = NSURL(string: "https://tdc.okstate.edu/Privacy-Statement")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url1! as URL)
        } else {
            // Fallback on earlier versions
        }
    }
}
