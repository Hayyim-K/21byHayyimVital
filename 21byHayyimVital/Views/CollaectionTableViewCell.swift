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
    var keys: [String : URL]!
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
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playersHand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170.8775877587759, height: 216)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        
        
        
        if collectionView.tag == 0 && indexPath.row == 1 && computersSecondCardChecker > 0  {
            cell.image.image = UIImage(named: "back")
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
            let url = keys[playersHand[indexPath.row].image]
            if let url = url {
                cell.image.image = cell.image.getCachedImage(from: url)
            } else {
                cell.image.image = UIImage(named: playersHand[indexPath.row].image)
            }
        }
        return cell
    }
}

