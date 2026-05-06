//
//  PlayerCell.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//



import UIKit
import SDWebImage

final class PlayerCell: UITableViewCell {

    static let reuseID = "PlayerCell"

  

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var numberBadge: UIView!
    @IBOutlet weak var numberLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var captainBadge: UIView!
    @IBOutlet weak var captainLabel: UILabel!
    @IBOutlet weak var injuredBadge: UIView!
    @IBOutlet weak var injuredLabel: UILabel!

    @IBOutlet weak var mpTitleLabel: UILabel!
    @IBOutlet weak var mpValueLabel: UILabel!

    @IBOutlet weak var statTitleLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!

    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        applyTheme()
    }
    
    func applyTheme() {
        nameLabel?.textColor = ThemeManager.shared.textColor
        ageLabel?.textColor = ThemeManager.shared.secondaryTextColor
        mpTitleLabel?.textColor = ThemeManager.shared.secondaryTextColor
        statTitleLabel?.textColor = ThemeManager.shared.secondaryTextColor
        ratingTitleLabel?.textColor = ThemeManager.shared.secondaryTextColor
        mpValueLabel?.textColor = ThemeManager.shared.textColor
        statValueLabel?.textColor = ThemeManager.shared.textColor
        ratingValueLabel?.textColor = ThemeManager.shared.textColor
        
        contentView.backgroundColor = ThemeManager.shared.isDarkTheme ? .clear : .white
        avatarView?.backgroundColor = ThemeManager.shared.isDarkTheme ? UIColor(white: 1.0, alpha: 0.1) : .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Circular styling
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        playerImageView.clipsToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .white
    }

    // MARK: - Configure

    func configure(with player: Player) {
        applyTheme()
        
        // Player Image
        playerImageView.sd_setImage(
            with: URL(string: player.imageURL),
            placeholderImage: UIImage(named: "PlayerPlacholder")
        )

        // Number
        numberLabel.text = player.number

        // Name / age
        nameLabel.text = player.name
        ageLabel.text  = "Age \(player.age)"

        // Badges
        captainBadge.isHidden = true
        injuredBadge.isHidden = true

        // Stats
        statTitleLabel.text = "Goals"
        mpValueLabel.text   = player.matches
        statValueLabel.text = player.goals
        
        ratingTitleLabel.text = "Cards (Y/R)"
        ratingValueLabel.text = "\(player.yellowCards)/\(player.redCards)"
    }
}
