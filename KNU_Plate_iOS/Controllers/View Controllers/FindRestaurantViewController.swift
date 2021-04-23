import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class FindRestaurantViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        
    }
    

    
    
    
    
}
