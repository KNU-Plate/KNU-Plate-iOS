import Foundation

protocol ReviewListViewModelDelegate {
    func didFetchReviewListResults()
    func didFetchEmptyReviewListResults()
    func failedFetchingReviewListResults()
}

class ReviewListViewModel {
    
    //MARK: - Object Properties
    var delegate: ReviewListViewModelDelegate?
    
    var reviewList: [ReviewListResponseModel] = []
    
    var selectedIndex: IndexPath?
    
    var isPaginating: Bool = false
    
    var needsToFetchMoreData: Bool = true
    
    
    //MARK: - Object Methods
    
    func fetchReviewList(pagination: Bool = false, of mallID: Int, at index: Int = 0) {
        
        if pagination {
            isPaginating = true
        }
        
        print("REVIEWLIST COUNT: \(reviewList.count)")
        
        let model = FetchReviewListModel(mallID: mallID, page: index)
        
        RestaurantManager.shared.fetchReviewList(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let responseModel):

                if responseModel.isEmpty {
                    self.needsToFetchMoreData = false
                    self.delegate?.didFetchEmptyReviewListResults()
                    return
                }
                
                let firstMallID = responseModel[0].mallID
                
                for existingReviews in self.reviewList {
                    
                    if existingReviews.mallID == firstMallID {
                        self.needsToFetchMoreData = false
                        self.delegate?.didFetchEmptyReviewListResults()
                        return
                    }
                }
                self.reviewList.append(contentsOf: responseModel)
                
                if pagination {
                    self.isPaginating = false
                }
                self.delegate?.didFetchReviewListResults()
                
                
            case .failure(let error):
                print("ReviewListViewModel - fetchReviewList() error")
                print(error.localizedDescription)
                self.delegate?.failedFetchingReviewListResults()
            }
        }
    }
    
}
