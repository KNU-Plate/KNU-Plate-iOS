import UIKit

//MARK: - 매장 리뷰 목록을 불러올 때, 각 ReviewCell에 다양한 사용자와 관련된 데이터를 표시하기 위해 필요한 구조체

struct UserDisplayModel: Decodable {
    
    let userID: String
    let username: String
    let displayName: String
    let mailAddress: String
    let medal: Int?
    let userProfileImage: [FileInfo]?
    
    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case username = "user_name"
        case displayName = "display_name"
        case mailAddress = "mail_address"
        case medal = "medal_id"
        case userProfileImage = "user_thumbnail"
    }
}

struct FileInfo: Decodable {
    
    let fileID: String
    let path: String
    let originalName: String
    let fileFolderID: String
    let uploaderID: String
    
    enum CodingKeys: String, CodingKey {
        
        case fileID = "file_id"
        case path
        case originalName = "original_name"
        case fileFolderID = "file_folder_id"
        case uploaderID = "uploader"
    }
}
