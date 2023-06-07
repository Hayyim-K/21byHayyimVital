//
//  ViewController.swift
//  21byHayyimVital
//
//  Created by vitasiy on 08.05.2023.
//

import UIKit

// - MARK: - Protocols
protocol PresentViewControllerDelegate {
    func startTheGame(with players: [Player])
}

protocol GameOverViewControllerDelegate {
    func playAgain(with players: [Player], and cardDeck: [Card])
}

class ViewController: UIViewController, UICollectionViewDelegate {
    
    // - MARK: - Outlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enoughButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    // - MARK: - Private Properties
    private var cardDeck = Card.getCardDeck()
    private var players = [Player(name: "🤖", score: 0, currentHand: [], countOfWins: 0)]
    private var numberOfPlayers = 1
    private var round = 1
    
    // - MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        preparetion()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    // - MARK: - Private funcs
    private func preparetion() {
        for index in 0..<players.count {
            getCard(for: players[index].name)
            getCard(for: players[index].name)
        }
    }
    
    private func getCard(for playerName: String) {
        print(cardDeck.count)
        let card = cardDeck.randomElement()!
        removeFromDeck(card)
        for index in 0..<players.count {
            if players[index].name == playerName {
                players[index].currentHand.append(card)
                players[index].score += card.value
            }
        }
    }
    
    private func showAlert() {
        let presentVC = self.storyboard?.instantiateViewController(withIdentifier: "PresentViewController") as! PresentViewController
        presentVC.delegate = self
        presentVC.modalPresentationStyle = .overCurrentContext
        // следующие три строки кажется никак не влияют на итог... разобраться для чего они
        presentVC.providesPresentationContextTransitionStyle = true
        presentVC.definesPresentationContext = true
        presentVC.modalTransitionStyle = .crossDissolve
        present(presentVC, animated: true,  completion: nil)
    }
    
    private func showEndView() {
        let endVC = self.storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
        endVC.delegate = self
        endVC.modalPresentationStyle = .overCurrentContext
        // следующие три строки кажется никак не влияют на итог... разобраться для чего они
        endVC.providesPresentationContextTransitionStyle = true
        endVC.definesPresentationContext = true
        endVC.modalTransitionStyle = .crossDissolve
        endVC.players = players
        present(endVC, animated: true,  completion: nil)
    }
    
    private func setupData() {
        tableView.isHidden = false
        numberOfPlayers = players.count
        infoLabel.text = "\(players[1].name)'s turn"
        
        for index in 0..<players.count {
            if players[index].name != "🤖" {
                getCard(for: players[index].name)
                getCard(for: players[index].name)
            }
        }
        tableView.reloadData()
    }
    
    private func removeFromDeck(_ card: Card) {
        if let index = cardDeck.firstIndex(of: card) {
            cardDeck.remove(at: index)
        }
    }
    
    private func playersName() -> String {
        let player = players[round < numberOfPlayers ? round : 0]
        let result = "\(player.name)'s turn  (\(player.countOfWins))"
        tableView.reloadData()
        return result
    }
    
    private func switchScore(secondCheck: Bool) {
        switch players[round].score {
        case 0..<21:
            if !secondCheck {
                getCard(for: players[round].name)
                switchScore(secondCheck: true)
            }
            tableView.reloadData()
            
        case 21:
            round += 1
            infoLabel.text = playersName()
            tableView.reloadData()
        case 22:
            if players[round].currentHand.count == 2 {
                round += 1
                infoLabel.text = playersName()
                tableView.reloadData()
            } else {
                round += 1
                infoLabel.text = playersName()
                tableView.reloadData()
            }
        default:
            round += 1
            tableView.reloadData()
            infoLabel.text = playersName()
        }
    }
    
    // - MARK: - IBActions
    @IBAction func enoughButtonHasPressed() {
        round += 1
        infoLabel.text = playersName()
    }
    
    @IBAction func moreButtonHasPressed() {
        
        if round < numberOfPlayers {
            infoLabel.text = playersName()
            switchScore(secondCheck: false)
        } else {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            while players[0].score < 17 {
                getCard(for: "🤖")
                tableView.reloadData()
            }
            switch players[0].score {
            case 17...20:
                infoLabel.text = "🤖 has \(players[0].score)!"
                tableView.reloadData()
                showEndView()
                
            case 21:
                infoLabel.text = "🤖 WIN!"
                tableView.reloadData()
                showEndView()
                
            default:
                infoLabel.text = "🤖 BUST!"
                tableView.reloadData()
                showEndView()
                
            }
        }
    }
}


// - MARK: - Extensions

// - MARK: - TableView Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfPlayers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? CollectionTableViewCell else {
            fatalError()
        }
        
        if indexPath.row == round {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
        
        cell.collectionView.delegate = self
        cell.collectionView.reloadData()
        cell.collectionView.tag = indexPath.row
        cell.playerNameLabel.text = players[indexPath.row].name
        
        let hand = players[indexPath.row].currentHand
        
        if indexPath.row == 0 && round < players.count {
            cell.scoreLabel.text = "Score: ??"
            cell.playersHandLabel.text = "\(hand[0].image)"
        } else {
            cell.scoreLabel.text = "Score: \(players[indexPath.row].score)"
            cell.playersHandLabel.text = hand.map({$0.image}).joined(separator: ", ")
        }
        cell.playersHand = hand
        cell.computersSecondCardChecker = numberOfPlayers - round
        return cell
    }
}

// - MARK: - Delegates
extension ViewController: PresentViewControllerDelegate {
    func startTheGame(with players: [Player]) {
        self.players += players
        setupData()
    }
}

extension ViewController: GameOverViewControllerDelegate {
    func playAgain(with players: [Player], and cardDeck: [Card]) {
        self.cardDeck = cardDeck
        self.players = players
        round = 1
        getCard(for: "🤖")
        getCard(for: "🤖")
        setupData()
    }
}

