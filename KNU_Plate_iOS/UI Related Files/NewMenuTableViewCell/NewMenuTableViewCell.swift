import UIKit

protocol NewMenuTableViewCellDelegate {
    
    func didPressDeleteMenuButton(at index: Int)
    func didPressEitherGoodOrBadButton(at index: Int, menu isGood: Bool)
}

class NewMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: NewMenuTableViewCellDelegate!
    
    var menuIsGood: Bool = true
    var indexPath: Int = 0
    
    var thumbsUpSelected: UIImage = UIImage(named: "thumbs up(selected)")!
    var thumbsUpNotSelected: UIImage = UIImage(named: "thumbs up(not_selected)")!
    
    var thumbsDownSelected: UIImage = UIImage(named: "thumbs down(selected)")!
    var thumbsDownNotSelected: UIImage = UIImage(named: "thumbs down(not_selected)")!
    
    var buttonImageSize: Int = 25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        menuNameTextField.isUserInteractionEnabled = false
        menuNameTextField.layer.borderWidth = 0
        
        configureUI()
        pressedMenuGoodOrBad(goodButton)
    }
    
    override func prepareForReuse() {
        indexPath = 0
        menuNameTextField.text = ""
    }
    
    func configureUI() {
        
        thumbsUpSelected = thumbsUpSelected.scalePreservingAspectRatio(targetSize: CGSize(width: buttonImageSize, height: buttonImageSize))
        thumbsUpNotSelected = thumbsUpNotSelected.scalePreservingAspectRatio(targetSize: CGSize(width: buttonImageSize, height: buttonImageSize))
        thumbsDownSelected = thumbsDownSelected.scalePreservingAspectRatio(targetSize: CGSize(width: buttonImageSize, height: buttonImageSize))
        thumbsDownNotSelected = thumbsDownNotSelected.scalePreservingAspectRatio(targetSize: CGSize(width: buttonImageSize, height: buttonImageSize))
        
        let deleteImage = UIImage(named: Constants.Images.deleteButton)
        deleteButton.setImage(deleteImage, for: .normal)
        
    }

    //MARK: - 추천 / 비추천 버튼 눌렀을 때 실행
    @IBAction func pressedMenuGoodOrBad(_ sender: UIButton) {
        
        menuNameTextField.resignFirstResponder()
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    
        switch sender {
        case goodButton:
            menuIsGood = true
            
            goodButton.setImage(thumbsUpSelected,
                                for: .normal)
            badButton.setImage(thumbsDownNotSelected,
                               for: .normal)
            
        case badButton:
            menuIsGood = false
            
            goodButton.setImage(thumbsUpNotSelected,
                                for: .normal)
            badButton.setImage(thumbsDownSelected,
                               for: .normal)
            
        default: return
        }
        delegate?.didPressEitherGoodOrBadButton(at: indexPath, menu: menuIsGood)
    }
    
    @IBAction func pressedDeleteButton(_ sender: UIButton) {
        delegate?.didPressDeleteMenuButton(at: indexPath)
    }
}
