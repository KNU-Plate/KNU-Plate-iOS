import Foundation

//MARK: - Error 관리 enum

public enum RegisterError: Error, LocalizedError {
    
    
    
}



public enum NewReviewInputError: Error, LocalizedError {

    /// 음식 사진에 대한 error 가 없는 이유는 "선택사항"이기 때문임
    
    case insufficientMenuNameError
    case insufficientReviewError
    
    public var errorDescription: String {
        
        switch self {
        
        case .insufficientMenuNameError:
            return "내가 주문한 메뉴를 하나 이상은 입력해야 합니다."
        case .insufficientReviewError:
            return "드셨던 음식에 대한 리뷰를 최소 5자 이상은 입력해주세요."
        
        
        }
        
    }

}


public enum NewRestaurantInputError: Error, LocalizedError {
    
    
}



