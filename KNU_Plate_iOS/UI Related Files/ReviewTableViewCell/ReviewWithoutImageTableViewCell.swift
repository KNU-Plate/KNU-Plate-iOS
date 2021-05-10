import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell -> 단, 리뷰용 사진이 없을 때만 사용

class ReviewWithoutImageTableViewCell: ReviewTableViewCell {

    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func initialize() {
        
        configureShowMoreButton()
    }
    
    

    
    override func configure(with viewModel: ReviewTableViewModel) {
        
        
    }
   
}

