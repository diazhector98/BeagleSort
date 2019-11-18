//
//  HighscoreTableViewCell.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

class HighscoreTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWon: UILabel!
    @IBOutlet weak var lblLost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (Auth.auth().currentUser!.email == self.lblName.text!) {
            self.lblName.font = UIFont.boldSystemFont(ofSize: 17);
        }
    }

}
