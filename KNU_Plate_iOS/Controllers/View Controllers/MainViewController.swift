import UIKit
import SnapKit
import Then
import SPIndicator

protocol MainCollectionReusableViewDelegate: AnyObject {
    func pushVC(category: Category)
}

/// Shows the main screen of the app
class MainViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    private let itemsPerRow: CGFloat = 2
    private let headerReuseIdentifier = "MainCollectionReusableView"
    private let cellReuseIdentifier = "Cell"
    
    private let viewModel = RestaurantListViewModel()
    
    private var foodCategory: Category?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title of main view
        self.navigationItem.title = "크슐랭가이드"
        // set title color
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        // set backbutton color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        // set prefersLargeTitles
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.delegate = self
        
        setupCollectionView()
        createRefreshTokenExpirationObserver()
        viewModel.fetchTodaysRecommendation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
}

//MARK: - RestaurantListViewModelDelegate
extension MainViewController: RestaurantListViewModelDelegate {
    
    func didFetchRestaurantList() {
        
        if viewModel.restaurants.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.fetchTodaysRecommendation()
            }
            return
        }
        collectionView.reloadData()
    }
    
}

//MARK: - Basic UI Set Up
extension MainViewController {
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(
            identifier: Constants.StoryboardID.restaurantInfoViewController
        ) as? RestaurantInfoViewController else { fatalError() }
        
        guard let cell = collectionView.cellForItem(
                at: indexPath
        ) as? RestaurantCollectionViewCell else { fatalError() }
        
        vc.navigationItem.title = cell.nameLabel.text
        vc.mallID = cell.mallID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
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
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? MainCollectionReusableView else { fatalError() }
            headerView.delegate = self
            return headerView
        default:
            assert(false, "Nope")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.restaurants.count == 0 {
            return 0
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel.restaurants.count == 0 { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellReuseIdentifier,
                for: indexPath
        ) as? RestaurantCollectionViewCell else {
            fatalError()
        }
    
        
        let cellVM = viewModel.restaurantAtIndex(indexPath.item)
        
        cell.imageView.sd_setImage(
            with: cellVM.thumbnailURL,
            placeholderImage: UIImage(named: "restaurant cell placeholder (gray)")
        )
        cell.nameLabel.text = cellVM.mallName
        cell.countLabel.text = String(cellVM.reviewCount)
        cell.ratingView.averageRating = cellVM.averageRating
        cell.mallID = cellVM.mallID
        
        return cell
    }
}

//MARK: - Collection View Flow Layout Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 60.0 + 60.0 + 300.0
        return CGSize(width: width, height: height)
    }
    
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

//MARK: - MainCollectionReusableViewDelegate
extension MainViewController: MainCollectionReusableViewDelegate {
    
    func pushVC(category: Category) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantCollectionViewController) as? RestaurantCollectionViewController else {
            fatalError()
        }
        nextViewController.category = category
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
