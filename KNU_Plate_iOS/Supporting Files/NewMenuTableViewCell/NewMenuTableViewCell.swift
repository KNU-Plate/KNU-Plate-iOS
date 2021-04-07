import UIKit

protocol NewMenuTableViewCellDelegate {
    
    func didChangeMenuName()
    func didChangeOneLineReview()
}

class NewMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var oneLineReviewForMenuTextField: UITextField!
    
    var delegate: NewMenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuNameTextField.delegate = self
        oneLineReviewForMenuTextField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension NewMenuTableViewCell: UITextFieldDelegate {
    
    
    
    
}
