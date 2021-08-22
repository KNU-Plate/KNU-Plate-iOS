import Foundation
import Alamofire

//MARK: - 새로운 사용자 회원가입용 Model -> UserManager.shared.signUp(with model: RegisterInfoModel)

struct RegisterRequestDTO {
    

    let username: String
    let password: String

    var profileImage: Data? = nil
    
    init(username: String, password: String, profileImage: Data?) {

        self.username = username
        self.password = password
    
        if let image = profileImage {
            self.profileImage = image
        }
    }
    
    /// HTTP Headers
    let headers: HTTPHeaders = [

        .accept("application/json"),
        .contentType("multipart/form-data")
    ]
}
