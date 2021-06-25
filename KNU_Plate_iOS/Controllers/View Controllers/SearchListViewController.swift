import UIKit
import PanModal

protocol SearchListDelegate {
    
    func didChoosePlace(index: Int)
}

class SearchListViewController: UITableViewController {

    @IBOutlet var searchResultTableView: UITableView!
    
    var placeName: [String] = [String]()
    var address: [String] = [String]()
    
    var delegate: SearchListDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
  
    }
    
    
}

//MARK: - SearchListViewController

extension SearchListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeName.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = Constants.CellIdentifier.searchedRestaurantResultCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            fatalError()
        }
        
        /// 검색된 결과가 있을 경우
        if placeName.count != 0 {
            
            cell.textLabel?.text = placeName[indexPath.row]
            cell.detailTextLabel?.text = address[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.didChoosePlace(index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
        return
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension SearchListViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return searchResultTableView
    }
}
