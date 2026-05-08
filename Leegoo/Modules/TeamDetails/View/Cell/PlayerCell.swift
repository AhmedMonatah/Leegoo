//
//  PlayerCell.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//



import UIKit
import SDWebImage
import SwiftTheme

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


    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = false
        
        SkeletonHelper.enable([avatarView, playerImageView])
        SkeletonHelper.styleLabels([nameLabel, ageLabel, mpTitleLabel, mpValueLabel, statTitleLabel, statValueLabel, ratingTitleLabel, ratingValueLabel], height: 15)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clearBackgroundsRecursively()
        setupStaticStyles()
        setupThemePickers()
    }
    
    private func setupStaticStyles() {
        numberLabel.textColor = .black
        numberLabel.theme_textColor = nil
        numberBadge.backgroundColor = .white
        numberBadge.isSkeletonable = false
    }
    
    private func setupThemePickers() {
        nameLabel.theme_textColor = AppTheme.textColor
        ageLabel.theme_textColor = AppTheme.secondaryTextColor
        mpTitleLabel.theme_textColor = AppTheme.secondaryTextColor
        statTitleLabel.theme_textColor = AppTheme.secondaryTextColor
        ratingTitleLabel.theme_textColor = AppTheme.secondaryTextColor
        mpValueLabel.theme_textColor = AppTheme.textColor
        statValueLabel.theme_textColor = AppTheme.textColor
        ratingValueLabel.theme_textColor = AppTheme.textColor
        
        contentView.theme_backgroundColor = AppTheme.glassBackgroundColor
        avatarView.theme_backgroundColor = AppTheme.glassBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        playerImageView.clipsToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .clear
        
        numberBadge.layer.cornerRadius = numberBadge.frame.height / 2
        numberBadge.clipsToBounds = true
    }


    func configure(with vm: PlayerCellViewModel) {
        
    
        playerImageView.sd_setImage(
            with: URL(string: vm.imageURL),
            placeholderImage: UIImage(named: "PlayerPlacholder")
        )
        numberLabel.text = vm.number
        nameLabel.text = vm.name
        ageLabel.text  = vm.ageText
        captainBadge.isHidden = true
        injuredBadge.isHidden = true
        statTitleLabel.text = "Goals"
        mpValueLabel.text   = vm.matches
        statValueLabel.text = vm.goals
        ratingTitleLabel.text = "Cards (Y/R)"
        ratingValueLabel.text = vm.cards
    }
}
