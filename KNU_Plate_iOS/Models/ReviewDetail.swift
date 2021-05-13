import Foundation

//MARK: - Review Image Cell 을 터치했을 때, 해당 리뷰를 상세히 볼 수 있는 VC로 이동. 이때 ReviewDetailVC 로 전달되는 구조체

struct ReviewDetail {
    
    var profileImage: UIImage
    var nickname: String
    var medal: UIImage
    var reviewImages: [UIImage]?
    var rating: Int
    var review: String
}
