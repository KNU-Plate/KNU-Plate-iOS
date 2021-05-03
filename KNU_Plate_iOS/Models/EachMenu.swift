import Foundation

class EachMenu: Encodable {
    
    var id: Int
    var isGood: String
    
    public init() {
        self.id = 0
        self.isGood = "Y"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case menuName
        case isGood = "is_like"
    }
}
