import Foundation

protocol NewRestaurantViewModelDelegate {
    func didCompleteUpload(_ success: Bool)
}

class NewRestaurantViewModel {
    
    //MARK: - Object Properties
    var delegate: NewRestaurantViewModelDelegate?
    
    var restaurantName: String
    
    /// 학교 문
    var gate: String = ""
    
    /// 매장 관련 사진 배열
    var userSelectedImages: [UIImage] = [] {
        didSet { convertUIImagesToDataFormat() }
    }
    
    var userSelectedImagesInDataFormat: [Data]? = nil
    
    /// 사용자가 선택한 음식 카테고리 (i.e 한식, 중식)
    var foodCategory: String = "🇰🇷 한식"
    
    /// 음식 카테고리 배열
    let foodCategoryArray: [String] = [
        "🇰🇷 한식", "🇯🇵 일식", "🇨🇳 중식", "🇺🇸 양식",
        "🌎 세계음식","☕️ 카페", "🍹 술집"
    ]
    
    /// 학교 문 배열
    let schoolGates: [String] = [
        "북문", "정/쪽문", "동문", "서문"
    ]
    
    /// 매장 연락처
    var contact: String = ""
    
    /// 카테고리 이름 ( i.e 음식점 > 카페 > 커피전문점 > 스타벅스 )
    var categoryName: String = ""
    
    /// 매장 위치
    var address: String = ""
    
    /// Y 좌표값, 경위도인 경우 latitude(위도)
    var latitude: Double = 0.0
    
    /// X 좌표값, 경위도인 경우 longitude (경도)
    var longitude: Double = 0.0
    
    //MARK: - Init
    
    public init(restaurantName: String) {
        
        self.restaurantName = restaurantName
  
    }
    
    //MARK: - Object Methods
    
    func validateUserInputs() throws {
        
        
    }
    
    // 신규 매장 등록
    func upload() {
        
        let newRestaurantModel = NewRestaurantModel(name: restaurantName,
                                                    contact: contact,
                                                    foodCategory: foodCategory,
                                                    address: address,
                                                    categoryName: categoryName,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    images: userSelectedImagesInDataFormat)
        
        RestaurantManager.shared.uploadNewRestaurant(with: newRestaurantModel) { isSuccess in
            
            print("NewRestaurantViewModel - upload() RESULT: \(isSuccess)")
            self.delegate?.didCompleteUpload(isSuccess)
        }
    }
    
    func convertUIImagesToDataFormat() {
        
        userSelectedImagesInDataFormat?.removeAll()
        
        userSelectedImagesInDataFormat = userSelectedImages.map( { (image: UIImage) -> Data in
            if let imageData =
                image.jpegData(compressionQuality: 0.5) {
                return imageData
            } else {
                print("Unable to convert UIImage to Data type")
                return Data()
            }
        })
    }
}


