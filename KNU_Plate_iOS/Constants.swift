import Foundation
import UIKit

struct Constants {
    
    static let API_BASE_URL = "http://3.35.58.40:4100/api/"
    

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
        static let newRestaurantViewController = "NewRestaurantViewController"
        static let reviewViewController = "ReviewViewController"
        static let locationViewController = "LocationViewController"
        static let menuViewController = "MenuViewController"
        static let sendDeveloperMessageViewController = "SendDeveloperMessageViewController"
        static let settingsViewController = "SettingsViewController"
        static let termsAndConditionsViewController = "TermsAndConditionViewController"
        static let menuRecommendationViewController = "MenuRecommendationViewController"
        static let reportReviewViewController = "ReportReviewViewController"
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
        static let searchedRestaurantResultCell = "searchedRestaurantResultCell"
        static let reviewTableViewCell = "reviewTableViewCell"
        static let reviewWithoutImageTableViewCell = "reviewWithoutImageTableViewCell"
        static let myPageCell = "myPageCell"
        static let menuRecommendCell = "menuRecommendCell"
    
    }
    
    struct SegueIdentifier {
        
        static let goToNewRestaurantVC = "goToNewRestaurantVC"
        static let goSeeDetailReview = "goSeeDetailReview"
        static let goToSendMessage = "goToSendMessage"
        static let goToSettings = "goToSettings"
        static let goToTermsAndConditions = "goToTermsAndConditions"
        static let goChangeDisplayName = "goChangeDisplayName"
        static let goChangePassword = "goChangePassword"
    }
    
    
    struct XIB {
        
        static let newMenuTableViewCell = "NewMenuTableViewCell"
        static let reviewTableViewCell = "ReviewTableViewCell"
        static let reviewWithoutImageTableViewCell = "ReviewWithoutImageTableViewCell"
    }
    
    struct UserDefaultsKey {
        
        static let isLoggedIn = "isLoggedIn"
        static let username = "username"
        static let password = "password"
        
    }
    
    struct KeyChainKey {
        
        static let accessToken                  = "accessToken"
        static let refreshToken                 = "refreshToken"
        static let password                     = "password"
    }
    
    
    
    static let gateNames: [String] = ["북문", "정/쪽문", "동문", "서문"]
    static let heightPerWidthRestaurantCell: CGFloat = 1.1
    
    
    
    struct Kakao {
        
        static let App_Key = "6536c927cc48b7eef60d77d79f1a2d85"
        static let API_Key = "8c416c51ef363c393c842ad3a1ec79da"
        static let JS_Key = "0ec64d2e6e745c47c3816e69ed3caf5a"
        static let Admin_Key = "41f6c290aeeebf1584538be2eb0c3379"
    }
    
    
    
}
