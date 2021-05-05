import Foundation
import Alamofire

//MARK: - 아이디 중복 체크용 Model -> UserManager.shared.checkUserNameDuplication()

struct CheckDuplicateModel {
    
    let userName: String?
    let displayName: String?
    
    init(username: String) {
        
        self.userName = username
        parameters["user_name"] = username
    }
    
    init(displayName: String) {
        
    }
    

    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": User.shared.accessToken
    ]
}
