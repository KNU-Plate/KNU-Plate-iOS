import Foundation
import Alamofire

//MARK: - 아이디 중복 체크용 Model -> UserManager.shared.checkDuplication()

struct CheckDuplicateRequestDTO {
    
    let userName: String?
    let displayName: String?
    
    // 아이디 중복 체크할 경우 아래 init 사용
    init(username: String) {
        
        self.userName = username
        self.displayName = nil
        parameters["user_name"] = username
    }
    
    // 닉네임 중복 체크할 경우에는 아래 init 사용
    init(displayName: String) {
        
        self.displayName = displayName
        self.userName = nil
        parameters["display_name"] = displayName
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
    ]
}
