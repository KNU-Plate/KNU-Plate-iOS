import Foundation
import Alamofire

//MARK: - 신규 매장 등록할 때 필요한 Model

class NewRestaurantRequestDTO {
    
    /// 매장명
    let name: String
    
    /// 매장 고유 ID
    let placeID: String
    
    /// 매장 연락처
    let contact: String?
    
    /// 음식 카테고리
    let foodCategory: String
    
    /// 매장 위치
    let address: String
    
    /// 카테고리 이름 ( i.e 음식점 > 카페 > 커피전문점 > 스타벅스 )
    let categoryName: String
    
    /// Y 좌표값, 경위도인 경우 latitude(위도)
    let latitude: Double
    
    /// X 좌표값, 경위도인 경우 longitude (경도)
    let longitude: Double
    
    /// 매장 관련 이미지
    let images: [Data]?
    
    /// 매장이 위치한 문
    //var gate: String
    
    init(name: String, placeID: String, contact: String, foodCategory: String, address: String, categoryName: String, latitude: Double, longitude: Double, images: [Data]?) {
        
        self.name = name
        self.placeID = placeID
        self.contact = contact
        self.foodCategory = foodCategory
        self.address = address
        self.categoryName = categoryName
        self.latitude = latitude
        self.longitude = longitude
        self.images = images
    }
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Authorization" : User.shared.accessToken
    ]

}
