import Foundation

protocol ReviewListViewModelDelegate {
    func didFetchReviewListResults()
    func didFetchEmptyReviewListResults()
    func failedFetchingReviewListResults()
}

class ReviewListViewModel {
    
    //MARK: - Object Properties
    var delegate: ReviewListViewModelDelegate?
    
    //var page: Int = 0
    
    var reviewList: [ReviewListResponseModel] = []
    
    var selectedIndex: IndexPath?
    
    var isPaginating: Bool = false
    
    var needToFetchMoreData: Bool = true
    
    
    //MARK: - Object Methods
    
    func fetchReviewList(pagination: Bool = false, of mallID: Int, at index: Int = 1) {
  
        if pagination {
            isPaginating = true
        }
        
        print("REVIEWLIST COUNT: \(reviewList.count)")
        if reviewList.count == index { return }
        
        let model = FetchReviewListModel(mallID: mallID, page: index)
    
        RestaurantManager.shared.fetchReviewList(with: model) { result in
            
            
            switch result {
            
            case .success(let responseModel):
                
            
                // empty 이거나 같은 값이 반환 ㅇㅇ?
                if responseModel.isEmpty {
                    self.needToFetchMoreData = false
                    self.delegate?.didFetchEmptyReviewListResults()
                    return
                }
            
                self.reviewList.append(contentsOf: responseModel)
    
                if pagination {
                    self.isPaginating = false
                }
                
                self.delegate?.didFetchReviewListResults()
                
        
            case .failure(let error):
                print("ReviewListViewModel - fetchReviewList() error")
                print(error.localizedDescription)
                
                
            }
            
        }
    }
    
}
