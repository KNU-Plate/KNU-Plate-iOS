import Foundation
import Alamofire

//MARK: - 프로필 정보 수정용 Model

struct EditUserInfoRequestDTO {
    
    var password: String? = nil
    var nickname: String? = nil
    var userProfileImage: Data? = nil
    var removeUserProfileImage: String = "N"
    
    init(password: String) {
        
        self.password = password
    }
    
    init(nickname: String) {
        
        self.nickname = nickname
    }
    
    init(userProfileImage: Data) {
        
        self.userProfileImage = userProfileImage
    }
    
    init(removeUserProfileImage: Bool) {
        
        self.removeUserProfileImage = "Y"
    }
    
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Authorization" : User.shared.accessToken
    ]
}
