import Foundation
import ProgressHUD

protocol ReviewListViewModelDelegate {
    func didFetchReviewListResults()
}


class ReviewListViewModel {
    
    //MARK: - Object Properties
    var delegate: ReviewListViewModelDelegate?
    
    var page: Int = 0
    
    var reviewList: [ReviewListResponseModel]?
    
    var selectedIndex: IndexPath?
    
    //MARK: - Object Methods
    
    func fetchReviewList(of mallID: Int) {
  
        let model = FetchReviewListModel(mallID: mallID, page: page)
    
        RestaurantManager.shared.fetchReviewList(with: model) { responseModel in
            
            self.reviewList = responseModel
            print(responseModel)
            self.delegate?.didFetchReviewListResults()
        }
    }
    
}
