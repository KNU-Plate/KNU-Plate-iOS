import UIKit
import Alamofire
import SnackBar_swift
import ProgressHUD

class SendDeveloperMessageViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
 
    
    @IBAction func pressedSendButton(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        if !validateUserInput() { return }
        
        showProgressBar()
        
        ReportManager.shared.sendFeedback(content: messageTextView.text!) { result in
            
            dismissProgressBar()
            
            switch result {
            
            case .success(_):
                self.showSimpleBottomAlert(with: "건의사항을 성공적으로 전송하였습니다 😁")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
}

//MARK: - Initialization

extension SendDeveloperMessageViewController {
    
    func initialize() {
        
        initializeTextView()
    }
    
    func initializeTextView() {
        
        messageTextView.delegate = self
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.cornerRadius = 10.0
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.clipsToBounds = true
        messageTextView.font = UIFont.systemFont(ofSize: 15)
        messageTextView.text = "개발팀에게 전하고 싶은 말을 자유롭게 작성해주세요 😁"
        messageTextView.textColor = UIColor.lightGray
    }
}

//MARK: - Input Validation

extension SendDeveloperMessageViewController {
    
    func validateUserInput() -> Bool {
        
        guard let content = messageTextView.text else { return false }
        
        if content.count >= 3 { return true }
        else {
            self.showSimpleBottomAlert(with: "건의 내용을 3글자 이상 적어주세요 👀")
            return false
        }
    }
}

//MARK: - UITextViewDelegate

extension SendDeveloperMessageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "개발팀에게 전하고 싶은 말을 자유롭게 작성해주세요 😁"
            textView.textColor = UIColor.lightGray
            return
        }
    }
}
