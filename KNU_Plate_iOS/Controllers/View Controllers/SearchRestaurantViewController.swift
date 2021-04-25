import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class SearchRestaurantViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultTableView: UITableView!
    
    var mapPoint: MTMapPoint?
    var pointItem: MTMapPOIItem?
    
    private let viewModel: SearchRestaurantViewModel = SearchRestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    func initialize() {
        
        viewModel.delegate = self
        
        searchBar.delegate = self
        searchBar.placeholder = "방문하신 매장을 검색해 주세요."
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        initializeMapView()
    }
    

}

//MARK: - SearchRestaurantViewModelDelegate

extension SearchRestaurantViewController: SearchRestaurantViewModelDelegate {
    
    func didFetchSearchResults() {
        searchResultTableView.reloadData()
    }
}

//MARK: - MTMapViewDelegate & Map Related Methods

extension SearchRestaurantViewController: MTMapViewDelegate {
    
    func initializeMapView() {
        
        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 35.888949648310486, longitude: 128.6104881544238)),
                             zoomLevel: 1,
                             animated: true)
        
    }
    
    func updateMapWithMarker(longitude: Double, latitude: Double, placeName: String) {
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)),
                             zoomLevel: 1,
                             animated: true)
        
        mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        
        pointItem = MTMapPOIItem()
        pointItem?.showAnimationType = .springFromGround
        pointItem?.markerType = .bluePin
        pointItem?.mapPoint = mapPoint
        pointItem?.itemName = placeName
        
        
        mapView.add(pointItem)
    }
    
    // 사용자가 POI (Point of Interest) Item 아이콘(마커) 위에 나타난 말풍선(Callout Balloon)을 터치한 경우 호출
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        
        
        /// Perform Segue
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placeName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = Constants.CellIdentifier.searchedRestaurantResultCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            fatalError("Failed to dequeue searchedRestaurantResultCell")
        }
        
        /// 검색된 결과가 있을 경우
        if viewModel.totalCount != 0 {
            
            cell.textLabel?.text = viewModel.placeName[indexPath.row]
            cell.detailTextLabel?.text = viewModel.address[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mapView.removeAllPOIItems()
        let (longitude, latitude, placeName) = viewModel.fetchLocation(of: indexPath.row)
        updateMapWithMarker(longitude: longitude, latitude: latitude, placeName: placeName)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension SearchRestaurantViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let searchKeyword = searchBar.text!
        viewModel.search(with: searchKeyword)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}


