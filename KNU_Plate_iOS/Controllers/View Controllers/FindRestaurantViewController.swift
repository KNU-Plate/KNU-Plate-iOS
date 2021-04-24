import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class FindRestaurantViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        initializeMapView()

        test()
        
    
        
        
    }
    
    func test() {
        
        let searchKeyword = "카카오프렌즈"
        
        let model = SearchRestaurantByKeywordModel(query: searchKeyword)
   
        
        MapManager.shared.searchByKeyword(with: model)
    }
    
    
    
    
    
    func initializeMapView() {
        
        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
    }
    
    
    
    
}


