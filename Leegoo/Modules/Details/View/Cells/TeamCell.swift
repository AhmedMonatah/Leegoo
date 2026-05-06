import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        applyTheme()
    }
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        teamNameLabel?.textColor = ThemeManager.shared.textColor
        teamImageView?.tintColor = isDark ? .white : .systemGray
        contentView.backgroundColor = .clear
    }
    
    func configure(with team: Team) {
        applyTheme()
        teamNameLabel.text = team.teamName ?? "Team"
        teamImageView.sd_setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )
    }
}
