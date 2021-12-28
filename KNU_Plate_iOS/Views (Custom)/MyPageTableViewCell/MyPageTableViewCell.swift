import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet var leftImageView: UIImageView!
    @IBOutlet var settingsTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }

}
