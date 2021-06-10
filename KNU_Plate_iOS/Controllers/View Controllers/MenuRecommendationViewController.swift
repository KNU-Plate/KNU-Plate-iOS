import UIKit

class MenuRecommendationViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
       
        
    }
    

}

//MARK: - UI Configuration

extension MenuRecommendationViewController {
    
    func initialize() {
        
        initializeTableView()
    }
    
    func initializeTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

//MARK: - UITableViewDataSource

extension MenuRecommendationViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.menuRecommendCell, for: indexPath) as? MenuRecommendationTableViewCell else {
            fatalError()
        }
        
        cell.menuLabel.text = "샌드위치"
        
        cell.initialize()
  

        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
