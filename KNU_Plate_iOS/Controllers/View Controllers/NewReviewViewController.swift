import UIKit
import Alamofire

class NewReviewViewController: UIViewController {
  
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    @IBOutlet weak var menuInputTextField: UITextField!
    @IBOutlet weak var menuInputTableView: UITableView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var starRating: RatingController!
    
    private let viewModel: NewReviewViewModel = NewReviewViewModel()
    
    var userSelectedReviewImages: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    
        //testAlamofire()
    }
    
    func testAlamofire() {
        
        let baseURL = "http://52.253.91.116:4100/api/signup"
        let user_name = "alex"
        let display_name = "alexding"
        let password = "123456789"
        let email_address = "alexding@knu.ac.kr"
        
        let param: Parameters = [
        
            "user_name": user_name,
            "display_name": display_name,
            "password": password,
            "mail_address": email_address
        ]
        
        let headers: HTTPHeaders = [
        
            "accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
            
        ]
        
        AF.request(baseURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            
            switch response.result {
        
            case .success:
                
                if let result = try! response.result.get() as? [String: Any] {
                    
                    print(result)
                    
                    let userID = result["user_id"] as? String
                    let userName = result["user_name"] as? String

                    
                    print(userID)
                    print(userName)
                }
                
            case .failure(let error):
                print(error)
                return
                
                
            }
        }


    }
    
    
    @objc func pressedAddMenuButton() {
        /// 메뉴 개수 제한하는 로직 필요 -> 무분별한 메뉴 추가 방지 // 최대 3개? 4개? 백엔드랑 상의해보기
        
        if viewModel.menu.count >= 5 {
            menuInputTextField.text?.removeAll()
            let alert = AlertManager.createAlertMessage(("메뉴는 최대 5개 입력 가능"), "메뉴는 최대 5개까지만 입력이 가능합니다.")
            self.present(alert, animated: true)
            return
        }
        if let nameOfMenu = menuInputTextField.text {

            if nameOfMenu.count == 0 {
                
                let alert = AlertManager.createAlertMessage("드신 메뉴를 입력해주세요.", "빈 칸으로 놔두는건 안 돼요~")
                self.present(alert, animated: true)
                return
            }
            
            viewModel.addNewMenu(name: nameOfMenu)
            menuInputTableView.insertRows(at: [IndexPath(row: viewModel.menu.count - 1, section: 0)],
                                          with: .bottom)
            self.viewWillLayoutSubviews()
            menuInputTextField.text?.removeAll()
    
        }
    }
    
    
    


}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.userSelectedImages.count + 1     /// Add Button 이 항상 있어야하므로 + 1
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
        
        /// 그 외의 셀은 사용자가 고른 사진  Cell
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFoodImageCellIdentifier, for: indexPath) as? UserPickedFoodImageCollectionViewCell else {
                fatalError("Failed to dequeue cell for UserPickedFoodImageCollectionViewCell")
            }
            
            cell.delegate = self
            cell.indexPath = indexPath.item
            
            // 사용자가 앨범에서 고른 사진이 있는 경우
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

        let indexToDelete = IndexPath.init(row: index, section: 0)
        reviewImageCollectionView.deleteItems(at: [indexToDelete])
        viewModel.userSelectedImages.remove(at: indexToDelete.item - 1)
        
        reviewImageCollectionView.reloadData()
        viewWillLayoutSubviews()
    }
}

//MARK: - NewMenuTableViewCellDelegate

extension NewReviewViewController: NewMenuTableViewCellDelegate {
   
    // 이미 추가한 메뉴의 이름을 변경했을 때 실행되는 함수
    func didChangeMenuName() {
        //
    }
    
    func didPressDeleteMenuButton(at index: Int) {
        
        let indexToDelete = IndexPath.init(row: index, section: 0)
        viewModel.menu.remove(at: indexToDelete.row)
        menuInputTableView.deleteRows(at: [indexToDelete], with: .left)
    
        menuInputTableView.reloadData()
        viewWillLayoutSubviews()
    }
    
    func didPressEitherGoodOrBadButton(at index: Int, is good: Bool) {
        //
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension NewReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.newMenuTableViewCell, for: indexPath) as? NewMenuTableViewCell else {
            fatalError("Failed to dequeue cell for NewMenuTableViewCell")
        }
        
        if self.viewModel.menu.count != 0 {
            
            let menuInfo = viewModel.menu[indexPath.row]
            
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

//MARK: - UITextViewDelegate

extension NewReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "방문하셨던 맛집에 대한 솔직한 리뷰를 남겨주세요!"
            textView.textColor = UIColor.lightGray
        }
    }
}


//MARK: - UI Configuration

extension NewReviewViewController {
    
    func initialize() {
        
        initializeTextField()
        initializeCollectionView()
        initializeTableView()
        initializeTextView()
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
        reviewTextView.text = "방문하셨던 맛집에 대한 솔직한 리뷰를 남겨주세요!"
        reviewTextView.textColor = UIColor.lightGray
        
        reviewTextView.layer.cornerRadius = 14.0
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    func initializeTextField() {
        
        menuInputTextField.layer.cornerRadius = menuInputTextField.frame.height / 2
        menuInputTextField.clipsToBounds = true
        menuInputTextField.layer.borderWidth = 1
        menuInputTextField.layer.borderColor = UIColor.black.cgColor
        
        menuInputTextField.leftView = UIView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: 10,
                                                           height: 0))
        menuInputTextField.leftViewMode = .always
            
        let addMenuButton = UIButton(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 25,
                                                   height: 25))
        
        addMenuButton.setImage(UIImage(named: "plus button"),
                               for: .normal)
        addMenuButton.isUserInteractionEnabled = true
        addMenuButton.contentMode = .scaleAspectFit
        addMenuButton.addTarget(self,
                                action: #selector(pressedAddMenuButton),
                                for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: 30,
                                             height: 25))
        rightView.addSubview(addMenuButton)
        menuInputTextField.rightView = rightView
        menuInputTextField.rightViewMode = .always
    }
    
}
