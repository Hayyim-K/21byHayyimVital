//
//  Models.swift
//  21byHayyimVital
//
//  Created by vitasiy on 08.05.2023.
//

import Foundation

struct Player {
    var name: String
    var score: Int
    var currentHand: [Card]
    var countOfWins: Int
}

enum Suits: String, CaseIterable {
    case heart = "♥️"
    case spade = "♠️"
    case diamond = "♦️"
    case club = "♣️"
}

struct Card: Equatable {
    let suit: String
    let value: Int
    var image = ""
}

extension Card {
    static func getCardDeck() -> [Card] {
        var cardDeck: [Card] = []
        
        for card in 2...11 {
            if card != 5 {
                
                for suit in Suits.allCases {
                    cardDeck.append(Card.init(suit: suit.rawValue, value: card, image: "\(card)\(suit.rawValue)"))
                }
                
//                cardDeck.append(Card.init(suit: Suits.club.rawValue, value: card, image: "\(card)\(Suits.club.rawValue)"))
//                cardDeck.append(Card.init(suit: Suits.diamond.rawValue, value: card, image: "\(card)\(Suits.diamond.rawValue)"))
//                cardDeck.append(Card.init(suit: Suits.heart.rawValue, value: card, image: "\(card)\(Suits.heart.rawValue)"))
//                cardDeck.append(Card.init(suit: Suits.spade.rawValue, value: card, image: "\(card)\(Suits.spade.rawValue)"))
            }
        }
        
        return cardDeck.shuffled()
    }
}
