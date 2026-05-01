//
//  SquadViewController.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//


import UIKit

final class SquadViewController: UIViewController {


    @IBOutlet weak var teamLogoView: UIView!
    @IBOutlet weak var teamInitialsLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!

    @IBOutlet weak var totalPlayersLabel: UILabel!
    @IBOutlet weak var goalkeepersCountLabel: UILabel!
    @IBOutlet weak var defendersCountLabel: UILabel!

    // MARK: - IBOutlets — Filter Buttons

    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterGKButton: UIButton!
    @IBOutlet weak var filterDefButton: UIButton!
    @IBOutlet weak var filterMidButton: UIButton!
    @IBOutlet weak var filterFwdButton: UIButton!



    @IBOutlet weak var tableView: UITableView!

  

    private var allPlayers: [Player] = []
    private var filteredPlayers: [Player] = []
    private var activeFilter: FilterTab = .all
    private var expandedSections: Set<Int> = [0, 1, 2, 3]

    /// Ordered position sections to display
    private var activeSections: [PlayerPosition] = PlayerPosition.allCases

    // MARK: - Computed helpers

    private var sections: [PlayerPosition] {
        switch activeFilter {
        case .all:          return PlayerPosition.allCases
        case .goalkeepers:  return [.goalkeeper]
        case .defenders:    return [.defender]
        case .midfielders:  return [.midfielder]
        case .forwards:     return [.forward]
        }
    }

    private func players(for position: PlayerPosition) -> [Player] {
        filteredPlayers.filter { $0.position == position }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupTeamHeader()
        setupFilterButtons()
        setupTableView()
        loadData()
    }

    // MARK: - Setup

    private func setupTeamHeader() {
        teamNameLabel.text = SquadData.teamName
        teamIDLabel.text   = SquadData.teamID

        teamLogoView.layer.cornerRadius = teamLogoView.frame.height / 2
        teamLogoView.backgroundColor = .white
        teamLogoView.layer.shadowColor   = UIColor.black.cgColor
        teamLogoView.layer.shadowOpacity = 0.08
        teamLogoView.layer.shadowRadius  = 8
        teamLogoView.layer.shadowOffset  = CGSize(width: 0, height: 2)

        teamInitialsLabel.text      = "JJ"
        teamInitialsLabel.font      = UIFont.systemFont(ofSize: 32, weight: .heavy)
        teamInitialsLabel.textColor = .black

        teamNameLabel.font  = UIFont.systemFont(ofSize: 24, weight: .bold)
        teamNameLabel.textColor = .black
        teamIDLabel.font    = UIFont.systemFont(ofSize: 13, weight: .regular)
        teamIDLabel.textColor = .systemGray
    }

    private func setupFilterButtons() {
        let buttons = [filterAllButton, filterGKButton, filterDefButton,
                       filterMidButton, filterFwdButton]
        let titles  = ["All", "Goalkeepers", "Defenders", "Midfielders", "Forwards"]

        for (i, btn) in buttons.enumerated() {
            guard let btn = btn else { continue }
            btn.setTitle(titles[i], for: .normal)
            btn.tag = i
            btn.layer.cornerRadius = 18
            btn.clipsToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            btn.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
        applyFilterStyle()
    }

    private func applyFilterStyle() {
        let buttons = [filterAllButton, filterGKButton, filterDefButton,
                       filterMidButton, filterFwdButton]
        let accent  = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)

        for btn in buttons {
            guard let btn = btn else { continue }
            let isActive = btn.tag == activeFilter.rawValue
            btn.backgroundColor = isActive ? accent : .white
            btn.setTitleColor(isActive ? .white : UIColor.darkGray, for: .normal)
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle  = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        // No need to register nibs; they are defined as prototype cells in Teams.storyboard
    }

    // MARK: - Data

    private func loadData() {
        allPlayers = SquadData.generatePlayers()
        applyFilter()
        updateStatCards()
    }

    private func applyFilter() {
        switch activeFilter {
        case .all:          filteredPlayers = allPlayers
        case .goalkeepers:  filteredPlayers = allPlayers.filter { $0.position == .goalkeeper }
        case .defenders:    filteredPlayers = allPlayers.filter { $0.position == .defender }
        case .midfielders:  filteredPlayers = allPlayers.filter { $0.position == .midfielder }
        case .forwards:     filteredPlayers = allPlayers.filter { $0.position == .forward }
        }
        // Reset expand state when filter changes
        expandedSections = Set(0..<sections.count)
        tableView.reloadData()
    }

    private func updateStatCards() {
        totalPlayersLabel.text   = "\(allPlayers.count)"
        goalkeepersCountLabel.text = "\(allPlayers.filter { $0.position == .goalkeeper }.count)"
        defendersCountLabel.text   = "\(allPlayers.filter { $0.position == .defender }.count)"
    }

    // MARK: - Actions

    @IBAction func filterTapped(_ sender: UIButton) {
        guard let tab = FilterTab(rawValue: sender.tag) else { return }
        activeFilter = tab
        applyFilterStyle()

        // Regenerate random data on each filter tap
        allPlayers = SquadData.generatePlayers()
        applyFilter()
        updateStatCards()
    }

    @IBAction func refreshTapped(_ sender: UIButton) {
        allPlayers = SquadData.generatePlayers()
        applyFilter()
        updateStatCards()
    }
}

// MARK: - UITableViewDataSource

extension SquadViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard expandedSections.contains(section) else { return 0 }
        return players(for: sections[section]).count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerCell.reuseID, for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }
        let player = players(for: sections[indexPath.section])[indexPath.row]
        cell.configure(with: player)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SquadViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: SectionHeaderView.reuseID) as? SectionHeaderView else { return nil }
        let pos = sections[section]
        header.configure(position: pos,
                         count: players(for: pos).count,
                         isExpanded: expandedSections.contains(section))
        header.section  = section
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat { 52 }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat { 0.01 }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let player = players(for: sections[indexPath.section])[indexPath.row]
        showPlayerAlert(player)
    }
}

// MARK: - SectionHeaderDelegate

extension SquadViewController: SectionHeaderDelegate {
    func sectionHeader(_ header: SectionHeaderView, didToggleSection section: Int) {
        let pos   = sections[section]
        let count = players(for: pos).count
        let indexPaths = (0..<count).map { IndexPath(row: $0, section: section) }

        tableView.beginUpdates()
        if expandedSections.contains(section) {
            expandedSections.remove(section)
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            expandedSections.insert(section)
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        tableView.endUpdates()

        // Refresh header chevron
        if let h = tableView.headerView(forSection: section) as? SectionHeaderView {
            h.configure(position: pos, count: count,
                        isExpanded: expandedSections.contains(section))
        }
    }
}

// MARK: - Detail Alert

private extension SquadViewController {
    func showPlayerAlert(_ player: Player) {
        let rating = player.rating.map { String(format: "%.2f", $0) } ?? "N/A"
        let mp     = player.matchesPlayed.map { "\($0)" } ?? "N/A"
        let stat   = player.statValue.map { "\($0)" } ?? "N/A"

        let msg = """
        #\(player.number) · \(player.position.rawValue)
        Age: \(player.age)
        \(player.statLabel): \(stat) · MP: \(mp)
        Rating: \(rating)
        """
        let alert = UIAlertController(title: player.name, message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }
}
