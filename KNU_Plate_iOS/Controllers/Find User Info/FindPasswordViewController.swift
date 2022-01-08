import UIKit
import PanModal
import TextFieldEffects

class FindPasswordViewController: UIViewController {
    
    @IBOutlet var idTextField: HoshiTextField!
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var findPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    @IBAction func pressedFindPasswordButton(_ sender: UIButton) {
        guard let _ = idTextField.text, let _ = emailTextField.text else {
            return
        }
    }
}

//MARK: - UI Configuration & Initialization

extension FindPasswordViewController {
    
    func initialize() {
        initializeFindPasswordButton()
    }
    
    func initializeFindPasswordButton() {
        findPasswordButton.layer.cornerRadius = findPasswordButton.frame.height / 2
        findPasswordButton.addBounceReactionWithoutFeedback()
        findPasswordButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    }
}

//MARK: - PanModalPresentable

extension FindPasswordViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(50)
    }
}
