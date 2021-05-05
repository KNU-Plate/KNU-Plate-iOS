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
            return "Bad Request: 400"               /// 잘못된 요청 . 타입 오류, 필수값 오류
        case .internalError:
            return "Internal Server Error: 500"     /// 일관적으로 처리 -> 삭제된 계정, 없는 계정 조회 시 500번대 error return .. 많아봤자 20개
        case .notFound:
            return "Not Found Error: 404"
        }
    }
}

//MARK: - 회원가입 Error Message 관리

enum SignUpError: String {
    
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

enum LogInError: String {
    
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

enum MailVerificationIssuanceError: String {
    
    case emptyToken = "token is empty"

    func returnErrorMessage() -> String {
        
        switch self {
        
        case .emptyToken:
            return "잘못된 요청입니다."
        }
    }

}
//
////MARK: - 로그아웃 Error Message 관리
//
//enum LogOutError: String {
//
//}
//
//enum UnregisterError: String {
//
//
//}







//MARK: - 신규 매장 등록 Error Message 관리

enum NewRestaurantUploadError: String {
    
    case mallAlreadyExists = "already enrolled mall"
    
    func returnErrorMessage() -> String {
        
        switch self {
        
        case .mallAlreadyExists:
            return "이미 등록된 매장입니다. 홈화면으로 돌아가시겠습니까?"
        }
    }
}

//MARK: - 신규 리뷰 등록 Error Message 관리

//enum NewMenuUploadError: String {
//
//
//    func returnErrorMessage() -> String {
//
//        switch self {
//
//    }
//}
