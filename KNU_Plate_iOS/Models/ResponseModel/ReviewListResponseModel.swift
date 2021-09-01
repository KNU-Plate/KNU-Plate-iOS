import Foundation

//MARK: - 특정 매장 리뷰 목록 불러오고 성공 시 반환되는 Model

struct ReviewListResponseModel: Decodable {
    
    let reviewID: Int
    let userID: String
    let mallID: Int
    let review: String
    let rating: Int
    let dateCreated: String
    let userInfo: UserDisplayModel
    let reviewImageFileFolder: FileFolder?
    
    enum CodingKeys: String, CodingKey {
        
        case reviewID = "review_id"
        case userID = "user_id"
        case mallID = "mall_id"
        case review = "contents"
        case rating = "evaluate"
        case dateCreated = "date_create"
        case reviewImageFileFolder = "file_folder"
        case userInfo = "user"
    }
}

