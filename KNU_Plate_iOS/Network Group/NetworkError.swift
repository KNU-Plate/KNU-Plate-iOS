import Foundation

//MARK: - 각종 Network 관련된 Error 를 처리하는 파일

enum HTTPStatus: Int, Error, LocalizedError {
    
    case success = 200
    
    /// The request was unacceptable, often due to missing a required parameter.
    case badRequest = 400
    
    /// Something went wrong on our end.
    case internalError = 500
    
    /// The requested resource doesn’t exist.
    case notFound = 404
    
    var errorDescription: String? {
        
        switch self {
        
        case .success:
            return "Success: 200"
        case .badRequest:
            return "Bad Request: 400"
        case .internalError:
            return "Internal Server Error: 500"
        case .notFound:
            return "Not Found Error: 404"
        }
    }
}

//MARK: - 회원가입 Error Message 관리 클래스

class SignUpError {
    
    static let shared = SignUpError()
    
    let usernameLengthTooLong = "user_name length is too short or too long"
    let usernameAlreadyExists = "user_name is unique"
    
    ///다른 에러는 준수씨한테 받기
    
    func returnErrorMessage(_ errorString: String) -> String {
        
        switch errorString {
        
        case self.usernameLengthTooLong:
            return "로그인 아이디는 4자 이상 20자 이하여야 합니다."
            
        case self.usernameAlreadyExists:
            return "아이디가 중복입니다."
            
        //TODO: - 준수씨한테 가능한 모든 오류 목록 받기
        default:
            return "알 수 없는 오류입니다."
        }
    }

}

//MARK: - 로그인 Error Message 관리 Struct

class LogInError {
    
    
    

}

//MARK: - 메일 인증 Error Message 관리 클래스

class MailVerificationError {
    
}

//MARK: - 인증코드 발급 Error Message 관리 클래스

class MailVerificationIssuanceError {
    
}

//MARK: - 로그아웃 Error Message 관리 클래스

class LogOutError {
    
}

class UnregisterError {
    
    
}

