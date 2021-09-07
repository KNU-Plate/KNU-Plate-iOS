import Foundation
import Alamofire
import SwiftyJSON

final class Interceptor: RequestInterceptor {
    
    private var isRefreshing: Bool = false
    private var retryLimit = 3
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("Interceptor - adapt() activated")
        
        if !User.shared.isLoggedIn {
            completion(.success(urlRequest))
            return
        }
        
        var request = urlRequest
        request.headers.update(name: "Authorization", value: User.shared.accessToken)
        request.timeoutInterval = 10
        
        completion(.success(request))
    }
    
    // AF.request(..).validate() 수행 후 statusCode 가 200...299 사이가 아니면 실행되는 함수
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        if !User.shared.isLoggedIn {
            completion(.doNotRetry)
            return
        }
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        print("Interceptor - retry() activated with statusCode: \(statusCode)")
        
        switch statusCode {
        
        case 200...299: completion(.doNotRetry)
            
        // 토큰이 만료되면 statusCode 401: Unauthorized 가 날라옴
        case 401:
            guard !isRefreshing else { return }
            
            print("✏️ accessToken 이 만료되어 새로 발급 받는 중입니다..")
            
            refreshToken() { [weak self] refreshResult in
                
                guard let self = self else { return }
                
                print("Interceptor - retry() refreshToken result: \(refreshResult)")
                
                switch refreshResult {
                
                case .success(_):

                    if request.retryCount < self.retryLimit {
                        completion(.retry)
                    } else {
                        completion(.doNotRetry)
                    }
                case .failure(let error):
                    
                    print("❗️ Refresh 토큰을 새로 발급받는 과정에 문제가 있었습니다.")
                    
                    if error == .unauthorized {
                        
                        print("❗️ Interceptor - 세션이 만료되었습니다. 다시 로그인 요망 (refreshToken 만료)")
                
                        NotificationCenter.default.post(name: Notification.Name.refreshTokenExpired,
                                                        object: nil)
                        completion(.doNotRetry)
                        
                    } else {
                        print("Interceptor - 이건 뭔 에러지?")
                        completion(.doNotRetry)
                    }
                    
                }
            }
        default:
            
            if request.retryCount > 3 {
                print("Interceptor retry() error: \(error)")
                completion(.doNotRetry)
            }
            completion(.doNotRetry)
            
        }
    }
    
}

extension Interceptor {
    
    typealias RefreshCompletion = (_ completion: Result<Bool, NetworkError>) -> Void
    
    func refreshToken(completion: @escaping RefreshCompletion) {
        
        self.isRefreshing = true
        
        let headers: HTTPHeaders = ["Authorization" : User.shared.refreshToken]
        
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
                            UserManager.shared.saveLoginInfo(with: decodedData)
                            print("successfully refreshed NEW token: \(User.shared.accessToken)")
                            completion(.success(true))
                        } catch {
                            completion(.failure(.internalError))
                        }
                    default:
                        print("Interceptor - refreshToken() failed default with statusCode: \(statusCode)")
                        completion(.failure(.unauthorized))
                    }
                   }
    }
}
