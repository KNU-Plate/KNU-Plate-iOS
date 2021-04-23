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
                    if let responseJSON = try! response.result.get() as? [String : String] {
                        
                        if let error = responseJSON["error"] {
                            
                            if let errorMessage = SignUpError(rawValue: error)?.returnErrorMessage() {
                                print(errorMessage)
                            } else {
                                print("알 수 없는 에러 발생.")
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
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200..<300:
                        do {
                            
                            let decodedData = try JSONDecoder().decode(LoginResponseModel.self, from: response.data!)
                            self.saveLoginInfoToUserDefaults(with: decodedData)
                            
                        } catch {
                            print("There was an error decoding JSON Data")
                        }
                        
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            
                            if let error = responseJSON["error"] {
                                
                                if let errorMessage = LogInError(rawValue: error)?.returnErrorMessage() {
                                    print(errorMessage)
                                } else {
                                    print("알 수 없는 에러 발생.")
                                }
                            }
                        }
                    }
                }
    }
    
    
    //MARK: - 이메일 인증 코드 발급 함수
    func getEmailVerificationCode() {
        
        AF.request(issueEmailVerificationCodeURL,
                   method: .post,
                   encoding: URLEncoding.httpBody).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200..<300:
                        do {
                            
                            //let decodedData = try JSONDecoder().decode(LoginResponseModel.self, from: response.data!)
                            
                            
                        } catch {
                            print("There was an error decoding JSON Data")
                        }
                        
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            
                            if let error = responseJSON["error"] {
                                
                                if let errorMessage = MailVerificationIssuanceError(rawValue: error)?.returnErrorMessage() {
                                    print(errorMessage)
                                } else {
                                    print("알 수 없는 에러 발생.")
                                }
                            }
                        }
                    }
                }
    }
    
    
}


extension UserManager {
    
    func saveUserRegisterInfo(with model: RegisterResponseModel) {
        
        //TODO: - 추후 Password 같은 민감한 정보는 Key Chain 에 저장하도록 변경
        
        User.shared.id = model.userID
        User.shared.username = model.username
        User.shared.password = model.password
        User.shared.displayName = model.displayName
        User.shared.email = model.email
        User.shared.dateCreated = model.dateCreated
        User.shared.isActive = model.isActive
    }
    
    //TODO: - User Login 이후 아이디, 비번, 등의 info 를 User Defaults 에 저장하여, 자동 로그인이 이루어지도록 해야 함.
    func saveLoginInfoToUserDefaults(with model: LoginResponseModel) {
        
        
    }
}
