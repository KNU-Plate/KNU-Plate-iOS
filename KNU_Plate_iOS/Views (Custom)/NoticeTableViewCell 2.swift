import UIKit

//MARK: - 공지사항 목록 Cell

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet var noticeImageView: UIImageView!
    @IBOutlet var noticeTitleLabel: UILabel!
    @IBOutlet var noticeDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    

}
