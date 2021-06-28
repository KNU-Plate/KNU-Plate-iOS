import Foundation
import Alamofire
import SwiftKeychainWrapper

//MARK: - 회원가입, 로그인 등 User와 직접적인 연관있는 로직을 처리하는 클래스

class UserManager {
    
    //MARK: - Singleton
    static let shared: UserManager = UserManager()
    
    let interceptor = Interceptor()
    
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
    func signUp(with model: RegisterInfoModel,
                completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.username.utf8),
                                     withName: "user_name")
            multipartFormData.append(Data(model.displayName.utf8),
                                     withName: "display_name")
            multipartFormData.append(Data(model.password.utf8),
                                     withName: "password")
            multipartFormData.append(Data(model.email.utf8),
                                     withName: "mail_address")
            
            if let profileImage = model.profileImage {
                
                multipartFormData.append(profileImage,
                                         withName: "user_thumbnail",
                                         fileName: "\(UUID().uuidString).jpeg",
                                         mimeType: "image/jpeg")
            }
        }, to: signUpRequestURL,
        headers: model.headers)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let decodedData = try JSONDecoder().decode(RegisterResponseModel.self,
                                                               from: response.data!)
                    self.saveUserRegisterInfoToDevice(with: decodedData)
                    completion(.success(true))
                    
                } catch {
                    print("UserManager - signUP catch ERROR: \(error)")
                    completion(.failure(.internalError))
                }
                
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("UserManager - signUp error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 로그인
    func logIn(with model: LoginInfoModel,
               completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        User.shared.resetAllUserInfo()
        
        AF.request(logInRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers)
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200:
                    print("UserManager - login SUCCESS")
                    do {
                        let decodedData = try JSONDecoder().decode(LoginResponseModel.self,
                                                                   from: response.data!)
                        self.saveLoginInfo(with: decodedData)
                        User.shared.isLoggedIn = true
                        
                        print("Access Token in Keychain: \(User.shared.accessToken)")
                        completion(.success(true))
                        
                    } catch {
                        print("UserManager - logIn catch ERROR: \(error)")
                        completion(.failure(.internalError))
                    }
                    
                default:
                    print("UserManager - login FAILED with statusCode: \(statusCode)")
                    let error = NetworkError.returnError(statusCode: statusCode)
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 이메일 인증 코드 발급
    // 수정 필요
    func sendEmailVerificationCode(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.request(sendEmailVerificationCodeURL,
                   method: .post,
                   encoding: URLEncoding.httpBody,
                   headers: RequestEmailVerifyCodeModel().headers,
                   interceptor: interceptor)
            .responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                case 200:
                    
                    completion(.success(true))
                    
                default:
                    let error = NetworkError.returnError(statusCode: statusCode)
                    completion(.failure(error))
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
                   headers: model.headers,
                   interceptor: interceptor)
            .responseJSON { (response) in
                
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
                          completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.request(requestURL,
                   method: .get,
                   parameters: model.parameters,
                   encoding: URLEncoding.queryString,
                   headers: model.headers,
                   interceptor: interceptor)
            .responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200:
                    completion(.success(true))
                    
                case 400:
                    // 중복
                    completion(.success(false))
                    
                default:
                    
                    let error = NetworkError.returnError(statusCode: statusCode)
                    print("UserManager - 이미 존재하는 닉네임: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 로그아웃
    func logOut(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let headers: HTTPHeaders = [
            .authorization("application/json"),
            .contentType("application/x-www-form-urlencoded")
        ]
        
        AF.request(logOutRequestURL,
                   method: .post,
                   encoding: URLEncoding.httpBody,
                   headers: headers,
                   interceptor: interceptor)
            .validate()
            .responseJSON { (response) in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200:
                    self.resetAllUserInfo()
                    completion(.success(true))
                default:
                    let error = NetworkError.returnError(statusCode: statusCode)
                    completion(.failure(error))
                }
            }
    }
        
    //MARK: - 사용자 정보 불러오기
    func loadUserProfileInfo(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.request(loadUserProfileInfoURL,
                   method: .get,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                print("loadUserProfileInfo statusCode: \(statusCode)")
                
                switch statusCode {
                
                case 200:
                    do {
                        let decodedData = try JSONDecoder().decode(LoadUserInfoModel.self, from: response.data!)
                        self.saveUserInfoToDevice(with: decodedData)
                        completion(.success(true))
                        
                    } catch {
                        print("UserManager - loadUserProfileInfo() catch ERROR: \(error)")
                        completion(.failure(.internalError))
                    }
                default:
                    let error = NetworkError.returnError(statusCode: statusCode)
                    
                    print("UserManager - loadUserProfileInfo() default activated with error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 시용자 닉네임 수정
    func updateNickname(with model: EditUserInfoModel,
                        completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.nickname!.utf8),
                                     withName: "display_name")
            multipartFormData.append(Data(model.removeUserProfileImage.utf8),
                                     withName: "force")
            
        }, to: modifyUserInfoURL,
        method: .patch,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                
                User.shared.displayName = model.nickname!
                print("UserManager - 닉네임 변경 성공")
                completion(.success(true))
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("UserManager - updateNickname error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 사용자 비밀번호 수정
    func updatePassword(with model: EditUserInfoModel,
                        completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.password!.utf8),
                                     withName: "password")
            multipartFormData.append(Data(model.removeUserProfileImage.utf8),
                                     withName: "force")
            
        }, to: modifyUserInfoURL,
        method: .patch,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                print("UserManager - 비밀번호 변경 성공")
                completion(.success(true))
                
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("UserManager - updatePassword error: \(error.errorDescription) and statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 사용자 프로필 이미지 업데이트
    func updateProfileImage(with model: EditUserInfoModel,
                            completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.removeUserProfileImage.utf8),
                                     withName: "force")
            
            if let profileImage = model.userProfileImage {
                multipartFormData.append(profileImage,
                                         withName: "user_thumbnail",
                                         fileName: "\(UUID().uuidString).jpeg",
                                         mimeType: "image/jpeg")
            }
            
        }, to: modifyUserInfoURL,
        method: .patch,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                print("UserManager - 프로필 이미지 변경 성공")
                completion(.success(true))
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("UserManager - updateNickname error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    //MARK: - 사용자 프로필 이미지 제거
    func removeProfileImage(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let model = EditUserInfoModel(removeUserProfileImage: true)
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.removeUserProfileImage.utf8),
                                     withName: "force")
        }, to: modifyUserInfoURL,
        method: .patch,
        headers: model.headers,
        interceptor: interceptor)
        .validate()
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                print("UserManager - 프로필 이미지 제거하기 성공")
                completion(.success(true))
                
            default:
                let error = NetworkError.returnError(statusCode: statusCode)
                print("UserManager - updateNickname error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 회원 탈퇴
    func unregisterUser(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.request(unregisterRequestURL,
                   method: .delete,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200:
                    completion(.success(true))
                    
                default:
                    let error = NetworkError.returnError(statusCode: statusCode)
                    print("UserManager - unregisterUser error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
}

//MARK: - 사용자 정보를 로컬에 저장하는 메서드 모음

extension UserManager {
    
    func saveUserRegisterInfoToDevice(with model: RegisterResponseModel) {

        User.shared.id = model.userID
        User.shared.username = model.username
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
    
    func saveLoginInfo(with model: LoginResponseModel) {
        
        User.shared.savedAccessToken = KeychainWrapper.standard.set(model.accessToken,
                                                                    forKey: Constants.KeyChainKey.accessToken)
        User.shared.savedRefreshToken = KeychainWrapper.standard.set(model.refreshToken,
                                                                     forKey: Constants.KeyChainKey.refreshToken)
    
        User.shared.id = model.user.userID
        User.shared.username = model.user.username
        User.shared.displayName = model.user.displayName
        User.shared.email = model.user.mailAddress
        User.shared.medal = model.user.medal
        //User.shared.profileImageLink = model.user.userProfileImageFolderID
        
        
        
        print("UserManager - saveLoginInfo success ")
        print("New accessToken: \(User.shared.accessToken)")
    }
    
    
    //TODO: - 로그아웃을 한 후에 UserDefaults 에 저장되어 있는 모든 값 지우기
    func resetAllUserInfo() {
        
        User.shared.resetAllUserInfo()
        
    }
    
}
