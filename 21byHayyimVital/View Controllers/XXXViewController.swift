//
//  XXXViewController.swift
//  21byHayyimVital
//
//  Created by vitasiy on 03.06.2023.
//

import UIKit

class XXXViewController: UIViewController {

    @IBOutlet weak var label: CardImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set()
        
    }
    
    
    private func set() {
        
        label.fatchImage(from: "11♠️")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
