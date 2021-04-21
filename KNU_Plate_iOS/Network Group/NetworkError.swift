import Foundation

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

enum SignUpError: String {
    
    case usernameLengthTooLong = "user_name length is too short or too long"
    case usernameAlreadyExists = "user_name is unique"
    
    func returnErrorMessage() -> String {
        
        switch self {
        case .usernameLengthTooLong:
            return "로그인 아이디는 4자 이상 20자 이하여야 합니다."

        case .usernameAlreadyExists:
            return "아이디가 중복입니다."
        }
    }
}
