import Foundation
import Alamofire

//MARK: - 사용자 로그인용 Model -> UserManager.shared.logIn(with model: LoginInfoModel)

struct LoginInfoModel {
    
    /// 로그인 이름
    let username: String
    
    ///비밀번호
    let password: String
    
    init(username: String, password: String) {
        
        self.username = username
        self.password = password
        
        /// Initialize parameters
        parameters["user_name"] = username
        parameters["password"] = password
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
}
