import Foundation
import Alamofire

//MARK: - 신규 매장 등록할 때 필요한 Model

class NewRestaurantModel {
    
    /// 매장명
    let name: String
    
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
    //let thumbnail: [Data]?
    
    /// 매장이 위치한 문
    //var gate: String
    
    let boundary = UUID().uuidString
    
    init(name: String, contact: String, foodCategory: String, address: String, categoryName: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.contact = contact
        self.foodCategory = foodCategory
        self.address = address
        self.categoryName = categoryName
        self.latitude = latitude
        self.longitude = longitude
        
        print(UUID().uuidString)
        
        /// Initialize parameters

        /// API 호출 시 유저의 accessToken 도 같이 호출해야 함
        /// headers["accessToken"] = User.shared.accessToken 이런 식으로 해야할듯
        

        
        
    }
 
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type" : "multipart/form-data"
        "Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2MzMDMyY2UtMjFiNS00OTA1LTg2MDctNjI1OWQxZjRhNjQyIiwic3ViIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNjE5NjA0ODY2LCJleHAiOjE2MTk2MDY2NjZ9._vH4egIXqgqomTNpFclq_eXWYxfSP-YHbB_6P2MS_5A"
        //"Authorization" : User.shared.accessToken
        
    ]

}
