import Foundation
import Alamofire

//MARK: - 매장 리뷰 관련 로직을 처리하는 클래스 -> i.e 리뷰 등록

class ReviewManager {
    
    //MARK: - Singleton
    static let shared: ReviewManager = ReviewManager()
    
    //MARK: - API Request URLs
    let uploadNewReviewRequestURL = "\(Constants.API_BASE_URL)review"
    
    private init() { }
    
    //MARK: - 신규 리뷰 등록
    func uploadNewReview(with model: NewReviewModel,
                         completion: @escaping ((Bool) -> Void)) {
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
