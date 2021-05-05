import Foundation
import Alamofire

//MARK: - 사용자가 신규 리뷰를 작성할 때 사용되는 메뉴 Model

struct UserAddedMenuModel: Encodable {
    
    /// 사용자가 직접 입력한 신규 메뉴 (DB에 등록되지 않은 메뉴)
    var menuName: String
    
    /// Y | N
    var isGood: String
    
    init(menuName: String) {
        self.menuName = menuName
        self.isGood = "Y"
    }
}
