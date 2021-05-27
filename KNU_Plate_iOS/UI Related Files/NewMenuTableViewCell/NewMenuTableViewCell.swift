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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        pressedMenuGoodOrBad(goodButton)
        menuNameTextField.isUserInteractionEnabled = false
        
        let font = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let deleteImage = UIImage(systemName: "x.circle", withConfiguration: configuration)
        deleteButton.setImage(deleteImage, for: .normal)
    }
    
    override func prepareForReuse() {
        indexPath = 0
        menuNameTextField.text = ""
    }

    //MARK: - 추천 / 비추천 버튼 눌렀을 때 실행
    @IBAction func pressedMenuGoodOrBad(_ sender: UIButton) {
        
        menuNameTextField.resignFirstResponder()
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    
        switch sender {
        case goodButton:
            menuIsGood = true
            
            goodButton.setImage(UIImage(named: "thumbs up(selected)"),
                                for: .normal)
            badButton.setImage(UIImage(named: "thumbs down(not_selected)"),
                               for: .normal)
            
        case badButton:
            menuIsGood = false
            
            goodButton.setImage(UIImage(named: "thumbs up(not_selected)"),
                                for: .normal)
            badButton.setImage(UIImage(named: "thumbs down(selected)"),
                               for: .normal)
            
        default: return
        }
        delegate?.didPressEitherGoodOrBadButton(at: indexPath, menu: menuIsGood)
    }
    
    @IBAction func pressedDeleteButton(_ sender: UIButton) {
        delegate?.didPressDeleteMenuButton(at: indexPath)
    }
}
