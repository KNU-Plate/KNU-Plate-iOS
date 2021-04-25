import Foundation

//MARK: - 카카오맵 키워드로 매장 검색 후 성공 시 반환되는 Model

struct SearchRestaurantByKeywordResponseModel: Decodable {
    
    let documents: [SearchedRestaurantInfo]
    let meta: MetaData
    
    enum CodingKeys: String, CodingKey {
        case documents, meta
    }
    
}

struct SearchedRestaurantInfo: Codable {
    
    let address: String

    /// 장소 ID
    let id: String

    /// 장소명, 업체명
    let placeName: String

    /// 장소 상세페이지 URL
    let placeURL: String

    /// 전체 도로명 주소
    let roadAddressName: String

    /// X 좌표값, 경위도인 경우 longitude (경도)
    let x: String

    /// Y 좌표값, 경위도인 경우 latitude(위도)
    let y: String

    enum CodingKeys: String, CodingKey {

        case id,x,y
        case address = "address_name"
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
    }
}

struct MetaData: Codable {
    
    /// 현재 페이지가 마지막 페이지인지 여부. 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
    let isEnd: Bool

    /// 검색어에 검색된 문서 수
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {

        case isEnd = "is_end"
        case totalCount = "total_count"
    }
}
