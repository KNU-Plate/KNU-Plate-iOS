import Foundation
import Alamofire
import SwiftKeychainWrapper

//MARK: - 회원가입, 로그인 등 User와 직접적인 연관있는 로직을 처리하는 클래스

class UserManager {
    
    //MARK: - Singleton
    static let shared: UserManager = UserManager()
    
    //MARK: - API Request URLs
    
    let unregisterRequestURL            = "\(Constants.API_BASE_URL)auth/unregister"
    let logOutRequestURL                = "\(Constants.API_BASE_URL)auth/logout"
    let refreshTokenRequestURL          = "\(Constants.API_BASE_URL)auth/refresh"
    let signUpRequestURL                = "\(Constants.API_BASE_URL)signup"
    let logInRequestURL                 = "\(Constants.API_BASE_URL)login"
    let sendEmailVerificationCodeURL    = "\(Constants.API_BASE_URL)mail-auth/issuance"
    let emailAuthenticationURL          = "\(Constants.API_BASE_URL)mail-auth/verification"
    let checkUserNameDuplicateURL       = "\(Constants.API_BASE_URL)check-user-name"
    let checkDisplayNameDuplicateURL    = "\(Constants.API_BASE_URL)check-display-name"
    let modifyUserInfoURL               = "\(Constants.API_BASE_URL)auth/modify"
    let loadUserProfileInfoURL          = "\(Constants.API_BASE_URL)auth"
    
    private init() {}
    
    //MARK: - 회원가입
    //TODO - multipartformdata 로 수정
    func signUp(with model: RegisterInfoModel) {
        
        AF.request(signUpRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers).responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                case 200:
                    do {
                        let decodedData = try JSONDecoder().decode(RegisterResponseModel.self,
                                                                   from: response.data!)
                        self.saveUserRegisterInfoToDevice(with: decodedData)
                        
                    } catch {
                        print("UserManager - signUP catch ERROR: \(error)")
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
                    
                    case 200:
                        do {
                            let decodedData = try JSONDecoder().decode(LoginResponseModel.self,
                                                                       from: response.data!)
                            self.saveAccessToken(with: decodedData)
                            print("Access Token in Keychain: \(User.shared.accessToken)")
                            
                        } catch {
                            print("UserManager - logIn catch ERROR: \(error)")
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
                    
                    case 200: completion(true)
                    default: completion(false)
                    }
                   }
    }
    
