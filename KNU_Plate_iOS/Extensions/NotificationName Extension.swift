import Foundation

extension Notification.Name {

    static let presentWelcomeVC = Notification.Name("co.kuchelin.presentWelcomeVC")
    static let refreshTokenExpired = Notification.Name("co.kuchelin.refreshTokenExpired")

    static let didMarkFavorite = Notification.Name("co.kuchelin.didMarkFavorite")
    static let didFailedMarkFavorite = Notification.Name("co.kuchelin.didFailedMarkFavorite")
    
    static let didUploadNewMall = Notification.Name("co.kuchelin.didUploadNewMall")
}
