import UIKit

let reviewImageCache = NSCache<AnyObject, AnyObject>()

class ReviewImageView: UIImageView {


    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)

    func loadImage(from url: URL) {

        image = nil

        addSpinner()

        if let task = task {
            print("Task has been cancelled")
            task.cancel()
        }

        if let imageFromCache = reviewImageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            return
        }

        print("ReviewImageView URL: \(url)")


        task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            print("response: \(response)")
            
            guard let data = data, let newImage = UIImage(data: data) else {

                print("ReviewImageView Extension - couldn't load image from url: \(String(describing: error))")
               
                print("ERROR: \(error)")
                DispatchQueue.main.async {
                    self.image = UIImage(named: "default review image")
                    self.removeSpinner()
                }
                return
            }

            reviewImageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)

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
