import Foundation

class User {
    
    //MARK: - Singleton
    static var shared: User = User()
    
    /// user unique ID
    var id: String = ""
    
    ///
    var username: String = ""
    
    /// user password
    var password: String = ""
    
    /// nickname
    var displayName: String = ""
    
    /// user email address (...@knu.ac.kr)
    var email: String = ""
    
    /// registered date
    var dateCreated: String = ""
    
    /// 활성화 상태 여부 (Y/N)
    var isActive: String = ""
     
    /// variable for medal
    var medal: String = "3"
    
    var medalImage: UIImage {
        get {
            switch self.medal {
            case "1": return UIImage(named: "first medal")!
            case "2": return UIImage(named: "second medal")!
            case "3": return UIImage(named: "third medal")!
            default: return UIImage(named: "third medal")!
            }
        }
    }
        
    var accessToken: String = ""
    
    var refreshToken: String = ""
    
    var profileImageLink: String = ""
    
    //TODO: - 매번 프로필 이미지를 다운 받을 수는 없으니 최초 한 번 다운 받고 저장 해서 medalImage처럼 get
    
    
    
    private init() {}
    
    
    //MARK: - 사용자 메달 이미지가 필요할 때 사용
    func getUserMedalInfo() -> UIImage {
        switch self.medal {
        case "1": return UIImage(named: "first medal")!
        case "2": return UIImage(named: "second medal")!
        case "3": return UIImage(named: "third medal")!
        default: return UIImage(named: "third medal")!
        }
    }
    
    
    
}
