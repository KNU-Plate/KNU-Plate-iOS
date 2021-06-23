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
    

    // 아래 함수 쓰이는 곳이 없는데 지우는거 고민
    func fetchProfileImageURL(with folderID: String) {
        
        FileManager.shared.searchFileFolder(fileFolderID: folderID) { file in
            
            self.userProfileImageURL = URL(string: file[0].path)
            
        }
    }
    
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
