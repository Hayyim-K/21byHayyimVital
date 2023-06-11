//
//  PresentViewController.swift
//  21byHayyimVital
//
//  Created by vitasiy on 10.05.2023.
//

import UIKit

class PresentViewController: UIViewController {
    
    // - MARK: - Outlets
    @IBOutlet weak var presentView: UIView!
    @IBOutlet weak var numberOfPlayersSlider: UISlider!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet var namesOfPlayersTextFields: [UITextField]!
    
    // - MARK: - Properties
    var delegate: PresentViewControllerDelegate!
    private var numbersOfPlayers = 1
    
    // - MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // - MARK: - Private Funcs
    private func setUp() {
        presentView.layer.cornerRadius = presentView.frame.height/22
        numberOfPlayersSlider.value = 1
        numberOfPlayersLabel.text = "\(Int(numberOfPlayersSlider.value))"
        hideAndShowTextFiedls(textFields: namesOfPlayersTextFields, numOfPlayers: numbersOfPlayers)
        
    }
    
    private func hideAndShowTextFiedls(textFields: [UITextField], numOfPlayers: Int) {
        textFields.forEach({$0.isHidden = true})
        for i in 0..<numOfPlayers {
            textFields[i].isHidden = false
        }
    }
    
    private func checkNames(of  players: [Player]) -> [Player] {
        var updatePlayers = players
        for i in 0..<updatePlayers.count {
            if updatePlayers[i].name == "🤖" {
                updatePlayers[i].name += " \(i)"
            }
            let k = i + 1
            for j in k..<updatePlayers.count {
                if k < updatePlayers.count {
                    if updatePlayers[i].name == updatePlayers[j].name {
                        updatePlayers[j].name += " \(i)"
                    }
                }
            }
        }
        return updatePlayers
    }
   
    // - MARK: - IBActions
    @IBAction func numberOfPlayersSliderValueHasChanged(_ sender: Any) {
        numberOfPlayersSlider.value = roundf(numberOfPlayersSlider.value)
        numbersOfPlayers = Int(numberOfPlayersSlider.value)
        numberOfPlayersLabel.text = "\(numbersOfPlayers)"
        hideAndShowTextFiedls(textFields: namesOfPlayersTextFields, numOfPlayers: numbersOfPlayers)
    }
    
    @IBAction func rulesButtonHasPressed(_ sender: Any) {
        let rules = "21 is played at a table of 2-7 players and uses one 36-card deck. All number cards (6-10) score the value indicated on them. The face cards (Jack, Queen, King) score 2, 3, 4 points respectively and Ace is treated as 11. At the beginning of each round all players are dealt two cards face-up in front of their respective positions. The Computer receives two cards, one face-up and another face-down. Starting to the left of the Computer, each player is given a chance to draw more cards. The players can either ‘hit’ or ‘stand’. If the player calls out ‘HIT’, they are given an extra card. They can then either call out ‘HIT’ again, or ‘STAND’ if they do not wish to draw any more cards. The player can ‘HIT’ as many times as they wish, but have to aim not to ‘BUST’ (exceed a total of 21). If the player BUSTS, they immediately lose. After each player has played and either stood or busted, the Computer takes their turn. If the Computers’s hand exceeds 21, he loses. All players who didn't BUST check their points: That plyer who has more points (<= 21) gets one winning point. If the player has Double Aces at the bigining, he get 3 winning points.\nSummation:\nBUST - you lose\nJust your score - won nothing lost nothing\nWIN - you won. Get +1 point\n2xAce - you get +3 points. Rare luck!"
        showAlert(title: "RULES", message: rules)
    }
    
    @IBAction func startButtonHasPressed(_ sender: Any) {
        var players = [Player]()
        for name in namesOfPlayersTextFields {
            if let playersName = name.text {
                players.append(Player(name: playersName, score: 0, currentHand: [], countOfWins: 0))
            }
        }
        for index in 0..<numbersOfPlayers {
            if players[index].name == "" {
                players[index].name = "Player \(index + 1)"
            }
        }
        players.removeLast(players.count - numbersOfPlayers)
        
        let names = players.map({ $0.name }).sorted()
        let namesSet = Set(names).sorted()
        if names != namesSet || names.contains(where: {$0 == "🤖"}) {
            showSameNameAlert(
                title: "ATTENTION",
                message: "Player names must not match!",
                players: players)
        } else {
            let updatePlayers = checkNames(of: players)
            delegate.startTheGame(with: updatePlayers)
            dismiss(animated: true)
        }
    }
    
}

// - MARK: - Text Field Delegate
extension PresentViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Alert Controller
extension PresentViewController {
    private func showAlert(title: String,
                           message: String,
                           textField: UITextField? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = nil
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showSameNameAlert(title: String,
                                   message: String,
                                   players: [Player]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Don't care", style: .default) { _ in
            let updatePlayers = self.checkNames(of: players)
            self.delegate.startTheGame(with: updatePlayers)
            self.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "Change", style: .cancel) { _ in
            return
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}
