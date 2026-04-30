import UIKit

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func configure(with team: Team) {
        teamNameLabel.text = team.strTeam?.components(separatedBy: " ").first ?? "Team"
        teamImageView.image = UIImage(systemName: "person.crop.circle")
        teamNameLabel.backgroundColor = .clear
    }
}
