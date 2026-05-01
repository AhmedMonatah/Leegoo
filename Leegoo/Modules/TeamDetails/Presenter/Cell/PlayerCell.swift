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
        setupStyles()
    }

    private func setupStyles() {
        // Avatar circle
        avatarView.layer.cornerRadius = 28
        avatarView.clipsToBounds = true

        initialsLabel.textColor = .white
        initialsLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)

        // Number badge
        numberBadge.layer.cornerRadius = 13
        numberBadge.backgroundColor = .black
        numberLabel.textColor = .white
        numberLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)

        // Name
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = UIColor(named: "PrimaryText") ?? .black

        // Age
        ageLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        ageLabel.textColor = .systemGray

        // Captain badge
        captainBadge.layer.cornerRadius = 9
        captainBadge.backgroundColor = UIColor(red: 0.38, green: 0.36, blue: 0.87, alpha: 1)
        captainLabel.textColor = .white
        captainLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        captainLabel.text = "C"

        // Injured badge
        injuredBadge.layer.cornerRadius = 9
        injuredBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        injuredLabel.textColor = .systemRed
        injuredLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        injuredLabel.text = "⚕ Injured"

        // Stat labels (titles)
        for lbl in [mpTitleLabel, statTitleLabel, ratingTitleLabel] {
            lbl?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            lbl?.textColor = .systemGray
        }
        mpTitleLabel.text = "MP"

        // Stat values
        for lbl in [mpValueLabel, statValueLabel] {
            lbl?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            lbl?.textColor = UIColor(named: "PrimaryText") ?? .black
        }

        ratingValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        ratingValueLabel.textColor = UIColor(red: 0.38, green: 0.36, blue: 0.87, alpha: 1)
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
            ratingValueLabel.textColor = UIColor(red: 0.38, green: 0.36, blue: 0.87, alpha: 1)
        } else {
            mpValueLabel.text     = "-"
            statValueLabel.text   = "-"
            ratingValueLabel.text = "-"
            ratingValueLabel.textColor = .systemGray
        }
    }
}
