import Foundation
import Alamofire

//MARK: - 새 메뉴 등록할 때 사용하는 Model -> RestaurantManager.shared.uploadNewMenu(with model: RegisterNewMenuModel)

struct RegisterNewMenuModel {
    
    let mallID: Int
    let menuName: [String]
    
    init(mallID: Int, menuName: [String]) {
        
        self.mallID = mallID
        self.menuName = menuName
        
        parameters["mall_id"]?.append(mallID)
        
        for eachMenu in menuName {
            parameters["menu_name"]?.append(eachMenu)
        }
    }
    
    /// API Parameters
    var parameters: [String: [Any]] = [
        
        "mall_id" : [],
        "menu_name" : []
    ]
    
    /// HTTP Headers
    var headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": User.shared.accessToken
    ]
    
    
}
