import Foundation
import Alamofire
import Security

//MARK: - 회원가입, 로그인 등 User와 직접적인 연관있는 로직을 처리하는 클래스

class UserManager {
    
    //MARK: - Singleton
    static let shared: UserManager = UserManager()
    
    //MARK: - API Request URLs
    
    /// 조회 request url 추가해야힘
    let unregisterRequestURL            = "\(Constants.API_BASE_URL)auth/unregister"
    let logOutRequestURL                = "\(Constants.API_BASE_URL)auth/logout"
    let refreshTokenRequestURL          = "\(Constants.API_BASE_URL)auth/refresh"
    let signUpRequestURL                = "\(Constants.API_BASE_URL)signup"
    let logInRequestURL                 = "\(Constants.API_BASE_URL)login"
    let sendEmailVerificationCodeURL    = "\(Constants.API_BASE_URL)mail-auth/issuance"
    let emailAuthenticationURL          = "\(Constants.API_BASE_URL)mail-auth/verification"
    let checkUserNameDuplicateURL       = "\(Constants.API_BASE_URL)check-user-name"
    let checkDisplayNameDuplicateURL    = "\(Constants.API_BASE_URL)check-display-name"
    
    private init() {}
    
    //MARK: - 회원가입
    //TODO: - signUp ( ) 파라미터로 @escaping method 넣기.
    
    func signUp(with model: RegisterInfoModel) {
        
        AF.request(signUpRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200..<300:
                    do {
                        let decodedData = try JSONDecoder().decode(RegisterResponseModel.self,
                                                                   from: response.data!)
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
                                print("알 수 없는 오류가 발생했습니다.")
                            }
                        }
                    }
                }
            }
    }
    
    //MARK: - 로그인
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
                            let decodedData = try JSONDecoder().decode(LoginResponseModel.self,
                                                                       from: response.data!)
                            self.saveLoginInfoToUserDefaults(with: decodedData)
                            
                        } catch {
                            print(error)
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
    
    
    //MARK: - 이메일 인증 코드 발급
    func sendEmailVerificationCode(completion: @escaping ((Bool) -> Void)) {
        
        AF.request(sendEmailVerificationCodeURL,
                   method: .post,
                   encoding: URLEncoding.httpBody,
                   headers: RequestEmailVerifyCodeModel().headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    case 200:
                        completion(true)
                        
                    default:
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 인증 코드 확인 (메일 인증)
    func verifyEmail(with model: VerifyMailModel,
                     completion: @escaping ((Bool) -> Void)) {
        
        AF.request(emailAuthenticationURL,
                   method: .patch,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        completion(true)
                        
                    default:
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 아이디 or 닉네임 중복 체크
    func checkDuplication(with model: CheckDuplicateModel,
                          _ requestURL: String,
                          completion: @escaping ((Bool) -> Void)) {
        
        AF.request(requestURL,
                   method: .get,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        completion(true)
                        
                    default:
                        //이미 존재하는 아이디 또는 닉네임입니다.
                        completion(false)
                    }
                   }
    }
    
    
    
    
    
    //MARK: - 로그아웃
    func logOut() {
        
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": User.shared.accessToken
        ]
        
        
        
    }
    
    //MARK: - 토큰 갱신
    func refreshToken() {
        // AF Request 보낼 때 header 에 accessToken 첨부해야함
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
        
        User.shared.accessToken = model.accessToken
        User.shared.refreshToken = model.refreshToken
        
        
        
    }
    
    //TODO: - User Login 이후 아이디, 비번, 등의 info 를 User Defaults 에 저장하여, 자동 로그인이 이루어지도록 해야 함.
    func saveLoginInfoToUserDefaults(with model: LoginResponseModel) {
        
        //TODO: - 앱 종료 후 바로 로그인이 가능하도록 아이디는 User Defaults 에 저장
        
        User.shared.accessToken = model.accessToken
    }
}
