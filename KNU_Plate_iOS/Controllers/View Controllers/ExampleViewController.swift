
import UIKit

class ExampleViewController: UIViewController, MTMapViewDelegate {

 
    @IBOutlet var kakaoMapView: MTMapView!
    //var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kakaoMapView = MTMapView()
        kakaoMapView.delegate = self
        kakaoMapView.baseMapType = .standard

        
//        mapView = MTMapView(frame: self.view.bounds)
//        mapView.delegate = self
//        mapView.baseMapType = .standard
//        self.view.addSubview(mapView)

    }
    

}
