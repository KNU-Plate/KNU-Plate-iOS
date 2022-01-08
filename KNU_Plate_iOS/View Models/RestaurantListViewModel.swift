import Foundation

protocol RestaurantListViewModelDelegate: AnyObject {
    func didFetchRestaurantList()
}

class RestaurantListViewModel {
    weak var delegate: RestaurantListViewModelDelegate?
    private var restaurants: [RestaurantListResponseModel] = []
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
        #warning("showProgressBar()하는 위치 Manager파일로 옮기기")
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
        let onePM = now.dateAt(hours: 13, minutes: 0)
        let fivePM = now.dateAt(hours: 17, minutes: 0)
        
        var index: Int = Constants.foodCategoryArray.firstIndex(of: "☕️ 카페") ?? 5
        
        if now < onePM || now > fivePM {
            var indexArray = Array<Int>(0..<Constants.foodCategoryArray.count)
            indexArray.remove(at: index)
            index = indexArray.randomElement() ?? 0
        }
        
        let foodCategoryName = Constants.foodCategoryArray[index]
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
