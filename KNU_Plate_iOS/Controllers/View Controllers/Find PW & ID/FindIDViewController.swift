import UIKit
import PanModal
import TextFieldEffects

class FindIDViewController: UIViewController {
    
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var findIDButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

    }
    
    @IBAction func pressedFindIDButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            return
        }
        
        guard email.contains("@") else {
            
            emailTextField.resignFirstResponder()
            self.showSimpleBottomAlert(with: "올바른 이메일 형식인지 확인해 주세요. 🧐")
            return
        }
        
        let parsedEmailString = email.components(separatedBy: "@")
      
        UserManager.shared.findMyID(email: parsedEmailString[0]) { [weak self] result in
                
            guard let self = self else { return }
            
            switch result {
            
            case .success(let username):
                
                self.showResult(with: "아이디: ", username: username)
            
            case .failure(_):
                
                self.showResult(with: "아이디를 찾디 못했습니다. 😥", username: nil)
           
            }
        }
        
        
    }
    
    func showResult(with message: String, username: String?) {
        
        resultLabel.isHidden = false
        
        if let username = username {
            
            resultLabel.text = message + username
            resultLabel.textColor = UIColor.systemGreen
        } else {
            resultLabel.text = message
            resultLabel.textColor = UIColor(named: Constants.Color.appDefaultColor)
        }
        
        resultLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    func dismissResult() {
        resultLabel.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        dismissResult()
    }

}

//MARK: - UI Configuration & Initialization

extension FindIDViewController {
    
    func initialize() {
        
        initializeFindIDButton()
        initializeResultLabel()
    }
    
    func initializeTextField() {
        
        emailTextField.addTarget(self,
                                 action: #selector(textFieldDidChange(_:)),
                                 for: .editingChanged)
    }
    
    func initializeFindIDButton() {
        
        findIDButton.layer.cornerRadius = findIDButton.frame.height / 2
        findIDButton.addBounceReactionWithoutFeedback()
        findIDButton.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
    }
    
    func initializeResultLabel() {
        
        resultLabel.isHidden = true
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
