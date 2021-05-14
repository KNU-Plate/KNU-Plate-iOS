import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

class ReviewTableViewModel {
    
    var userID: String = ""
    
    var userProfileImageURLInString: String? {
        didSet {
            userProfileImageURL = URL(string: userProfileImageURLInString!)
            downloadProfileImage()
        }
    }
    
    var userProfileImageURL: URL?
    
    var userProfileImage: UIImage = UIImage(named: "default profile image")!
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""

    var reviewImages: [UIImage]?
    
    var reviewImagesFolder: [FileInfo]? {
        didSet { downloadReviewImages() }
    }
    
    func downloadReviewImages() {
        
        if let folder = reviewImagesFolder {
            
            for eachImageInfo in folder {
                let downloadURL = URL(string: eachImageInfo.path)
                let imageData = try! Data(contentsOf: downloadURL!)
                self.reviewImages?.append(UIImage(data: imageData) ?? UIImage(named: "default review image")!)
            }
        }
    }
    
    func downloadProfileImage() {
        
        let downloadURL = URL(string: userProfileImageURLInString!)
        let imageData = try! Data(contentsOf: downloadURL!)
        self.userProfileImage = UIImage(data: imageData) ?? UIImage(named: "default review image")!
    }
    


}
