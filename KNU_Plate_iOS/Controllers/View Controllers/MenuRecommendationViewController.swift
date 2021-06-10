import UIKit
import SnackBar_swift

class MenuRecommendationViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel = MenuListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: 아래 숫자 수정 필요
        viewModel.fetchMenuList(of: 2)
    }
    

}

//MARK: - UI Configuration

extension MenuRecommendationViewController {
    
    func initialize() {
        
        initializeViewModel()
        initializeTableView()
    }
    
    func initializeViewModel() {
        
        viewModel.delegate = self
    }
    
    func initializeTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
}

extension MenuRecommendationViewController: MenuListViewModelDelegate {
    
    func didFetchMenuList() {
        
        print("MenuRecommendVC - didFetchMenuList SUCCESS")
        tableView.reloadData()
    }
    
    func failedFetchingMenuList(with error: NetworkError) {
        print("MenuRecommendVC - failedFetchingMenuList")
        SnackBar.make(in: self.view,
                      message: error.errorDescription,
                      duration: .lengthLong).show()
    }
}

//MARK: - UITableViewDataSource

extension MenuRecommendationViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.menuRecommendCell, for: indexPath) as? MenuRecommendationTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModel.menuList[indexPath.row])
        
        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
