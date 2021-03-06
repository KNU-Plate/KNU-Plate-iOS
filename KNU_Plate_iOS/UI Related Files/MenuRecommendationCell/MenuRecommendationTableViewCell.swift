import UIKit
import GTProgressBar

class MenuRecommendationTableViewCell: UITableViewCell {
    
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var progressBar: GTProgressBar!
    
    @IBOutlet var likeTitleLabel: UILabel!
    @IBOutlet var totalLikeNumberLabel: UILabel!
    @IBOutlet var dislikeTitleLabel: UILabel!
    @IBOutlet var totalDislikeNumberLabel: UILabel!
    
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var dislikeImageView: UIImageView!
    
    func initializeProgressBar(likePercentage: Double) {
        progressBar.backgroundColor = .clear
        progressBar.barBorderWidth = 0
        progressBar.barFillColor = #colorLiteral(red: 0.537254902, green: 0.6901960784, blue: 0.9843137255, alpha: 1)
        progressBar.barBackgroundColor = #colorLiteral(red: 1, green: 0.5937769413, blue: 0.6053269506, alpha: 1)
        progressBar.displayLabel = false
        progressBar.cornerType = .rounded
        progressBar.barFillInset = 0
        
        if likePercentage == 0.0 {
            progressBar.progress = 0.0
        } else {
            progressBar.progress = CGFloat(likePercentage)
        }
        
        progressBar.animateTo(progress: CGFloat(likePercentage))
    }
    
    func configureLabels(totalLikes: Int) { 
        if totalLikes == 0 {
            progressBar.barBackgroundColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            likeImageView.image = UIImage(named: Constants.Images.thumbsUpInGray)
            dislikeImageView.image = UIImage(named: Constants.Images.thumbsDownInGray)
            likeTitleLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            dislikeTitleLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            totalLikeNumberLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            totalDislikeNumberLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
        } else {
            likeImageView.image = UIImage(named: Constants.Images.thumbsUpInBlue)
            dislikeImageView.image = UIImage(named: Constants.Images.thumbsDownInRed)
        }
    }
}
