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
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            //                  - Animation:
//            cell.image.alpha = 0
//            let originCoordinateX = cell.image.frame.origin.x
//            let originCoordinateY = cell.image.frame.origin.y
//            cell.image.frame.origin.x += 100
//            cell.image.frame.origin.y += 200
//            UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseInOut, animations: {
//                cell.image.frame.origin.x = originCoordinateX
//                cell.image.frame.origin.y = originCoordinateY
//                cell.image.alpha = 1
//            })
            
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

