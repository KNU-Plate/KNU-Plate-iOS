
import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let reviewNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        let cellID = "reviewTableViewCell"
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)


    }
    

}


extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array = ["괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요"]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as? ReviewTableViewCell else {
            fatalError("Failed to dequeue cell for NewMenuTableViewCell")
        }
        
        cell.reviewImageView.image = UIImage(named: "test1")!
        
        cell.reviewLabel.text = array[indexPath.row]
        

        return cell
    }
    
    
}
