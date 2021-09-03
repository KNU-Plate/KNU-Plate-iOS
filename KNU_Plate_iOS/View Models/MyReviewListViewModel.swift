import Foundation

protocol ReviewListViewModelDelegate: AnyObject {
    func didFetchReviewListResults()
    func didFetchEmptyReviewListResults()
    func didDeleteMyReview()
    
    func failedFetchingReviewListResults(with error: NetworkError)
    func failedDeletingMyReview(with error: NetworkError)
}

class MyReviewListViewModel {
    
    //MARK: - Object Properties
    weak var delegate: ReviewListViewModelDelegate?
    
    var reviewList: [ReviewListResponseModel] = []
    
    var selectedIndex: IndexPath?
    
    var isFetchingData: Bool = false
    
    var indexToFetch: Int?

    
    //MARK: - Object Methods
    
    func getReviewImageURL(index: Int) -> URL? {
        
        let files = self.reviewList[index].reviewImageFileFolder?.files
        
        if let files = files, files.count > 0 {
            do {
                let url = try files[0].path.asURL()
                return url
            } catch {
                print("❗️ error in getReviewImageURL: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func getProfileImageURL(index: Int) -> URL? {
        
        let files = self.reviewList[index].userInfo.fileFolder?.files
        if let files = files, files.count > 0 {
            do {
                let url = try files[0].path.asURL()
                return url
            } catch {
                print("❗️ error in getProfileImageURL: \(error.localizedDescription)")
            }
        }
        return nil
    }

    
    func fetchReviewList() {
        
        isFetchingData = true
        
        let model = FetchReviewListRequestDTO(mallID: nil, cursor: indexToFetch, isMyReview: "Y")
        
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
                
            case .failure(let error):
                self.delegate?.failedFetchingReviewListResults(with: error)
            }
        }
    }
    
    func deleteMyReview(reviewID: Int) {
        
        UserManager.shared.deleteMyReview(reviewID: reviewID) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(_):
                self.delegate?.didDeleteMyReview()
                
            case .failure(let error):
                self.delegate?.failedDeletingMyReview(with: error)
            }
        }
    }
    
    func resetValues() {
        
        reviewList.removeAll()
        indexToFetch = 0
        isFetchingData = false
    }
}
    

