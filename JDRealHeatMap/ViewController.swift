

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController {

    // Declaration of objects
    @IBOutlet weak var mapsView: UIView!
    var map:JDSwiftHeatMap?
    var ref: DatabaseReference!
    var cattleBloatedLocations = [CLLocationCoordinate2D(latitude: 37.78, longitude: -122.0),CLLocationCoordinate2D(latitude: 37.8, longitude: -122.0)]
    
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
                self.testpointCoor.removeAll()
                for eachRecord in snapshot.children.allObjects as! [DataSnapshot] {
                    let cattleDetails = eachRecord.value as? NSDictionary
//                    let numberOfCattleBloated = cattleDetails?["no_cattleBloated"]
                    let numberOfCattleBloated = Int(cattleDetails?["no_cattleBloated"] as? String ?? "") ?? 0
                    let long = Double(cattleDetails?["Longitude"] as? String ?? "") ?? 0
                    let lat = Double(cattleDetails?["Latitude"] as? String ?? "") ?? 0

                    for _ in 0..<numberOfCattleBloated
                    {
                        self.testpointCoor.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
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
            testpointCoor.append(CLLocationCoordinate2D(latitude: lati, longitude: loti))
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
        return testpointCoor.count
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
        return testpointCoor[index]
    }
}
