import Foundation
import Alamofire
import ProgressHUD

//MARK: - 매장 관련 로직을 처리하는 클래스 -> i.e 매장 등록, 매장 목록 조회, 매장 주소 검색, 매장 삭제 등

class RestaurantManager {
    
    //MARK: - Singleton
    static let shared: RestaurantManager = RestaurantManager()
    
    let interceptor = Interceptor()
    
    //MARK: - API Request URLs
    let uploadNewRestaurantRequestURL               = "\(Constants.API_BASE_URL)mall"
    let uploadNewMenuRequestURL                     = "\(Constants.API_BASE_URL)menu"
    let uploadNewReviewRequestURL                   = "\(Constants.API_BASE_URL)review"
    let fetchReviewListRequestURL                   = "\(Constants.API_BASE_URL)review"
    let fetchDetailInfoRequestURL                   = "\(Constants.API_BASE_URL)mall"
    let markFavoriteRequestURL                      = "\(Constants.API_BASE_URL)mall/recommend/"
    let fetchRestaurantListRequestURL               = "\(Constants.API_BASE_URL)mall"
    let fetchRestaurantInfoRequestURL               = "\(Constants.API_BASE_URL)mall/"
    let fetchRestaurantImagesRequestURL             = "\(Constants.API_BASE_URL)mall/review-images"
    let fetchFavoriteRestaurantListRequestURL       = "\(Constants.API_BASE_URL)mall/my-recommend"
    
    private init() {}
    
