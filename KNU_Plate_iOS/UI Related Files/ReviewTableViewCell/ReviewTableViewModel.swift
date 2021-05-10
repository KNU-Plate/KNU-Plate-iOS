import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

class ReviewTableViewModel {
    
    //let userID: Int  이것도 필요할 수도 있음(신고하기 기능을 위해)
    // 아니면 review
    
    var userProfileImage: UIImage = UIImage(named: "default_profile_image")!
    
    let userNickname: String
    
    var userMedal: Int {
        didSet { self.userMedalImage = determineUserMedalImage() }
    }
    
    var userMedalImage: UIImage = UIImage(named: "third medal")!
    
    var reviewImages: [UIImage]?
    
    let rating: Int
    
    let review: String
    
    var profileImageInDataFormat: Data? {
        didSet {
            if let profileImageAvailable = self.profileImageInDataFormat {
                self.userProfileImage = UIImage(data: profileImageAvailable)
                    ?? UIImage(named: "default_profile_image")!
            }
        }
    }
    
    var reviewImagesInDataFormat: [Data]? {
        didSet {
            
            if let reviewImagesAvailable = self.reviewImagesInDataFormat {
                for eachImage in reviewImagesAvailable {
                    let reviewImage = UIImage(data: eachImage)!
                    reviewImages?.append(reviewImage)
                }
            }
        }
    }
    
    init(profileImage: Data?, nickname: String, userMedal: Int, reviewImages: [Data]?, rating: Int, review: String ) {
        
        if let profileImageAvailable = profileImage {
            self.profileImageInDataFormat = profileImageAvailable
        }
        if let reviewImagesAvailable = reviewImages {
            self.reviewImagesInDataFormat = reviewImagesAvailable
        }
        
        self.userNickname = nickname
        self.userMedal = userMedal
        self.rating = rating
        self.review = review
    }
    
    

    func determineUserMedalImage() -> UIImage {
        
        switch userMedal {
        case 1: return UIImage(named: "first medal")!
        case 2: return UIImage(named: "second medal")!
        case 3: return UIImage(named: "third medal")!
        default: return UIImage(named: "third medal")!
        }
    }
}
