import Foundation
import UIKit

struct Constants {

    struct Color {
        
        static let appDefaultColor = "AppDefaultColor"
    }
    
    struct StoryboardID {
        
        static let restaurantCollectionViewController = "RestaurantCollectionViewController"
        static let restaurantViewController = "RestaurantViewController"
        static let welcomeViewController = "WelcomeViewController"
        static let loginViewController = "LoginViewController"
        static let registerViewController = "RegisterViewController"
        static let verifyEmailViewController = "VerifyEmailViewController"
    }
    
    struct Layer {
        
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 15.0
        static let borderColor: CGColor = UIColor.lightGray.cgColor
    }
    
    struct CellIdentifier {
        
        static let newMenuTableViewCell = "newMenuTableViewCell"
        static let addFoodImageCell = "addFoodImageCell"
        static let newUserPickedFoodImageCell = "userPickedFoodImageCell"
    }
    
    
    struct XIB {
        
        static let newMenuTableViewCell = "NewMenuTableViewCell"
    }
    
    struct UserDefaultsKey {
        
        static let isLoggedIn = "isLoggedIn"
        static let username = "username"
        static let password = "password"
        
        //TODO: - accessToken, refreshToken, expires, expires_refresh 도 다 저장해야되는지 준수씨랑 상의
        
    }
    
    static let API_BASE_URL = "http://3.35.58.40:4100/api/"
    
    
    
    static let gateNames: [String] = ["북문", "정/쪽문", "동문", "서문"]
    static let heightPerWidthRestaurantCell: CGFloat = 1.1
    
    
    
}
