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
    
                    if error == .unauthorized {
                        // Refresh Token 을 했는데도 401 에러가 날라오면 그때는 로그인을 아예 다시 해야함
                        
                        
                    } else {
                        completion(.doNotRetry)
                    }
                    
                }
            }
        default:
            
            if request.retryCount > 5 {
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
                            UserManager.shared.saveAccessToken(with: decodedData)
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
