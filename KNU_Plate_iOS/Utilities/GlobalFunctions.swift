import UIKit
import ProgressHUD

func setUserMedalImage(medalRank: Int) -> UIImage {
    
    switch medalRank {
    case 1: return UIImage(named: Constants.Images.firstMedal)!
    case 2: return UIImage(named: Constants.Images.secondMedal)!
    case 3: return UIImage(named: Constants.Images.thirdMedal)!
    default: return UIImage(named: Constants.Images.thirdMedal)!
    }
}

func showProgressBar() {
    ProgressHUD.animationType = .lineSpinFade
    ProgressHUD.colorAnimation = UIColor(named: Constants.Color.appDefaultColor) ?? .systemGray
    ProgressHUD.show()
}

func dismissProgressBar() {
    ProgressHUD.dismiss()
}
