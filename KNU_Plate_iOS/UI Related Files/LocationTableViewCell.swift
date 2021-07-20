import UIKit
import SnapKit

class LocationTableViewCell: UITableViewCell {
    
    let mapView = MTMapView()
    let poiItem = MTMapPOIItem()
    
    let addressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("👌 LocationTableViewCell - init")
        
        mapView.baseMapType = .standard
        
        self.addSubview(mapView)
        self.addSubview(addressLabel)
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(250).priority(.low)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
