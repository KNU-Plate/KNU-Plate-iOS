import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class SearchRestaurantViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultTableView: UITableView!
    
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

//MARK: - MTMapViewDelegate

extension SearchRestaurantViewController: MTMapViewDelegate {
    
    func initializeMapView() {
        
        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
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


