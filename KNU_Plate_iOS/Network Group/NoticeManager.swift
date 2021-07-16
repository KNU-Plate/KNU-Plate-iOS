import Foundation
import Alamofire
import SwiftyJSON

//MARK: - 공지사항 담당 클래스

class NoticeManager {
    
    //MARK: - Singleton
    static let shared: NoticeManager = NoticeManager()
    
    let interceptor = Interceptor()
    
    //MARK: - API Request URLs
    let getNoticeURL            = "\(Constants.API_BASE_URL)notice"
    
    private init() {}
    
    //MARK: - 공지 목록 조회
    func fetchNoticeList(index: Int,
                       completion: @escaping ((Result<[NoticeListModel], NetworkError>) -> Void)) {
        
        let requestURL = getNoticeURL + "?cursor=\(index)"
        
        AF.request(requestURL,
                   method: .get)
            .responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                case 200:
                    print("✏️ NoticeManager - getNoticeList SUCCESS")
                    
                    do {
                        let decodedData = try JSONDecoder().decode([NoticeListModel].self,
                                                                   from: response.data!)
                        completion(.success(decodedData))
                        
                    } catch {
                        print("❗️ NoticeManager - getNoticeList error in parsing data, error: \(error)")
                        completion(.failure(.internalError))
                    }
                default:
                    completion(.failure(.internalError))
                }
            }
    }
    
}
