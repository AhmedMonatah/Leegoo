
import UIKit

class HomeCell: UICollectionViewCell {
    static let identifier = "HomeCell"
        
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!
    
    func configure(with item: Sport) {
        sportImage.image = UIImage(named: item.imageName)
        sportImage.contentMode = .scaleAspectFill
        sportImage.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        sportTitle.text = item.title
    }
       
}
