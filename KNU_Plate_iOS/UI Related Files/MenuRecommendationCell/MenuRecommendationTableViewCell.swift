import UIKit
import GTProgressBar

class MenuRecommendationTableViewCell: UITableViewCell {
    
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var progressBar: GTProgressBar!
    
    @IBOutlet var likeTitleLabel: UILabel!
    @IBOutlet var totalLikeLabel: UILabel!
    @IBOutlet var dislikeTitleLabel: UILabel!
    @IBOutlet var totalDislikeLabel: UILabel!
    
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var dislikeImageView: UIImageView!
    
    var viewModel = MenuRecommendationViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func resetValues() {
        
        menuLabel.text = ""
        totalLikeLabel.text = ""
        totalDislikeLabel.text = ""
    }
    
    func configure(with model: ExistingMenuModel) {
        
        resetValues()
        
        viewModel.menuName = model.menuName
        viewModel.likes = model.likes
        viewModel.dislikes = model.dislikes
        
        initialize()
    }
    
    func initialize() {
        
        
        initializeProgressBar()
        configureLabels()
        progressBar.animateTo(progress: CGFloat(viewModel.likePercentage))
    }
    
    func initializeProgressBar() {
        
        progressBar.backgroundColor = .clear
        progressBar.barBorderWidth = 0
        progressBar.barFillColor = #colorLiteral(red: 0.537254902, green: 0.6901960784, blue: 0.9843137255, alpha: 1)
        progressBar.barBackgroundColor = #colorLiteral(red: 1, green: 0.5937769413, blue: 0.6053269506, alpha: 1)
        progressBar.displayLabel = false
        progressBar.cornerType = .rounded
        progressBar.barFillInset = 0
        
        
        if viewModel.likePercentage == 0.0 {
            progressBar.progress = 0.0

        } else {
            progressBar.progress = CGFloat(viewModel.likePercentage)
   
        }
    }
    
    func configureLabels() {
    
        menuLabel.text = viewModel.menuName
        totalLikeLabel.text = "(\(String(viewModel.likes)))"
        totalDislikeLabel.text = "(\(String(viewModel.dislikes)))"
        
        if viewModel.totalLikes == 0 {
            
            progressBar.barBackgroundColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            likeImageView.image = UIImage(named: "thumbs up(gray)")
            dislikeImageView.image = UIImage(named: "thumbs down(gray)")
            likeTitleLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            dislikeTitleLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            totalLikeLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
            totalDislikeLabel.textColor = #colorLiteral(red: 0.7530117035, green: 0.753121376, blue: 0.7529876828, alpha: 1)
        
        } else {
            
            likeImageView.image = UIImage(named: "thumbs up(selected,edited)")
            dislikeImageView.image = UIImage(named: "thumbs down(selected,edited)")
        }
    
    }
 
}
