import Foundation

protocol RestaurantListViewModelDelegate: AnyObject {
    func didFetchRestaurantList()
}

class RestaurantListViewModel {
    weak var delegate: RestaurantListViewModelDelegate?
    var restaurants: [RestaurantListResponseModel] = []
    var hasMore: Bool = true
    var isFetchingData: Bool = false
    private var lastMallID: Int?
}

extension RestaurantListViewModel {
    var numberOfRestaurants: Int {
        return self.restaurants.count
    }
    
    func refreshFavoriteRestaurantList() {
        self.restaurants.removeAll(keepingCapacity: true)
        self.hasMore = true
        self.isFetchingData = false
        self.lastMallID = nil
        self.fetchFavoriteRestaurantList()
    }
    
    func resetRestaurantList() {
        self.restaurants.removeAll()
        self.hasMore = true
        self.isFetchingData = false
        self.lastMallID = nil
    }
    
    func restaurantAtIndex(_ index: Int) -> RestaurantViewModel {
        let restaurant = self.restaurants[index]
        return RestaurantViewModel(restaurant)
    }
}

extension RestaurantListViewModel {
    func fetchRestaurantList(mall mallName: String? = nil, category categoryName: String? = nil, gate gateLocation: String? = nil) {
        showProgressBar()
        isFetchingData = true
        let model = FetchRestaurantListRequestDTO(mallName: mallName, categoryName: categoryName, gateLocation: gateLocation, cursor: lastMallID)
        RestaurantManager.shared.fetchRestaurantList(with: model) { [weak self] result in
            dismissProgressBar()
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastMallID = data.last?.mallID
                }
                self.restaurants.append(contentsOf: data)
                self.isFetchingData = false
                self.delegate?.didFetchRestaurantList()
            case .failure:
                return
            }
        }
    }
    
    func fetchFavoriteRestaurantList() {
        isFetchingData = true
        RestaurantManager.shared.fetchFavoriteRestaurantList(cursor: lastMallID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastMallID = data.last?.mallID
                }
                self.restaurants.append(contentsOf: data)
                self.isFetchingData = false
                self.delegate?.didFetchRestaurantList()
            case .failure:
                return
            }
        }
    }
    
    func fetchTodaysRecommendation() {
        let foodCategory = getRecommendationCategory()
        let category = Category(foodCategory: foodCategory)
        
        fetchRestaurantList(category: category.foodCategory)
    }
}

extension RestaurantListViewModel {
    
    // 오후 1~5시 사이에는 카페, 그 외는 음식점 추천을 위함
    func getRecommendationCategory() -> String {
        let now = Date()
        let one_PM = now.dateAt(hours: 13, minutes: 0)
        let five_PM = now.dateAt(hours: 17, minutes: 0)
        
        let index: Int?
        
        if now >= one_PM && now <= five_PM {
            index = Constants.footCategoryArray.firstIndex(of: "☕️ 카페") ?? 5
        } else {
            let array = Constants.footCategoryArray.filter { $0 != "☕️ 카페" }
            index = Int.random(in: 0...array.count - 1)
        }
        
        let foodCategoryName = Constants.footCategoryArray[index!]
        let startIdx = foodCategoryName.index(foodCategoryName.startIndex, offsetBy: 2)
        let foodCategory = String(foodCategoryName[startIdx...])
        return foodCategory
    }
}

//MARK: - RestaurantViewModel

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
    
    var mallID: Int {
        return self.restaurant.mallID
    }
    
    var averageRating: Double {
        return self.restaurant.evaluateAverage ?? 0.0
    }
    
    var reviewCount: Int {
        return self.restaurant.reviewCount
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
