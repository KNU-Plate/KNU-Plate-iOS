import Foundation
import Alamofire

//MARK: - 매장 관련 로직을 처리하는 클래스 -> i.e 매장 등록, 매장 목록 조회, 매장 주소 검색, 매장 삭제 등

class RestaurantManager {
    
    //MARK: - Singleton
    static let shared: RestaurantManager = RestaurantManager()
    
    //MARK: - API Request URLs
    let uploadNewRestaurantRequestURL = "http://3.35.58.40:4100/api/mall"
    
    
    private init() {}
    
    //MARK: - 신규 매장 등록
    func uploadNewRestaurant(with model: NewRestaurantModel,
                             completion: @escaping ((NewRestaurantResponseModel) -> Void)){
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(Data(model.name.utf8), withName: "mall_name")
            multipartFormData.append(Data(model.categoryName.utf8), withName: "category_name")
            multipartFormData.append(Data(model.address.utf8), withName: "address")
            multipartFormData.append(Data(String(model.latitude).utf8), withName: "latitude")
            multipartFormData.append(Data(String(model.longitude).utf8), withName: "longitude")
         
            //사진도 추가해야함
            
        }, to: uploadNewRestaurantRequestURL,
        headers: model.headers)
        .responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                
                print("매장 등록 성공")
                
            /// 매장 등록이 성공이면 해당 화면 닫고 홈화면으로 돌아가기 popToRootVC?
            
            
            default:
                if let responseJSON = try! response.result.get() as? [String : String] {
                    
                    if let error = responseJSON["error"] {
                        
                        print(error)
                    }
                }
            }
     
            
            
            
            
        }
        
        
    }
    
    
    
    
    //    func uploadNewRestaurant(with model: NewRestaurantModel,
    //                             completion: @escaping ((NewRestaurantResponseModel) -> Void)){
    //
    //        AF.request(uploadNewRestaurantRequestURL,
    //                   method: .post,
    //                   parameters: model.parameters,
    //                   headers: model.headers)
    //            .responseJSON { (response) in
    //
    //                guard let statusCode = response.response?.statusCode else {
    //                    return
    //                }
    //
    //                switch statusCode {
    //
    //                case 200:
    //
    //                    do {
    //
    //                        print("COMPLETED!")
    //                        print(response.data!)
    //
    //                        let decodedData = try JSONDecoder().decode(NewRestaurantResponseModel.self, from: response.data!)
    //
    //
    //                        completion(decodedData)
    //                    } catch {
    //                        print("There was an error decoding JSON Data into NewRestaurantResponseModel")
    //                    }
    //
    //
    //                default:
    //
    //                    if let responseJSON = try! response.result.get() as? [String : String] {
    //
    //                        if let error = responseJSON["error"] {
    //
    //                            print(error)
    //                        }
    //                    }
    //
    //
    //                    print("ERROR in Restaurant Manager")
    //
    //
    //                }
    //            }
    //    }
    
    
    
    
    
    //MARK: - 신규 리뷰 등록 
    func uploadNewReview(with model: NewReviewModel) {
        
        // AF Request 보낼 때 header 에 accessToken 첨부해야함
    }
    
    
    
}
