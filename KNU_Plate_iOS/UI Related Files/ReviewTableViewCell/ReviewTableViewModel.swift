import Foundation

//MARK: - ReviewTableViewCell 을 위한 ViewModel

class ReviewTableViewModel {
    
    var reviewID: Int = 0
    
    var userID: String = ""
    
    var userProfileImageFolderID: String? {
        
        didSet {
            DispatchQueue.global(qos: .userInitiated).sync {
                self.fetchProfileImageURL(with: self.userProfileImageFolderID!)
            }
        }
    }
    
    var userProfileImageURL: URL?
    
    var userProfileImage: UIImage = UIImage(named: "default profile image")!
    
    var userNickname: String = ""
    
    var medal: Int = 3
    
    var rating: Int = 5
    
    var review: String = ""

    var reviewImagesFileFolder: FileFolder?
    

    func fetchProfileImageURL(with folderID: String) {
        
        FileManager.shared.searchFileFolder(fileFolderID: folderID) { file in
            
            self.userProfileImageURL = URL(string: file[0].path)
            
        }
    }

    


}
