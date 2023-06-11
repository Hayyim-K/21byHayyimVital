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
            image.layer.cornerRadius = image.bounds.height / 33
            }
        }
    }
