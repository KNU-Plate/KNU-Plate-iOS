import UIKit
import IQKeyboardManagerSwift
import SPIndicator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("✏️ AppDelegate")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
//        Test.shared.login()
        
        
        //TEST
        if User.shared.isLoggedIn == true {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: Constants.StoryboardID.mainTabBarController)
            window?.rootViewController = mainTabBarController
            
            
            UserManager.shared.loadUserProfileInfo { [weak self] result in
                
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("\(error.errorDescription)")
                }
            }
        
            
        } else {
            
            //TODO: 아래 수정
            let storyboard = UIStoryboard(name: "UserRegister", bundle: nil)
            let initialController = storyboard.instantiateViewController(identifier: Constants.StoryboardID.registerNavigationController)
            window?.rootViewController = initialController
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

