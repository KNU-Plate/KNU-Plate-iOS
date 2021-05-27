import UIKit

//MARK: - 신규 맛집 등록 시 위치 검색하는 화면

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
    
    /// 카카오 지도가 메모리를 많이 잡아먹는 것 같은데 이거 관련해서 생각해보기
    deinit {
        mapView = nil
        mapPoint = nil
    }
    
    func presentVerificationAlert() {
        
        guard let placeSelected = viewModel.currentlySelectedIndex else {
            return
        }
        let alertMessage = viewModel.placeName[placeSelected]
        
        let alert = UIAlertController(title: "위치가 여기 맞나요?",
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "다시 고를래요",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "네 맞아요!",
                                      style: .default,
                                      handler: { (action: UIAlertAction!) in
                                        
                                        self.performSegue(withIdentifier: Constants.SegueIdentifier.goToNewRestaurantVC, sender: self)
                                        
                                      }))
        self.present(alert, animated: true)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        presentVerificationAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.SegueIdentifier.goToNewRestaurantVC {
            
            let newRestaurantVC = segue.destination as! NewRestaurantViewController
            
            guard let indexSelected = viewModel.currentlySelectedIndex else {
                return
            }
            
            let restaurantName = viewModel.placeName[indexSelected]
            let address = viewModel.documents[indexSelected].address
            let contact = viewModel.documents[indexSelected].contact
            let category = viewModel.documents[indexSelected].categoryName
            let latitude = Double(viewModel.documents[indexSelected].y)!
            let longitude = Double(viewModel.documents[indexSelected].x)!
            
            // 나중에 구조체로 묶어서 한 번에 보내는 것도 고려
        
            newRestaurantVC.configure(name: restaurantName,
                                                         address: address,
                                                         contact: contact,
                                                         categoryName: category,
                                                         latitude: latitude,
                                                         longitude: longitude)
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
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 35.888949648310486,
                                                                longitude: 128.6104881544238)),
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
        pointItem?.showDisclosureButtonOnCalloutBalloon = true

        
        
        mapView.add(pointItem)
        mapView.select(pointItem, animated: true)
    
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        presentVerificationAlert()
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonRightSideOf poiItem: MTMapPOIItem!) {
        presentVerificationAlert()
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

//MARK: - UI Configuration

extension SearchRestaurantViewController {
    
    func initialize() {
        
        viewModel.delegate = self
        
        initializeSearchBar()
        initializeTableView()
        initializeMapView()
        initializeUIComponents()
    }
    
    func initializeSearchBar() {

        searchBar.delegate = self
        searchBar.placeholder = "방문하신 매장을 검색해 주세요."
    }
    
    func initializeTableView() {
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
    }
    
    func initializeUIComponents() {
        
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
        var buttonImage: UIImage = UIImage(named: "arrow_right")!
        buttonImage = buttonImage.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30))
        nextButton.setImage(buttonImage, for: .normal)
        nextButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    }
    
    
}


