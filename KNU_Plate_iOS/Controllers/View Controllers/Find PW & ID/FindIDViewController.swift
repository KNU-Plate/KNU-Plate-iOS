import UIKit
import PanModal
import TextFieldEffects

class FindIDViewController: UIViewController {
    
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var findIDButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

    }
    
    @IBAction func pressedFindIDButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            return
        }
        
        //TODO: - @ 전까지 문자열 자르기
        
        
    }
    

}

//MARK: - UI Configuration & Initialization

extension FindIDViewController {
    
    func initialize() {
        
    
        
        initializeFindIDButton()
    }
    
    func initializeFindIDButton() {
        
        findIDButton.layer.cornerRadius = findIDButton.frame.height / 2
        findIDButton.addBounceReactionWithoutFeedback()
        findIDButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    
    }
    
}

//MARK: - PanModalPresentable

extension FindIDViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
    
}
