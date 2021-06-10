import UIKit
import GTProgressBar

class MenuRecommendationTableViewCell: UITableViewCell {
    
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var progressBar: GTProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            

    }

    func initialize() {
        
        progressBar.barBorderWidth = 0
        progressBar.barBackgroundColor = #colorLiteral(red: 1, green: 0.8813940883, blue: 0.8838400245, alpha: 1)
        progressBar.barFillColor = #colorLiteral(red: 1, green: 0.5937769413, blue: 0.6053269506, alpha: 1)

        progressBar.progress = 0.3
        progressBar.displayLabel = false
        progressBar.cornerType = .rounded


    }
 
}
