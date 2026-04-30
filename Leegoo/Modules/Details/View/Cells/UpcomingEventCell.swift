import UIKit

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
        matchLabel.text = event.strEvent ?? "Match Event"
        homeTeamLabel.text = event.strHomeTeam?.components(separatedBy: " ").first ?? "Home"
        awayTeamLabel.text = event.strAwayTeam?.components(separatedBy: " ").first ?? "Away"
        dateLabel.text = event.dateEvent != nil ? formatDate(event.dateEvent) : "24 May 2024"
        timeLabel.text = event.strTime != nil ? formatTime(event.strTime) : "00:00"
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
