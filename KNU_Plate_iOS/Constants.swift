import Foundation
import UIKit

struct Constants {
    
    //static let API_BASE_URL = "http://3.35.58.40:4100/api/"
    static let API_BASE_URL = "http://222.104.199.114:4100/api/"
    
    
    //MARK: - Identifiers
    
    struct StoryboardID {
        
        // Register & Login
        static let welcomeViewController                    = "WelcomeViewController"
        static let loginViewController                      = "LoginViewController"
        static let registerViewController                   = "RegisterViewController"
        static let verifyEmailViewController                = "VerifyEmailViewController"
        
        // Home Tab
        static let restaurantCollectionViewController       = "RestaurantCollectionViewController"
        static let restaurantInfoViewController             = "RestaurantInfoViewController"
        static let restaurantImageViewController            = "RestaurantImageViewController"
        static let newRestaurantViewController              = "NewRestaurantViewController"
        static let searchRestaurantViewController           = "SearchRestaurantViewController"
        static let searchListViewController                 = "SearchListViewController" 
        static let reviewDetailViewController               = "ReviewDetailViewController"
        static let menuRecommendationViewController         = "MenuRecommendationViewController"
        static let newReviewViewController                  = "NewReviewViewController"
        
        // Favorites Tab
        
         
        // My Page Tab
        static let sendDeveloperMessageViewController       = "SendDeveloperMessageViewController"
        static let myReviewListViewController               = "MyReviewListViewController"
        static let settingsViewController                   = "SettingsViewController"
        static let termsAndConditionsViewController         = "TermsAndConditionViewController"
        static let reportReviewViewController               = "ReportReviewViewController"
        static let noticeViewController                     = "NoticeViewController"
        static let noticeDetailViewController               = "NoticeDetailViewController"
        static let developerInfoViewController              = "DeveloperInformationViewController"
        static let openSourceInfoViewController             = "OpenSourceInfoViewController"
        
        static let myPageVCStoryBoardID                     = [
                                                                noticeViewController,
                                                                myReviewListViewController,
                                                                settingsViewController,
                                                                sendDeveloperMessageViewController,
                                                                termsAndConditionsViewController,
                                                                developerInfoViewController,
                                                                openSourceInfoViewController,
                                                                ]
        static let myPageVCOptions                          = [ "공지사항",
                                                                "내가 쓴 리뷰",
                                                                "설정",
                                                                "개발자에게 건의사항 보내기",
                                                                "서비스 이용약관",
                                                                "개발자 정보",
                                                                "오픈 소스 라이센스"
                                                                ]
    }
    

    struct CellIdentifier {
        
        static let newMenuTableViewCell                 = "newMenuTableViewCell"
        static let addFoodImageCell                     = "addFoodImageCell"
        static let newUserPickedFoodImageCell           = "userPickedFoodImageCell"
        static let searchedRestaurantResultCell         = "searchedRestaurantResultCell"
        static let reviewTableViewCell                  = "reviewTableViewCell"
        static let reviewWithoutImageTableViewCell      = "reviewWithoutImageTableViewCell"
        static let myPageCell                           = "myPageCell"
        static let noticeCell                           = "noticeCell"
        static let menuRecommendCell                    = "menuRecommendCell"
        static let locationTableViewCell                = "locationTableViewCell"
    }
    
    struct SegueIdentifier {
        
        static let goToNewRestaurantVC          = "goToNewRestaurantVC"
        static let goSeeDetailReview            = "goSeeDetailReview"
        static let goToSendMessage              = "goToSendMessage"
        static let goToSettings                 = "goToSettings"
        static let goToTermsAndConditions       = "goToTermsAndConditions"
        static let goChangeDisplayName          = "goChangeDisplayName"
        static let goChangePassword             = "goChangePassword"
        static let restaurantInfoSegue          = "RestaurantInfoSegue"
    }
    
    //MARK: - Keys
    
    struct KeyChainKey {
        
        static let accessToken                  = "accessToken"
        static let refreshToken                 = "refreshToken"
        static let password                     = "password"
    }
    
    struct UserDefaultsKey {
        
        static let isLoggedIn                   = "isLoggedIn"
        static let userID                       = "userID"
        static let username                     = "username"
        static let displayName                  = "displayName"
        static let email                        = "email"
        static let medal                        = "medal"
        
    }
    
    
    struct Kakao {
        
        static let App_Key                      = "6536c927cc48b7eef60d77d79f1a2d85"
        static let API_Key                      = "8c416c51ef363c393c842ad3a1ec79da"
        static let JS_Key                       = "0ec64d2e6e745c47c3816e69ed3caf5a"
        static let Admin_Key                    = "41f6c290aeeebf1584538be2eb0c3379"
    }
    
    //MARK: - UI Related Constants
    
    struct Images {
        
        // PlaceHolder & Default images
        static let defaultProfileImage                      = "default profile image"
        static let defaultReviewImage                       = "default review image"
        static let pickProfileImage                         = "pick profile pic(black)"
        static let defaultRestaurantTitleImage              = "restaurant title image placeholder"
        
        // MenuRecommendationTableViewCell
        static let thumbsUpInGray                           = "thumbs up(gray2)"
        static let thumbsDownInGray                         = "thumbs down(gray2)"
        static let thumbsUpInBlue                           = "thumbs up(selected,edited2)"
        static let thumbsDownInRed                          = "thumbs down(selected,edited2)"
        
        // NewMenuTableViewCell
        static let thumbsUpSelected                         = "thumbs up(selected)"
        static let thumbsUpNotSelected                      = "thumbs up(not_selected)"
        static let thumbsDownSelected                       = "thumbs down(selected)"
        static let thumbsDownNotSelected                    = "thumbs down(not_selected)"
         
        // ReviewTableViewCell
        static let multipleImageExistsIcon                  = "multiple images"
        
        // NewMenuTableViewCell
        static let deleteButton                             = "delete button"
        
        // Star Rating images
        static let starsUnfilled                            = "star rating (unfilled)"
        static let starsFilled                              = "star rating (filled)"
        
        // User Medal images
        static let firstMedal                               = "first medal"
        static let secondMedal                              = "second medal"
        static let thirdMedal                               = "third medal"
        
        // Other
        static let rightArrow                               = "arrow_right"
        static let myPageVCImageOptions                     = [ "bell.badge",
                                                                "tray.full",
                                                                "gear",
                                                                "paperplane",
                                                                "doc.text",
                                                                "info.circle",
                                                                "book.closed"
                                                                ]
    }
    
    struct XIB {
        
        static let newMenuTableViewCell             = "NewMenuTableViewCell"
        static let reviewTableViewCell              = "ReviewTableViewCell"
        static let reviewWithoutImageTableViewCell  = "ReviewWithoutImageTableViewCell"
        static let menuRecommendTableViewCell       = "MenuRecommendationTableViewCell"
    }
    
    struct Color {
        
        static let appDefaultColor  = "AppDefaultColor"
    }
    
    struct Layer {
        
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 15.0
        static let borderColor: CGColor = UIColor.lightGray.cgColor
    }
    
    static let heightPerWidthRestaurantCell: CGFloat = 1.1
    
    //MARK: - Model
    
    static let gateNames: [String]              = ["북문", "정/쪽문", "동문", "서문"]
    
    static let footCategoryArray: [String]      = [
        "🇰🇷 한식", "🇯🇵 일식", "🇨🇳 중식", "🇺🇸 양식",
        "🌎 세계음식","☕️ 카페", "🍹 술집"
    ]
    
}
