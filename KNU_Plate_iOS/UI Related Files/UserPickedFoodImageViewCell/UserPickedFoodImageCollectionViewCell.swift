import UIKit

protocol UserPickedFoodImageCellDelegate {
    func didPressDeleteImageButton(at index: Int)
}

// 리뷰 또는 신규 식당 등록 시 사용자가 고른 이미지가 표시되는 Collection View Cell

class UserPickedFoodImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPickedImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: UserPickedFoodImageCellDelegate!
    
    var indexPath: Int = 0
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        delegate?.didPressDeleteImageButton(at: indexPath)
    }
}
