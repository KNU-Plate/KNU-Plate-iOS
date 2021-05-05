import Foundation
import Alamofire

//MARK: - 사용자 개인 메일로 전송된 인증 코드로 최종적으로 "이메일 인증"을 할 때 사용하는 Model -> UserManager.shared.verifyEmail()

struct VerifyMailModel {
    
    let verificationCode: String
    
    init(code: String) {
        
        self.verificationCode = code
        parameters["auth_code"] = verificationCode
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
