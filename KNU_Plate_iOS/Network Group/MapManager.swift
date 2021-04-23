import Foundation
import Alamofire

//MARK: - 카카오지도 관련 로직을 처리하는 클래스

class MapManager {
    
    //MARK: - Singleton
    static let shared: MapManager = MapManager()
    
    //MARK: - API Request URLs
    let searchByKeywordRequestURL = "https://dapi.kakao.com/v2/local/search/keyword.json?"
    
    
    private init() {}
    
    //MARK: - 키워드로 장소 검색
    func searchByKeyword(with model: SearchRestaurantByKeywordModel) {
        ///파라미터로 검색 키워드가 들어가야 할 것임
        
        AF.request(searchByKeywordRequestURL,
                   method: .get,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers)
            .responseJSON { (response) in
            
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                
                switch statusCode {
                
                case 200:
                    do {
                        
                    } catch {
                        
                    }
                default:
                    
                }
            
            
            
            
            }
            
            
        
        
        
        
        
    }
    

    
}
