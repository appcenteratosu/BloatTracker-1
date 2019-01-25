//
//  Submit_ViewController.swift
//  JDRealHeatMap
//
//  Created by OSU App Center on 1/22/19.
//  Copyright © 2019 james12345. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Submit_ViewController: UIViewController {

    // Declaration of UI objects.
    @IBOutlet weak var cattleBloated_TextField: UITextField!
    @IBOutlet weak var cattleDead_TextField: UITextField!
    @IBOutlet weak var cattlePasture_TextField: UITextField!
    
    var refCattle: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refCattle = Database.database().reference().child("details");
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        addCattle()
    }
    
    func addCattle() {
        let key = refCattle.childByAutoId().key
        
        let cattle = ["id":key,
                      "no_cattleBloated": cattleBloated_TextField.text! as String,
                      "no_cattleDead": cattleDead_TextField.text! as String,
                      "no_cattlePasture": cattlePasture_TextField.text! as String
                      ]
        
        refCattle.child(key!).setValue(cattle)
    }
}
