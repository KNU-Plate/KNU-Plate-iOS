import UIKit

class NewReviewViewController: UIViewController {
  
    
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewImageCollectionView.delegate = self
        reviewImageCollectionView.dataSource = self
        

    }
    
    



}

extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserPickedImageCollectionViewCell
        
        
        if indexPath.item == 0 {
            cell.userPickedImageView.image = UIImage(named: "add button")
            cell.cancelButtonImage.isHidden = true
        }
        else {
            cell.userPickedImageView.image = UIImage(named: "chinese food")
        }
        
        
        
        return cell
        
    }
    
    
    
}
