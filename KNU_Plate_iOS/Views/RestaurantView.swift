import UIKit

class RestaurantView: UIView {
    
    let scrollView = UIScrollView()
    
    let imageContentsView = UIView()
    
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    let imageView4 = UIImageView()
    
    let stackView1 = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
