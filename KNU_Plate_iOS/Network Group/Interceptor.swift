import Foundation
import Alamofire
import SwiftyJSON


final class Interceptor: RequestInterceptor {
    
    private var isRefreshing: Bool = false
    private var retryLimit = 5
    
    // 어떠한 AF request 이든지간데 중간에 가로채서 header 에 accesstoken 을 넣는 것이기에 매번 넣을 필요 X
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("Interceptor - adapt() activated")
        
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
        
        print("Interceptor - retry() activated with statusCode: \(statusCode)")
        
        switch statusCode {
        
        case 200...299:
            completion(.doNotRetry)
            
        // TODO: 아래 status Code 수정 필요
        // 토큰 만료되면 statusCode 401: Unauthorized 가 날라옴
        case 401:
            guard !isRefreshing else { return }
            
            refreshToken { refreshResult in
                
                print("Interceptor - retry() refreshToken result: \(refreshResult)")
                
                switch refreshResult {
                
                case .success(_):
                    
                    if request.retryCount < self.retryLimit {
                        completion(.retry)
                    } else {
                        completion(.doNotRetry)
                    }
                case .failure(_):
                    // refresh 했는데도 fail 이 돌아온다면 세션이 만료되어 아예 로그인을 다시 해야한다는 알림을 띄우고, rootVC 바꾸기
                    completion(.doNotRetry)
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
            "Authorization" : User.shared.refreshToken
        ]
        
        AF.request(UserManager.shared.refreshTokenRequestURL,
                   method: .post,
                   headers: headers).responseJSON { [weak self] response in
                    
                    self?.isRefreshing = false
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    print("Interceptor - refreshToken() activated with statusCode: \(statusCode)")
                    
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
