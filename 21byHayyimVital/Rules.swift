//
//  Rules.swift
//  21byHayyimVital
//
//  Created by vitasiy on 12/07/2023.
//

import Foundation

public let rules = "21 is played at a table of 2-7 players and uses one 36-card deck.\nAll number cards (6-10) score the value indicated on them. The face cards (Jack, Queen, King) score 2, 3, 4 points respectively and Ace is treated as 11.\nAt the beginning of each round all players are dealt two cards face-up in front of their respective positions.\n🤖 receives two cards, one face-up and another face-down.\nStarting to the down of 🤖, each player is given a chance to draw more cards. The players can either ‘HIT’(🫴) or ‘STAND’(🫸). If the player calls out 🫴, they are given an extra card. They can then either call out 🫴 again, or 🫸 if they do not wish to draw any more cards. The player can 🫴 as many times as they wish, but have to aim not to 'BUST'(👎) (exceed a total of 21).\nIf the player 👎, they immediately lose.\nAfter each player has played and either 🫸 or 👎, 🤖 takes their turn. If the 🤖’s hand exceeds 21, he loses.\nAll players who didn't 👎 check their points:\nThat plyer who has more points (<= 21) gets one winning point.\nIf the player has Double Aces at the bigining, he get 3 winning points.\n\nSummation:\n👎 - you lose\nJust your score - won nothing lost nothing\n👍 - you won. Get +1 point\n🍀 - 2xAce, you get +3 points. Rare luck!\n\nT = 11 points\nJ = 2 points\nQ = 3 points\nK = 4 points\n10 = 10 points\n9 = 9 points\n8 = 8 points\n7 = 7 points\n6 = 6 points"
