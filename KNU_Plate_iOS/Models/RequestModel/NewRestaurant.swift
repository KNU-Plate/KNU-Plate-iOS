import Foundation
import Alamofire

//MARK: - 신규 매장 등록할 때 필요한 Model

class NewRestaurant {
    
    /// 매장명
    let name: String
    
    /// 매장 연락처
    let contact: String?
    
    /// 음식 카테고리
    let foodCategory: String
    
    /// 매장 위치
    let address: String
    
    /// Y 좌표값, 경위도인 경우 latitude(위도)
    let latitude: Double
    
    /// X 좌표값, 경위도인 경우 longitude (경도)
    let longitude: Double
    
    /// 매장 관련 이미지
    //let thumbnail: [Data]?
    
    /// 매장이 위치한 문
    //var gate: String
    
    init(name: String, contact: String, foodCategory: String, address: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.contact = contact
        self.foodCategory = foodCategory
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
        /// Initialize parameters
        parameters["mall_name"] = name
        parameters["contact"] = contact
        parameters["category_name"] = foodCategory
        parameters["address"] = address
        parameters["latitude"] = latitude
        parameters["longitude"] = longitude
        
        
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "multipart/form-data"
    ]

}
