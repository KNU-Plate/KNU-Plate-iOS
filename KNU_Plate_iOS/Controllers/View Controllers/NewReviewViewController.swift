import UIKit
import Alamofire
import ProgressHUD
import SnackBar_swift

class NewReviewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var starRating: RatingController!
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    @IBOutlet weak var menuInputTextField: UITextField!
    @IBOutlet weak var menuInputTableView: UITableView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var addMenuButton: UIButton!
    
    lazy var existingMenusPickerView = UIPickerView()
    
    
    // 수정 필요 mallIID
    private let viewModel: NewReviewViewModel = NewReviewViewModel(mallID: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //reset viewmodel 하기
    }
    
    // RestaurantVC 에서 받은 매장 정보를 이용하여 viewModel 변수 초기화
    func configure(mallID: Int, existingMenus: [ExistingMenuModel]) {
        
        viewModel.mallID = mallID
        viewModel.existingMenus.append(contentsOf: existingMenus)
    }
    
    @IBAction func pressedAddMenuButton(_ sender: Any) {
        
        self.view.endEditing(true)
        
        do {
            if let nameOfMenu = menuInputTextField.text {
                
                try viewModel.validateMenuName(menu: nameOfMenu)
                
                viewModel.addNewMenu(name: nameOfMenu)
                
                menuInputTableView.reloadData()
                self.viewWillLayoutSubviews()
                menuInputTextField.text?.removeAll()
                menuInputTextField.resignFirstResponder()
                initializePickerViewForMenuTextField()
                return
            }
        } catch {
            
            switch error {
            
            case NewReviewInputError.tooMuchMenusAdded:
                SnackBar.make(in: self.view,
                              message: "\(NewReviewInputError.tooMuchMenusAdded.errorDescription) 🥲",
                              duration: .lengthLong).show()
            case NewReviewInputError.menuNameTooShort:
                SnackBar.make(in: self.view,
                              message: "\(NewReviewInputError.menuNameTooShort.errorDescription) 🥲",
                              duration: .lengthLong).show()
            case NewReviewInputError.alreadyExistingMenu:
                SnackBar.make(in: self.view,
                              message: "\(NewReviewInputError.alreadyExistingMenu.errorDescription) 🥲",
                              duration: .lengthLong).show()
            default:
                SnackBar.make(in: self.view,
                              message: "개발자도 예기치 못한 오류가 발생했습니다. 불편을 드려 죄송합니다 😥 ",
                              duration: .lengthLong).show()
            
            }
        }
        menuInputTextField.text?.removeAll()
    }
    
    // 완료 버튼 눌렀을 시 실행
    @IBAction func pressedFinishButton(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        self.presentAlertWithCancelAction(title: "리뷰를 업로드 하시겠습니까?", message: "") { selectedOk in
             
            if !selectedOk { return }
            else {
                showProgressBar()
                do {
                    try self.viewModel.validateUserInputs()
                    
                    self.viewModel.rating = self.starRating.starsRating
                    
                    
                   
                    self.viewModel.startUploading()

                } catch {
                    
                    switch error {
                    
                    case NewReviewInputError.insufficientMenuError:
                        SnackBar.make(in: self.view,
                                      message: "\(NewReviewInputError.insufficientMenuError.errorDescription) 🥲",
                                      duration: .lengthLong).show()
                        
                    case NewReviewInputError.insufficientReviewError:
                        SnackBar.make(in: self.view,
                                      message: "\(NewReviewInputError.insufficientReviewError.errorDescription) 🥲",
                                      duration: .lengthLong).show()
                    case NewReviewInputError.blankMenuNameError:
                        SnackBar.make(in: self.view,
                                      message: "\(NewReviewInputError.blankMenuNameError.errorDescription) 🥲",
                                      duration: .lengthLong).show()
                    default:
                        SnackBar.make(in: self.view,
                                      message: "개발자도 예기치 못한 오류가 발생했습니다. 불편을 드려 죄송합니다 😥 ",
                                      duration: .lengthLong).show()
                    }
                }
                
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource -> 사용자가 업로드 할 사진을 위한 Collection View

extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.userSelectedImages.count + 1     /// Add Button 이 항상 있어야하므로 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let addImageButtonCellIdentifier = Constants.CellIdentifier.addFoodImageCell
        let newFoodImageCellIdentifier = Constants.CellIdentifier.newUserPickedFoodImageCell
        
        /// 첫 번째 Cell 은 항상 Add Button
        if indexPath.item == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addImageButtonCellIdentifier, for: indexPath) as? AddImageButtonCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            return cell
        }
        
        /// 그 외의 셀은 사용자가 고른 사진으로 구성된  Cell
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFoodImageCellIdentifier, for: indexPath) as? UserPickedFoodImageCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.indexPath = indexPath.item
            
            /// 사용자가 앨범에서 고른 사진이 있는 경우
            if viewModel.userSelectedImages.count > 0 {
                cell.userPickedImageView.image = viewModel.userSelectedImages[indexPath.item - 1]
            }
            return cell
        }
    }
}

