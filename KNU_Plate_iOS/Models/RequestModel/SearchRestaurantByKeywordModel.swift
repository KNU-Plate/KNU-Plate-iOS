import Foundation
import Alamofire

//MARK: - 카카오맵 화면에서 키워드로 식당 검색 시 사용하는 Model -> MapManager.shared.searchByKeyword()

struct SearchRestaurantByKeywordModel {
    
    /// X 좌표값, 경위도인 경우 longitude (경도)
    var x: String = "128.6104881544238"
    
    /// Y 좌표값, 경위도인 경우 latitude(위도)
    var y: String = "35.888949648310486"
    
    /// 중심 좌표부터의 반경거리
    /// 일단 기본 5km 로 설정
    var radius: String = "3000"
    
    /// 사용자 검색 매장
    var query: String
    
    init(query: String) {
        
        self.query = query
        
        /// Initialize parameters
        parameters["x"] = self.x
        parameters["y"] = self.y
        parameters["radius"] = self.radius
        parameters["query"] = self.query
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
    
        "Authorization": "KakaoAK \(Constants.Kakao.API_Key)"
    ]
}
