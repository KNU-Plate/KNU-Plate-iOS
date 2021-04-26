import Foundation

class NewRestaurantViewModel {
    
    var newRestaurant = NewRestaurant()
    
    //MARK: - Object Properties
    
    var restaurantName: String {
        didSet {
            print("didSet Activated")
            newRestaurant.name = restaurantName
        }
    }
    
    /// 학교 문
    var gate: String {
        didSet {
            newRestaurant.gate = gate
        }
    }
    
    /// 매장 관련 사진 배열
    var userSelectedImages: [UIImage] {
        willSet {
            userSelectedImages.removeAll()
        }
        didSet {
            
            
        }
    }
    
    /// 사용자가 선택한 음식 카테고리 (i.e 한식, 중식)
    var foodCategory: String {
        didSet {
            newRestaurant.foodCategory = foodCategory
        }
    }
    
    /// 음식 카테고리 배열
    let foodCategoryArray: [String] = [
    
        "한식", "일식", "중식", "양식",
        "세계음식","카페", "술집"
    ]
    
    /// 학교 문 배열
    let schoolGates: [String] = [
    
        "북문", "정/쪽문", "동문", "서문"
    ]
    
    
    
    public init(restaurantName: String) {
        
        self.restaurantName = restaurantName
        self.gate = ""
        self.foodCategory = ""
        self.userSelectedImages = [UIImage]()
    }
    
    //MARK: - Object Methods
    
    func validateUserInputs() throws {
        
        
    }
    
    
    
}


