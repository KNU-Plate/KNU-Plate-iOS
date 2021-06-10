import Foundation

//MARK: - MenuRecommendationTableViewCell 을 위한 ViewModel

struct MenuRecommendationViewModel {
    
    var menuName: String = ""
    var likes: Int = 0
    var dislikes: Int = 0

    var likePercentage: Double {
        get {
            let total = likes + dislikes
    
            if total == 0 { return 0 }
            else { return Double(likes / total) }
        }
    }

}
