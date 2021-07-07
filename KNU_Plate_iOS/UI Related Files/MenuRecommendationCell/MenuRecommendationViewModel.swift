import Foundation

//MARK: - MenuRecommendationTableViewCell 을 위한 ViewModel

struct MenuRecommendationViewModel {
    
    var menuName: String = ""
    var likes: Int = 0
    var dislikes: Int = 0

    var likePercentage: Double {
        get {
            if totalLikes == 0 { return 0.0 }
            else { return Double(likes) / Double(totalLikes) }
        }
    }
    
    var totalLikes: Int {
        get {
            return likes + dislikes
        }
    }
}
