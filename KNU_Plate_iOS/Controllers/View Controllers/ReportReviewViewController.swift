import UIKit

class ReportReviewViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        initialize()
    }
    


    func initialize() {
        
        initializeTextView()
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
