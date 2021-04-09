import UIKit

protocol NewMenuTableViewCellDelegate {
    
    func didChangeMenuName()
    func didPressDeleteMenuButton(at index: Int)
}

class NewMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: NewMenuTableViewCellDelegate!
    
    var menuIsGood: Bool?
    var indexPath: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        menuNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pressedMenuGoodOrBad(_ sender: UIButton) {
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    
        switch sender {
        case goodButton:
            menuIsGood = true
            
            goodButton.setImage(UIImage(named: "good (selected)"), for: .normal)
            badButton.setImage(UIImage(named: "bad (not-selected)"), for: .normal)
            
            
        case badButton:
            menuIsGood = false
            
            goodButton.setImage(UIImage(named: "good (not-selected)"), for: .normal)
            badButton.setImage(UIImage(named: "bad (selected)"), for: .normal)
            
            

        default:
            return
        }
        

    }

    
    
    @IBAction func pressedDeleteButton(_ sender: UIButton) {
        
        delegate?.didPressDeleteMenuButton(at: indexPath)
    }
    
}

extension NewMenuTableViewCell: UITextFieldDelegate {
    
    ///menuNameTextField 글자 수 제한도 필요해 보임.
    
    
    
}
