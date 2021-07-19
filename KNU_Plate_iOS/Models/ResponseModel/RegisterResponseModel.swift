import Foundation

//MARK: - 회원가입 시도 후 성공 시 반환되는 Model

struct RegisterResponseModel: Decodable {
    
    let userID: String
    let username: String
    let displayName: String
    let email: String
    let dateCreated: String
    let isActive: String
    let medal: Int
    let userProfileImage: String?

    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case username = "user_name"
        case displayName = "display_name"
        case email = "mail_address"
        case dateCreated = "date_create"
        case isActive = "is_active"
        case medal = "medal_id"
        case userProfileImage = "user_thumbnail"
    }
    
}


/* 회원가입 JSON Response Body 예시

 {
   "user_id": "8a6577d6-decb-4e99-9824-7573c6cf1057",
   "user_name": "borislee",
   "password": "g7uqO+Sp1P/IhhM/7erHhhgQSgVElxH82k89uJi/56braHp9Na4SRC7R9F/NEjfjcgngSLGMayUTaUy8Mi1Ufg==",
   "display_name": "borislee",
   "mail_address": "borislee@knu.ac.kr",
   "date_create": "2021-05-10T07:13:22.000Z",
   "is_active": "Y",
   "medal_list": null,
   "user_thumbnail": null
 }

 */
