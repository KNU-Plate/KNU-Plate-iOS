import Foundation
import Alamofire

//MARK: - 새로운 사용자 회원가입용 Model -> UserManager.shared.signUp(with model: RegisterInfoModel)

struct RegisterInfoModel {
    
    /// 로그인 아이디. 4자 이상 20자 제한. 영어, 숫자 입력가능
    let username: String
    
    /// 표시할 이름. 표시할 이름 2자 이상 10자 이하
    let displayName: String
    
    /// 비밀번호. 4자 이상 30자 제한.
    let password: String

    /// 메일 주소 : @knu.ac.kr 로 끝나야하는데, 검사를 클라이언트에서 해야 할 듯
    let email: String
    
    init(username: String, displayName: String, password: String, email: String) {

        self.username = username
        self.displayName = displayName
        self.password = password
        self.email = email
        
        /// Initialize parameters
        parameters["user_name"] = username
        parameters["display_name"] = displayName
        parameters["password"] = password
        parameters["mail_address"] = email
    }

    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    let headers: HTTPHeaders = [
        

        .accept("application/json"),
        .contentType("application/x-www-form-urlencoded")
    ]
}
