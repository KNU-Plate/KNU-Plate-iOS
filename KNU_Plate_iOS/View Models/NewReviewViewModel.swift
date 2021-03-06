import Foundation
import UIKit

protocol NewReviewViewModelDelegate: AnyObject {
    func didCompleteReviewUpload(_ success: Bool)
    func failedUploadingReview(with error: NetworkError)
    
    func didCompleteMenuUpload()
    func failedUploadingMenu(with error: NetworkError)
}

class NewReviewViewModel {
    
    //MARK: - Object Properties
    weak var delegate: NewReviewViewModelDelegate?
    
    var mallID: Int
    
    var rating: Int = 4
    
    var userSelectedImagesInDataFormat: [Data]?
    
    var userSelectedImages = [UIImage]() {
        didSet { convertUIImagesToDataFormat() }
    }
    
    var existingMenus: [ExistingMenuModel] = [ExistingMenuModel(menuID: 0,
                                                                mallID: 0,
                                                                menuName: "직접 입력",
                                                                likes: 0,
                                                                dislikes: 0)]
    
    /// 사용자가 추가한 메뉴
    var userAddedMenus = [UserAddedMenuModel]()
    
    /// 따로 DB 에 등록해야 할 메뉴
    var menusToUpload = [UploadMenuModel]()
    
    /// 리뷰를 최종적으로 등록할 때 필요한 메뉴의 Model
    var finalMenuInfo = [FinalMenuModel]()
    
    var review: String = ""

    var menuInfoInJSONString: String = ""

   
    //MARK: - Init
    
    public init(mallID: Int, existingMenus: [ExistingMenuModel]) {
        
        self.mallID = mallID
        self.existingMenus.insert(contentsOf: existingMenus, at: 0)
    }
    
    //MARK: - Object Methods
    
    func addNewMenu(name: String) {
    
        let newMenu = UserAddedMenuModel(menuName: name)
        self.userAddedMenus.append(newMenu)
        
        if checkIfMenuNeedsToBeNewlyRegistered(menuName: name) {
            let newMenuToUpload = UploadMenuModel(mallID: self.mallID,
                                                  menuName: name)
            menusToUpload.append(newMenuToUpload)
        }
    }
    
    // DB에 새로 등록해야 하는 메뉴인지 파악하는 함수
    func checkIfMenuNeedsToBeNewlyRegistered(menuName: String) -> Bool {
        
        for eachMenu in existingMenus {
            if menuName == eachMenu.menuName { return false }
        }
        return true
    }
    
    func startUploading() {
        
        if menusToUpload.isEmpty {
            
            convertMenusToUploadableFormat(with: nil)
            menuInfoInJSONString = convertMenusToJSONString(from: finalMenuInfo)
            uploadReview()
            
        } else {
            uploadNewMenus()
        }
    }
    
    // DB에 메뉴 등록
    func uploadNewMenus() {
        
        var menuNames: [String] = []
    
        for eachMenu in menusToUpload {
            menuNames.append(eachMenu.menuName)
        }
        let model = RegisterNewMenuRequestDTO(mallID: self.mallID,
                                         menuName: menuNames)
    
        RestaurantManager.shared.uploadNewMenu(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let responseModel):
                
                self.convertMenusToUploadableFormat(with: responseModel)
                self.menuInfoInJSONString = self.convertMenusToJSONString(from: self.finalMenuInfo)
                self.uploadReview()
                
            case .failure(let error):
                
                self.delegate?.failedUploadingMenu(with: error)
            }
        }
    }
    
    // 신규 리뷰 등록
    func uploadReview() {
    
        let newReviewModel = NewReviewRequestDTO(mallID: mallID,
                                            menus: menuInfoInJSONString,
                                            review: review,
                                            rating: rating,
                                            reviewImages: userSelectedImagesInDataFormat)
        
        RestaurantManager.shared.uploadNewReview(with: newReviewModel) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(_):
                self.delegate?.didCompleteReviewUpload(true)
                
            case .failure(let error):
                self.delegate?.failedUploadingReview(with: error)
                
            }
        }
    }
    
    //MARK: - Conversion Methods
    
    func convertUIImagesToDataFormat() {
        userSelectedImagesInDataFormat?.removeAll()
        
        userSelectedImagesInDataFormat = userSelectedImages.map( { (image: UIImage) -> Data in
            
            if let imageData = image.jpegData(compressionQuality: 1) {
                return imageData
            } else {
                print("Unable to convert UIImage to Data type")
                return Data()
            }
        })
    }
    
    func convertMenusToUploadableFormat(with model: [MenuRegisterResponseModel]?) {
        
        for i in 0..<userAddedMenus.count {

            for j in 0..<existingMenus.count {
                
                if userAddedMenus[i].menuName == existingMenus[j].menuName {
                    
                    let menuID = existingMenus[j].menuID
                    let isGood = userAddedMenus[i].isGood
                    let newMenu = FinalMenuModel(menuID: menuID, isGood: isGood)

                    finalMenuInfo.append(newMenu)
                }
            }
        }
    
        if let model = model {
            
            for i in 0..<model.count {
                
                for j in 0..<userAddedMenus.count {
                    
                    if model[i].menuName == userAddedMenus[j].menuName {
                        
                        let menuID = model[i].menuID
                        let isGood = userAddedMenus[j].isGood
                        let newMenu = FinalMenuModel(menuID: menuID, isGood: isGood)
                        
                        finalMenuInfo.append(newMenu)
                    }
                }
            }
        }
    }
    
    func convertMenusToJSONString(from data: [FinalMenuModel]) -> String {
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            
            let JSONData = try encoder.encode(data)
            let JSONString = String(data: JSONData, encoding: .utf8)
            
            if let encodedData = JSONString {
                return encodedData
            }
        } catch {
            print("NEW REVIEW VIEW MODEL - There was an error in convertMenusToUploadToJSONString()")
        }
        fatalError("NEW REVIEW VIEW MODEL - convertMenusToUploadToJSONString FAILED")
    }


}

//MARK: - User Input Validation Methods

extension NewReviewViewModel {
    
    func validateMenuName(menu: String) throws {
        
        if userAddedMenus.count > 5 { throw NewReviewInputError.tooMuchMenusAdded }
        if menu.count == 0 { throw NewReviewInputError.menuNameTooShort }
        
        for eachMenu in userAddedMenus {
            guard eachMenu.menuName != menu else {
                throw NewReviewInputError.alreadyExistingMenu
            }
        }
    }
    
    func validateUserInputs() throws {

        /// 메뉴 개수가 0개이면 Error
        if self.userAddedMenus.count == 0 { throw NewReviewInputError.insufficientMenuError }

        /// 리뷰 글자수가 5 미만이면 Error
        if self.review.count < 5 { throw NewReviewInputError.insufficientReviewError }
        
        if self.review.count > 300 { throw NewReviewInputError.reviewTooLong }
        
        /// 입력한 메뉴 중 메뉴명이 비어있는게 하나라도 있으면 Error
        for eachMenu in userAddedMenus {
            guard eachMenu.menuName.count > 0 else {
                throw NewReviewInputError.blankMenuNameError
            }
        }
        

    }
}
