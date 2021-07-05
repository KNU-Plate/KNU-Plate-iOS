import UIKit
import PanModal
import SnackBar_swift

//MARK: - 신규 맛집 등록 시 위치 검색하는 화면

class SearchRestaurantViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
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
        let placeName = viewModel.placeName[placeSelected]
        
        let alert = UIAlertController(title: "위치가 여기 맞나요?",
                                      message: placeName,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "다시 고를래요",
                                      style: .default,
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
            
            guard let newRestaurantVC = segue.destination as? NewRestaurantViewController else { return }
            guard let indexSelected = viewModel.currentlySelectedIndex else { return }
            
            let restaurantDetails = viewModel.getRestaurantDetails(for: indexSelected)
            newRestaurantVC.configure(with: restaurantDetails)
        }
    }
}

//MARK: - SearchRestaurantViewModelDelegate

extension SearchRestaurantViewController: SearchRestaurantViewModelDelegate {

    func didFetchSearchResults() {
        
        guard let searchModalVC = self.storyboard?.instantiateViewController(identifier: "SearchListViewController")
                as? SearchListViewController else { return }

        searchModalVC.placeName = viewModel.placeName
        searchModalVC.address = viewModel.address
        searchModalVC.searchResultCount = viewModel.placeName.count
        searchModalVC.delegate = self
        
        presentPanModal(searchModalVC)
    }
    
    func failedFetchingSearchResults(with error: NetworkError) {
        print("❗️ failedFetchingSearchResults")
        SnackBar.make(in: self.view,
                      message: error.errorDescription,
                      duration: .lengthLong).show()
    }
}

//MARK: - SearchListDelegate

extension SearchRestaurantViewController: SearchListDelegate {
    
    func didChoosePlace(index: Int) {
        
        
        mapView.removeAllPOIItems()
        let (longitude, latitude, placeName) = viewModel.fetchLocation(of: index)
        updateMapWithMarker(longitude: longitude, latitude: latitude, placeName: placeName)
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
        
        mapView.layer.cornerRadius = 30
        mapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
//TODO: - 아래는 지우는거 고민

extension SearchRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placeName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = Constants.CellIdentifier.searchedRestaurantResultCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            fatalError()
        }
        
        /// 검색된 결과가 있을 경우
        if viewModel.totalCount != 0 {
            
            cell.textLabel?.text = viewModel.placeName[indexPath.row]
            cell.detailTextLabel?.text = viewModel.address[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("✏️ viewModel.totalCount == \(viewModel.totalCount)")
        
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
        
        guard let searchKeyword = searchBar.text else { return }
   
        
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
        initializeMapView()
        initializeButton()
    }
    
    func initializeSearchBar() {

        searchBar.delegate = self
        searchBar.placeholder = "방문하신 매장을 검색해 주세요."
    }
    
    func initializeButton() {
        
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
        var buttonImage: UIImage = UIImage(named: Constants.Images.rightArrow)!
        buttonImage = buttonImage.scalePreservingAspectRatio(targetSize: CGSize(width: 30,
                                                                                height: 30))
        nextButton.setImage(buttonImage, for: .normal)
        nextButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    }
}


