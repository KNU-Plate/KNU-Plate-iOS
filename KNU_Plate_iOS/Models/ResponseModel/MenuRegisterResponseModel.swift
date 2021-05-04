import Foundation

//MARK: - 신규 메뉴 등록 후 성공 시 반환되는 Model

struct MenuRegisterResponseModel: Decodable {
    
    
    let menuID: Int
    let mallID: Int
    let menuName: String
    let likes: Int
    let dislikes: Int
    let dateCreated: String
    
    enum CodingKeys: String, CodingKey {
        
        case menuID = "menu_id"
        case mallID = "mall_id"
        case menuName = "menu_name"
        case likes = "like"
        case dislikes = "dislikes"
        case dateCreated = "date_create"
    }
}
