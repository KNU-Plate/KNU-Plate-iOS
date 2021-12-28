import UIKit

class NoticeDetailViewController: UIViewController {
    
    @IBOutlet var noticeTitleLabel: UILabel!
    @IBOutlet var noticeDateLabel: UILabel!
    @IBOutlet var noticeContentLabel: UILabel!
    
    var noticeTitle: String = ""
    var noticeDate: String = ""
    var noticeContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        
        noticeTitleLabel.text = noticeTitle
        noticeDateLabel.text = noticeDate
        noticeContentLabel.text = noticeContent
    }
}
