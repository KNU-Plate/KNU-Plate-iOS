import Foundation

protocol SearchRestaurantViewModelDelegate {
    func didFetchSearchResults()
}

class SearchRestaurantViewModel {
    
    //MARK: - Object Properties
    
    var delegate: SearchRestaurantViewModelDelegate?
    
    /// 검색어에 검색된 문서 수
    var totalCount: Int = 0
    
    /// /// 장소명, 업체명
    var placeName: [String] = []
    
    var address: [String] = []
    
    
    
    //MARK: - Object Methods
    
    func search(with keyword: String) {

        resetSearchResults()
        let searchModel = SearchRestaurantByKeywordModel(query: keyword)
        
        MapManager.shared.searchByKeyword(with: searchModel) { result in
            
            for result in result.documents {
                self.placeName.append(result.placeName)
                self.address.append(result.address)
            }
            self.totalCount = self.placeName.count
            self.delegate?.didFetchSearchResults()
        }
    }
    
    func resetSearchResults() {
        
        placeName.removeAll()
        address.removeAll()
    }
    

    

    

    
    
    
    
    
    
    
    
    
}
