import Foundation

//MARK: - 회원가입 시도 후 성공 시 반환되는 Model

struct RegisterResponseModel: Decodable {
    
    let userID: String
    let username: String
    let password: String
    let displayName: String
    let email: String
    let dateCreated: String
    let isActive: String

    enum Codingkeys: String, CodingKey {

        case password
        case userID = "user_id"
        case userName = "user_name"
        case displayName = "display_name"
        case email = "mail_address"
        case dateCreated = "date_create"
        case isActive = "is_active"
    }
    
}


/* 회원가입 JSON Response Body 예시

{
  "user_id": "e27b8491-77bd-4652-8eae-b1d07f1224da",
  "user_name": "kevinkim2222",
  "password": "g7uqO+Sp1P/IhhM/7erHhhgQSgVElxH82k89uJi/56braHp9Na4SRC7R9F/NEjfjcgngSLGMayUTaUy8Mi1Ufg==",
  "display_name": "kevin2323",
  "mail_address": "kevinkim2586@gmail.com",
  "date_create": "2021-04-21T12:27:27.000Z",
  "is_active": "Y"
}

 */
