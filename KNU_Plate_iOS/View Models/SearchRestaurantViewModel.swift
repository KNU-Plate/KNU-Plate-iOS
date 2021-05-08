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
    
    var documents: [SearchedRestaurantInfo] = []
    
    /// 현재 선택된 장소
    var currentlySelectedIndex: Int = 0
    
    //MARK: - Object Methods
    
    func search(with keyword: String) {

        resetSearchResults()
        let searchModel = SearchRestaurantByKeywordModel(query: keyword)
        
        MapManager.shared.searchByKeyword(with: searchModel) { result in
            
            self.documents = result.documents
            
            ///수정 좀 하기 -> append 말고 한 방에 value assign 
            for result in result.documents {
                
                self.placeName.append(result.placeName)
                self.address.append(result.address)
            }
            self.totalCount = self.placeName.count
            self.delegate?.didFetchSearchResults()
        }
    }
    
    func fetchLocation(of index: Int) -> (Double, Double, String) {
        
        let placeName = documents[index].placeName
        currentlySelectedIndex = index
        
        if let x = Double(documents[index].x), let y = Double(documents[index].y) {
            return (x, y, placeName)
        }

        /// 기본값 반환 (경북대 중앙)
        let x = 128.6104881544238       /// longitude
        let y = 35.888949648310486      /// latitude
        
        return (x, y, placeName)
    }
    
    /// search 함수에서 append 를 하기 때문에 다른 검색어로 검색할 때 reset 을 해줘야 한다.
    func resetSearchResults() {
        
        placeName.removeAll()
        address.removeAll()
    }
    
    
    
}
