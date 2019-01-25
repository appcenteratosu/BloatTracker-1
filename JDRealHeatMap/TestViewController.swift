//
//  Submit_ViewController.swift
//  BloatTracker
//
//  Created by AppCenter on 10/2/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase

class TestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate,  CLLocationManagerDelegate, UITextFieldDelegate, UIApplicationDelegate{
    
    // Declaration of UI objects.
    @IBOutlet weak var cattleBloated_TextField: UITextField!
    @IBOutlet weak var cattlePasture_TextField: UITextField!
    @IBOutlet weak var cattleDead_TextField: UITextField!
    @IBOutlet weak var map_IBOutlet: MKMapView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var Pasture_type_IBOutlet: UIButton!
    @IBOutlet weak var Pasture_Label_Selected: UIButton!
    @IBOutlet weak var Pasture_type: UIPickerView!
    @IBOutlet weak var AddInfoView: UIView!
    @IBOutlet weak var addInfoStack: UIStackView!
    @IBOutlet weak var fedHay: UIButton!
    @IBOutlet weak var fedPoloxalene: UIButton!
    @IBOutlet weak var pastureFertilize: UIButton!
    @IBOutlet weak var fedIonophores: UIButton!
    @IBOutlet weak var SupplementFed: UIButton!
    @IBOutlet weak var number_of_days: UITextField!
    
    var selected = ""
    var selected1 = ""
    var selected2 = ""
    var pastureType = ""
    var Date = ""
    var Latitude = ""
    var Longitude = ""
    var cattle: [String] = [""]
    var cattle_dead:[String]=[""]
    var cattle_Pasture:[String]=[""]
    var pasturetype:[String]=[""]
    var fedhay = String()
    var fedSupplement = String()
    var fedpoloxalene = String()
    var fedlonophores = String()
    var pasturefed = String()
    
    let button = UIButton(type: UIButton.ButtonType.custom)
    let locationManager = CLLocationManager()
    var refArtists: DatabaseReference!
    var refArtists1: DatabaseReference!
    var picker_Pasture_Type = ["Pick any of these","Wheat", "Rye", "Ryegrass", "Oats", "Alfalfa", "Clover", "Other"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // toolbar items on the submit view controller page.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        cattleBloated_TextField.inputAccessoryView = toolBar
        cattlePasture_TextField.inputAccessoryView = toolBar
        cattleDead_TextField.inputAccessoryView = toolBar
        number_of_days.inputAccessoryView = toolBar
        
        // created a reference in database of bloattrackerapp as details to store the report values submitted in this page.
        map_IBOutlet.delegate = self
        self.navigationItem.hidesBackButton = false
        refArtists = Database.database().reference().child("details");
        refArtists1 = Database.database().reference().child("additional_Info");
        blurView.isHidden = true
        self.cattleBloated_TextField.delegate = self
        self.cattlePasture_TextField.delegate = self
        self.cattleDead_TextField.delegate = self
        self.number_of_days.delegate = self
        
        button.setTitle("Return", for: UIControl.State())
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(TestViewController.Done(_:)), for: UIControl.Event.touchUpInside)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // mapOutlet properties.
        map_IBOutlet.delegate = self
        map_IBOutlet.mapType = .standard
        map_IBOutlet.isZoomEnabled = true
        map_IBOutlet.isScrollEnabled = true
        
        if let coor = map_IBOutlet.userLocation.location?.coordinate{
            map_IBOutlet.setCenter(coor, animated: true)
        }
        
