import Foundation

protocol ReviewListViewModelDelegate: AnyObject {
    func didFetchReviewListResults()
    func didFetchEmptyReviewListResults()
    func failedFetchingReviewListResults()
}

class ReviewListViewModel {
    
    //MARK: - Object Properties
    weak var delegate: ReviewListViewModelDelegate?
    
    var reviewList: [ReviewListResponseModel] = []
    
    var selectedIndex: IndexPath?
    
    var mallID: Int = 2
    
    var isFetchingData: Bool = false
    
    var indexToFetch: Int = 0
    
    //MARK: - Object Methods
    
    func fetchReviewList(myReview: String = "N") {
        
        isFetchingData = true
        
        let model = FetchReviewListRequestDTO(mallID: mallID, page: indexToFetch)
        
        RestaurantManager.shared.fetchReviewList(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let responseModel):
                
                if responseModel.isEmpty {
                    self.delegate?.didFetchEmptyReviewListResults()
                    return
                }
                
                self.indexToFetch = responseModel[responseModel.count - 1].reviewID
                self.reviewList.append(contentsOf: responseModel)
                self.isFetchingData = false
                self.delegate?.didFetchReviewListResults()
                
            case .failure(_):
                self.delegate?.failedFetchingReviewListResults()
            }
        }
    }
    
    func resetValues() {
        
        reviewList.removeAll()
        indexToFetch = 0
        isFetchingData = false
    }
}
    

