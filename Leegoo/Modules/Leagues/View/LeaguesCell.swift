//
//  LeaguesCell.swift
//  Leegoo
//
//  Created by TaqieAllah on 30/04/2026.
//

import UIKit
import SDWebImage
import SwiftTheme

class LeaguesCell: UITableViewCell {

    @IBOutlet weak var leagueLogo: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        leagueName.theme_textColor = AppTheme.textColor
        arrowImageView.theme_tintColor = AppTheme.accentColor
        leagueLogo.clipsToBounds = true
        leagueLogo.contentMode = .scaleAspectFit
        selectionStyle = .none
        
        // Clear storyboard-baked backgrounds recursively
        contentView.clearBackgroundsRecursively()
        
        // Ensure all components are skeletonable
        isSkeletonable = true
        contentView.isSkeletonable = false
        SkeletonHelper.enable([leagueLogo])
        SkeletonHelper.styleLabels([leagueName], height: 15)
        arrowImageView.isSkeletonable = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leagueLogo.layer.cornerRadius = leagueLogo.frame.width / 2
    }
    
    func configure(with league: League) {
        leagueName.text = league.leagueName
        
        if let logoString = league.leagueLogo,
        let url = URL(string: logoString) {
            leagueLogo.sd_setImage(with: url, placeholderImage: UIImage(named: "SplashIcon"))
        } else {
            leagueLogo.image = UIImage(named: "SplashIcon")
        }
    }

}
