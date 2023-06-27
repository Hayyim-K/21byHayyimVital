//
//  CollectionViewCell.swift
//  21byHayyimVital
//
//  Created by vitasiy on 08.05.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: CardImageView! {
        didSet {
            image.bounds.size.height = 216
            image.bounds.size.width = 170.8775877587759
            image.layer.cornerRadius = image.bounds.height / 33
            }
        }
    
    
    }
