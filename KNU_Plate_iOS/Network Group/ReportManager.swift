import Foundation
import Alamofire
import ProgressHUD

//MARK: - 신고하기 및 건의하기 기능 담당 클래스

class ReportManager {
    
    //MARK: - Singleton
    static let shared: ReportManager = ReportManager()
    
    let interceptor = Interceptor()
    
    //MARK: - API Request URLs
    let reportURL       = "\(Constants.API_BASE_URL)report"
    let suggestURL      = "\(Constants.API_BASE_URL)suggestion"
    
    private init() {}
    
    //MARK: - 유저 신고하기
    func reportReview(reviewID: Int,
                      reason: String,
                      completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let headers: HTTPHeaders = [.authorization(User.shared.accessToken)]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append("\(reviewID)".data(using: .utf8)!,
                                     withName: "review_id")
            multipartFormData.append("\(reason)".data(using: .utf8)!,
                                     withName: "reason")
            
        }, to: reportURL,
        headers: headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                completion(.success(true))
            
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("ReportManager - reportReview() error \(error.errorDescription) and statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }

    //MARK: - 건의사항 보내기
    func sendSuggestion(content: String,
                        completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        //let headers: HTTPHeaders = [.authorization(User.shared.accessToken)]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append("..".data(using: .utf8)!,
                                     withName: "title")
            multipartFormData.append("\(content)".data(using: .utf8)!,
                                     withName: "contents")
        
        }, to: suggestURL,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                print("✏️ ReportManager - sendSuggestion success")
                completion(.success(true))
            
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("ReportManager - sendSuggestion() error \(error.errorDescription) and statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }
}
