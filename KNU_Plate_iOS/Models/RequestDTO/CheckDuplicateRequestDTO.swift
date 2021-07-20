import Foundation
import Alamofire

//MARK: - 아이디 중복 체크용 Model -> UserManager.shared.checkDuplication()

struct CheckDuplicateRequestDTO {
    
    var parameters: Parameters = [:]
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
    ]
    
    // 아이디 중복 체크할 경우 아래 init 사용
    init(username: String) {
        
        parameters["user_name"] = username
    }
    
    // 닉네임 중복 체크할 경우에는 아래 init 사용
    init(displayName: String) {
        
        parameters["display_name"] = displayName
    }
    

}
