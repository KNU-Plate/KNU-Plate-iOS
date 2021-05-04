import Foundation
import Alamofire

//MARK: - 한 매장에 대한 신규 리뷰 작성을 위한 Model

class NewReviewModel: Encodable {
    
    /// 매장 아이디
    var mallID: Int
    
    /// 메뉴 정보 -> JSON 배열 형태
    var menus: String
    
    /// 리뷰 내용 
    var review: String
    
    /// 평점
    var rating: Int
    
    /// 리뷰 이미지
    var reviewImages: [Data]?
    
    init(mallID: Int, menus: String, review: String, rating: Int,
         reviewImages: [Data]?) {
        
        self.mallID = mallID
        self.menus = menus
        self.review = review
        self.rating = rating
        self.reviewImages = reviewImages
    }
    
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
    
    "accept": "application/json",
    "Content-Type": "multipart/form-data",
    "Authorization": User.shared.accessToken
    
    ]
    
    enum CodingKeys: String, CodingKey {
        
        case mallID = "mall_id"
        case menus = "menu_info"
        case review = "contents"
        case rating = "evaluate"
        case reviewImages = "review_image"
        
    }
}


/*
 menus 보낼 때의 Model 형식 (String 형태로 보내야함)
 
 [
  {
    "menu_id":1,
    "is_like": "Y"
 
   },
   {
    "menu_id":2,
    "is_like": "Y"
   }
 ]
    
 
 */
