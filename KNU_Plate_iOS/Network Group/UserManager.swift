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
                    
                    case HTTPStatus.success.rawValue:
                        
                        if let result = try! response.result.get() as? [String: String] {
                            
                            print(result)
                            
                            self.updateUserRegisterInfo(with: result)
                            
                            /// success 하고 다음 vc 로 넘어가야 할 듯
                        }
                        else {
                            print("Failed to convert signup request response JSON to model")
                        }
                        
                    case HTTPStatus.badRequest.rawValue:
                        
                        
                        print(HTTPStatus.badRequest.errorDescription)
                        
                    case HTTPStatus.internalError.rawValue:
                 
                       
                  
                        print(HTTPStatus.internalError.errorDescription)
                     
                    case HTTPStatus.notFound.rawValue:
                        
                        print("not found")
                    default:
                        break
                        
                    }
                    
              
        }
        
        
    }
    
    
    //MARK: - 로그인 함수
    func logIn() {
        
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
