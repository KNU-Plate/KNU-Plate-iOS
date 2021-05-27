import Foundation

//MARK: - 사용자 정보 조회 API 사용 후 성공 시 반환되는 Model

struct LoadUserInfoModel: Decodable {
    
    let userID: String
    let username: String
    let displayName: String
    let email: String
    let medal: Int
    let fileFolder: FileFolder?
    
    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case username = "user_name"
        case displayName = "display_name"
        case email = "mail_address"
        case medal = "medal_id"
        case fileFolder = "file_folder"
    }
    
}
