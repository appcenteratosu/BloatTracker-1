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
import MapKit
import CoreLocation

@available(iOS 10.0, *)
@available(iOS 10.0, *)
class Submit_ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Declaration of UI objects.
    @IBOutlet weak var cattleBloated_TextField: UITextField!
    @IBOutlet weak var cattleDead_TextField: UITextField!
    @IBOutlet weak var cattlePasture_TextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pastureTypePickerView: UIPickerView!
    @IBOutlet weak var pastureTypeLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var AddInfoView: UIView!
    @IBOutlet weak var addInfoStack: UIStackView!
    @IBOutlet weak var fedHay: UIButton!
    @IBOutlet weak var SupplementFed: UIButton!
    @IBOutlet weak var fedPoloxalene: UIButton!
    @IBOutlet weak var fedIonophores: UIButton!
    @IBOutlet weak var pastureFertilize: UIButton!
    @IBOutlet weak var number_of_days: UITextField!
    
    var refCattle: DatabaseReference!
    let locationManager = CLLocationManager()
    var Latitude = ""
    var Longitude = ""
    var pickerData: [String] = [String]()
    var selectedPastureType: String = ""
    var fedhay = String()
    var fedSupplement = String()
    var fedpoloxalene = String()
    var fedlonophores = String()
    var pasturefed = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refCattle = Database.database().reference().child("details");
        
        mapView.delegate = self
        self.cattleBloated_TextField.delegate = self as! UITextFieldDelegate
        self.cattlePasture_TextField.delegate = self as! UITextFieldDelegate
        self.cattleDead_TextField.delegate = self as! UITextFieldDelegate
        self.number_of_days.delegate = self as! UITextFieldDelegate
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        pastureTypePickerView.delegate = self
        pastureTypePickerView.dataSource = self
        
        pickerData = ["Pick any of these","Wheat", "Rye", "Ryegrass", "Oats", "Alfalfa", "Clover", "Other"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pastureTypeLabel.text = pickerData[row]
        blurView.isHidden = true
        pastureTypePickerView.isHidden = true
    }
    
    @IBAction func pastureTypeButton(_ sender: UIButton) {
        blurView.isHidden = false
        pastureTypePickerView.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        Latitude = String(locValue.latitude)
        Longitude = String(locValue.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        mapView.addAnnotation(annotation)
        mapView.mapType = MKMapType.standard
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        addCattle()
        self.performSegue(withIdentifier: "SubmitToHeatMap", sender: self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func addCattle() {
        let key = refCattle.childByAutoId().key
        let Date = String(describing: NSDate())
        
        let cattle = ["id":key,
                      "no_cattleBloated": cattleBloated_TextField.text! as String,
                      "no_cattleDead": cattleDead_TextField.text! as String,
                      "no_cattlePasture": cattlePasture_TextField.text! as String,
                      "pastureType": pastureTypeLabel.text as! String,
                      "Date_of_Submission": Date as String,
                      "Latitude": Latitude as String,
                      "Longitude": Longitude as String
                      ]
        
        let cattleAddInfo = ["id": key,
                             "Fed_Hay": self.fedhay as String,
                             "Fed_Supplement": self.fedSupplement as String,
                             "Fed_Poloxalene": self.fedpoloxalene as String,
                             "Fed_Ionophores": self.fedlonophores as String,
                             "Pasture Fertilized heavily": self.pasturefed as String,
                             "no_cattle_on_pasture": number_of_days.text
            ] as [String : Any]
        
        refCattle.child(key!).setValue(cattleAddInfo)
        
        refCattle.child(key!).setValue(cattle)
    }
    
    @IBAction func AddInfoButtonPressed(_ sender: Any) {
        addInfoStack.isHidden = !addInfoStack.isHidden
    }
    
    @IBAction func FedHayPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedhay = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedhay = "NO"
        }
    }
    
    @IBAction func SupplementFedPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedSupplement = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedSupplement = "NO"
        }
    }
    
    @IBAction func FedPoloxalenePressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedpoloxalene = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedpoloxalene = "NO"
        }
    }
    
    @IBAction func FedIonophoresPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedlonophores = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedlonophores = "NO"
        }
    }
    
    @IBAction func PastureFertilizedPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            pasturefed = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            pasturefed = "NO"
        }
    }
    
//    @available(iOS 10.0, *)
//    @IBAction func SubmitAddInfoPressed(_ sender: UIButton) {
//        additionalCattleInfo()
//
//        let failAlert = UIAlertController(title: "Alert", message: "Futher Information is submitted", preferredStyle: UIAlertController.Style.alert)
//        self.present(failAlert, animated: true, completion: nil)
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in failAlert.dismiss(animated: true, completion: nil)} )
//        } else {
//            // Fallback on earlier versions
//        }
//
//        addInfoStack.isHidden = true
//    }
    
//    func additionalCattleInfo() {
////        let key = refCattle.childByAutoId().key
//
//
//    }
    
    @IBAction func backbutton(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromReportToHome", sender: nil)
    }
    
    // when the keyboard appears the view goesup.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -150
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.frame.origin.y = 0
        self.number_of_days.resignFirstResponder()
        self.cattleBloated_TextField.resignFirstResponder()
        self.cattleDead_TextField.resignFirstResponder()
        self.cattlePasture_TextField.resignFirstResponder()
    }
    
}
