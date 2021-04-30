import Foundation

class Menu: Encodable {
    
    var menuName: String
    var isGood: Bool
    
    public init() {
        self.menuName = ""
        self.isGood = true
    }
    
    enum CodingKeys: String, CodingKey {
        
        case menuName = "id"
        case isGood = "is_like"
    }
}
