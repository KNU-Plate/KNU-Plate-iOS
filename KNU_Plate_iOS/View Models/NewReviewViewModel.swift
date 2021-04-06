import Foundation

class NewReviewViewModel {
    
    var newReview = NewReview()
    
    // Variable Initialization
    
    var rating: Int {
        didSet {
            newReview.rating = rating
        }
    }
    
//    var reviewImages: Data {
//        didSet {
//            newReview.
//        }
//    }
    
    
    var menu: [Menu] //{
//        didSet {
//            newReview.menu.append(contentsOf: menu)
//        }
//    }
    
    var review: String {
        didSet {
            newReview.review = review
        }
    }
    
    
    public init() {
        
        self.rating = 3
        self.review = ""
        self.menu = [Menu]()
        
    }
    
    func addNewMenu() {
        
        let newMenu = Menu()
        self.menu.append(newMenu)
    }
    
    
}
