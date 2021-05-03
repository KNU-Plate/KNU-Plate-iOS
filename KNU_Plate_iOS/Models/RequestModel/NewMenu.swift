import Foundation
import Alamofire

//MARK: - DB에 등록되어 있지 않은 메뉴를 추가할 때 사용하는 Model

struct NewMenu {
    
    /// 매장 고유 ID (Auto-Increment 값)
    let mallID: Int
    
    /// 사용자가 직접 입력한 신규 메뉴 (DB에 등록되지 않은 메뉴)
    let menuName: String
    
    init(mallID: Int, menuName: String) {
        
        self.mallID = mallID
        self.menuName = menuName
        
        /// Initialize parameters
        parameters["mall_id"] = mallID
        parameters["menu_name"] = menuName
    }
    
    /// API Parameters
    var parameters: Parameters = [:]
    
    /// HTTP Headers
    let headers: HTTPHeaders = [
        
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization" : User.shared.accessToken
    ]
}
