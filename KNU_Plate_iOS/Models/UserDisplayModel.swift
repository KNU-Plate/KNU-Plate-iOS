import UIKit

//MARK: - 매장 리뷰 목록을 불러올 때, 각 ReviewCell에 다양한 사용자와 관련된 데이터를 표시하기 위해 필요한 구조체

struct UserDisplayModel: Decodable {
    
    let userID: String
    let username: String
    let displayName: String
    let mailAddress: String
    let medal: Int
    let userProfileImageFolderID: String?
    let fileFolder: FileFolder?
    
    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case username = "user_name"
        case displayName = "display_name"
        case mailAddress = "mail_address"
        case medal = "medal_id"
        case userProfileImageFolderID = "user_thumbnail"
        case fileFolder = "file_folder"
    }
}

struct FileFolder: Decodable {
    
    let fileFolderID: String
    let dateCreated: String
    let files: [Files]?
    
    enum CodingKeys: String, CodingKey {
        
        case fileFolderID = "file_folder_id"
        case dateCreated = "date_create"
        case files
    }
}

struct Files: Decodable {
    
    let fileID: String
    let path: String
    let fileFolderID: String
    let uploader: String
    
    enum CodingKeys: String, CodingKey {
        
        case fileID = "file_id"
        case path
        case fileFolderID = "file_folder_id"
        case uploader
    }
    
}
