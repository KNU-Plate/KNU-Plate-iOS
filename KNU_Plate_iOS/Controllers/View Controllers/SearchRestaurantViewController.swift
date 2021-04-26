import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class SearchRestaurantViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultTableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    
    var mapPoint: MTMapPoint?
    var pointItem: MTMapPOIItem?
    
    private let viewModel: SearchRestaurantViewModel = SearchRestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    func initialize() {
        
        viewModel.delegate = self
        
        /// SearchBar 초기화
        searchBar.delegate = self
        searchBar.placeholder = "방문하신 매장을 검색해 주세요."
        
        /// TableView 초기화
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
        initializeMapView()
        
        /// Next Button 초기화
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
        var buttonImage: UIImage = UIImage(named: "arrow_right")!
        buttonImage = buttonImage.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30))
        nextButton.setImage(buttonImage, for: .normal)
        nextButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        
        let placeSelected = viewModel.currentlySelectedIndex
        let alertMessage = viewModel.placeName[placeSelected]
        
        let alert = UIAlertController(title: "위치가 여기 맞나요?",
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "다시 고를게요",
                                      style: .destructive,
                                      handler: { (action: UIAlertAction!) in
                                        
                                      }))
        
        alert.addAction(UIAlertAction(title: "네 맞아요!",
                                      style: .default,
                                      handler: { (action: UIAlertAction!) in
                                        
                                        self.performSegue(withIdentifier: Constants.SegueIdentifier.goToNewRestaurantVC, sender: self)
                                        
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let secondVC = storyboard.instantiateViewController(identifier: "NewRestaurantViewController")
//                                        self.show(secondVC, sender: self)

                                      }))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.SegueIdentifier.goToNewRestaurantVC {
            
            let newRestaurantVC = segue.destination as! NewRestaurantViewController
            newRestaurantVC.restaurantName = viewModel.placeName[viewModel.currentlySelectedIndex]
        }
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
        pointItem?.showDisclosureButtonOnCalloutBalloon = false
    
        mapView.add(pointItem)
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


