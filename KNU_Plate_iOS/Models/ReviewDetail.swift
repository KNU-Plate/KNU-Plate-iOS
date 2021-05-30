import Foundation

//MARK: - Review Image Cell 을 터치했을 때, 해당 리뷰를 상세히 볼 수 있는 VC로 이동. 이때 ReviewDetailVC 로 전달되는 구조체

struct ReviewDetail {
    
    var profileImage: UIImage = UIImage()
    var nickname: String = ""
    var medal: Int = 3
    var reviewImageFiles: [Files]?
    //var reviewImagesFileFolder: FileFolder?
    var rating: Int = 0
    var review: String = ""
}
