import UIKit
import SwiftKeychainWrapper

class User {
    
    static var shared: User = User()
    
    private init() {}
    
    /// user unique ID
    var userUID: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userID) ?? "표시 에러"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.userID)
        }
    }
    
    var username: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.username) ?? "로그인 필요"
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
            return password
        }
        set {
            self.savedPassword = KeychainWrapper.standard.set(newValue, forKey: Constants.KeyChainKey.password)
        }
    }
    
    var savedPassword: Bool = false
    
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
    
    var blockedUserUIDList: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Constants.UserDefaultsKey.blockedUserUIDList) ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.blockedUserUIDList)
        }
    }
    
    
    func resetAllUserInfo() {
        
        userUID = ""
        username = ""
        dateCreated = ""
        password = ""
   
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userID)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.username)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.medal)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.blockedUserUIDList)
        
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.accessToken)
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.refreshToken)
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.KeyChainKey.password)
        
        savedAccessToken = false
        savedRefreshToken = false
        profileImage = nil
        profileImageLink = ""
        User.shared.medal = 3
        
        print("User - resetAllUserInfo activated")
    }
    
}
