import Foundation

protocol RestaurantInfoViewModelDelegate: AnyObject {
    func didFetchRestaurantInfo()
    func didFetchRestaurantImages()
    func didFetchReview()
    func didFetchMenu()
    func didMarkFavorite()
    func didFailMarkFavorite()
    func didDeleteMyReview()
    func didFailDeletingMyReview()
    func didSendFeedback()
    func didFailSendingFeedback()
}

// MARK: - Main Body
class RestaurantInfoViewModel {
    weak var delegate: RestaurantInfoViewModelDelegate?
    
    private var mallID: Int?
    
    private var restaurant: RestaurantInfoResponseModel? {
        didSet {
            if let restaurant = restaurant {
                self.menus = restaurant.menus
                self.delegate?.didFetchMenu()
            }
        }
    }
    private var titleImages: [RestaurantImageResponseModel] = []
    private var reviews: [ReviewListResponseModel] = []
    private var menus: [ExistingMenuModel] = []
    
    var hasMoreReview: Bool = true
    var isFetchingReview: Bool = false
    private var lastReviewID: Int?
    
    func setMallID(mallID: Int?) {
        self.mallID = mallID
    }
    
    func fetch() {
        self.fetchRestaurantInfo()
        self.fetchTitleImages()
        self.fetchReviews()
    }
    
    func refreshViewModel() {
        self.restaurant = nil
        self.titleImages.removeAll(keepingCapacity: true)
        self.reviews.removeAll(keepingCapacity: true)
        self.menus.removeAll(keepingCapacity: true)
        self.hasMoreReview = true
        self.isFetchingReview = false
        self.lastReviewID = nil
        self.fetch()
    }
}

extension RestaurantInfoViewModel {
    var numberOfReviews: Int {
        return self.reviews.count
    }
    
    var numberOfLocations: Int {
        if self.restaurant?.address == nil &&
           self.restaurant?.latitude == nil &&
           self.restaurant?.longitude == nil {
            return 0
        }
        return 1
    }
    
    var numberOfMenus: Int {
        return self.menus.count
    }
    
    var menusForNextVC: [ExistingMenuModel] {
        return self.menus
    }
    
    func reviewAtIndex(_ index: Int) -> RestaurantReviewViewModel {
        let review = self.reviews[index]
        return RestaurantReviewViewModel(review)
    }
    
    func menuAtIndex(_ index: Int) -> RestaurantMenuViewModel {
        let menu = self.menus[index]
        return RestaurantMenuViewModel(menu)
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
    
    var address: String {
        // 기본값: 경북대학교 중앙(대학원동)
        return self.restaurant?.address ?? "대구 북구 대학로 80"
    }
    
    var latitude: Double {
        // 기본값: 경북대학교 중앙 위도
        return self.restaurant?.latitude ?? 35.889529
    }
    
    var longitude: Double {
        // 기본값: 경북대학교 중앙 경도
        return self.restaurant?.longitude ?? 128.609971
    }
    
    var kakaoMallID: Int? {
        return self.restaurant?.kakaoMallID
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

// MARK: - Fetch Reviews
extension RestaurantInfoViewModel {
    func fetchReviews() {
        guard let mallID = self.mallID else {
            print("RestaurantInfoViewModel: mallID is empty")
            return
        }
        
        isFetchingReview = true
        
        let model = FetchReviewListRequestDTO(mallID: mallID, cursor: lastReviewID, isMyReview: "N")
        RestaurantManager.shared.fetchReviewList(with: model) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMoreReview = false
                } else {
                    self.lastReviewID = data.last?.reviewID
                }
        
                for review in data {
                    if User.shared.blockedUserUIDList.contains(review.userID) {
                        continue
                    }
                    self.reviews.append(review)
                }
                self.isFetchingReview = false
                self.delegate?.didFetchReview()
            case .failure:
                return
            }
        }
    }
}

// MARK: - Mark Favorite
extension RestaurantInfoViewModel {
    func markFavorite(markMyFavorite: Bool) {
        guard let mallID = self.mallID else {
            print("RestaurantInfoViewModel: mallID is empty")
            return
        }
        
        RestaurantManager.shared.markFavorite(mallID: mallID, markMyFavorite: markMyFavorite) { result in
            switch result {
            case .success:
//                self.delegate?.didMarkFavorite()
                NotificationCenter.default.post(name: Notification.Name.didMarkFavorite, object: nil)
                return
            case .failure:
//                self.delegate?.didFailedMarkFavorite()
                NotificationCenter.default.post(name: Notification.Name.didFailedMarkFavorite, object: nil)
                return
            }
        }
    }
}

//MARK: - Delete My Review
extension RestaurantInfoViewModel {
    
    func deleteMyReview(reviewID: Int) {
        
        UserManager.shared.deleteMyReview(reviewID: reviewID) { [weak self] result in
            guard let self = self else { return}
            switch result {
            case .success:
                self.delegate?.didDeleteMyReview()
            case .failure:
                self.delegate?.didFailDeletingMyReview()
            }
        }
    }
}

//MARK: - Report Incorrect Info of Restaurant
extension RestaurantInfoViewModel {

    func sendFeedback(with type: FeedbackType) {
        showProgressBar()
        let mallName = restaurant?.mallName ?? "(매장명 불러오기 실패)"
        let feedback = mallName + " - " + type.rawValue
        
        ReportManager.shared.sendFeedback(content: feedback) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.didSendFeedback()
            case .failure:
                self.delegate?.didFailSendingFeedback()
            }
        }
    }
}

// MARK: - RestaurantReviewViewModel
/// Only used in tableView(cellForRowAt:) method 
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
    
    var userID: String {
        return self.review.userID
    }
    
    var reviewID: Int {
        return self.review.reviewID
    }
    
    var userNickname: String {
        return self.review.userInfo.username
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
    
    func getFormattedDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        guard let convertedDate = dateFormatter.date(from: self.review.dateCreated) else {
            return "날짜 표시 에러"
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(convertedDate) {
            return "오늘"
        } else if calendar.isDateInYesterday(convertedDate) {
            return "어제"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let finalDate = dateFormatter.string(from: convertedDate)
            return finalDate
        }
    }
}

// MARK: - RestaurantMenuViewModel
/// Only used in tableView(cellForRowAt:) method
class RestaurantMenuViewModel {
    private let menu: ExistingMenuModel
    
    init(_ menu: ExistingMenuModel) {
        self.menu = menu
    }
}

extension RestaurantMenuViewModel {
    var menuName: String {
        return self.menu.menuName
    }
    
    var likes: Int {
        return self.menu.likes
    }
    
    var dislikes: Int {
        return self.menu.dislikes
    }
    
    var totalLikes: Int {
        return likes + dislikes
    }
    
    var likePercentage: Double {
        if totalLikes == 0 { return 0.0 }
        else { return Double(likes) / Double(totalLikes) }
    }
}
