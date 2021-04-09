import Foundation

// 한 맛집에 대한 신규 리뷰 작성을 위한 Model

class NewReview: Codable {
    
    var rating: Int
//    var reviewImages: Data?              // 데이터 타입이 Data 맞는지 확인해보기 -> byte buffer 형태로 보내는게 맞는가?
    var menu: [Menu]
    var review: String
    
    public init() {
        
        self.rating = 3
        //self.reviewImages = ?
        
        self.menu = [Menu]()
        self.review = ""
    }
    
    
}