    //MARK: - 아이디 or 닉네임 중복 체크
    func checkDuplication(with model: CheckDuplicateModel,
                          requestURL: String,
                          completion: @escaping ((Bool) -> Void)) {
        
        AF.request(requestURL,
                   method: .get,
                   parameters: model.parameters,
                   encoding: URLEncoding.queryString,
                   headers: model.headers).responseJSON { (response) in
        
                    guard let statusCode = response.response?.statusCode else { return }
                
                    switch statusCode {
                    case 200: completion(true)
                        
                    default:
                        //이미 존재하는 아이디 또는 닉네임입니다.
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 로그아웃
    func logOut(completion: @escaping ((Bool) -> Void)) {
        
        let headers: HTTPHeaders = [
            .authorization("application/json"),
            .contentType("application/x-www-form-urlencoded"),
            .authorization(User.shared.accessToken)
        ]
        
        AF.request(logOutRequestURL,
                   method: .post,
                   encoding: URLEncoding.httpBody,
                   headers: headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        completion(true)
                    default:
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 회원 탈퇴
    func unregisterUser(completion: @escaping ((Bool) -> Void)) {
        
        let headers: HTTPHeaders = [
            .authorization("application/json"),
            .contentType("application/x-www-form-urlencoded"),
            .authorization(User.shared.accessToken)
        ]
        
        AF.request(unregisterRequestURL,
                   method: .delete,
                   encoding: URLEncoding.httpBody,
                   headers: headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        completion(true)
                        
                    default:
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 토큰 갱신
    func refreshToken(completion: @escaping ((Bool) -> Void)) {
    
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(User.shared.refreshToken)
        ]
        
        AF.request(refreshTokenRequestURL,
                   method: .post,
                   encoding: URLEncoding.httpBody,
                   headers: headers).responseJSON { (response) in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    case 200:
                        do {
                            let decodedData = try JSONDecoder().decode(LoginResponseModel.self, from: response.data!)
                            self.saveAccessToken(with: decodedData)
                            completion(true)
                            
                        } catch {
                            print("UserManager - refreshToken catch ERROR: \(error)")
                        }
                    default:
                        //TODO: - accessToken 이 아닌 refreshToken 으로 했는데도 fail 하면 그땐 재로그인이 필요함. 즉, 실패 알림 띄우고 로그인 화면으로 강제로 가게끔 해야함.
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 사용자 정보 불러오기
    func loadUserProfileInfo(completion: @escaping ((Bool) -> Void)) {
        
        // medal 정보도 저장 맨날 하는게 좋을듯
        let headers: HTTPHeaders = [.authorization(User.shared.accessToken)]
        
        AF.request(loadUserProfileInfoURL,
                   method: .get,
                   headers: headers).responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        do {
                            
                            let decodedData = try JSONDecoder().decode(LoadUserInfoModel.self, from: response.data!)
                            self.saveUserInfoToDevice(with: decodedData)
                            
                        } catch {
                            print("UserManager - loadUserProfileInfo() catch ERROR: \(error)")
                            completion(false)
                        }
                        
                    default:
                        if let responseJSON = try! response.result.get() as? [String : String] {
                            if let error = responseJSON["error"] {
                                print("UserManager - loadUserProfileInfo() default activated with error: \(error)")
                            }
                        }
                        completion(false)
                    }
                   }
    }
    
    //MARK: - 시용자 닉네임 수정
    func updateNickname(with model: EditUserInfoModel,
                        completion: @escaping ((Bool) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.nickname!.utf8),
                                     withName: "display_name")
            multipartFormData.append(Data(model.removeUserProfileImage.utf8),
                                     withName: "force")
            
        }, to: modifyUserInfoURL,
        method: .patch,
        headers: model.headers)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                
                User.shared.displayName = model.nickname!
                print("닉네임 변경 성공")
                completion(true)
            default:
                
                if let responseJSON = try! response.result.get() as? [String : String] {
                    if let error = responseJSON["error"] {
                        print("UserManager - updateNickname error: \(error)")
                        completion(false)
                    }
                }
            }
        }
    }
    
    //MARK: - 사용자 비밀번호 수정
    func updatePassword(with model: EditUserInfoModel) {
        
        
    }
    
    //MARK: - 사용자 프로필 이미지 업데이트
    func updateProfileImage(with model: EditUserInfoModel) {
        
    }
    
    //MARK: - 사용자 프로필 이미지 제거
    func removeProfileImage(completion: @escaping ((Bool) -> Void)) {
        
        
    }
    
    
    
}


extension UserManager {
    
    func saveUserRegisterInfoToDevice(with model: RegisterResponseModel) {
        
        //TODO: - 추후 Password 같은 민감한 정보는 Key Chain 에 저장하도록 변경 -> KeyChainWrapper 이용하기 
        
        User.shared.id = model.userID
        User.shared.username = model.username
        User.shared.password = model.password
        User.shared.displayName = model.displayName
        User.shared.email = model.email
        User.shared.dateCreated = model.dateCreated
        User.shared.isActive = model.isActive
        User.shared.medal = model.medal
        
        if let profileImageLink = model.userProfileImage {
            User.shared.profileImageLink = profileImageLink
        }
    }
    
    func saveUserInfoToDevice(with model: LoadUserInfoModel) {
        
        User.shared.id = model.userID
        User.shared.username = model.username
        User.shared.displayName = model.displayName
        User.shared.email = model.email
        User.shared.medal = model.medal
        
        if let fileFolder = model.fileFolder {
            if let profileImagePath = fileFolder.files?[0].path {
                
                let downloadURL = URL(string: profileImagePath)
                
                do {
                    let imageData = try Data(contentsOf: downloadURL!)
                    User.shared.profileImage = UIImage(data: imageData)
                } catch {
                    User.shared.profileImage = nil
                }
            }
        }
    }
    
    //TODO: - User Login 이후 아이디, 비번, 등의 info 를 User Defaults 에 저장하여, 자동 로그인이 이루어지도록 해야 함.
    func saveAccessToken(with model: LoginResponseModel) {
        
        //TODO: - 앱 종료 후 바로 로그인이 가능하도록 아이디는 User Defaults 에 저장

        User.shared.savedAccessToken = KeychainWrapper.standard.set(model.accessToken,
                                                                    forKey: Constants.KeyChainKey.accessToken)
    
        User.shared.savedRefreshToken = KeychainWrapper.standard.set(model.refreshToken,
                                                                     forKey: Constants.KeyChainKey.refreshToken)
    }
    
    
    //TODO: - 로그아웃을 한 후에 UserDefaults 에 저장되어 있는 모든 값 지우기
    func resetAllUserInfo() {
        
        
    }
    
}
