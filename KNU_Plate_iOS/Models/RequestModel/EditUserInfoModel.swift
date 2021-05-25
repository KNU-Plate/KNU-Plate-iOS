import Foundation
import Alamofire


//MARK: - 프로필 정보 수정용 Model

struct EditUserInfoModel {
    
    let password: String?
    let nickname: String?
    let userProfileImage: Data?
    var removeUserProfileImage: String = "N"
    
    init(password: String) {
        
        self.password = password
        self.nickname = nil
        self.userProfileImage = nil
    }
    
    init(nickname: String) {
        
        self.nickname = nickname
        self.password = nil
        self.userProfileImage = nil
    }
    
    init(userProfileImage: Data) {
        
        self.userProfileImage = userProfileImage
        self.password = nil
        self.nickname = nil
    }
    
//    init(removeUserProfileImage: Bool) {
//
//        self.password = nil
//        self.nickname = nil
//        self.userProfileImage = nil
//        self.removeUserProfileImage = "Y"
//    }
  
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Authorization" : User.shared.accessToken
    ]
}
