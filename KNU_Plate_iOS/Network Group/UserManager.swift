import Foundation
import Alamofire

class UserManager {
    
    //MARK: - Singleton
    static let shared: UserManager = UserManager()
    
    let signUpRequestURL = "http://3.35.58.40:4100/api/signup"
    let logInRequestURL = "http://3.35.58.40:4100/api/login"
    
    
    
    //MARK: - 회원가입 함수
    func signUp(with model: RegisterInfoModel) {
        
        AF.request(signUpRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
            
                    switch response.response?.statusCode {
                    
                    /// Success :  200
                    case HTTPStatus.success.rawValue:
                        
                        if let responseBody = try! response.result.get() as? [String: String] {
                            
                            self.updateUserRegisterInfo(with: responseBody)
                            //return HTTPStatus.success
                            
                            
                            /// success 하고 다음 vc 로 넘어가야 할 듯 (이메일 인증)
                        }
                        else {
                            print("Failed to convert signup request response body JSON to model")
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
                            
                           
                            
                            print(responseBody)
                            
                            
                            //return HTTPStatus.success
                            
                            
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
    
    //TODO: - User Login 이후 아이디, 비번, 등의 info 를 User Defaults 에 저장하여, 자동 로그인이 이루어지도록 해야 함.
    func saveLoginInfoToUserDefaults(with model: [String: String]) {
        
    }
    
    
    
}


extension UserManager {
    
    func updateUserRegisterInfo(with model: [String: String]) {
        
        User.shared.id = model["user_id"]!
        User.shared.username = model["user_name"]!
        User.shared.password = model["password"]!
        User.shared.displayName = model["display_name"]!
        User.shared.email = model["mail_address"]!
        User.shared.dateCreated = model["date_create"]!
        User.shared.isActive = model["is_active"]!
    }
}
