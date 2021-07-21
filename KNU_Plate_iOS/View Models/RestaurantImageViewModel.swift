import Foundation

protocol RestaurantImageViewModelDelegate: AnyObject {
    func didFetchImage()
}

class RestaurantImageViewModel {
    weak var delegate: RestaurantImageViewModelDelegate?
    
    private var images: [RestaurantImageResponseModel] = []
    private var mallID: Int?
    private var lastFileIdx: Int?
    var hasMore: Bool = true
    var isFetchingData: Bool = false
    
    func setMallID(_ mallID: Int?) {
        self.mallID = mallID
    }
}

extension RestaurantImageViewModel {
    var numberOfImages: Int {
        return self.images.count
    }
    
    func getImageURL(of index: Int) -> URL? {
        do {
            let url = try self.images[index].path.asURL()
            return url
        } catch {
            print("RestaurantImageViewModel - \(error)")
        }
        return nil
    }
    
    func fetchImages() {
        guard let mallID = self.mallID else {
            print("RestaurantInfoViewModel: mallID is empty")
            return
        }
        
        isFetchingData = true
        
        RestaurantManager.shared.fetchRestaurantImages(of: mallID, cursor: lastFileIdx) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastFileIdx = data.last?.index
                }
                self.images.append(contentsOf: data)
                self.isFetchingData = false
                self.delegate?.didFetchImage()
            case .failure:
                return
            }
        }
    }
}
