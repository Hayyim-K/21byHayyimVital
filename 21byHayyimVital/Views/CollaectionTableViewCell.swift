//
//  CollectionTableViewCell.swift
//  21byHayyimVital
//
//  Created by vitasiy on 08.05.2023.
//

import UIKit


class CollectionTableViewCell: UITableViewCell {

    // - MARK: - Outlets
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playersHandLabel: UILabel!
    
    // - MARK: - Properties
    var playersHand: [Card]!
    var computersSecondCardChecker: Int!
    
    // - MARK: - Override funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// - MARK: - Collection View Data Source
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playersHand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        
        if collectionView.tag == 0 && indexPath.row == 1 && computersSecondCardChecker > 0  {
            cell.image.image = UIImage(named: "back")
        } else {
            cell.image.fatchImage(from: playersHand[indexPath.row].image)
        }
        
        return cell
    }
}

