import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

protocol ReviewTableViewModelDelegate {
    
    func didReportReview()
    func failedReportingReview(with error: NetworkError)
}

class ReviewTableViewModel {
    
    var delegate: ReviewTableViewModelDelegate?
    
    var reviewID: Int = 0
    
    var userID: String = ""
    
    var userProfileImagePath: String? {
        didSet {
            guard let path = userProfileImagePath else { return }
            self.userProfileImageURL = URL(string: path)
        }
    }
    
    var userProfileImageURL: URL?
    
    var userProfileImage: UIImage = UIImage(named: "default profile image")!
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""

    var reviewImagesFileFolder: FileFolder?
    

    // 아래 함수 쓰이는 곳이 없는데 지우는거 고민
    func fetchProfileImageURL(with folderID: String) {
        
        FileManager.shared.searchFileFolder(fileFolderID: folderID) { file in
            
            self.userProfileImageURL = URL(string: file[0].path)
            
        }
    }
    
    func reportReview() {
        
        ReportManager.shared.reportReview(reviewID: reviewID,
                                          reason: ""){ result in
            
            switch result {
            
            case .success(_):
                
                self.delegate?.didReportReview()
                
            case .failure(let error):
                self.delegate?.failedReportingReview(with: error)
            }
        }
        
    }

    


}
