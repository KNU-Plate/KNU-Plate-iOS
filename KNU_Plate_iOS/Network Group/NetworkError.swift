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

/// error(String)를 사용자에게 표시될 메시지로 변환
func errorToMessage(_ errorString: String) -> String {
    let message: String
    // conditions have to be added
    if errorString == "user_name length is too short or too long" {
        message = "로그인 아이디는 4자 이상 20자 이하여야 합니다."
    } else if errorString == "user_name is unique" {
        message = "아이디가 중복입니다."
    } else {
        message = "알 수 없는 에러입니다."
    }
    return message
}
