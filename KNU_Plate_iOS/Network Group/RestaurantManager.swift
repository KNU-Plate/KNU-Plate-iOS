import Foundation
import Alamofire
import ProgressHUD

//MARK: - 매장 관련 로직을 처리하는 클래스 -> i.e 매장 등록, 매장 목록 조회, 매장 주소 검색, 매장 삭제 등

class RestaurantManager {
    
    //MARK: - Singleton
    static let shared: RestaurantManager = RestaurantManager()
    
    //MARK: - API Request URLs
    let uploadNewRestaurantRequestURL   = "\(Constants.API_BASE_URL)mall"
    let uploadNewMenuRequestURL         = "\(Constants.API_BASE_URL)menu"
    let uploadNewReviewRequestURL       = "\(Constants.API_BASE_URL)review"
    let fetchReviewListRequestURL       = "\(Constants.API_BASE_URL)review"
    let markFavoriteRequestURL          = "\(Constants.API_BASE_URL)mall/recommend/"
    
    
    private init() {}
    
    //MARK: - 신규 매장 등록
    func uploadNewRestaurant(with model: NewRestaurantModel,
                             completion: @escaping ((Bool) -> Void)){
        
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

                    /// fileName 변경하는거 알아보기
                    multipartFormData.append(images,
                                             withName: "thumbnail",
                                             fileName: "\(UUID().uuidString).jpeg",
                                             mimeType: "image/jpeg")
                }
            }
            
        }, to: uploadNewRestaurantRequestURL,
        headers: model.headers)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                
                print("매장 등록 성공")
                completion(true)
                
            /// 매장 등록이 성공이면 해당 화면 닫고 홈화면으로 돌아가기 popToRootVC?
            
            
            default:
                if let responseJSON = try! response.result.get() as? [String : String] {
                    
                    if let error = responseJSON["error"] {
                        
                        if let errorMessage = NewRestaurantUploadError(rawValue: error)?.returnErrorMessage() {
                            
                            print(errorMessage)
                            
                        } else {
                            print(error)
                            print("알 수 없는 오류가 발생했습니다.")
                            
                        }
                        completion(false)
                    }
                }
            }
        }
    }
    
    //MARK: - 신규 메뉴 등록 (DB에 저장되지 않은 메뉴일 경우 실행)
    func uploadNewMenu(with model: RegisterNewMenuModel,
                       completion: @escaping (([MenuRegisterResponseModel]) -> Void)) {
        
        AF.request(uploadNewMenuRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   headers: model.headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else {
                        return
                    }
                    
                    switch statusCode {
                    
                    case 200:
                        
                        print("RESTAURANT MANAGER - SUCCESS IN UPLOADING NEW MENU")
                        
                        do {
                            let decodedData = try JSONDecoder().decode([MenuRegisterResponseModel].self,
                                                                       from: response.data!)
                            completion(decodedData)
                        } catch {
                            
                            print("RESTAURANT MANAGER - There was an error decoding JSON Data with error: \(error)")
                        }
                        
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            
                            if let error = responseJSON["error"] {
                                
                                print(error)
                                //                                if let errorMessage = MailVerificationIssuanceError(rawValue: error)?.returnErrorMessage() {
                                //                                    print(errorMessage)
                            } else {
                                print("알 수 없는 에러 발생.")
                            }
                        }
                    }
                    
                    
                   }
        
    
    }
    
    //MARK: - 신규 리뷰 등록 
    func uploadNewReview(with model: NewReviewModel,
                         completion: @escaping ((Bool) -> Void)) {
     
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
        headers: model.headers)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                
                print("RESTAURANT MANAGER - SUCCESS IN UPLOADING NEW REVIEW")
                completion(true)
                
            default:
                if let responseJSON = try! response.result.get() as? [String : String] {
                    
                    if let error = responseJSON["error"] {
                        
                        print("RESTAURANT MANAGER - DEFAULT ACTIVATED ERROR MESSAGE: \(error)")
                    }
                }
                completion(false)
                
            }
    }
        
    }
    
    //MARK: - 특정 매장 리뷰 목록 불러오기

    func fetchReviewList(with model: FetchReviewListModel,
                         completion: @escaping ((Result<[ReviewListResponseModel],Error>) -> Void)) {
      
        AF.request(fetchReviewListRequestURL,
                   method: .get,
                   parameters: model.parameters,
                   encoding: URLEncoding.queryString,
                   headers: model.headers).responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    case 200:
                        do {
                            let decodedData = try JSONDecoder().decode([ReviewListResponseModel].self, from: response.data!)
                            completion(.success(decodedData))
                
                        } catch {
                            print("Restaurant Manager - fetchReviewList ERROR: \(error)")
                        }
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            
                            if let error = responseJSON["error"] {
                                
                                print("RESTAURANT MANAGER - DEFAULT ACTIVATED ERROR MESSAGE: \(error)")
                            }
                            
                        }
                    }
                   }
    }
    


    //MARK: - 매장 좋아요하기 API
    func markFavorite(mallID: Int,
                      httpMethod: HTTPMethod,
                      completion: @escaping ((Bool) -> Void)) {
        
        let headers: HTTPHeaders = ["Authorization": User.shared.accessToken]
        
        AF.request(markFavoriteRequestURL + String(mallID),
                   method: httpMethod,
                   headers: headers).responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    case 200:
                        print("RESTAURANT MANAGER - SUCCESS IN MARKING FAVORITE")
                        completion(true)
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            if let error = responseJSON["error"] {
                                print(error)
                            } else { print("알 수 없는 에러 발생.") }
                        }
                        completion(false)
                    }
                   }
    }
}
