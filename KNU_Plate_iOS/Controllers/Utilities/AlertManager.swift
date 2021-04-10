import UIKit

class AlertManager {
    
    class func createAlertMessage(_ title: String, _ message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    
    
}
