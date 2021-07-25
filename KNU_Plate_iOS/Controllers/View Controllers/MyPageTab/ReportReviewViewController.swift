import UIKit
import SnackBar_swift

class ReportReviewViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    var reviewID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
    
    @IBAction func pressedSendButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if !validateUserInput() { return }
        
        showProgressBar()
        
        ReportManager.shared.reportReview(reviewID: reviewID,
                                          reason: contentTextView.text!) { result in
            
            dismissProgressBar()
            
            switch result {
            
            case .success(_):
                self.showSimpleBottomAlert(with: "신고해주셔서 감사합니다. 검토 후 처리할게요! 😁")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.dismiss(animated: true)
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
}

//MARK: - Initialization

extension ReportReviewViewController {
    
    func initialize() {
        
        initializeTextView()
        initializeButton()
    }
    
    func initializeTextView() {
        
        contentTextView.delegate = self
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 10.0
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.clipsToBounds = true
        contentTextView.font = UIFont.systemFont(ofSize: 15)
        contentTextView.text = "신고 내용을 적어주세요 🤔"
        contentTextView.textColor = UIColor.lightGray
    }
    
    func initializeButton() {
        sendButton.layer.cornerRadius = 10
    }
}

//MARK: - Input Validation

extension ReportReviewViewController {
    
    func validateUserInput() -> Bool {
        
        guard let content = contentTextView.text else { return false }
        
        if content.count >= 3 { return true }
        else {
            showSimpleBottomAlert(with: "신고 내용을 3글자 이상 적어주세요 👀")
            return false
        }
    }
}

//MARK: - UITextViewDelegate

extension ReportReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "신고 내용을 적어주세요 🤔"
            textView.textColor = UIColor.lightGray
            return
        }
    }
}
