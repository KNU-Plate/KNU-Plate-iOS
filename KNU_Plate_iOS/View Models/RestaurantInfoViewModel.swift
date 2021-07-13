import Foundation

protocol RestaurantInfoViewModelDelegate: AnyObject {
    func didFetchRestaurantInfo()
    func didFetchRestaurantImages()
}

// MARK: - Main Body
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

// MARK: -
extension RestaurantInfoViewModel {
    var numberOfReviews: Int {
        return self.reviews.count
    }
    
    var numberOfLocations: Int {
        return 1
    }
    
    var numberOfMenus: Int {
        return self.menus.count
    }
    
    func reviewAtIndex(_ index: Int) -> RestaurantReviewViewModel {
        let review = self.reviews[index]
        return RestaurantReviewViewModel(review)
    }
}

// MARK: - Related To Fetch Restaurant Info
extension RestaurantInfoViewModel {
    var mallName: String {
        return self.restaurant?.mallName ?? "음식점이름"
    }
    
    var category: String {
        return self.restaurant?.categoryName ?? "카테고리"
    }
    
    var rating: Double {
        return self.restaurant?.evaluateAverage ?? 0.0
    }
    
    var gate: String {
        return self.restaurant?.gateLocation ?? "위치"
    }
    
    var isFavorite: Bool {
        if let restaurant = self.restaurant {
            if restaurant.myRecommend == "Y" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    var reviewCount: Int {
        return self.restaurant?.reviewCount ?? 0
    }
    
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

// MARK: - Related To Fetch Restaurant Title Images
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
            case .failure:
                return
            }
        }
    }
}

// MARK: - Related To Fetch Reviews
extension RestaurantInfoViewModel {
    func fetchReviews() {
        
    }
}


class RestaurantReviewViewModel {
    private let review: ReviewListResponseModel
    
    init(_ review: ReviewListResponseModel) {
        self.review = review
    }
}

extension RestaurantReviewViewModel {
    var hasReviewImage: Bool {
        return self.review.reviewImageFileFolder != nil
    }
    
    var reviewID: Int {
        return self.review.reviewID
    }
    
    var userNickname: String {
        return self.review.userInfo.displayName
    }
    
    var medal: Int {
        return self.review.userInfo.medal
    }
    
    var reviewContent: String {
        return self.review.review
    }
    
    var rating: Int {
        self.review.rating
    }
    
    var profileImageURL: URL? {
        let files = self.review.userInfo.fileFolder?.files
        if let files = files, files.count > 0 {
            do {
                let url = try files[0].path.asURL()
                return url
            } catch {
                print("In RestaurantReviewViewModel: \(error)")
            }
        }
        return nil
    }
    
    var reviewImageURL: URL? {
        let files = self.review.reviewImageFileFolder?.files
        if let files = files, files.count > 0 {
            do {
                let url = try files[0].path.asURL()
                return url
            } catch {
                print("In RestaurantReviewViewModel: \(error)")
            }
        }
        return nil
    }
    
    var reviewImageFiles: [Files]? {
        return self.review.reviewImageFileFolder?.files
    }
    
    var reviewImageCount: Int? {
        return self.review.reviewImageFileFolder?.files?.count
    }
}
