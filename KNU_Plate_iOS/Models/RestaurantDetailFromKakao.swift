import Foundation

//MARK: - 카카오 지도에서 매장 검색 후 매장 등록 화면으로 넘어가기 위해 필요한 정보를 모아둔 구조체

struct RestaurantDetailFromKakao {
    
    var name: String = ""
    var address: String = ""
    var contact: String = ""
    var category: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
}
