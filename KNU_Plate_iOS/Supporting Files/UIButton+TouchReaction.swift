import Foundation
import UIKit

extension UIButton {
    func addBounceReaction() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUpFailed(_:)), for: [.touchCancel, .touchUpOutside, .touchDragExit])
        addTarget(self, action: #selector(touchUpSucceeded(_:)), for: .touchUpInside)
    }
    
    @objc func touchDown(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    @objc func touchUpFailed(_ sender: UIButton) {
        animate {
            sender.transform = .identity
        }
    }
    
    @objc func touchUpSucceeded(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            self.animate {
                sender.transform = .identity
            }
        }
    }
    
    func animate(reaction: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: reaction, completion: completion)
    }
}