//MARK: - AddImageDelegate

extension NewReviewViewController: AddImageDelegate {
    
    func didPickImagesToUpload(images: [UIImage]) {
        
        viewModel.userSelectedImages = images
        reviewImageCollectionView.reloadData()
    }
}

//MARK: - UserPickedFoodImageCellDelegate

extension NewReviewViewController: UserPickedFoodImageCellDelegate {

    func didPressDeleteImageButton(at index: Int) {

        viewModel.userSelectedImages.remove(at: index - 1)
        reviewImageCollectionView.reloadData()
        viewWillLayoutSubviews()
    }
}

//MARK: - NewMenuTableViewCellDelegate

extension NewReviewViewController: NewMenuTableViewCellDelegate {

    func didPressDeleteMenuButton(at index: Int) {
    
        viewModel.userAddedMenus.remove(at: index)
        menuInputTableView.reloadData()
        viewWillLayoutSubviews()
    }
    
    func didPressEitherGoodOrBadButton(at index: Int, menu isGood: Bool) {
        
        if isGood {
            viewModel.userAddedMenus[index].isGood = "Y"
        } else {
            viewModel.userAddedMenus[index].isGood = "N"
        }
    }
}

//MARK: - NewReviewViewModelDelegate

extension NewReviewViewController: NewReviewViewModelDelegate {
    
    func didCompleteReviewUpload(_ success: Bool) {
        dismissProgressBar()
        print("NEW REVIEW UPLOAD COMPLETE")
        
        SnackBar.make(in: self.view,
                      message: "리뷰 업로드 성공! 🎉",
                      duration: .lengthLong).show()
    }
    
    func failedUploadingReview(with error: NetworkError) {
        dismissProgressBar()
        SnackBar.make(in: self.view,
                      message: error.errorDescription,
                      duration: .lengthLong).show()
    }
    
    func didCompleteMenuUpload() {
        print("신규 메뉴 등록 성공")
    }
    
    func failedUploadingMenu(with error: NetworkError) {
        SnackBar.make(in: self.view,
                      message: error.errorDescription,
                      duration: .lengthLong).show()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource -> 메뉴 입력을 위한 TableView

extension NewReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userAddedMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.newMenuTableViewCell, for: indexPath) as? NewMenuTableViewCell else {
            fatalError()
        }
        
        if viewModel.userAddedMenus.count != 0 {
            let menuInfo = viewModel.userAddedMenus[indexPath.row]
            
            cell.delegate = self
            cell.menuNameTextField.text = menuInfo.menuName
            cell.indexPath = indexPath.row
        }
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = self.menuInputTableView.contentSize.height
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width:self.view.bounds.width, height: view.frame.height)
    }

}

//MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension NewReviewViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.existingMenus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.existingMenus[row].menuName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == viewModel.existingMenus.count - 1 {
            menuInputTextField.text = ""
            return
        }
        menuInputTextField.text = viewModel.existingMenus[row].menuName
    }
}

//MARK: - UITextViewDelegate -> For reviewTextView

extension NewReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "방문하셨던 맛집에 대한 솔직한 리뷰를 남겨주세요! 🍔"
            textView.textColor = UIColor.lightGray
            return
        }
        viewModel.review = textView.text
    }
}

//MARK: - UI Configuration

extension NewReviewViewController {
    
    func initialize() {
        
        viewModel.delegate = self
        
        initializeStarRating()
        initializeTextField()
        initializeCollectionView()
        initializeTableView()
        initializeTextView()
        initializeAddMenuButton()
    }
    
    func initializeStarRating() {
        
        starRating.setStarsRating(rating: viewModel.rating)
    }
    
    func initializeTableView() {
        
        menuInputTableView.delegate = self
        menuInputTableView.dataSource = self
        
        let menuNib = UINib(nibName: Constants.XIB.newMenuTableViewCell, bundle: nil)
        let cellIdentifier = Constants.CellIdentifier.newMenuTableViewCell
        menuInputTableView.register(menuNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func initializeCollectionView() {
        
        reviewImageCollectionView.delegate = self
        reviewImageCollectionView.dataSource = self
    }
    
    func initializeTextView() {
        
        reviewTextView.delegate = self
        reviewTextView.text = "방문하셨던 맛집에 대한 솔직한 리뷰를 남겨주세요! 🍔"
        reviewTextView.textColor = UIColor.lightGray
        
        reviewTextView.layer.cornerRadius = 10.0
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func initializeTextField() {

        menuInputTextField.placeholder = "드신 메뉴를 고르거나 입력해주세요! 🍽"
        menuInputTextField.layer.cornerRadius = 10
        menuInputTextField.clipsToBounds = true
        menuInputTextField.layer.borderWidth = 1
        menuInputTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        menuInputTextField.leftView = UIView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: 10,
                                                           height: 0))
        menuInputTextField.leftViewMode = .always
        
        let expandButton = UITextField(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 25,
                                                     height: 25))
        expandButton.background = UIImage(named: "expand button")
        expandButton.isUserInteractionEnabled = true
        expandButton.inputView = existingMenusPickerView
        expandButton.tintColor = .clear

        let rightView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: 30,
                                             height: 25))
        rightView.addSubview(expandButton)
        menuInputTextField.rightView = rightView
        menuInputTextField.rightViewMode = .always
        initializePickerViewForMenuTextField()
        menuInputTextField.inputAccessoryView = initializeToolbar()
    }
    
    func initializePickerViewForMenuTextField() {
        
        existingMenusPickerView.backgroundColor = .white
        existingMenusPickerView.delegate = self
        existingMenusPickerView.dataSource = self
    }
    
    func initializeAddMenuButton() {
        
        addMenuButton.layer.cornerRadius = 5
        addMenuButton.clipsToBounds = true
        addMenuButton.addBounceReactionWithoutFeedback()
    }
    
    func initializeToolbar() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "완료",
                                         style: UIBarButtonItem.Style.done,
                                         target: self,
                                         action: #selector(self.dismissPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func cancelPicker(pickerView: UIPickerView) {
        self.view.endEditing(true)
    }
    
    @objc func dismissPicker(pickerView: UIPickerView) {
        
        self.view.endEditing(true)
        
        let selectedRow = existingMenusPickerView.selectedRow(inComponent: 0)
        
        /// 만약 "직접 입력" 옵션을 선택했을 시
        if selectedRow == viewModel.existingMenus.count - 1 {
            menuInputTextField.inputAccessoryView = nil
            menuInputTextField.becomeFirstResponder()
        } else {
            menuInputTextField.resignFirstResponder()
        }
    }
    
}
