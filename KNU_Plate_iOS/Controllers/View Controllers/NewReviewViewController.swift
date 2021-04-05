import UIKit

class NewReviewViewController: UIViewController {
  
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    @IBOutlet weak var menuInputTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewImageCollectionView.delegate = self
        reviewImageCollectionView.dataSource = self
        
        setUpView()
        
        
       
    
    }
    
    @objc func addMenuButtonPressed() {
        /// need edit
        print("pressed")
    }
    
    
    func setUpView() {
        
        menuInputTextField.layer.cornerRadius = menuInputTextField.frame.height / 2
        menuInputTextField.clipsToBounds = true
        menuInputTextField.layer.borderWidth = 1
        menuInputTextField.layer.borderColor = UIColor.black.cgColor
        
        menuInputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        menuInputTextField.leftViewMode = .always
            
        
        let addMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        addMenuButton.setImage(UIImage(named: "plus button"), for: .normal)
        addMenuButton.isUserInteractionEnabled = true
        addMenuButton.contentMode = .scaleAspectFit
        addMenuButton.addTarget(self, action: #selector(addMenuButtonPressed), for: .touchUpInside)
        
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        rightView.addSubview(addMenuButton)
        menuInputTextField.rightView = rightView
        menuInputTextField.rightViewMode = .always
    }


}

extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// need edit
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        /// need edit
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
