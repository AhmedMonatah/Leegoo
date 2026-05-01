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

    

    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterGKButton: UIButton!
    @IBOutlet weak var filterDefButton: UIButton!
    @IBOutlet weak var filterMidButton: UIButton!
    @IBOutlet weak var filterFwdButton: UIButton!



    @IBOutlet weak var tableView: UITableView!

  

    private var allPlayers: [Player] = []
    private var filteredPlayers: [Player] = []
    private var activeFilter: FilterTab = .all


    private var activeSections: [PlayerPosition] = PlayerPosition.allCases



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



    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNameLabel.text = SquadData.teamName
        teamIDLabel.text   = SquadData.teamID
        teamInitialsLabel.text = "JJ"
        
        setupTableView()
        loadData()
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

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        
    }

  

    private func loadData() {
        allPlayers = SquadData.generatePlayers()
        applyFilter()
        applyFilterStyle()
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
        tableView.reloadData()
    }

    private func updateStatCards() {
        totalPlayersLabel.text   = "\(allPlayers.count)"
        goalkeepersCountLabel.text = "\(allPlayers.filter { $0.position == .goalkeeper }.count)"
        defendersCountLabel.text   = "\(allPlayers.filter { $0.position == .defender }.count)"
    }

    

    @IBAction func filterTapped(_ sender: UIButton) {
        guard let tab = FilterTab(rawValue: sender.tag) else { return }
        activeFilter = tab
        applyFilterStyle()

        applyFilter()
        updateStatCards()
    }

    @IBAction func refreshTapped(_ sender: UIButton) {
        allPlayers = SquadData.generatePlayers()
        applyFilter()
        updateStatCards()
    }
}


extension SquadViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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


extension SquadViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: SectionHeaderView.reuseID) as? SectionHeaderView else { return nil }
        let pos = sections[section]
        header.configure(position: pos,
                         count: players(for: pos).count)
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
    }
}




