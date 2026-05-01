//
//  SectionHeader.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//


import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func sectionHeader(_ header: SectionHeaderView, didToggleSection section: Int)
}

final class SectionHeaderView: UITableViewCell {

    static let reuseID = "SectionHeaderView"

    weak var delegate: SectionHeaderDelegate?
    var section: Int = 0

    // MARK: - IBOutlets

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var chevronLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)

        titleLabel.font  = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black

        countLabel.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        countLabel.textColor = UIColor(red: 0.38, green: 0.36, blue: 0.87, alpha: 1)

        chevronLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        chevronLabel.textColor = .systemGray

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }

    func configure(position: PlayerPosition, count: Int, isExpanded: Bool) {
        switch position {
        case .goalkeeper: iconLabel.text = "🧤"; titleLabel.text = "Goalkeepers"
        case .defender:   iconLabel.text = "🛡"; titleLabel.text = "Defenders"
        case .midfielder: iconLabel.text = "⚽️"; titleLabel.text = "Midfielders"
        case .forward:    iconLabel.text = "🎯"; titleLabel.text = "Forwards"
        }
        countLabel.text  = "\(count)"
        chevronLabel.text = isExpanded ? "∧" : "∨"
    }

    @objc private func tapped() {
        delegate?.sectionHeader(self, didToggleSection: section)
    }
}