    //MARK: - 신규 매장 등록
    func uploadNewRestaurant(with model: NewRestaurantRequestDTO,
                             completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        print("✏️ \(model.name)")
        print("✏️ \(model.categoryName)")
        print("✏️ \(model.address)")
        print("✏️ \(model.latitude)")
        print("✏️ \(model.longitude)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(Data(model.name.utf8),
                                     withName: "mall_name")
            multipartFormData.append(Data(model.categoryName.utf8),
                                     withName: "category_name")
            multipartFormData.append(Data(model.address.utf8),
                                     withName: "address")
            multipartFormData.append(Data(String(model.latitude).utf8),
                                     withName: "latitude")
            multipartFormData.append(Data(String(model.longitude).utf8),
                                     withName: "longitude")
            
            if let imageArray = model.images {
                for images in imageArray {
                    multipartFormData.append(images,
                                             withName: "thumbnail",
                                             fileName: "\(UUID().uuidString).jpeg",
                                             mimeType: "image/jpeg")
                }
            }
        }, to: uploadNewRestaurantRequestURL,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                
                print("RestaurantManager - 매장 등록 성공")
                completion(.success(true))
                
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                
                print("RestaurantManager - uploadNewRes() statusCode: \(statusCode) and error: \(error.errorDescription)")
                
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 신규 메뉴 등록 (DB에 저장되지 않은 메뉴일 경우 실행)
    func uploadNewMenu(with model: RegisterNewMenuRequestDTO,
                       completion: @escaping ((Result<[MenuRegisterResponseModel], NetworkError>) -> Void)) {
        
        AF.request(uploadNewMenuRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   headers: model.headers,
                   interceptor: interceptor)
            .validate()
            .responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                
                switch statusCode {
                
                case 200:
                    
                    print("RESTAURANT MANAGER - SUCCESS IN UPLOADING NEW MENU")
                    
                    do {
                        let decodedData = try JSONDecoder().decode([MenuRegisterResponseModel].self,
                                                                   from: response.data!)
                        completion(.success(decodedData))
                        
                    } catch {
                        
                        print("RESTAURANT MANAGER - There was an error decoding JSON Data with error: \(error) with statusCode: \(statusCode)")
                        
                        completion(.failure(.internalError))
                    }
                    
                default:
                    let error = NetworkError.returnError(statusCode: statusCode)
                    print("RestaurantManager - uploadNewMenu() error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 신규 리뷰 등록 
    func uploadNewReview(with model: NewReviewRequestDTO,
                         completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(Data(String(model.mallID).utf8),
                                     withName: "mall_id")
            multipartFormData.append(Data(model.menus.utf8),
                                     withName: "menu_info")
            multipartFormData.append(Data(model.review.utf8),
                                     withName: "contents")
            multipartFormData.append(Data(String(model.rating).utf8),
                                     withName: "evaluate")
            
            if let imageArray = model.reviewImages {
                for images in imageArray {
                    
                    multipartFormData.append(images,
                                             withName: "review_image",
                                             fileName: "\(UUID().uuidString).jpeg",
                                             mimeType: "image/jpeg")
                }
            }
        }, to: uploadNewReviewRequestURL,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                
                print("RESTAURANT MANAGER - SUCCESS IN UPLOADING NEW REVIEW")
                completion(.success(true))
                
                
            default:
                
                let error = NetworkError.returnError(statusCode: statusCode)
                print("RestaurantManager uploadNewReview error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 특정 매장 리뷰 목록 불러오기
    
    func fetchReviewList(with model: FetchReviewListRequestDTO,
                         completion: @escaping ((Result<[ReviewListResponseModel], NetworkError>) -> Void)) {
        
        AF.request(fetchReviewListRequestURL,
                   method: .get,
                   parameters: model.parameters,
                   headers: model.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([ReviewListResponseModel].self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("RESTAURANT MANAGER - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    
    
    //MARK: - 매장 좋아요하기 API
    func markFavorite(mallID: Int,
                      markMyFavorite: Bool,
                      completion: @escaping ((Result<Bool,NetworkError>) -> Void)) {
        
        var headers: HTTPHeaders = [:]
        if User.shared.accessToken != "Invalid AccessToken" {
            headers["Authorization"] = User.shared.accessToken
        }
        let httpMethod: HTTPMethod = markMyFavorite ? .post : .delete
        
        AF.request(markFavoriteRequestURL + String(mallID),
                   method: httpMethod,
                   headers: headers)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    print("RESTAURANT MANAGER - SUCCESS IN \(markMyFavorite ? "Marking":"Unmarking") FAVORITE")
                    completion(.success(true))
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    // MARK: - 매장 목록 조회
    func fetchRestaurantList(with model: FetchRestaurantListRequestDTO,
                             completion: @escaping ((Result<[RestaurantListResponseModel], NetworkError>) -> Void)) {
        AF.request(fetchRestaurantListRequestURL,
                   method: .get,
                   parameters: model.parameters,
                   headers: model.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([RestaurantListResponseModel].self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("RESTAURANT MANAGER - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    // MARK: - 좋아하는 매장 목록 조회
    func fetchFavoriteRestaurantList(cursor: Int?,
                                     completion: @escaping ((Result<[RestaurantListResponseModel], NetworkError>) -> Void)) {
        var headers: HTTPHeaders = [:]
        var parameters: Parameters = [:]
        if User.shared.accessToken != "Invalid AccessToken" {
            headers["Authorization"] = User.shared.accessToken
        }
        parameters["cursor"] = cursor
        
        AF.request(fetchFavoriteRestaurantListRequestURL,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([RestaurantListResponseModel].self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("RESTAURANT MANAGER - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    // MARK: - 매장 상세 조회
    func fetchRestaurantInfo(of mallID: Int,
                             completion: @escaping ((Result<RestaurantInfoResponseModel, NetworkError>) -> Void)) {
        let requestURL = fetchRestaurantInfoRequestURL + String(mallID)
        var headers: HTTPHeaders = [
            "accept":"application/json",
        ]
        if User.shared.accessToken != "Invalid AccessToken" {
            headers["Authorization"] = User.shared.accessToken
        }
        
        AF.request(requestURL,
                   method: .get,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode(RestaurantInfoResponseModel.self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("RESTAURANT MANAGER - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    // MARK: - 매장 상세보기의 이미지 조회
    func fetchRestaurantImages(of mallID: Int,
                               cursor: Int? = nil,
                               completion: @escaping ((Result<[RestaurantImageResponseModel], NetworkError>) -> Void)) {
        var parameters: Parameters = ["mall_id":String(mallID)]
        let headers: HTTPHeaders = ["accept": "application/json"]
        parameters["cursor"] = cursor
        
        AF.request(fetchRestaurantImagesRequestURL,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([RestaurantImageResponseModel].self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("RESTAURANT MANAGER - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    print("RESTAURANT MANAGER - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 RESTAURANT MANAGER - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("RESTAURANT MANAGER - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
}
