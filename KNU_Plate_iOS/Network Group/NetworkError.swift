import Foundation

public enum HTTPStatusError: Int, Error, LocalizedError {
    
    case success = 200
    /// The request was unacceptable, often due to missing a required parameter.
    case badRequest = 400
    /// Something went wrong on our end.
    case internalError = 500
    /// The requested resource doesn’t exist.
    case notFound = 404
    
    public var errorDescription: String {
        
        switch self {
        
        case .success:
            return "Success"
        case .badRequest:
            return "잘못된 요청입니다."
        case .internalError:
            return "서버에 문제가 있습니다."
        case .notFound:
            return "조회에 실패하였습니다"
        }
    }
    
    
}
