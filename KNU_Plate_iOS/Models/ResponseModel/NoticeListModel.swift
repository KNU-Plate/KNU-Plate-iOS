import Foundation

//MARK: - 공지사항 목록 불러오기 성공 시 반환되는 Model

struct NoticeListModel: Decodable {
    
    let noticeID: Int
    let userID: String
    let dateCreated: Int
    let title: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        
        case noticeID = "notice_id"
        case userID = "user_id"
        case dateCreated = "date_create"
        case title, contents
    }
}
