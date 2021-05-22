import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

class ReviewTableViewModel {
    
    var reviewID: Int = 0
    
    var userID: String = ""
    
    var userProfileImageURLPath: String? {
        didSet {
            guard let urlString = userProfileImageURLPath else {
                userProfileImageURL = nil
                return
            }
            userProfileImageURL = URL(string: urlString)
        }
    }

    var userProfileImageURL: URL?
    
    var userProfileImage: UIImage = UIImage(named: "default profile image")!
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""

    var reviewImagesFileFolder: [FileInfo]?
    

    

    


}
