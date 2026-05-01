//
//  PlayerCell.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//



import UIKit

final class PlayerCell: UITableViewCell {

    static let reuseID = "PlayerCell"

  

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var initialsLabel: UILabel!
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
    }

    // MARK: - Configure

    func configure(with player: Player) {
        // Initials placeholder
        let parts = player.name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        initialsLabel.text = initials
        avatarView.backgroundColor = player.placeholderColor

        // Number
        numberLabel.text = "\(player.number)"

        // Name / age
        nameLabel.text = player.name
        ageLabel.text  = "Age \(player.age)"

        // Badges
        captainBadge.isHidden = !player.isCaptain
        injuredBadge.isHidden = !player.isInjured

        // Stats
        statTitleLabel.text = player.statLabel

        if let mp = player.matchesPlayed {
            mpValueLabel.text   = "\(mp)"
            statValueLabel.text = player.statValue.map { "\($0)" } ?? "-"
            ratingValueLabel.text = player.rating.map { String(format: "%.2f", $0) } ?? "-"
            ratingValueLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        } else {
            mpValueLabel.text     = "-"
            statValueLabel.text   = "-"
            ratingValueLabel.text = "-"
            ratingValueLabel.textColor = .systemGray
        }
    }
}
