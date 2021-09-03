import Foundation

protocol NewRestaurantViewModelDelegate: AnyObject {
    func didCompleteUpload(_ success: Bool)
    func alreadyRegisteredRestaurant(with error: UploadError)
    func failedToUpload(with error: NetworkError)
}

class NewRestaurantViewModel {
    
    //MARK: - Object Properties
    weak var delegate: NewRestaurantViewModelDelegate?
    
    var restaurantName: String
    
    var placeID: String = ""
    
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
    let foodCategoryArray: [String] = Constants.footCategoryArray
    
    /// 학교 문 배열
    let schoolGates: [String] = Constants.gateNames
    
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
        
        let newRestaurantModel = NewRestaurantRequestDTO(name: restaurantName,
                                                         placeID: placeID,
                                                         contact: contact,
                                                         foodCategory: foodCategory,
                                                         address: address,
                                                         categoryName: categoryName,
                                                         latitude: latitude,
                                                         longitude: longitude,
                                                         images: userSelectedImagesInDataFormat)
        
        RestaurantManager.shared.uploadNewRestaurant(with: newRestaurantModel) { [weak self] result in
            
            guard let self = self else { return }
            
            print("✏️ NewRestaurantViewModel - upload() RESULT: \(result)")
            
            switch result {
            
            case .success(_):
                self.delegate?.didCompleteUpload(true)
                NotificationCenter.default.post(name: .didUploadNewMall, object: nil)
                
            case .failure(let error):
                
                if let uploadError = error as? UploadError {
                    self.delegate?.alreadyRegisteredRestaurant(with: uploadError)
                    return
                }
                
                if let error = error as? NetworkError {
                    self.delegate?.failedToUpload(with: error)
                }
            
            }
        }
    }
    
    func convertUIImagesToDataFormat() {
        
        userSelectedImagesInDataFormat?.removeAll()
        userSelectedImagesInDataFormat = userSelectedImages.map( { (image: UIImage) -> Data in
            if let imageData =
                image.jpegData(compressionQuality: 1.0) {
                return imageData
            } else {
                print("Unable to convert UIImage to Data type")
                return Data()
            }
        })
    }
}


