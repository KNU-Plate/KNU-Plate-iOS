import UIKit
import SwiftKeychainWrapper

class User {
    
    static var shared: User = User()
    
    /// user unique ID
    var id: String = ""
    
    var username: String = ""
    
    var password: String = ""
    
    var savedPassword: Bool = false
    
    /// nickname
    var displayName: String = ""
    
    /// user email address (...@knu.ac.kr)
    var email: String = ""
    
    /// registered date
    var dateCreated: String = ""
    
    /// 활성화 상태 여부 (Y/N)
    var isActive: String = ""
     
    var medal: Int = 3
    
    var accessToken: String {
        
        get {
            let retrievedAccessToken: String? = KeychainWrapper.standard.string(forKey: Constants.KeyChainKey.accessToken)
            guard let accessToken = retrievedAccessToken else {
                return "Invalid AccessToken"
            }
            return accessToken
        }
    
    }
    
    var refreshToken: String {
        
        get {
            let retrievedRefreshToken: String? = KeychainWrapper.standard.string(forKey: Constants.KeyChainKey.refreshToken)
            guard let refreshToken = retrievedRefreshToken else {
                return "Invalid RefreshToken"
            }
            return refreshToken
        }
    }
    
    var savedAccessToken: Bool = false
    
    var savedRefreshToken: Bool = false
    
    var profileImageLink: String = ""
    
    var profileImage: UIImage?
    
    func resetAllUserInfo() {
        
        self.id = ""
        self.username = ""
        self.displayName = ""
        self.email = ""
        self.dateCreated = ""
        
        self.savedAccessToken = false
        self.savedRefreshToken = false
        self.profileImage = nil
        self.profileImageLink = ""
    
        
        
        
    }
    
    
    private init() {}
    
}
