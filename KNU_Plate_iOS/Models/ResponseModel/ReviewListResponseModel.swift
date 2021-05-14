import Foundation

//MARK: - 특정 매장 리뷰 목록 불러오고 성공 시 반환되는 Model
//NOTE: - 배열로 받아와야 함 -> [ReviewListResponseModel]

struct ReviewListResponseModel: Decodable {
    
    let reviewID: Int
    let userID: String
    let mallID: Int
    let review: String
    let rating: Int
    let reviewImageFileFolderID: String?
    let userInfo: UserDisplayModel
    
    enum CodingKeys: String, CodingKey {
        
        case reviewID = "review_id"
        case userID = "user_id"
        case mallID = "mall_id"
        case review = "contents"
        case rating = "evaluate"
        case reviewImageFileFolderID = "review_image"
        case userInfo = "user"
    }
    
}

