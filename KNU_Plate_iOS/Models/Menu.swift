import Foundation

class Menu: Codable {
    
    var menuName: String
    var isGood: Bool
     
    public init() {
        self.menuName = ""
        self.isGood = true
    }
}
