import Foundation
import Alamofire

//MARK: - 사용자 로그인용 Model -> UserManager.shared.logIn(with model: LoginInfoModel)

struct LoginInfoModel {

    var parameters: Parameters = [:]
    var headers: HTTPHeaders = [
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
    ]

    init(username: String, password: String) {
        /// Initialize parameters
        parameters["user_name"] = username
        parameters["password"] = password
    }
}
