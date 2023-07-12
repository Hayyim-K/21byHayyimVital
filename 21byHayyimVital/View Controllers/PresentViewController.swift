//
//  PresentViewController.swift
//  21byHayyimVital
//
//  Created by vitasiy on 10.05.2023.
//

import UIKit
import AudioToolbox

class PresentViewController: UIViewController {
    
    // - MARK: - Outlets
    @IBOutlet weak var presentView: UIView!
    @IBOutlet weak var numberOfPlayersSlider: UISlider!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet var namesOfPlayersTextFields: [UITextField]!
    @IBOutlet weak var rulseButton: UIButton!
    
    // - MARK: - Properties
    var delegate: PresentViewControllerDelegate!
    private var numbersOfPlayers = 1
    
    // - MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateThings()
        setUp()
    }
    
    // - MARK: - Private Funcs
    private func setUp() {
        presentView.layer.cornerRadius = presentView.frame.height/22
        pulsate(for: rulseButton)
        numberOfPlayersSlider.value = 1
        numberOfPlayersLabel.text = "\(Int(numberOfPlayersSlider.value))"
        hideAndShowTextFiedls(textFields: namesOfPlayersTextFields, numOfPlayers: numbersOfPlayers)
        
    }
    
    private func delegateThings() {
        for i in 0..<namesOfPlayersTextFields.count {
            namesOfPlayersTextFields[i].delegate = self
        }
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
        showAlert(title: "RULES", message: rules)
    }
    
    @IBAction func startButtonHasPressed(_ sender: Any) {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
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
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
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
