import UIKit
import PanModal

protocol SearchListDelegate {
    
    func didChoosePlace(index: Int)
}

class SearchListViewController: UITableViewController {

    @IBOutlet var searchResultTableView: UITableView!
    
    var placeName: [String] = [String]()
    var address: [String] = [String]()
    var searchResultCount: Int = 0
    
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
        
        if placeName.count > 0 {
            return placeName.count
        } else {
            return 1
        }
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
        
        else {
            cell.textLabel?.text = "검색 결과가 없습니다.🤔"
            cell.detailTextLabel?.text = "경북대학교 주변에 있는 매장이 맞는지 확인해주세요."
            tableView.tableFooterView = UIView(frame: .zero)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchResultCount == 0 {
            return
        }
        
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
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(50)
    }
}
