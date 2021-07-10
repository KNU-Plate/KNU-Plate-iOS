import Foundation

protocol RestaurantInfoViewModelDelegate: AnyObject {
    func didFetchRestaurantInfo()
    func didFetchRestaurantImages()
}

class RestaurantInfoViewModel {
    weak var delegate: RestaurantInfoViewModelDelegate?
    
    private var restaurant: RestaurantInfoResponseModel? {
        didSet {
            if let restaurant = restaurant {
                self.menus = restaurant.menus
            }
        }
    }
    private var titleImages: [RestaurantImageResponseModel] = []
    private var reviews: [ReviewListResponseModel] = []
    private var menus: [ExistingMenuModel] = []
    
    private var mallID: Int?
    
    func setMallID(mallID: Int?) {
        self.mallID = mallID
    }
}

extension RestaurantInfoViewModel {
    var mallName: String {
        return self.restaurant?.mallName ?? ""
    }
    
    var category: String {
        return self.restaurant?.categoryName ?? ""
    }
    
    var rating: Double {
        return self.restaurant?.evaluateAverage ?? 0.0
    }
    
    var gate: String {
        return self.restaurant?.gateLocation ?? ""
    }
    
//    var isFavorite: Bool {
//        if let restaurant = self.restaurant {
//            if restaurant.myRecommend == "Y" {
//                return true
//            } else {
//                return false
//            }
//        }
//        return false
//    }
    
    func fetchRestaurantInfo() {
        guard let mallID = self.mallID else {
            print("RestaurantInfoViewModel: mallID is empty")
            return
        }
        RestaurantManager.shared.fetchRestaurantInfo(of: mallID) { [weak self] result in
            switch result {
            case .success(let data):
                self?.restaurant = data
                self?.delegate?.didFetchRestaurantInfo()
            case .failure:
                return
            }
        }
    }
}

extension RestaurantInfoViewModel {
    var image1URL: URL? {
        if self.titleImages.count > 0 {
            let path = self.titleImages[0].path
            do {
                let url = try path.asURL()
                return url
            } catch {
                print("In RestaurantInfoViewModel: \(error)")
                return nil
            }
        }
        return nil
    }
    
    var image2URL: URL? {
        if self.titleImages.count > 1 {
            let path = self.titleImages[1].path
            do {
                let url = try path.asURL()
                return url
            } catch {
                print("In RestaurantInfoViewModel: \(error)")
                return nil
            }
        }
        return nil
    }
    
    var image3URL: URL? {
        if self.titleImages.count > 2 {
            let path = self.titleImages[2].path
            do {
                let url = try path.asURL()
                return url
            } catch {
                print("In RestaurantInfoViewModel: \(error)")
                return nil
            }
        }
        return nil
    }
    
    var image4URL: URL? {
        if self.titleImages.count > 3 {
            let path = self.titleImages[3].path
            do {
                let url = try path.asURL()
                return url
            } catch {
                print("In RestaurantInfoViewModel: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func fetchTitleImages() {
        guard let mallID = self.mallID else {
            print("RestaurantInfoViewModel: mallID is empty")
            return
        }
        RestaurantManager.shared.fetchRestaurantImages(of: mallID) { [weak self] result in
            switch result {
            case .success(let data):
                self?.titleImages = data
                self?.delegate?.didFetchRestaurantImages()
                print("👌 titleImages count: \(self?.titleImages.count)")
            case .failure:
                return
            }
        }
    }
}

extension RestaurantInfoViewModel {
    func fetchReviews() {
        
    }
}
