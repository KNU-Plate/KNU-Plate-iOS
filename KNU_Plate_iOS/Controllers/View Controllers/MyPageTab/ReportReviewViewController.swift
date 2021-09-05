import UIKit
import SnackBar_swift

class ReportReviewViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    var reviewID: Int = 0
    
    private let textViewPlaceholder: String = "✻ 신고 내용을 적어서 아래 신고 접수 버튼을 눌러주세요. 개발팀이 검토 후 조치를 취하도록 하겠습니다."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        print("✏️ reviewID: \(reviewID)")
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
        
        initializeNavigationBar()
        initializeTextView()
        initializeButton()
    }
    
    func initializeTextView() {
        
        contentTextView.delegate = self
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 5.0
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.clipsToBounds = true
        contentTextView.font = UIFont.systemFont(ofSize: 15)
        contentTextView.text = textViewPlaceholder
        contentTextView.textColor = UIColor.lightGray
    }
    
    func initializeButton() {
        sendButton.layer.cornerRadius = 10
    }
    
    func initializeNavigationBar() {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 150
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight,
                                                          width: view.bounds.size.width, height: 50))
        navigationBar.tintColor = .lightGray
        navigationBar.setBackgroundImage(UIImage(),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
        self.view.addSubview(navigationBar)
        
        let navItem = UINavigationItem(title: "")
        let navBarButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                           target: self,
                                           action: #selector(dismissVC))
        navItem.rightBarButtonItem = navBarButton
        navigationBar.items = [navItem]
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
            textView.text = textViewPlaceholder
            textView.textColor = UIColor.lightGray
            return
        }
    }
}
