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

class Submit_ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Declaration of UI objects.
    @IBOutlet weak var cattleBloated_TextField: UITextField!
    @IBOutlet weak var cattleDead_TextField: UITextField!
    @IBOutlet weak var cattlePasture_TextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pastureTypePickerView: UIPickerView!
    @IBOutlet weak var pastureTypeLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    var refCattle: DatabaseReference!
    let locationManager = CLLocationManager()
    var Latitude = ""
    var Longitude = ""
    var pickerData: [String] = [String]()
    var selectedPastureType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refCattle = Database.database().reference().child("details");
        
        mapView.delegate = self
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
        
        refCattle.child(key!).setValue(cattle)
    }
}
