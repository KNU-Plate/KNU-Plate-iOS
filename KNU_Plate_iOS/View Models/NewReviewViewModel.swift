import Foundation
import UIKit

class NewReviewViewModel {
    
    var newReview = NewReview()
    
    //MARK: - Object Properties
    
    var rating: Int {
        didSet {
            newReview.rating = rating
        }
    }
    
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
    
    
    var menus: [Menu] //{
//        didSet {
//            newReview.menu.append(contentsOf: menu)
//        }
        
        
    //}
    
    var review: String {
        didSet {
            newReview.review = review
        }
    }
    
    //MARK: - Init
    
    public init() {
        
        self.rating = 3
        self.review = ""
        self.userSelectedImages = [UIImage]()
        self.menus = [Menu]()
        
    }
    
    //MARK: - Object Methods
    
    func addNewMenu(name: String) {
        
        let newMenu = Menu()
        newMenu.menuName = name
        self.menus.append(newMenu)

    }
    
    func validateUserInputs() throws {
        
        if self.menus.count == 0 { throw NewReviewInputError.insufficientMenuError }
        if self.review.count < 5 { throw NewReviewInputError.insufficientReviewError }
        
        for eachMenu in self.menus {
            
            print("eachMenu: \(eachMenu.menuName.count)")
            
            guard eachMenu.menuName.count > 0 else {
                throw NewReviewInputError.blankMenuNameError
            }
        }
        
    }
    
    
}

