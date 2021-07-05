import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

class ReviewTableViewModel {
    
    var reviewID: Int = 0
    
    var userID: String = ""
    
    var userProfileImagePath: String?
    
    var userProfileImageURL: URL?
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""

    var reviewImagesFileFolder: FileFolder?
    
    func resetValues() {
        
        reviewID = 0
        userID = ""
        userProfileImagePath = nil
        userProfileImageURL = nil
        userNickname = ""
        medal = 1
        rating = 0
        review = ""
        reviewImagesFileFolder = nil
    }

}
