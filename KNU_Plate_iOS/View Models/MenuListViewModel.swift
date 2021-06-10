import Foundation

protocol MenuListViewModelDelegate {
    func didFetchMenuList()
    func failedFetchingMenuList(with error: NetworkError)
}

class MenuListViewModel {
    
    var delegate: MenuListViewModelDelegate?
    
    var menuList: [ExistingMenuModel] = []
    
    
    func fetchMenuList(of mallID: Int) {
        
        //TODO: mall id 수정 필요
        RestaurantManager.shared.fetchRestaurantDetailInfo(of: mallID) { result in
            
            switch result {
            
            case .success(let model):
                
                self.menuList = model.menus
                self.delegate?.didFetchMenuList()
                
            case .failure(let error):
                self.delegate?.failedFetchingMenuList(with: error)
            }
        }
        
        
    }

    
    
    
    
    
}
