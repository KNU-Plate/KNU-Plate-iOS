import UIKit
import NMapsMap

//MARK: - 신규 맛집 등록 시 위치 우선 검색

class FindRestaurantViewController: UIViewController {
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        configureNaverMapView()
        
        
    }
    
    func configureNaverMapView() {

        naverMapView.showLocationButton = true
        naverMapView.positionMode = NMFMyPositionMode.normal
        
        let camPosition =  NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
        //naverMapView.update
    }
    
    
    
    
    
}
