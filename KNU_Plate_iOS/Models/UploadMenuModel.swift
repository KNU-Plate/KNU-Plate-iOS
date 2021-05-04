import Foundation

//MARK: - "리뷰 등록" API 호출 시 사용하는 Model

class UploadMenuModel: Encodable {
    
    /// 매장 고유 ID (Auto-Increment 값)
    var id: Int
    
    /// Y | N
    var isGood: String
    
    public init() {
        self.id = 0
        self.isGood = "Y"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id = "menu_id"
        case isGood = "is_like"
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
