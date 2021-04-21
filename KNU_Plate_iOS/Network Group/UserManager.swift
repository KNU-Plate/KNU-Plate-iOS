import Foundation
import Alamofire

//MARK: - 회원가입, 로그인 등 User와 직접적인 연관있는 로직을 처리하는 클래스

class UserManager {
    
    //MARK: - Singleton
    static let shared: UserManager = UserManager()
    
    //MARK: - API Request URLs
    let signUpRequestURL = "\(Constants.API_BASE_URL)signup"
    let logInRequestURL = "\(Constants.API_BASE_URL)login"
    let issueEmailVerificationCodeURL = "\(Constants.API_BASE_URL)mail-auth/issuance"
    let emailVerificationURL = "\(Constants.API_BASE_URL)mail-auth/verification"
    
    private init() {}
    
    //MARK: - 회원가입 함수
    //TODO: - signUp ( ) 파라미터로 @escaping method 넣기.
    func signUp(with model: RegisterInfoModel) {
        
        AF.request(signUpRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers)
            .responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                case 200..<300:
                    do {
                        let decodedData = try JSONDecoder().decode(RegisterResponseModel.self, from: response.data!)
                        self.saveUserRegisterInfo(with: decodedData)
                        
                    } catch {
                        print("There was an error decoding JSON Data")
                    }
                    
                default:
                    if let responseJSON = try! response.result.get() as? [String:Any] {
                        if let error = responseJSON["error"] as? String {
                            if let errorMessage = SignUpError(rawValue: error)?.returnErrorMessage() {
                                print(errorMessage)
                            } else {
                                print("알 수 없는 에러입니다.")
                            }
                        }
                    }
                }
            }
    }
    
    //MARK: - 로그인 함수
    func logIn(with model: LoginInfoModel) {
        
        AF.request(logInRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
                    
                    switch response.response?.statusCode {
                    
                    /// Success :  200
                    case HTTPStatus.success.rawValue:
                        
                        if let responseBody = try! response.result.get() as? [String: Any] {
                            
                            self.saveLoginInfoToUserDefaults(with: responseBody)
                            
                            
                            
                            /// success 하고 홈화면으로 넘어가야함
                        }
                        else {
                            print("Failed to convert signup request response JSON to model")
                        }
                        
                        
                    /// Bad Request: 400
                    case HTTPStatus.badRequest.rawValue:
                        
                        print(HTTPStatus.badRequest.errorDescription)
                    //return HTTPStatus.badRequest
                    
                    /// Internal Error : 500
                    case HTTPStatus.internalError.rawValue:
                        
                        print(HTTPStatus.internalError.errorDescription)
                    //return HTTPStatus.internalError
                    
                    /// Not Found Error : 404
                    case HTTPStatus.notFound.rawValue:
                        
                        //return HTTPStatus.notFound
                        
                        print("not found")
                        
                        
                    default:
                        
                        break
                        
                    } /// end - switch
                   } // end - closure
        
    }
    
    
    //MARK: - 이메일 인증 코드 발급 함수
    func getEmailVerificationCode() {
        
        AF.request(issueEmailVerificationCodeURL,
                   method: .post,
                   encoding: URLEncoding.httpBody).responseJSON { (response) in
                    
                    switch response.response?.statusCode {
                    
                    /// Success :  200
                    case HTTPStatus.success.rawValue:
                        
                        if let responseBody = try! response.result.get() as? [String: Int] {
                            
                            self.saveLoginInfoToUserDefaults(with: responseBody)
                            
                            
                            
                            /// success 하고 홈화면으로 넘어가야함
                        }
                        else {
                            print("Failed to convert signup request response JSON to model")
                        }
                        
                        
                    /// Bad Request: 400
                    case HTTPStatus.badRequest.rawValue:
                        
                        print(HTTPStatus.badRequest.errorDescription)
                    //return HTTPStatus.badRequest
                    
                    /// Internal Error : 500
                    case HTTPStatus.internalError.rawValue:
                        
                        print(HTTPStatus.internalError.errorDescription)
                    //return HTTPStatus.internalError
                    
                    /// Not Found Error : 404
                    case HTTPStatus.notFound.rawValue:
                        
                        //return HTTPStatus.notFound
                        
                        print("not found")
                        
                        
                    default:
                        
                        break
                        
                    } /// end - switch
                    
                    
                    
                   }
    }
    
    
}


extension UserManager {
    
    func saveUserRegisterInfo(with model: [String: String]) {
        
        //TODO: - Password 같은 민감한 정보는 Key Chain 에 저장하도록 변경
        
        User.shared.id = model["user_id"]!
        User.shared.username = model["user_name"]!
        User.shared.password = model["password"]!
        User.shared.displayName = model["display_name"]!
        User.shared.email = model["mail_address"]!
        User.shared.dateCreated = model["date_create"]!
        User.shared.isActive = model["is_active"]!
    }
    
    //TODO: - User Login 이후 아이디, 비번, 등의 info 를 User Defaults 에 저장하여, 자동 로그인이 이루어지도록 해야 함.
    func saveLoginInfoToUserDefaults(with model: [String: Any]) {
        
        
    }
}
