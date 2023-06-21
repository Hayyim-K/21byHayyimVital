//
//  GameOverViewController.swift
//  21byHayyimVital
//
//  Created by vitasiy on 18.05.2023.
//

import UIKit

class GameOverViewController: UIViewController {
    
    // - MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    // - MARK: - Properties
    var players: [Player]!
    var delegate: GameOverViewControllerDelegate!
    
    private var sortedPlayers = [Player]()
    
    // - MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        UISelectionFeedbackGenerator().selectionChanged()
        shadowSort()
        tableView.delegate = self
        tableView.dataSource = self
        mainView.layer.cornerRadius = mainView.frame.height/22
        
    }
    
    // - MARK: - Private funcs
    private func set(_ label: UILabel, by index: Int) {
        switch sortedPlayers[index].score {
        case 22...:
            if playerIsWinner(sortedPlayers[index]) {
                label.text = "🍀(+3)"
            } else {
                label.text = "👎(-1)"
            }
        case 21:
            label.text = "👍(+1)"
        default:
            label.text = "\(sortedPlayers[index].score)"
        }
    }
    
    private func playerIsWinner(_ player: Player) -> Bool {
        player.currentHand.count == 2 &&
        player.currentHand[0].value == 11 &&
        player.currentHand[1].value == 11
    }
    
    private func synchronizer(_ player: Player, add points: Int) {
        let winnersName = player.name
        if let winnersIndex = players.firstIndex(where: {$0.name == winnersName}) {
            players[winnersIndex].countOfWins += points
        }
    }
    
    private func shadowSort() {
        var i = 0
        sortedPlayers = players
        sortedPlayers.sort(by: { $0.score > $1.score })
        for index in 0..<sortedPlayers.count {
            if sortedPlayers[index].score <= 21 || playerIsWinner(sortedPlayers[index]) {
                if playerIsWinner(sortedPlayers[index]) {
                    sortedPlayers[index].countOfWins += 3
                    synchronizer(sortedPlayers[index], add: 3)
                } else {
                    if i == 0 {
                        sortedPlayers[index].countOfWins += 1
                        synchronizer(sortedPlayers[index], add: 1)
                        i += 1
                    } else if i == 1 {
                        if sortedPlayers[index].score == sortedPlayers[index - 1].score {
                            sortedPlayers[index].countOfWins += 1
                            synchronizer(sortedPlayers[index], add: 1)
                        } else {
                            i += 1
                        }
                    }
                }
            } else {
                sortedPlayers[index].countOfWins -= 1
                synchronizer(sortedPlayers[index], add: -1)
            }
        }
        sortedPlayers.sort(by: {$0.countOfWins > $1.countOfWins})
    }
    
    // - MARK: - IBActions
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        for index in 0..<players.count {
            players[index].currentHand = []
            players[index].score = 0
        }
        let cardDeck = Card.getCardDeck()
        delegate.playAgain(with: players, and: cardDeck)
        dismiss(animated: true)
    }
    
    @IBAction func quitButtonPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        exit(0)
    }
}

// - MARK: - Extensions

// - MARK: - TableView Data Source
extension GameOverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedPlayers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: tableView.frame.width,
                    height: 17
                )
            )
        )
        let label = UILabel(frame: headerView.bounds)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Name: /Current Result: /Total:"
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EndTableViewCell
        let player = sortedPlayers[indexPath.row]
        set(cell.scoreLabel, by: indexPath.row)
        cell.playerNameLabel.text = player.name
        cell.countOfWinsLabel.text = "\(player.countOfWins)"
        return cell
    }
}
