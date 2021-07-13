import Foundation

struct RestaurantInfoResponseModel: Decodable {
    let mallID: Int
    let userID: String
    let dateCreated: String
    let mallName: String
    let contact: String?
    let categoryName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let thumbnail: String?
    let evaluateAverage: Double?
    let recommendCount: Int
    let isActive: String?
    let gateLocation: String?
    let fileFolder: FileFolder?
    let menus: [ExistingMenuModel]
    let reviewCount: Int
    let myRecommend: String
    
    enum CodingKeys: String, CodingKey {
        case mallID = "mall_id"
        case userID = "user_id"
        case dateCreated = "date_create"
        case mallName = "mall_name"
        case contact
        case categoryName = "category_name"
        case address, latitude, longitude, thumbnail
        case evaluateAverage = "evaluate_average"
        case recommendCount = "recommend_count"
        case isActive = "is_active"
        case gateLocation = "gate_location"
        case fileFolder = "file_folder"
        case menus, reviewCount
        case myRecommend = "my_recommend"
    }
}
