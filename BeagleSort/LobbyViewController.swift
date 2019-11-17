//
//  LobbyViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnLeaderboard: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StylesHelper.addButtonStyles(button: self.btnSearch);
        StylesHelper.addButtonStyles(button: self.btnLeaderboard);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true);
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
