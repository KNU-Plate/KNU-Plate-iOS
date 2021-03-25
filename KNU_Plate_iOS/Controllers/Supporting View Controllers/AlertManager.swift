import UIKit

class AlertManager {
    
    class func showAlertMessage(_ title: String, _ message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    
}
