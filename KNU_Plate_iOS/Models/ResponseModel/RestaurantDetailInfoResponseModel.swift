import Foundation

//MARK: - 매장 상세 정보 조회 후 성공 시 반환되는 Model

struct RestaurantDetailInfoResponseModel: Decodable {
    
    /// 매장 아이디
    let mallID: Int
    
    /// 매장명
    let mallName: String
    
    /// 카테고리명
    let categoryName: String
    
    /// 위치
    let address: String
    
    let latitude: Double
    
    let longitude: Double
    
    //let thumbnail: [Data]?
    
    /// 매장 평점
    let rating: Float
    
    /// 매장 리뷰에 참여한 사람들 총 수
    let recommendCount: Int
    
    /// 매장 위치 (문)
    //let gate: String
    
    /// 매장에 등록된 총 메뉴 (배열)
    let menus: [MenuInfo]
    
    
    /// 내 찜 목록에 추가되어 있는 매장인가? -> Y, N
    let isFavorite: String
    
    enum CodingKeys: String, CodingKey {
        
        case mallID = "mall_id"
        case mallName = "mall_name"
        case categoryName = "category_name"
        case address, latitude, longitude
        case rating = "evaluate_average"
        case recommendCount = "recommend_count"
        case isFavorite = "my_recommend"
    }
}

struct MenuInfo: Decodable {
    
    let menuID: Int
    let mallID: Int
    let menuName: String
    let likes: Int
    let dislikes: Int

    enum CodingKeys: String, CodingKey {
        
        case menuID = "menu_id"
        case mallID = "mall_id"
        case menuName = "menu_name"
        case likes = "like"
        case dislikes = "dislikes"
    }
    
}
