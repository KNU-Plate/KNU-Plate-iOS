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
    
    func restaurantAtIndex(_ index: Int) -> RestaurantViewModel {
        let restaurant = self.restaurants[index]
        return RestaurantViewModel(restaurant)
    }
}

extension RestaurantListViewModel {
    func fetchRestaurantList(mall mallName: String? = nil, category categoryName: String? = nil, gate gateLocation: String? = nil) {
        isFetchingData = true
        let model = FetchRestaurantListRequestDTO(mallName: mallName, categoryName: categoryName, gateLocation: gateLocation, cursor: lastMallID)
        RestaurantManager.shared.fetchRestaurantList(with: model) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                    return
                }
                self.restaurants.append(contentsOf: data)
                self.lastMallID = data.last?.mallID
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
                    return
                }
                self.restaurants.append(contentsOf: data)
                self.lastMallID = data.last?.mallID
                self.isFetchingData = false
                self.delegate?.didFetchRestaurantList()
            case .failure:
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
    
    var mallID: Int {
        return self.restaurant.mallID
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
