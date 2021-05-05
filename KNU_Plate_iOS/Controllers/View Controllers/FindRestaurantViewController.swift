import UIKit


//MARK: - 신규 맛집 등록 시 위치 우선 검색

class SearchRestaurantViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        initialize()
        //test()
      
    }
    
    func test() {
        
        let searchKeyword = "카카오프렌즈"
        
        let model = SearchRestaurantByKeywordModel(query: searchKeyword)
   
        
        MapManager.shared.searchByKeyword(with: model)
    }
    
    func initialize() {
        
        searchBar.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        initializeMapView()
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
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}

//MARK: - UISearchBarDelegate

extension SearchRestaurantViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


