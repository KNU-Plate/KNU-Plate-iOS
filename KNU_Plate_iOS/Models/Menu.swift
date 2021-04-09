import Foundation

class Menu: Codable {
    
    var menuName: String
    var oneLineReview: String
     
    public init() {
        self.menuName = ""
        self.oneLineReview = ""
    }
}
