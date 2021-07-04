import Foundation
import Alamofire

// MARK: - 매장 목록 조회시 사용되는 Request Model
struct FetchRestaurantListModel {
    /// API Parameters
    var parameters: Parameters = [:]
    let headers: HTTPHeaders = [
        "accept": "application/json"
    ]
    
    init(mallName: String? = nil, categoryName: String? = nil, gateLocation: String? = nil, cursor: Int? = nil) {
        // Initialize parameters
        parameters["mall_name"] = mallName
        parameters["category_name"] = categoryName
        parameters["gate_location"] = gateLocation
        parameters["cursor"] = cursor
    }
}
