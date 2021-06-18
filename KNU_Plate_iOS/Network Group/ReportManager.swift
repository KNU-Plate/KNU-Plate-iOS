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
    
    //MARK: - 유조 신고하기
    func reportReview(with id: String,
                    completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let headers: HTTPHeaders = [.authorization(User.shared.accessToken)]
        
        AF.request(reportURL,
                   method: .post,
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

    
    func sendSuggestion(content: String,
                        completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let headers: HTTPHeaders = [.authorization(User.shared.accessToken)]
        
        AF.request(suggestURL,
                   method: .post,
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
                    print("ReportManager - sendSuggestion() error \(error.errorDescription) and statusCode: \(statusCode)")
                    completion(.failure(error))
                }
            }
    }
}
