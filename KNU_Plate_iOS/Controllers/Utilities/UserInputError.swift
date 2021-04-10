import Foundation

//MARK: - Error 관리 enum


//MARK: - 신규 리뷰 등록 시 일어날 수 있는 Error
 
public enum NewReviewInputError: Error, LocalizedError {
    
    /// 메뉴를 하나도 안 추가했을 때 발생하는 Error
    case insufficientMenuError
    
    /// 메뉴명이 비었을 때 발생하는 Error
    case blankMenuNameError
    
    /// 리뷰를 적지 않았을 때 발생하는 Error
    case insufficientReviewError
    
    public var errorDescription: String {
        
        switch self {
        
        case .insufficientMenuError:
            return "내가 주문한 메뉴를 하나 이상은 입력해야 합니다."
        case .blankMenuNameError:
            return "비어있는 메뉴명이 있습니다."
        case .insufficientReviewError:
            return "드셨던 음식에 대한 리뷰를 최소 5자 이상은 입력해주세요."
        
        }
    }
}

//MARK: - 신규 맛집 등록 시 일어날 수 있는 Error

public enum NewRestaurantInputError: Error, LocalizedError {
    
    
}



