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
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var leagueName: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leagueLogo.clipsToBounds = true
        leagueLogo.contentMode = .scaleAspectFit    }
    
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

    @IBAction func favButtonTapped(_ sender: Any) {
    }
}
