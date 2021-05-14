import Foundation

public func setUserMedalImage(medalRank: Int) -> UIImage {
    
    switch medalRank {
    case 1: return UIImage(named: "first medal")!
    case 2: return UIImage(named: "second medal")!
    case 3: return UIImage(named: "third medal")!
    default: return UIImage(named: "third medal")!
    }
}
