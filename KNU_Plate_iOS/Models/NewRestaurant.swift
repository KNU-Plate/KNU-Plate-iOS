import Foundation

// 새 맛집을 등록할 때 필요한 Model

class NewRestaurant: Codable {
    
    var name: String = ""
    var gate: String = ""
    var foodCategory: String = "한식"
    var rating: Int = 3
    var userReview: String = ""
   
    
    // 추가로 뭐 필요한지 생각해보기
    
}
