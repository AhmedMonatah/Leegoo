import UIKit
import SDWebImage

class LatestEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    func configure(with event: Event) {
        homeTeamLabel.text = event.eventHomeTeam ?? "Home"
        awayTeamLabel.text = event.eventAwayTeam  ?? "Away"
        scoreLabel.text = event.eventFinalResult?.isEmpty == false ? event.eventFinalResult : "0 - 0"
        homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )

        awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )
        setupInfoLabel(event: event)
    }

    
    private func setupInfoLabel(event: Event) {
        let dateText = formatDate(event.eventDate)
        let timeText = formatTime(event.eventTime)
        let info = NSMutableAttributedString()
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]
        
        if let calImg = UIImage(systemName: "calendar")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal) {
            let a = NSTextAttachment(); a.image = calImg
            a.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            info.append(NSAttributedString(attachment: a))
            info.append(NSAttributedString(string: " "))
        }
        info.append(NSAttributedString(string: dateText + "   ", attributes: attrs))
        
        if let clkImg = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal) {
            let a = NSTextAttachment(); a.image = clkImg
            a.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            info.append(NSAttributedString(attachment: a))
            info.append(NSAttributedString(string: " "))
        }
        info.append(NSAttributedString(string: timeText, attributes: attrs))
        infoLabel.attributedText = info
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
