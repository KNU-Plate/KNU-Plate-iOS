import UIKit
import Alamofire

class NewReviewViewController: UIViewController {
  
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    @IBOutlet weak var menuInputTextField: UITextField!
    @IBOutlet weak var menuInputTableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    private let viewModel: NewReviewViewModel = NewReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    
        testAlamofire()
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
 
        
//        curl -X 'POST' \
//          'http://52.253.91.116:4100/api/signup' \
//          -H 'accept: application/json' \
//          -H 'Content-Type: application/x-www-form-urlencoded' \
//          -d 'user_name=kevinkim&display_name=kevinkim&password=123456789&mail_address=kevinkim2586%40knu.ac.kr'
    }
    
    
    

    
    @objc func addMenuButtonPressed() {
        /// 메뉴 개수 제한하는 로직 필요 -> 무분별한 메뉴 추가 방지 // 최대 3개? 4개? 백엔드랑 상의해보기
    
        viewModel.addNewMenu()
        menuInputTableView.insertRows(at: [IndexPath(row: viewModel.menu.count - 1, section: 0)],
                                      with: .bottom)
        self.viewWillLayoutSubviews()
        
    }
    
    
    func initialize() {
        
        initializeView()
        initializeCollectionView()
        initializeTableView()
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
    
    func initializeView() {
        
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
                                action: #selector(addMenuButtonPressed),
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

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// need edit
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        /// need edit
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserPickedImageCollectionViewCell
        
        if indexPath.item == 0 {
            cell.userPickedImageView.image = UIImage(named: "add button")
            cell.cancelButtonImage.isHidden = true
        }
        else {
            cell.userPickedImageView.image = UIImage(named: "chinese food")
        }
        
        
        
        return cell
        
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
            
            //cell.delegate = self
            cell.menuNameTextField.text = ""
            cell.oneLineReviewForMenuTextField.text = ""
            
            
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = self.menuInputTableView.contentSize.height + 80
    }
    
    
    

}