        Pasture_type.isHidden = true;
        Pasture_type.dataSource = self;
        Pasture_type.delegate=self;
    }
    
    @IBAction func UnwindFromReportToHome(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromReportToHome", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // finds the latitude and longitude of the mapoutlet when it loads.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            let coords = loc.coordinate
            
            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coords, span: span)
            map_IBOutlet.setRegion(region, animated: true)
            Latitude = String(coords.latitude)
            Longitude = String(coords.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            map_IBOutlet.addAnnotation(annotation)
        }
        
        map_IBOutlet.mapType = MKMapType.standard
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // total number of cell rows in picker view.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker_Pasture_Type.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker_Pasture_Type[row] as String
    }
    
    // Font name and font size of the picker view cells.
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = picker_Pasture_Type[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    // when a cell in picker view is selected that value of the cell will replace the pastureType Button title.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pastureType = picker_Pasture_Type[row]
        pasturetype.append(pastureType)
        self.blurView.isHidden = true
        Pasture_type.isHidden = true
        Pasture_Label_Selected.setTitle(pastureType, for: UIControl.State.normal)
        
    }
    
    @IBAction func AddInfoButtonPressed(_ sender: UIButton) {
        addInfoStack.isHidden = !addInfoStack.isHidden
    }
    
    // check buttons of the cattle additional information options.
    @IBAction func FedHay_Button(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedhay = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedhay = "NO"
        }
    }
    
    // check buttons of the cattle additional information options.
    @IBAction func  SupplementFed_Button(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedSupplement = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedSupplement = "NO"
        }
    }
    
    // check buttons of the cattle additional information options.
    @IBAction func FedPoloxalene_Button(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedpoloxalene = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedpoloxalene = "NO"
        }
    }
    
    // check buttons of the cattle additional information options.
    @IBAction func FedIonophores_Button(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            fedlonophores = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            fedlonophores = "NO"
        }
    }
    
    // check buttons of the cattle additional information options.
    @IBAction func PastureFertilized_Button(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "unselected-bullet") {
            sender.setImage(UIImage(named: "selected-bullet"), for: UIControl.State.normal)
            pasturefed = "YES"
        } else {
            sender.setImage(UIImage(named: "unselected-bullet"), for: UIControl.State.normal)
            pasturefed = "NO"
        }
    }
    
    // appends the details of each textfield to it's particular array respectively.
    @IBAction func Submit_Button(_ sender: Any) {
        Date = String(describing: NSDate())
        adddetails()
        
        //  date.append(String(describing: Date))
        cattle.append(cattleBloated_TextField.text!)
        cattle_dead.append(cattleDead_TextField.text!)
        cattle_Pasture.append(cattlePasture_TextField.text!)
        selected = cattleBloated_TextField.text!
        selected1 = cattleDead_TextField.text!
        selected2 = cattlePasture_TextField.text!
        
        // checks if any of the required fields are missing. If any field is empty the submit button gives a popup to enter all details.
        if(selected.isEmpty || selected1.isEmpty || selected2.isEmpty || pastureType.isEmpty){
            let failAlert = UIAlertController(title: "Alert", message: "please enter all details .", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            failAlert.addAction(okAction)
            self.present(failAlert, animated: true, completion: nil)
        }
            
            // If all the required fields are filled then this page goes to heatmap screen and displays heatmap for the report entered.
        else
        {
            
            self.performSegue(withIdentifier: "SubmitToHeatMap", sender: self)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
//            let alertController = UIAlertController(title: "Alert", message: "Report details are submitted", preferredStyle: UIAlertController.Style.alert)
//            self.present(alertController, animated: true, completion: nil)
//            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alertController.dismiss(animated: true, completion: nil)} )
        }
    }
    
    // appends the details of each textfield to it's particular array respectively.
    @IBAction func Submit_addInfo(_ sender: Any) {
        //generating a new key inside details node
        //and also getting the generated key
        let key = refArtists1.childByAutoId().key
        
        blurView.isHidden = true
        
        //creating details with the given values
        let details = ["id":key,
                       "Fed_Hay": self.fedhay as String,
                       "Fed_Supplement": self.fedSupplement as String,
                       "Fed_Poloxalene": self.fedpoloxalene as String,
                       "Fed_Ionophores": self.fedlonophores as String,
                       "Pasture Fertilized heavily": self.pasturefed as String,
                       "no_cattle_on_pasture": number_of_days.text! as String
        ]
        
        //adding the details inside the generated unique key
        refArtists1.child(key!).setValue(details)
//        let failAlert = UIAlertController(title: "Alert", message: "Futher Information is submitted", preferredStyle: UIAlertController.Style.alert)
//        self.present(failAlert, animated: true, completion: nil)
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in failAlert.dismiss(animated: true, completion: nil)} )
        
        addInfoStack.isHidden = true
    }
    
    // opens the picker view of pasture type.
    @IBAction func Pasture_Label_Pressed(_ sender: UIButton) {
        self.blurView.isHidden = false
        Pasture_type.isHidden = false
        
    }
    
    // opens the picker view of pasture type.
    @IBAction func Pasture_Type_Button(_ sender: Any) {
        self.blurView.isHidden = false
        Pasture_type.isHidden = false
        
    }
    
    // sends the details to firebase database to id : key.
    func adddetails(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refArtists.childByAutoId().key
        
        //creating artist with the given values
        let keydetails = ["id":key,
                          "no_cattleBloated": cattleBloated_TextField.text! as String,
                          "no_cattlePasture": cattlePasture_TextField.text! as String,
                          "no_cattleDead": cattlePasture_TextField.text! as String,
                          "pastureType": pastureType as String,
                          "Date_of_Submission": Date as String,
                          "Latitude": Latitude as String,
                          "Longitude": Longitude as String
        ]
        
        //adding the artist inside the generated unique key
        refArtists.child(key!).setValue(keydetails)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tab_Bar") as! TabBar_ViewController
//    self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // when the keyboard appears the view goesup.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -150
    }
    
    
    // when the keyboard is dismissed the view comes to normal position.
    @objc func doneClicked() {
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
    
    @IBAction func Tapagesture(_ sender: UITapGestureRecognizer) {
        self.number_of_days.resignFirstResponder()
        self.view.frame.origin.y = 0
        self.cattleBloated_TextField.resignFirstResponder()
        self.cattleDead_TextField.resignFirstResponder()
        self.cattlePasture_TextField.resignFirstResponder()
    }
    
    
    @objc func Done(_ sender : UIButton){
        DispatchQueue.main.async { () -> Void in
            self.cattleBloated_TextField.resignFirstResponder()
            self.cattleDead_TextField.resignFirstResponder()
            self.cattlePasture_TextField.resignFirstResponder()
            self.number_of_days.resignFirstResponder()
        }
    }
}
