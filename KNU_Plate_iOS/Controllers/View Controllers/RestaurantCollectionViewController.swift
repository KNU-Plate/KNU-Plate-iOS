import UIKit
import SnapKit

/// Shows restaurant list according to gate
class RestaurantCollectionViewController: UIViewController {
    
    private let reuseIdentifier = "Cell"
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    private let itemsPerRow: CGFloat = 2
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        setupCollectionView()
        setCollectionViewLayout()
    }
}
//MARK: - Basic Set Up
extension RestaurantCollectionViewController {
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = .white
        self.collectionView.alwaysBounceVertical = true
    }
    
    func setCollectionViewLayout() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - UICollectionViewDataSource
extension RestaurantCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RestaurantCollectionViewCell else {
            fatalError("fail to dequeue cell or cast cell as RestaurantCollectionViewCell")
        }
    
        // Configure the cell
        let rating: Int = 4
        cell.imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        cell.nameLabel.text = "배터지는깐풍기"
        cell.ratingStackView.setStarsRating(rating: rating)
        return cell
    }

}
// MARK: - UICollectionViewDelegate
extension RestaurantCollectionViewController: UICollectionViewDelegate {
    // cell selected, prepare for next view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected, indexPath: \(indexPath.item)")
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantViewController) else {
            fatalError("fail to instantiate view controller")
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCollectionViewCell else {
            fatalError("fail to get cell for indexpath or cast cell as RestaurantCollectionViewCell")
        }
        nextViewController.navigationItem.title = cell.nameLabel.text
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // cell deselected
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselected, indexPath: \(indexPath.item)")
    }
    
    // touch animation when cell is highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("Highligted, indexPath: \(indexPath.item)")
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    // touch animation when cell is unhighlighted
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("Unhighlited, indexPath: \(indexPath.item)")
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.transform = .identity
                }
            }
        }
    }
}
//MARK: - Collection View Flow Layout Delegate
extension RestaurantCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * Constants.heightPerWidthRestaurantCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
