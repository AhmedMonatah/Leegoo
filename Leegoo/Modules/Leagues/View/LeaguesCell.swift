//
//  LeaguesCell.swift
//  Leegoo
//
//  Created by TaqieAllah on 30/04/2026.
//

import UIKit
import SDWebImage

class LeaguesCell: UITableViewCell {

    @IBOutlet weak var leagueLogo: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        applyTheme()
        leagueLogo.clipsToBounds = true
        leagueLogo.contentMode = .scaleAspectFit    }
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        leagueName?.textColor = ThemeManager.shared.textColor
        arrowImageView?.tintColor = ThemeManager.shared.accentColor
        contentView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leagueLogo.layer.cornerRadius = leagueLogo.frame.width / 2
    }
    
    func configure(with league: League) {
        applyTheme()
        leagueName.text = league.leagueName
        
        if let logoString = league.leagueLogo,
        let url = URL(string: logoString) {
            leagueLogo.sd_setImage(with: url, placeholderImage: UIImage(named: "SplashIcon"))
        } else {
            leagueLogo.image = UIImage(named: "SplashIcon")
        }
    }

}
