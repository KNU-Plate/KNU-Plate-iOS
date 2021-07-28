import UIKit
import Then

class MainCollectionReusableView: UICollectionReusableView {
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerColumn: CGFloat = 1
    private let reuseID1 = "MainCollectionViewCell1"
    private let reuseID2 = "MainCollectionViewCell2"
    
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
        $0.text = "오늘은 이거 어때?"
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
        
        let spacing: CGFloat = 10
        let labelHeight: CGFloat = 20
        let collectionViewHeight: CGFloat = 150
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(labelHeight)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(collectionViewHeight)
        }
        gateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(labelHeight)
        }
        gateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(gateLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(collectionViewHeight)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(gateCollectionView.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(labelHeight)
            make.bottom.equalToSuperview().offset(-spacing).priority(.low)
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
            cell.foodImageView.image = UIImage(named: "foodCategory\(indexPath.item)")
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

//MARK: - Collection View Flow Layout Delegate
extension MainCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.top * (itemsPerColumn + 1)
        let availableHeight = self.categoryCollectionView.frame.height - paddingSpace
        let heightPerItem = availableHeight / itemsPerColumn
        return CGSize(width: heightPerItem*0.67, height: heightPerItem)
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
