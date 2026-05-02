import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func configure(with team: Team) {
        teamNameLabel.text = team.teamName?.components(separatedBy: " ").first ?? "Team"
        teamImageView.sd_setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )
    }
}
