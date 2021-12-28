import Foundation

//MARK: - 로그인 시도 후 성공 시 반환되는 Model

struct LoginResponseModel: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expires: Double
    let expires_refresh: Double
    let user: UserDisplayModel
}
