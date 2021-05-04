import Foundation
import Alamofire

//MARK: - 새 메뉴 등록할 때 사용하는 Model -> RestaurantManager.shared.uploadNewMenu(with model: RegisterNewMenuModel)

struct RegisterNewMenuModel {
    
    let mallID: Int
    let menuName: String
    
    init(mallID: Int, menuName: String) {
        
        self.mallID = mallID
        self.menuName = menuName
        
        parameters["mall_id"] = mallID
        parameters["menu_name"] = menuName
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": User.shared.accessToken
    ]
    
    
}
