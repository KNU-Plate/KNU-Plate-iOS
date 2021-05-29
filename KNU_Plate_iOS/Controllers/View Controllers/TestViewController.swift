import UIKit
import SDWebImage

class TestViewController: UIViewController {

    @IBOutlet var imageView: ReviewImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downloadString = "http://3.35.58.40:4200/bucket/a2b51566-b08f-4aaf-8db4-138bde48f88b/82dd028130d4be62bf5143e2422276cc"
        
        if let downloadURL = URL(string: downloadString) {
            

            
            imageView.sd_setImage(with: downloadURL, placeholderImage: UIImage(named: "default review image"))
            
//            do {
//
//                let imageData = try Data(contentsOf: downloadURL)
//                imageView.image = UIImage(data: imageData)
//
//            } catch {
//                print("catch: ")
//            }
        }
        
        
        
        else {
            print("optional binding error")
        }
        
        
        
    }
    
    
}
