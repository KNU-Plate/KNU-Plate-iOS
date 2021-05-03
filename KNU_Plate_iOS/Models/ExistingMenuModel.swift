import Foundation

//MARK: - 이미 매장에 등록된 메뉴 정보를 받아올 때 사용하는 Model

struct ExistingMenuModel: Decodable {
    
    let menuID: Int
    let mallID: Int
    let menuName: String
    let likes: Int
    let dislikes: Int

    enum CodingKeys: String, CodingKey {
        
        case menuID = "menu_id"
        case mallID = "mall_id"
        case menuName = "menu_name"
        case likes = "like"
        case dislikes = "dislikes"
    }
    
}
