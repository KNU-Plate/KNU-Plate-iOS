import UIKit
import Alamofire
import SnackBar_swift
import ProgressHUD

class SendDeveloperMessageViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
 
    
    @IBAction func pressedSendButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if !validateUserInput() { return }
        
        showProgressBar()
        
        ReportManager.shared.sendSuggestion(content: messageTextView.text!) { result in
            
            dismissProgressBar()
            
            switch result {
            
            case .success(_):
                SnackBar.make(in: self.view,
                              message: "건의사항을 성공적으로 전송하였습니다😁",
                              duration: .lengthLong).show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                SnackBar.make(in: self.view,
                              message: error.errorDescription,
                              duration: .lengthLong).show()
            }
        }
    }
}

//MARK: - Initialization

extension SendDeveloperMessageViewController {
    
    func initialize() {
        
        initializeTextView()
        initializeButton()
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
    
    func initializeButton() {
        sendButton.layer.cornerRadius = 10
    }
}

//MARK: - Input Validation

extension SendDeveloperMessageViewController {
    
    func validateUserInput() -> Bool {
        
        guard let content = messageTextView.text else { return false }
        
        if content.count >= 3 { return true }
        else {
            SnackBar.make(in: self.view,
                          message: "건의 내용을 3글자 이상 적어주세요 👀",
                          duration: .lengthLong).show()
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
