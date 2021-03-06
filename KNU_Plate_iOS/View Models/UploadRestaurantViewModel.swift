import Foundation

class NewRestaurantViewModel {
    
    var newRestaurant = NewRestaurant()
    
    // Variable Initialization
    
    var restaurantName: String {
        didSet {
            newRestaurant.name = restaurantName
        }
    }
    
    var gate: String {
        didSet {
            newRestaurant.gate = gate
        }
    }
    
    var foodCategory: String {
        didSet {
            newRestaurant.foodCategory = foodCategory
        }
    }
    
    var rating: Int {
        didSet {
            newRestaurant.rating = rating
        }
    }
    
    var userReview: String {
        didSet {
            newRestaurant.userReview = userReview
        }
    }
    
    public init() {
        
        self.restaurantName = ""
        self.gate = ""
        self.foodCategory = ""
        self.rating = 3
        self.userReview = ""
    }
    
    
    
}

//MARK: -
extension NewRestaurantViewModel {

    
}


