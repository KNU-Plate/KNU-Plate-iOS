import UIKit

protocol NewMenuTableViewCellDelegate {
    
    func didChangeMenuName()
    func didChangeOneLineReview()
}

class NewMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameTextField: UITextField!
    //@IBOutlet weak var oneLineReviewForMenuTextField: UITextField!
    
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    var delegate: NewMenuTableViewCellDelegate!
    
    var menuIsGood: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuNameTextField.delegate = self
        //oneLineReviewForMenuTextField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pressedMenuGoodOrBad(_ sender: UIButton) {
    
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

    
    
    
}

extension NewMenuTableViewCell: UITextFieldDelegate {
    
    
    
    
}
