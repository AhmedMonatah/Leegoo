import UIKit
import SDWebImage

class UpcomingEventCell: UICollectionViewCell {
    
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with event: Event) {
        matchLabel.text = "\(event.eventHomeTeam ?? "Home") vs \(event.eventAwayTeam ?? "Away")"
        homeTeamLabel.text = event.eventHomeTeam?.components(separatedBy: " ").first ?? "Home"
        awayTeamLabel.text = event.eventAwayTeam?.components(separatedBy: " ").first ?? "Away"
        dateLabel.text = event.eventDate != nil ? formatDate(event.eventDate) : "--"
        timeLabel.text = event.eventTime != nil ? formatTime(event.eventTime) : "--"
        
        homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )

        awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )
        
    }

    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "--" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        return outputFormatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String?) -> String {
        guard let timeString = timeString else { return "--" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var date = inputFormatter.date(from: timeString)
        if date == nil {
            inputFormatter.dateFormat = "HH:mm"
            date = inputFormatter.date(from: timeString)
        }
        
        guard let parsedDate = date else { return timeString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US")
        return outputFormatter.string(from: parsedDate)
    }
}
