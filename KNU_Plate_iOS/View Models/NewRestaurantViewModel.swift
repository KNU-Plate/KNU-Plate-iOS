import Foundation

class NewRestaurantViewModel {
    
    var newRestaurant = NewRestaurant()
    
    //MARK: - Object Properties
    
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
    

    
    public init() {
        
        self.restaurantName = ""
        self.gate = ""
        self.foodCategory = ""
        
    }
    
    
    
}

//MARK: -
extension NewRestaurantViewModel {

    
}


