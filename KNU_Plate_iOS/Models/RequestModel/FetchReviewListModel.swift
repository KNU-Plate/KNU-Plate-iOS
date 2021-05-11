import Foundation
import Alamofire

//MARK: - 특정 매장에 대한 리뷰 목록을 불러올 때 사용하는 Model

struct FetchReviewListModel {
    
    let mallID: Int
    let page: Int
    
    init(mallID: Int, page: Int) {
        
        self.mallID = mallID
        self.page = page
        
        /// Initialize parameters
        parameters["mall_id"] = mallID
        parameters["page"] = page
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    let headers: HTTPHeaders = [
        
        .accept("application/json"),
        .authorization(User.shared.accessToken)
    ]
}
