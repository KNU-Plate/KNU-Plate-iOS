import UIKit

class User {
    
    static var shared: User = User()
    
    /// user unique ID
    var id: String = ""
    
    var username: String = ""
    
    var password: String = ""
    
    /// nickname
    var displayName: String = ""
    
    /// user email address (...@knu.ac.kr)
    var email: String = ""
    
    /// registered date
    var dateCreated: String = ""
    
    /// 활성화 상태 여부 (Y/N)
    var isActive: String = ""
     
    var medal: Int = 3
    
    var accessToken: String = ""
    
    var refreshToken: String = ""
    
    var profileImageLink: String = ""
    
    var profileImage: UIImage?
    
    
    private init() {}
    
}
