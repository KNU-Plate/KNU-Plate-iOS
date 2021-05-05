import Foundation

//MARK: - User Input 시 일어날수 있는 Error 관리 enum 모음


//MARK: - 신규 리뷰 등록 시 일어날 수 있는 Error
 
enum NewReviewInputError: Error, LocalizedError {
    
    /// 메뉴를 하나도 안 추가했을 때 발생하는 Error
    case insufficientMenuError
    
    /// 메뉴명이 비었을 때 발생하는 Error
    case blankMenuNameError
    
    /// 리뷰를 적지 않았을 때 발생하는 Error
    case insufficientReviewError
    
    /// 중복 메뉴를 추가하려고 할 때 발생하는 Error
    case alreadyExistingMenu
    
    /// 추가하려는 메뉴 개수가 5개 이상이면 발생하는 Error
    case tooMuchMenusAdded
    
    /// 메뉴명 길이가 0일 때 발생하는 Error (아무것도 입력 안 했는데 메뉴를 추가하려고 할 때임)
    case menuNameTooShort
    
    // TODO: - 이것도 Network Error 형식으로 바꾸기
    
    var errorDescription: String {
        
        switch self {
        
        case .insufficientMenuError:
            return "내가 주문한 메뉴를 하나 이상은 입력해야 합니다."
        case .blankMenuNameError:
            return "비어있는 메뉴명이 있습니다."
        case .insufficientReviewError:
            return "드셨던 음식에 대한 리뷰를 최소 5자 이상은 입력해주세요."
        case .alreadyExistingMenu:
            return "이미 추가하신 메뉴입니다."
        case .tooMuchMenusAdded:
            return "메뉴는 최대 5개까지만 입력이 가능해요."
        case .menuNameTooShort:
            return "드신 메뉴를 입력해 주세요. 빈 칸은 추가가 불가능해요."
        }
    }
}

//MARK: - 신규 맛집 등록 시 일어날 수 있는 Error

enum NewRestaurantInputError: Error, LocalizedError {
    

    
}



