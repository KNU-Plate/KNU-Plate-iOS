import UIKit
import SnapKit
import Then
import SPIndicator

/// Shows the main screen of the app
class MainViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    private let itemsPerRow: CGFloat = 2
    private let headerReuseIdentifier = "MainCollectionReusableView"
    private let cellReuseIdentifier = "RestaurantCollectionViewCell"
    
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
        
        setupCollectionView()
        welcomeUser()
    }
}

//MARK: - Basic UI Set Up
extension MainViewController {
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
            return headerView
        default:
            assert(false, "Nope")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? RestaurantCollectionViewCell else {
            fatalError("fail to dequeue cell or cast cell as RestaurantCollectionViewCell")
        }

        // Configure the cell
        cell.nameLabel.text = "반미리코"
        cell.countLabel.text = "10"
        cell.ratingStackView.averageRating = 4.7
        
        return cell
    }
}

//MARK: - Collection View Flow Layout Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 10.0*6 + 20.0*3 + 150.0*2
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

////MARK: - Prepare For Next View
//extension MainViewController {
//    /// Execute next view controller
//    @objc func gateButtonWasTapped(_ sender: UIButton) {
//        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantCollectionViewController) as? RestaurantCollectionViewController else {
//            fatalError()
//        }
//        nextViewController.navigationItem.title = Constants.gateNames[sender.tag]
//        nextViewController.gate = Gate.gateFromInt(number: sender.tag)
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//    }
//}

//MARK: - Other Methods
extension MainViewController {
    func welcomeUser() {
        SPIndicator.present(title: "\(User.shared.displayName)님",
                            message: "환영합니다 🎉",
                            preset: .custom(UIImage(systemName: "face.smiling")!))
    }
}
