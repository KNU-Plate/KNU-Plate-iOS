import Foundation
import Alamofire
import SwiftyJSON


final class Interceptor: RequestInterceptor {
    
    private var isRefreshing: Bool = false
    
    // 어떠한 AF request 이든지간데 중간에 가로채서 header 에 accesstoken 을 넣는 것이기에 매번 넣을 필요 X
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        
        request.headers.update(name: "Authorization", value: User.shared.accessToken)
        
        completion(.success(request))
    }
    
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        
        case 200...299:
            completion(.doNotRetry)
            
        // TODO: 아래 status Code 수정 필요
        case 403:
            guard !isRefreshing else { return }
            
            refreshToken { refreshResult in
                
                switch refreshResult {
                
                case .success(_):
                    completion(.retry)
                case .failure(_):
                    completion(.retryWithDelay(2))
                }
            }
        default:
            completion(.retry)
            
        }
    }
    
}

extension Interceptor {
    
    typealias RefreshCompletion = (_ completion: Result<Bool, Error>) -> Void
    
    func refreshToken(completion: @escaping RefreshCompletion) {
        
        self.isRefreshing = true
        
        let headers: HTTPHeaders = [
            "authentication" : User.shared.accessToken
        ]
        
        AF.request(UserManager.shared.refreshTokenRequestURL,
                   method: .post,
                   headers: headers).responseJSON { [weak self] response in
                    
                    self?.isRefreshing = false
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        
                        do {
                            
                            let decodedData = try JSONDecoder().decode(LoginResponseModel.self, from: response.data!)
                            
                            UserManager.shared.saveAccessToken(with: decodedData)
                            print("successfully refreshed NEW token: \(User.shared.accessToken)")
                            completion(.success(true))
                            
                        } catch {
                            
                        }
                        
                    default:
                        print("Interceptor - refreshToken() failed default")
                        completion(.success(false))
                    }
                   }
    }
}
