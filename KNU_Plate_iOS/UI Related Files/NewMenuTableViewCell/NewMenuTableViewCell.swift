import UIKit

protocol NewMenuTableViewCellDelegate {
    
    func didChangeMenuName(at index: Int, _ newMenuName: String)
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
        menuNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pressedMenuGoodOrBad(_ sender: UIButton) {
        
        menuNameTextField.resignFirstResponder()
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    
        switch sender {
        case goodButton:
            menuIsGood = true
            
            goodButton.setImage(UIImage(named: "good (selected)"),
                                for: .normal)
            badButton.setImage(UIImage(named: "bad (not-selected)"),
                               for: .normal)
            
        case badButton:
            menuIsGood = false
            
            goodButton.setImage(UIImage(named: "good (not-selected)"),
                                for: .normal)
            badButton.setImage(UIImage(named: "bad (selected)"),
                               for: .normal)
            
        default:
            return
        }
        delegate?.didPressEitherGoodOrBadButton(at: indexPath, menu: menuIsGood)
        
    }
    
    @IBAction func pressedDeleteButton(_ sender: UIButton) {
        delegate?.didPressDeleteMenuButton(at: indexPath)
    }
    
}

extension NewMenuTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if let editedMenu = textField.text {
            
            guard editedMenu.count > 0 else {
                
                let alert = AlertManager.createAlertMessage("메뉴가 비었습니다.", "메뉴명을 입력해 주세요.")
                let vc = self.window?.rootViewController
                vc?.present(alert, animated: true)
                
                delegate?.didChangeMenuName(at: indexPath, "")
                return
            }
            delegate?.didChangeMenuName(at: indexPath, editedMenu)
        }
    }
}