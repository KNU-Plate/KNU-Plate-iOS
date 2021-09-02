import Foundation
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

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
    let deleteReviewURL                 = "\(Constants.API_BASE_URL)review/"
    let findIDURL                       = "\(Constants.API_BASE_URL)search/username"
    let findPasswordURL                 = "\(Constants.API_BASE_URL)search/password"
    
    private init() {}
    
    //MARK: - 회원가입
    func register(with model: RegisterRequestDTO,
                completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.username.utf8),
                                     withName: "user_name")
            multipartFormData.append(Data(model.password.utf8),
                                     withName: "password")

            
        }, to: signUpRequestURL,
        headers: model.headers)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let decodedData = try JSONDecoder().decode(RegisterResponseModel.self,
                                                               from: response.data!)
                    
                    print("✏️ UserManager - register SUCCESS ")
                    print("✏️ NEW ACCESS TOKEN: \(decodedData.accessToken)")
                    self.saveUserRegisterInfoToDevice(with: decodedData)
                    completion(.success(true))
                    
                } catch {
                    print("❗️ UserManager - register catch ERROR: \(error)")
                    completion(.failure(.internalError))
                }
                
            default:
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                print("UserManager - signUp error: \(error.errorDescription), with statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 로그인    
    func logIn(with model: LoginRequestDTO,
               completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        User.shared.resetAllUserInfo()
        
        AF.request(logInRequestURL,
                   method: .post,
                   parameters: model.parameters,
                   encoding: URLEncoding.httpBody,
                   headers: model.headers)
            .responseJSON { response in
                
                switch response.result {
                
                case .success(_):
           
                    do {
                        let decodedData = try JSONDecoder().decode(LoginResponseModel.self,
                                                                   from: response.data!)
                        self.saveLoginInfo(with: decodedData)
                        User.shared.isLoggedIn = true
                        print("✏️ UserManager - login SUCCESS")
                        print("✏️ Access Token in Keychain: \(User.shared.accessToken)")
                        completion(.success(true))
                        
                    } catch {
                        print("✏️ UserManager - logIn catch ERROR: \(error)")
                        completion(.failure(.internalError))
                    }
                case .failure(let error):
                    
                    if let jsonData = response.data {
                        print("UserManager - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("UserManager - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("🥲 UserManager - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode, responseData: response.data)
                    print("UserManager - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                
                }
            }
    }
    
    //MARK: - 아이디 or 닉네임 중복 체크
    func checkDuplication(requestURL: String,
                          completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        AF.request(requestURL,
                   method: .get)
        .responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
                
                case 200:
                    completion(.success(true))
                case 400:
                    // 중복일 경우 아래 수행
                    completion(.success(false))
                default:
                    let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                    print("✏️ UserManager - checkDuplication error: \(error.errorDescription)")
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
                    let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                    completion(.failure(error))
                }
            }
    }
        
    //MARK: - 사용자 정보 불러오기
    func loadUserProfileInfo(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let name: Parameters = ["user_name": User.shared.username]
        
        AF.request(loadUserProfileInfoURL,
                   method: .get,
                   parameters: name,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                print("✏️ loadUserProfileInfo statusCode: \(statusCode)")
                
                switch statusCode {
                
                case 200:
                    do {
                        let decodedData = try JSONDecoder().decode(LoadUserInfoModel.self, from: response.data!)
                        self.saveUserInfoToDevice(with: decodedData)
                        completion(.success(true))
                        
                    } catch {
                        print("❗️ UserManager - loadUserProfileInfo() catch ERROR: \(error)")
                        completion(.failure(.internalError))
                    }
                default:
                    let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                    
                    print("❗️ UserManager - loadUserProfileInfo() default activated with error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }

    
    //MARK: - 사용자 비밀번호 수정
    func updatePassword(with model: EditUserInfoRequestDTO,
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
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                print("UserManager - updatePassword error: \(error.errorDescription) and statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - 사용자 프로필 이미지 업데이트
    func updateProfileImage(with model: EditUserInfoRequestDTO,
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
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                print("UserManager - updateProfileImage error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    //MARK: - 사용자 프로필 이미지 제거
    func removeProfileImage(completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let model = EditUserInfoRequestDTO(removeUserProfileImage: true)
        
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
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
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
                    let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                    print("UserManager - unregisterUser error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 내가 쓴 리뷰 삭제
    func deleteMyReview(reviewID: Int,
                        completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let url = deleteReviewURL + "\(reviewID)"
        
        AF.request(url,
                   method: .delete,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                
                case 200:
                    print("✏️ UserManager - deleteMyReview SUCCESS")
                    completion(.success(true))
                
                default:
                    let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                    print("❗️ UserManager - deleteMyReview FAILED error :\(error.errorDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - 아이디 찾기
    func findMyID(email: String,
                  completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(email.utf8),
                                     withName: "mail_address")
            
        }, to: findIDURL)
        .responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            
            case 200:
                
                do {
                    let decodedData = try JSONDecoder().decode(LoadUserInfoModel.self, from: response.data!)
                    
                    print("✏️ UserManager - findMyID SUCCESS")
                    
                    let userID = decodedData.username
                    completion(.success(userID))
                    
                } catch {
                    print("❗️ UserManager - findMyID decoding catch error: \(error)")
                    completion(.failure(.internalError))
                }
                
            default:
                
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data)
                print("❗️ UserManager - findMyID error statusCode: \(statusCode), with error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
        
        }
}

//MARK: - 사용자 정보를 로컬에 저장하는 메서드 모음

extension UserManager {
    
    func saveUserRegisterInfoToDevice(with model: RegisterResponseModel) {
        
        User.shared.savedAccessToken = KeychainWrapper.standard.set(model.accessToken,
                                                                    forKey: Constants.KeyChainKey.accessToken)
        User.shared.savedRefreshToken = KeychainWrapper.standard.set(model.refreshToken,
                                                                     forKey: Constants.KeyChainKey.refreshToken)
    
        User.shared.userUID = model.user.userID
        User.shared.username = model.user.username

        User.shared.medal = model.user.medal
        
        print("UserManager - saveUserRegisterInfoToDevice success ")
        print("New accessToken: \(User.shared.accessToken)")
    }
    
    func saveUserInfoToDevice(with model: LoadUserInfoModel) {
        
        User.shared.userUID = model.userID
        User.shared.username = model.username
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
    
        User.shared.userUID = model.user.userID
        User.shared.username = model.user.username
        User.shared.medal = model.user.medal
        
        User.shared.isLoggedIn = true
        
        print("UserManager - saveLoginInfo success ")
        print("New accessToken: \(User.shared.accessToken)")
    }
    
    
    //TODO: - 로그아웃을 한 후에 UserDefaults 에 저장되어 있는 모든 값 지우기
    func resetAllUserInfo() {
        
        User.shared.resetAllUserInfo()
        
    }
    
}
