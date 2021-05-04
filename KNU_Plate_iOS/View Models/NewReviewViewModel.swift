import Foundation
import UIKit

protocol NewReviewViewModelDelegate {
    func didCompleteUpload(_ success: Bool)
}

class NewReviewViewModel {
    
    //MARK: - Object Properties
    var delegate: NewReviewViewModelDelegate?
    
    var mallID: Int
    
    var rating: Int
    
    var userSelectedImagesInDataFormat: [Data]?
    
    var userSelectedImages: [UIImage] {
        didSet { convertUIImagesToDataFormat() }
    }
    
    /// 이미 매장에 등록되어 있는 메뉴 배열
    var existingMenus: [ExistingMenuModel] = [
    
    ExistingMenuModel(menuID: 1, mallID: 1, menuName: "삼겹살", likes: 2, dislikes: 3),
    ExistingMenuModel(menuID: 2, mallID: 1, menuName: "피자", likes: 4, dislikes: 10),
    ExistingMenuModel(menuID: 2, mallID: 1, menuName: "족발", likes: 20, dislikes: 1),
    
    // ------------------항상 있는것
    ExistingMenuModel(menuID: 0, mallID: 0, menuName: "직접 입력", likes: 0, dislikes: 0)
        
    ]
    
    /// 사용자가 추가한 메뉴
    var userAddedMenus: [NewMenuModel]
    
    /// 따로 DB 에 등록해야 할 메뉴
    var menusToUpload: [UploadMenuModel]

    
    var review: String

    
   
    //MARK: - Init
    
    public init(mallID: Int) {
        
        ///mallID 추후 dynamic 하게 수정 self.mallID = mallID
        self.mallID = 2
        self.rating = 3
        
        self.userSelectedImages = [UIImage]()
        //self.existingMenus = [ExistingMenuModel]()
        self.userAddedMenus = [NewMenuModel]()
        self.menusToUpload = [UploadMenuModel]()
        self.review = ""

    }
    
    //MARK: - Object Methods
    
    func addNewMenu(name: String) {

        let newMenu = NewMenuModel(menuName: name)
        self.userAddedMenus.append(newMenu)
        
        if checkIfMenuNeedsToBeNewlyRegistered(menuName: name) {
            let newMenuToUpload = UploadMenuModel(mallID: 2,
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
    
    // DB에 메뉴 등록
    func uploadMenuInfo() {
        
        //TODO: - 수정 필요

        let mall_id = menusToUpload[0].mallID
        let menu_name = menusToUpload[0].menuName
        
        let model = RegisterNewMenuModel(mallID: mall_id,
                                                 menuName: menu_name)
        

        
        RestaurantManager.shared.uploadNewMenu(with: model) { responseModel in
            
      
            
            
            
        }

        
        

    }
    
    
    // 신규 리뷰 등록
    func uploadReview() {
        
        /*
         현재 상황 : addMenu 하면 NewMenuModel 로 되지 UploadMenuModel 형태가 아님
         변환이 필요해보임.
         
         */
        
        let menuInfo = convertMenusToUploadToJSONString()

        let newReviewModel = NewReviewModel(mallID: mallID,
                                            menus: menuInfo,
                                            review: review,
                                            rating: rating,
                                            reviewImages: userSelectedImagesInDataFormat)
        
        RestaurantManager.shared.uploadNewReview(with: newReviewModel) { isSuccess in
            
            print("SUCCESSFULLY UPLOAD NEW REVIEW")
            self.delegate?.didCompleteUpload(isSuccess)
        }
        
        
        
    }
    
    //MARK: - Conversion Methods
    
    func convertUIImagesToDataFormat() {
        userSelectedImagesInDataFormat?.removeAll()
        
        userSelectedImagesInDataFormat = userSelectedImages.map( { (image: UIImage) -> Data in
            
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                return imageData
            } else {
                print("Unable to convert UIImage to Data type")
                return Data()
            }
        })
    }
    
    func convertMenusToUploadToJSONString() -> String {
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            
            let JSONData = try encoder.encode(menusToUpload)
            let JSONString = String(data: JSONData, encoding: .utf8)
            
            if let encodedData = JSONString {
                return encodedData
            }
            
        } catch {
            print("There was an error in convertMenusToUploadToJSONString()")
        }
        fatalError("convertMenusToUploadToJSONString FAILED")
    }
    
    //MARK: - User Input Validation Methods
    
    func validateMenuName(menu: String) throws {
        
        if userAddedMenus.count > 5 { throw NewReviewInputError.tooMuchMenusAdded }
        if menu.count == 0 { throw NewReviewInputError.menuNameTooShort }
        
        for eachMenu in userAddedMenus {
            if eachMenu.menuName == menu {
                throw NewReviewInputError.alreadyExistingMenu
            }
        }
    }
    
    func validateUserInputs() throws {

        /// 메뉴 개수가 0개이면 Error
        if self.userAddedMenus.count == 0 { throw NewReviewInputError.insufficientMenuError }

        /// 리뷰 글자수가 5 미만이면 Error
        if self.review.count < 5 { throw NewReviewInputError.insufficientReviewError }

        /// 입력한 메뉴 중 메뉴명이 비어있는게 하나라도 있으면 Error
        for eachMenu in userAddedMenus {
            guard eachMenu.menuName.count > 0 else {
                throw NewReviewInputError.blankMenuNameError
            }
        }
    }
}

