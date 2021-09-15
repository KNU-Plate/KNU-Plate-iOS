import UIKit
import Then

class MainCollectionReusableView: UICollectionReusableView {
    
    private let sectionInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
    private let collectionViewHeight: CGFloat = 150
    private let itemsPerColumn: CGFloat = 1
    private let itemsPerRow: CGFloat = 4
    private let reuseID1 = "MainCollectionViewCell1"
    private let reuseID2 = "MainCollectionViewCell2"
    
    weak var delegate: MainCollectionReusableViewDelegate?
    
    //MARK: - Description Label
    let categoryLabel = UILabel().then {
        $0.text = "카테고리별로 살펴보세요!"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    //MARK: - Category CollectionView
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }
    
    let rightArrow = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.compact.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemGray3
    }
    
    //MARK: - Description Label
    let gateLabel = UILabel().then {
        $0.text = "문 별 맛집이 궁금하다면?"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    //MARK: - Gate CollectionView
    let gateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
    }
    
    //MARK: - Recommend Label
    let recommendLabel = UILabel().then {
        $0.text = UIViewController().getRecommendationLabel()
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        
        self.addSubview(categoryLabel)
        self.addSubview(categoryCollectionView)
        self.addSubview(gateLabel)
        self.addSubview(gateCollectionView)
        self.addSubview(recommendLabel)
        self.addSubview(rightArrow)
        
        let spacing: CGFloat = 10
        let labelHeight: CGFloat = 20
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing + 5)
            make.height.equalTo(labelHeight)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(collectionViewHeight)
        }
        gateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing + 5)
            make.height.equalTo(labelHeight)
        }
        gateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(gateLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(collectionViewHeight)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(gateCollectionView.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing + 5)
            make.height.equalTo(labelHeight)
            make.bottom.equalToSuperview().offset(-spacing).priority(.low)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(categoryCollectionView)
            make.width.equalTo(sectionInsets.right*2)
            make.height.equalTo(collectionViewHeight*0.67)
            make.right.equalToSuperview()
        }
        // sum of height: 10*6 + 20*3 + 150*2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        gateCollectionView.dataSource = self
        gateCollectionView.delegate = self
        categoryCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseID1)
        gateCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseID2)
    }
}

//MARK: - UICollectionViewDataSource
extension MainCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 7
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID1, for: indexPath) as? MainCollectionViewCell else { fatalError() }
            cell.foodImageView.image = UIImage(named: "food\(indexPath.item)")
            cell.insideLabel.textColor = .clear
            
            let foodCategoryName = Constants.footCategoryArray[indexPath.item]
            let startIdx = foodCategoryName.index(foodCategoryName.startIndex, offsetBy: 2)
            cell.titleLabel.text = String(foodCategoryName[startIdx...])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID2, for: indexPath) as? MainCollectionViewCell else { fatalError() }
            cell.backView.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
            cell.foodImageView.image = nil
            cell.insideLabel.textColor = .white
            cell.insideLabel.text = Constants.gateNamesShort[indexPath.item]
            cell.titleLabel.text = Constants.gateNames[indexPath.item]
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MainCollectionReusableView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= 5 {
            rightArrow.isHidden = true
        }
        if scrollView.contentOffset.x < 5 {
            rightArrow.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let foodCategoryName = Constants.footCategoryArray[indexPath.item]
            let startIdx = foodCategoryName.index(foodCategoryName.startIndex, offsetBy: 2)
            let foodCategory = String(foodCategoryName[startIdx...])
            
            self.delegate?.pushVC(category: Category(foodCategory: foodCategory))
        } else {
            let gateName = Constants.gateNames[indexPath.item]
            
            self.delegate?.pushVC(category: Category(gate: gateName))
        }
    }
}

//MARK: - Collection View Flow Layout Delegate
extension MainCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPaddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.categoryCollectionView.frame.width - horizontalPaddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem*1.3)
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
