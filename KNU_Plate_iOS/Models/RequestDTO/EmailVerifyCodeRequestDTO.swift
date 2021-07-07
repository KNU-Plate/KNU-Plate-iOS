import Foundation
import Alamofire

//MARK: - 회원가입을 완료한 사용자가 메일 인증을 위해 "인증 코드"를 발급 받을 때 사용하는 요청 Model -> UserManager.shared.getEmailVerificationCode()

struct EmailVerifyCodeRequestDTO {
    
    init() {}
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": User.shared.accessToken
    ]
}
