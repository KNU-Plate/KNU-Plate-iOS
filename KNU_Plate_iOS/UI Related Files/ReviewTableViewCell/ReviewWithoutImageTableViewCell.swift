import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell -> 단, 리뷰용 사진이 없을 때만 사용

class ReviewWithoutImageTableViewCell: ReviewTableViewCell {
    
    private var viewModel = ReviewTableViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure(with model: ReviewListResponseModel) {
    
        viewModel.userID = model.userID
        viewModel.review = model.review
        viewModel.rating = model.rating
        
        initialize()
    }
    
    override func initialize() {
        
        configureShowMoreButton()
    
        //TODO: - 나중에는 기본 사진 넣기
        reviewImageView.image = nil
        
    }
    
   
}

