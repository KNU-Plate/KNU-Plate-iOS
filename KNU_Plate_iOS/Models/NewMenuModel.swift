import Foundation
import Alamofire

//MARK: - DB에 등록되어 있지 않은 메뉴를 추가할 때 사용하는 Model, 즉 신규 메뉴를 뜻함

struct NewMenuModel {
    
    /// 사용자가 직접 입력한 신규 메뉴 (DB에 등록되지 않은 메뉴)
    var menuName: String
    
    /// Y | N
    var isGood: String
    
    init(menuName: String) {
        self.menuName = menuName
        self.isGood = "Y"
    }
}
