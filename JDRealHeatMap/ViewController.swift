

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var NumberOfDays: UIButton!
    @IBOutlet weak var NumberOfDaysArrow: UIButton!
    
    @IBOutlet weak var oneMonth: UIButton!
    @IBOutlet weak var twoMonth: UIButton!
    @IBOutlet weak var threeMonth: UIButton!
    
    @IBOutlet weak var dropDownStack: UIStackView!

    // Declaration of objects
    @IBOutlet weak var mapsView: UIView!
    var map:JDSwiftHeatMap?
    var ref: DatabaseReference!
    var cattleBloatedLocations = [CLLocationCoordinate2D(latitude: 37.78, longitude: -122.0),CLLocationCoordinate2D(latitude: 37.8, longitude: -122.0)]
    
    @IBAction func DaysDropDownTouched(_ sender: UIButton) {
        dropDownStack.isHidden = !dropDownStack.isHidden
    }
    
    @IBAction func Past1MonthClicked(_ sender: UIButton) {
        NumberOfDays.setTitle(sender.currentTitle, for: UIControl.State.normal)
        dropDownStack.isHidden = !dropDownStack.isHidden
    }
    
    @IBAction func Past2MonthsClicked(_ sender: UIButton) {
        NumberOfDays.setTitle(sender.currentTitle, for: UIControl.State.normal)
        dropDownStack.isHidden = !dropDownStack.isHidden
    }
    
    @IBAction func Past3MonthsClicked(_ sender: UIButton) {
        NumberOfDays.setTitle(sender.currentTitle, for: UIControl.State.normal)
        dropDownStack.isHidden = !dropDownStack.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addRandomData()
        ref = Database.database().reference().child("details");
        addFirebaseData()
        map = JDSwiftHeatMap(frame: mapsView.frame, delegate: self, maptype: .FlatDistinct)
        //map = JDSwiftHeatMap(frame: mapsView.frame, delegate: self, maptype: .FlatDistinct, BasicColors: [UIColor.yellow,UIColor.red], devideLevel: 2)
        map?.delegate = self
        mapsView.addSubview(map!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeToRaidusD(_ sender: Any) {
        map?.setType(type: .RadiusDistinct)
    }
    
    @IBAction func ChangeToRadiusB(_ sender: Any) {
        map?.setType(type: .RadiusBlurry)
    }
    
    @IBAction func ChangeToFlatD(_ sender: Any) {
        map?.setType(type: .FlatDistinct)
    }
    
    func addFirebaseData()
    {
        ref.observe(.value, with: { snapshot in
            
            if snapshot.childrenCount > 0 {
                self.cattleBloatedLocations.removeAll()
                for eachRecord in snapshot.children.allObjects as! [DataSnapshot] {
                    let cattleDetails = eachRecord.value as? NSDictionary
//                    let numberOfCattleBloated = cattleDetails?["no_cattleBloated"]
                    let numberOfCattleBloated = Int(cattleDetails?["no_cattleBloated"] as? String ?? "") ?? 0
                    let long = Double(cattleDetails?["Longitude"] as? String ?? "") ?? 0
                    let lat = Double(cattleDetails?["Latitude"] as? String ?? "") ?? 0

                    for _ in 0..<numberOfCattleBloated
                    {
                        self.cattleBloatedLocations.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
                        self.map?.setType(type: .RadiusBlurry)
                    }

                }
            }
            
        })
    }
    
    func addRandomData()
    {
        for _ in 0..<1
        {
            let loti:Double = Double(119) + Double(Float(arc4random()) / Float(UINT32_MAX))
            let lati:Double = Double(25 + arc4random_uniform(4)) + 2 * Double(Float(arc4random()) / Float(UINT32_MAX))
            cattleBloatedLocations.append(CLLocationCoordinate2D(latitude: lati, longitude: loti))
        }
    }
}

extension ViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let heatoverlay = map?.heatmapView(mapView, rendererFor: overlay)
        {
            return heatoverlay
        }
        else
        {
            return MKOverlayRenderer()
        }
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        map?.heatmapViewWillStartRenderingMap(mapView)
    }
    
    
}

extension ViewController:JDHeatMapDelegate
{
    func heatmap(HeatPointCount heatmap:JDSwiftHeatMap) -> Int
    {
        return cattleBloatedLocations.count
    }
    
    func heatmap(HeatLevelFor index:Int) -> Int
    {
        return 1 + index
    }
    
    func heatmap(RadiusInKMFor index: Int) -> Double {
        return Double(20 + index * 2)
    }
    
    func heatmap(CoordinateFor index:Int) -> CLLocationCoordinate2D
    {
        return cattleBloatedLocations[index]
    }
}
