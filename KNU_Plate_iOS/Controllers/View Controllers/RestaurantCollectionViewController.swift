import UIKit
import SnapKit
import SDWebImage

/// Shows restaurant list according to gate
class RestaurantCollectionViewController: UIViewController {
    
    private let reuseIdentifier = "Cell"
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    private let itemsPerRow: CGFloat = 2
    
    private let restaurantListVM = RestaurantListViewModel()
    
    var gate: Gate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        restaurantListVM.delegate = self
        setupCollectionView()
        setCollectionViewLayout()
        
        guard let gate = gate else { return }
        restaurantListVM.fetchRestaurantList(gate: gate.rawValue)
        print("👌 RestaurantCollectionViewController viewDidLoad")
    }
    
    deinit {
        print("👌 RestaurantCollectionViewController deinit")
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
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension RestaurantCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.restaurantListVM.numberOfRestaurants
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RestaurantCollectionViewCell else {
            fatalError("fail to dequeue cell or cast cell as RestaurantCollectionViewCell")
        }

        let restaurantVM = self.restaurantListVM.restaurantAtIndex(indexPath.item)

        // Configure the cell
        cell.imageView.sd_setImage(with: restaurantVM.thumbnailURL,
                                   placeholderImage: UIImage(named: "restaurant cell placeholder (gray)"))
        cell.nameLabel.text = restaurantVM.mallName
        cell.ratingStackView.averageRating = restaurantVM.averageRating
        cell.mallID = restaurantVM.mallID
        
        return cell
    }
}

//MARK: - RestaurantListViewModelDelegate
extension RestaurantCollectionViewController: RestaurantListViewModelDelegate {
    func didFetchRestaurantList() {
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate
extension RestaurantCollectionViewController: UICollectionViewDelegate {
    // cell selected, prepare for next view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected, indexPath: \(indexPath.item)")
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantInfoViewController) as? RestaurantInfoViewController else {
            fatalError("fail to instantiate view controller")
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCollectionViewCell else {
            fatalError("fail to get cell for indexpath or cast cell as RestaurantCollectionViewCell")
        }
        nextViewController.navigationItem.title = cell.nameLabel.text
        nextViewController.mallID = cell.mallID
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && restaurantListVM.hasMore && !restaurantListVM.isFetchingData {
            // fetch more
            guard let gate = gate else { return }
            restaurantListVM.fetchRestaurantList(gate: gate.rawValue)
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
