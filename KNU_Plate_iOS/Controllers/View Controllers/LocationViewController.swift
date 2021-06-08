import UIKit
import SnapKit

class LocationViewController: UIViewController, MTMapViewDelegate {

    var parentVC: RestaurantViewController?
    let mapView = MTMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}
