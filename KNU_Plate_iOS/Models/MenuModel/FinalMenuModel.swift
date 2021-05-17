import Foundation

//MARK: - "리뷰 등록" 할 때 필요한 메뉴 Model

class FinalMenuModel: Encodable {
    
    var menuID: Int
    var isGood: String
    
    init(menuID: Int, isGood: String) {
        self.menuID = menuID
        self.isGood = isGood
    }
    
    enum CodingKeys: String, CodingKey {
        
        case menuID = "menu_id"
        case isGood = "is_like"
    }
}
