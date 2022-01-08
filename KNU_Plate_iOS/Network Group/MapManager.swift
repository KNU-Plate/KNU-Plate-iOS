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
    func searchByKeyword(
        with model: SearchRestaurantRequestDTO,
        completion: @escaping ((Result<SearchRestaurantByKeywordResponseModel,NetworkError>) -> Void)
    ) {
        
        AF.request(
            searchByKeywordRequestURL,
            method: .get,
            parameters: model.parameters,
            headers: model.headers
        ).responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let decodedData = try JSONDecoder().decode(SearchRestaurantByKeywordResponseModel.self,
                                                               from: response.data!)
                    completion(.success(decodedData))
                    
                } catch {
                    completion(.failure(.internalError))
                    print("There was an error decoding JSON Data (KakaoMap)")
                }
            default:
                completion(.failure(.internalError))
                print("default activated in MAPMANAGER")
            }
        }
    }
}
