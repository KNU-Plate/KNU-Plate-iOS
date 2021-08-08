import UIKit
import ProgressHUD
import SnackBar_swift

// 맛집 올리기 View Controller

class NewRestaurantViewController: UIViewController {
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var foodCategoryTextField: UITextField!
    @IBOutlet var expandButtonTextField: UITextField!
    @IBOutlet var reviewImageCollectionView: UICollectionView!
    
    private var viewModel = NewRestaurantViewModel(restaurantName: "")

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
    
    // SearchRestaurantVC 에서 받은 매장 정보를 이용하여 viewModel 변수 초기화
    func configure(with details: RestaurantDetailFromKakao) {
    
        viewModel.restaurantName = details.name
        viewModel.address = details.address
        viewModel.contact = details.contact
        viewModel.categoryName = details.category
        viewModel.latitude = details.latitude
        viewModel.longitude = details.longitude
        viewModel.placeID = details.placeID
 
    }
    
    @IBAction func pressedUploadButton(_ sender: UIBarButtonItem) {
        
        showProgressBar()
        viewModel.upload()
       
    }
    
    func goBackToHomeVC() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    

}

//MARK: - NewRestaurantViewModelDelegate

extension NewRestaurantViewController: NewRestaurantViewModelDelegate {
    
    func didCompleteUpload(_ success: Bool) {
        
        dismissProgressBar()
        
        showSimpleBottomAlertWithAction(message: "매장 등록 성공 🎉",
                                        buttonTitle: "홈으로 돌아가기") {
            self.goBackToHomeVC()
        }
    }
    
    func failedToUpload(with error: NetworkError) {
        
        dismissProgressBar()
        
        showSimpleBottomAlertWithAction(message: error.errorDescription,
                                        buttonTitle: "홈으로 돌아가기") {
            self.goBackToHomeVC()
        }
    }
    
    func alreadyRegisteredRestaurant(with error: UploadError){
        
        dismissProgressBar()
        
        showSimpleBottomAlertWithAction(message: error.errorDescription,
                                        buttonTitle: "홈으로 돌아가기") {
            self.goBackToHomeVC()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource -> 사용자가 업로드 할 사진을 위한 Collection View

extension NewRestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.userSelectedImages.count + 1             /// Add Button 이 항상 있어야하므로 + 1
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

extension NewRestaurantViewController: AddImageDelegate {
    
    func didPickImagesToUpload(images: [UIImage]) {
        
        viewModel.userSelectedImages = images
        reviewImageCollectionView.reloadData()
    }
}

//MARK: - UserPickedFoodImageCellDelegate

extension NewRestaurantViewController: UserPickedFoodImageCellDelegate {
    
    func didPressDeleteImageButton(at index: Int) {
        
        viewModel.userSelectedImages.remove(at: index - 1)
        reviewImageCollectionView.reloadData()
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension NewRestaurantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.foodCategoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.foodCategoryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let selectedFoodCategory = viewModel.foodCategoryArray[row]
        viewModel.foodCategory = selectedFoodCategory
        foodCategoryTextField.text = selectedFoodCategory
    }
}

//MARK: - UI Configuration Methods

extension NewRestaurantViewController {

    func initialize() {
        
        viewModel.delegate = self
        
        initializeRestaurantName()
        initializeCollectionView()
        createPickerView()
    }
    
    func initializeRestaurantName() {
        restaurantNameLabel.text = viewModel.restaurantName
    }
    
    func initializeCollectionView() {
        
        reviewImageCollectionView.delegate = self
        reviewImageCollectionView.dataSource = self
    }
    
    func createPickerView() {
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        expandButtonTextField.inputView = pickerView
        foodCategoryTextField.inputView = pickerView
    }
}
