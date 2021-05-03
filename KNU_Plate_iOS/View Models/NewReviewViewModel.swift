import Foundation
import UIKit

class NewReviewViewModel {
    
    //MARK: - Object Properties
    
    var rating: Int
    
//
//    var userSelectedImagesInJPEG: Data {
//        didSet {
//
//        }
//    }
    
    var userSelectedImages: [UIImage] {
        willSet {
            userSelectedImages.removeAll()
        }
        didSet {
            /// 받은 UIImage 를 JPEGData 로 저장하고,
            /// userSelectedImagesInJPEG 에 저장 후
            /// NewReview 모델에 저장
        }
    }
    
    /// 이미 매장에 등록되어 있는 메뉴 배열
    var existingMenus: [ExistingMenuModel] = [
    
        
    ExistingMenuModel(menuID: 1, mallID: 1, menuName: "삼겹살", likes: 2, dislikes: 3),
    ExistingMenuModel(menuID: 2, mallID: 1, menuName: "피자", likes: 4, dislikes: 10),
    ExistingMenuModel(menuID: 2, mallID: 1, menuName: "족발", likes: 20, dislikes: 1),
    
    // ------------------항상 있는것
    ExistingMenuModel(menuID: 0, mallID: 0, menuName: "직접 입력", likes: 0, dislikes: 0)
    ]
    
    /// 사용자가 직접 추가한 메뉴
    var userAddedMenus: [NewMenuModel]
    
    /// 업로드 할 총 배열?
    var menusToUpload: [UploadMenuModel]

    
    var review: String

    
    
    
    
    
    
    //MARK: - Init
    
    public init() {
        
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
    
    // 신규 리뷰 등록
    func upload() {
        
 
        
        
        
        
        
    }
    
    
    
    
    /*
     
     
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
             
             print("RESULT: \(isSuccess)")
             self.delegate?.didCompleteUpload(isSuccess)
         }
         
         
     }
     */
    
    
}

