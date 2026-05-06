
import UIKit

class HomeCell: UICollectionViewCell {
    static let identifier = "HomeCell"
        
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    func configure(with item: Sport) {

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        sportImage.contentMode = .scaleAspectFill
        sportImage.clipsToBounds = true
        sportImage.image = UIImage(named: item.imageName)
        sportTitle.text = item.title
        sportTitle.textColor = .white
        sportTitle.tag = 1001
    }

}
