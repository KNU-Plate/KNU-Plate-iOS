import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

struct ReviewTableViewModel {
    
    //let userID: Int  이것도 필요할 수도 있음(신고하기 기능을 위해)
    // 아니면 review
    
    var userID: String = ""
    
    var userProfileImage: UIImage = UIImage(named: "default profile image")!
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""
    
    var profileImageURL: URL?
    
    var reviewImages: [UIImage]?
    
    var reviewImagesFolderID: String? {
        didSet { fetchReviewImages() }
    }
    
    
//    init(profileImage: Data?, nickname: String, reviewImages: [Data]?, rating: Int, review: String ) {
//
//        if let profileImageAvailable = profileImage {
//            self.profileImageInDataFormat = profileImageAvailable
//        }
//        if let reviewImagesAvailable = reviewImages {
//            self.reviewImagesInDataFormat = reviewImagesAvailable
//        }
//
//        self.userNickname = nickname
//        self.rating = rating
//        self.review = review
//    }
    
    mutating func fetchReviewImages() {
        
        if let folderID = reviewImagesFolderID {
            FileManager.shared.searchFileFolder(fileFolderID: folderID) { fileInfo in
                self.downloadReviewImages(reviewFiles: fileInfo)
            }
        }
    }
    
    mutating func downloadReviewImages(reviewFiles: [FileInfo]) {
    
        for eachFile in reviewFiles {
            let downloadURL = URL(string: eachFile.path)
            let imageData = try! Data(contentsOf: downloadURL!)
            self.reviewImages?.append(UIImage(data: imageData) ?? UIImage(named: "default review image")!)
        }
    }

}
