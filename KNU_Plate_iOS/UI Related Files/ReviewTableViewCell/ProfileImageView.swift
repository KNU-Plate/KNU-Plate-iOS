import UIKit

let profileImageCache = NSCache<AnyObject, AnyObject>()

class ProfileImageView: UIImageView {
    
    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        
        image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = profileImageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let newImage = UIImage(data: data) else {
                print("ProfileImageView Extension - couldn't load image from url: \(String(describing: error))")
                
                DispatchQueue.main.async {
                    
                    self.image = UIImage(named: Constants.Images.defaultProfileImage)
                    self.removeSpinner()
                }
                return
            }
            
            profileImageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
        }
        task.resume()
    }
    
    func addSpinner() {
        
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
