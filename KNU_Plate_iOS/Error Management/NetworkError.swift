import Foundation
import SwiftyJSON

//MARK: - 각종 Network 관련된 Error 를 처리하는 파일

enum NetworkError: Int, Error {
    
    case success        = 200

    // 잘못된 접근 or 요청
    case badRequest     = 400
    case unauthorized   = 401
    case notFound       = 404
    
    // Server 문제
    case internalError  = 500
    
    var errorDescription: String {
        
        switch self {
        
        case .success:
            return "성공"
        case .badRequest:
            return "일시적인 오류입니다. 잠시 후 다시 시도해주세요😢"
        case .internalError:
            return "일시적인 서비스 오류입니다. 잠시 후 다시 시도해주세요😢"
        case .notFound:
            return "요청히신 작업을 처리할 수 없습니다. 잠시 후 다시 시도해주세요😢 "
        case .unauthorized:
            return "세션이 만료되었습니다. 다시 로그인해주세요🧐"
        }
    }
    
    static func returnError(statusCode: Int) -> NetworkError {
        return NetworkError(rawValue: statusCode) ?? .internalError
    }
}

//MARK: - 업로드 상황에서 마주할 수 있는 다양한 에러 처리 enum

enum UploadError: Error {
    
    case alreadyEnrolledMall
    
    var errorDescription: String {
        
        switch self {
        
        case .alreadyEnrolledMall:
            return "이미 등록된 매장입니다. 🤔"
        }
    }
    
}

//MARK: - 회원가입 Error Message 관리

enum SignUpError: String, Error {
    
    case usernameLengthTooLong = "user_name length is too short or too long"
    case usernameAlreadyExists = "user_name is unique"
    
    ///다른 에러는 준수씨한테 받기
    
    func returnErrorMessage() -> String {
        
        switch self {
        
        case .usernameLengthTooLong:
            return "로그인 아이디는 4자 이상 20자 이하여야 합니다."
        case .usernameAlreadyExists:
            return "아이디가 중복입니다."
        //TODO: - 준수씨한테 가능한 모든 오류 목록 받기
        }
    }
}

//MARK: - 로그인 Error Message 관리

enum LogInError: String, Error {
    
    case userNotFound = "invalid password"
    case invalidPassword = "user not founded"
    
    func returnErrorMessage() -> String {
        
        switch self {
        
        case.userNotFound:
            return "아이디가 잘못되었습니다."
        case .invalidPassword:
            return "비밀번호를 다시 한 번 확인해 주세요."
        }
    }
}

//MARK: - 메일 인증 Error Message 관리

//enum MailVerificationError: String {
//
//
//}

//MARK: - 인증코드 발급 Error Message 관리

enum MailVerificationIssuanceError: String, Error {
    
    case emptyToken = "token is empty"

    func returnErrorMessage() -> String {
        
        switch self {
        
        case .emptyToken:
            return "잘못된 요청입니다."
        }
    }

}
