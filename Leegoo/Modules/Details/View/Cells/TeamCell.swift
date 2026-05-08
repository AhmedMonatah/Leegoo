import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        teamNameLabel.theme_textColor = AppTheme.textColor
        teamImageView.theme_tintColor = AppTheme.secondaryTextColor
        
        contentView.clearBackgroundsRecursively()
        isSkeletonable = true
        contentView.isSkeletonable = false
        SkeletonHelper.enable([teamImageView])
        SkeletonHelper.styleLabels([teamNameLabel], height: 15)
    }
    
    func configure(with team: Team) {
        teamNameLabel.text = team.teamName ?? "Team"
        teamImageView.sd_setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )
    }
}
