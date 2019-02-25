//
//  BMP_ViewController.swift
//  BloatTracker
//
//  Created by AppCenter on 10/2/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class BMP_ViewController: UIViewController {
    
    // Declaration of UI objects that are required.
    @IBOutlet weak var fill_Cattle_turnout_IBOutlet: UIButton!
    @IBOutlet weak var Feed_Cattle_Monensin_IBOutlet: UIButton!
    @IBOutlet weak var Feed_cattle_poloxalene_IBOutlet: UIButton!
    @IBOutlet weak var Check_Bloated_Cattle_IBOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let frame = UIScreen.main.bounds
        if frame.height > 670 && frame.width > 400  {
            fill_Cattle_turnout_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
            Feed_Cattle_Monensin_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
            Feed_cattle_poloxalene_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
            Check_Bloated_Cattle_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        }
        else
        {
            fill_Cattle_turnout_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
            Feed_Cattle_Monensin_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
            Feed_cattle_poloxalene_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
            Check_Bloated_Cattle_IBOutlet.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // open web page of the particular links
    @IBAction func fill_Cattle_turnout_Button(_ sender: Any) {
        let url1 = NSURL(string: "http://pods.dasnr.okstate.edu/docushare/dsweb/Get/Document-4968/ANSI-3034web.pdf")
        UIApplication.shared.open(url1! as URL)
    }
    
    // open web page of the particular links
    @IBAction func Feed_Cattle_Monensin_Button(_ sender: Any) {
        let url2 = NSURL(string: "http://pods.dasnr.okstate.edu/docushare/dsweb/Get/Document-1962/PSS-2585web.pdf")
        UIApplication.shared.open(url2! as URL)
    }
    
    // open web page of the particular links
    @IBAction func Feed_cattle_poloxalene_Button(_ sender: Any) {
        let url3 = NSURL(string: "http://pods.dasnr.okstate.edu/docushare/dsweb/Get/Document-2032/E-861web.pdf")
        UIApplication.shared.open(url3! as URL)
    }
    
    // open web page of the particular links
    @IBAction func Check_Bloated_Cattle_Button(_ sender: Any) {
        let url4 = NSURL(string: "https://www.asi.k-state.edu/doc/forage/fora38.pdf")
        UIApplication.shared.open(url4! as URL)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tab_Bar") as! TabBar_ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func UnwindFromBMPSToHome(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromBMPSToHome", sender: nil)
    }
    
}
