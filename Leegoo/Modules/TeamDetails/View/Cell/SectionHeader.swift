//
//  SectionHeader.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//


import UIKit

final class SectionHeaderView: UITableViewCell {

    static let reuseID = "SectionHeaderView"

    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(position: PlayerPosition, count: Int) {
        titleLabel.text = position.rawValue
        countLabel.text  = "\(count)"
    }
}
