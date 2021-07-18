import Foundation
import Alamofire

//MARK: - 특정 매장에 대한 리뷰 목록을 불러올 때 사용하는 Model

struct FetchReviewListRequestDTO {
    
    var parameters: Parameters = [:]
    var headers: HTTPHeaders = [
        "accept": "application/json"
    ]

    init(mallID: Int?, cursor: Int?, isMyReview: String) {
    
        parameters["mall_id"] = mallID
        parameters["cursor"] = cursor
        parameters["myReview"] = isMyReview
        
        if isMyReview == "Y" {
            headers["Authorization"] = User.shared.accessToken
        }
    }
}
