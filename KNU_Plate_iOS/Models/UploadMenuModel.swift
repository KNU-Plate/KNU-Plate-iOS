import Foundation

//MARK: - "리뷰 등록" API 호출 시 사용하는 Model

class UploadMenuModel: Encodable {
    
    /// 매장 고유 ID (Auto-Increment 값)
    var mallID: Int
    
    /// Y | N
    var menuName: String
    
    public init(mallID: Int, menuName: String) {
        self.mallID = mallID
        self.menuName = menuName
    }
    
    enum CodingKeys: String, CodingKey {
        
        case mallID = "mall_id"
        case menuName = "menu_name"
    }
}


/*
 
 [
    {
        "menu_id": 1,
        "is_like": "Y"
    },
    {
        "menu_id":2,
        "is_like": "Y"
    }
 ]
 

 
 */
