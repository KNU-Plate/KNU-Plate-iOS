
import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let reviewNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        let cellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutImageNib = UINib(nibName: "ReviewWithoutImageTableViewCell", bundle: nil)
        let cellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: cellID2)
        
        
    }
    
    let array = ["괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요"]
    
}


extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        if indexPath.row < 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else {
                fatalError("Failed to dequeue cell for ReviewTableViewCell")
            }
            cell.reviewImageView.image = UIImage(named: "test1")!
            cell.reviewLabel.text = array[indexPath.row]
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else {
                fatalError("Failed to dequeue cell for ReviewWithoutImageTableViewCell")
            }
            cell.reviewLabel.text = "시험시험시험"
            return cell
        }

        
 
    }
    
    
}
