import Foundation

class RestaurantListViewModel {
    var restaurants: [RestaurantListResponseModel] = []
}

extension RestaurantListViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.restaurants.count
    }
    
    func restaurantAtIndex(_ index: Int) -> RestaurantViewModel {
        let restaurant = self.restaurants[index]
        return RestaurantViewModel(restaurant)
    }
}

extension RestaurantListViewModel {
    func fetchRestaurantList(mall mallName: String? = nil, category categoryName: String? = nil, gate gateLocation: String? = nil, cursor: Int? = nil) {
        let model = FetchRestaurantListModel(mallName: mallName, categoryName: categoryName, gateLocation: gateLocation, cursor: cursor)
        RestaurantManager.shared.fetchRestaurantList(with: model) { result in
            switch result {
            case .success(let data):
                self.restaurants.append(contentsOf: data)
            case .failure(let error):
                return
            }
        }
    }
}

class RestaurantViewModel {
    private let restaurant: RestaurantListResponseModel
    
    init(_ restaurant: RestaurantListResponseModel) {
        self.restaurant = restaurant
    }
}

extension RestaurantViewModel {
    var mallName: String {
        return self.restaurant.mallName
    }
    
    var averageRating: Double {
        return self.restaurant.evaluateAverage ?? 0.0
    }
    
    var thumbnailURL: URL? {
        guard let files = self.restaurant.fileFolder?.files, files.count > 0 else {
            return nil
        }
        do {
            let url = try files[0].path.asURL()
            return url
        } catch {
            print("In RestaurantViewModel: \(error)")
            return nil
        }
    }
}
