import Foundation

//MARK: - 회원가입 시도 후 성공 시 반환되는 Model

struct RegisterResponseModel: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expires: Double
    let expires_refresh: Double
    let user: UserDisplayModel
}

//struct RegisterResponseModel: Decodable {
//
//    let userID: String
//    let username: String
//    let displayName: String
//    let email: String
//    let dateCreated: String
//    let isActive: String
//    let medal: Int
//    let userProfileImage: String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case userID = "user_id"
//        case username = "user_name"
//        case displayName = "display_name"
//        case email = "mail_address"
//        case dateCreated = "date_create"
//        case isActive = "is_active"
//        case medal = "medal_id"
//        case userProfileImage = "user_thumbnail"
//    }
//
//}

