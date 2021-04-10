import Foundation
import Alamofire


//MARK: - 새로운 사용자 회원가입용 Model -> UserManager.shared.signUp(with model: RegisterInfoModel)

struct RegisterInfoModel {
   
    var displayName: String {
        
        didSet {
            parameters["display_name"] = displayName
        }
    }
    
    var username: String {
        
        didSet {
            parameters["user_name"] = username
        }
    }
    
    var password: String {
        
        didSet {
            parameters["password"] = password
        }
    }
    
    var email: String {
        
        didSet {
            parameters["mail_address"] = email
        }
    }
    
    /// API parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
}
