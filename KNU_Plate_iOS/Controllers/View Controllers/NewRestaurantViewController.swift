import UIKit

// 맛집 올리기 View Controller

class NewRestaurantViewController: UIViewController {
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var foodCategoryTextField: UITextField!
    @IBOutlet var expandButtonTextField: UITextField!
    @IBOutlet var reviewImageCollectionView: UICollectionView!
    
    var viewModel = NewRestaurantViewModel(restaurantName: "매장명")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
       
    
    }


    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
      
   
        
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.gate = viewModel.schoolGates[0]
        case 1:
            viewModel.gate = viewModel.schoolGates[1]
        case 2:
            viewModel.gate = viewModel.schoolGates[2]
        case 3:
            viewModel.gate = viewModel.schoolGates[3]
        default:
            viewModel.gate = "북문"
        }
    }
}

//MARK: - UI Configuration Methods

extension NewRestaurantViewController {

    func initialize() {
        
        initializeCollectionView()
        createPickerView()
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
        
        /// Toolbar 없으면 추가로 넣기 ("완료" 버튼)
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
                fatalError("Failed to dequeue cell for AddImageButtonCollectionViewCell")
            }
            cell.delegate = self
            return cell
        }
        
        /// 그 외의 셀은 사용자가 고른 사진으로 구성된  Cell
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFoodImageCellIdentifier, for: indexPath) as? UserPickedFoodImageCollectionViewCell else {
                fatalError("Failed to dequeue cell for UserPickedFoodImageCollectionViewCell")
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
