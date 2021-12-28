import Foundation

//MARK: - 회원가입 시도 후 성공 시 반환되는 Model

struct RegisterResponseModel: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expires: Double
    let expires_refresh: Double
    let user: UserDisplayModel
}

