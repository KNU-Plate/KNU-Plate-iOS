import UIKit
import SwiftKeychainWrapper

class User {
    
    static var shared: User = User()
    
    private init() {}
    
    /// user unique ID
    var id: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userID) ?? "표시 에러"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.userID)
        }
    }
    
    var username: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.username) ?? "표시 에러"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.username)
        }
    }
    
    var password: String {
        get {
            let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: Constants.KeyChainKey.password)
            guard let password = retrievedPassword else {
                return "❗️ Invalid Password"
            }
            print("✏️ Password: \(password)")
            return password
        }
        set {
            self.savedPassword = KeychainWrapper.standard.set(newValue, forKey: Constants.KeyChainKey.password)
        }
    }
    
    var savedPassword: Bool = false
    
    /// 닉네임
    var displayName: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.displayName) ?? "표시 에러"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.displayName)
        }
    }
    
    /// user email address (...@knu.ac.kr)
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.email) ?? "표시 에러"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.email)
        }
    }

    var dateCreated: String = ""

    var isVerified: Bool = false

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
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.isLoggedIn)
        }
    }
    
    func resetAllUserInfo() {
        
        self.id = ""
        self.username = ""
        self.displayName = ""
        self.email = ""
        self.dateCreated = ""
        self.password = ""
   
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userID)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.username)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.displayName)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.email)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.medal)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isLoggedIn)
        
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.accessToken)
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.refreshToken)
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.password)
        
        self.savedAccessToken = false
        self.savedRefreshToken = false
        self.profileImage = nil
        self.profileImageLink = ""
        
        print("User - resetAllUserInfo activated")
    }
    
}
