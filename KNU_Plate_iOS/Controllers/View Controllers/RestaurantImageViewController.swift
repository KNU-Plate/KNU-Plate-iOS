import UIKit
import SDWebImage

class RestaurantImageViewController: UIViewController {
    
    private let reuseIdentifier = "RestaurantImageCell"
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    private let itemsPerRow: CGFloat = 2
    
    var mallID: Int?
    private var restaurantImageVM = RestaurantImageViewModel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)

        setupCollectionView()
        restaurantImageVM.delegate = self
        restaurantImageVM.setMallID(mallID)
        restaurantImageVM.fetchImages()
    }
}

extension RestaurantImageViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension RestaurantImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantImageVM.numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RestaurantImageCollectionViewCell else {
            fatalError("fail to dequeue cell or cast cell as RestaurantCollectionViewCell")
        }
        // Configure the cell
        cell.imageView.sd_setImage(with: restaurantImageVM.getImageURL(of: indexPath.item),
                                   placeholderImage: UIImage(named: "restaurant cell placeholder (gray)"))
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension RestaurantImageViewController: UICollectionViewDelegate {
    // cell selected, prepare for next view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        /*
                이미지 줌 뷰 컨트롤러 구현하기
        */
//        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantInfoViewController) as? RestaurantInfoViewController else {
//            fatalError("fail to instantiate view controller")
//        }
//        guard let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCollectionViewCell else {
//            fatalError("fail to get cell for indexpath or cast cell as RestaurantCollectionViewCell")
//        }
//        nextViewController.navigationItem.title = cell.nameLabel.text
//        nextViewController.mallID = cell.mallID
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // touch animation when cell is highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    // touch animation when cell is unhighlighted
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && restaurantImageVM.hasMore && !restaurantImageVM.isFetchingData {
            // fetch more
            restaurantImageVM.fetchImages()
        }
    }
}

//MARK: - RestaurantImageViewModelDelegate
extension RestaurantImageViewController: RestaurantImageViewModelDelegate {
    func didFetchImage() {
        print("didFetchImage count: \(restaurantImageVM.numberOfImages)")
        collectionView.reloadData()
    }
}

//MARK: - Collection View Flow Layout Delegate
extension RestaurantImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
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
