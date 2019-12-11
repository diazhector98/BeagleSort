//
//  HighscoresViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

class HighscoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var highscores = [UserModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.fetchHighscores();
    }
    

    private func fetchHighscores() -> Void {
        let databaseRef = Database.database().reference();
        let usersRef = databaseRef.child("users");
        usersRef.observe(.value, with: { (snapshot) in
            let data = (snapshot.value as? NSDictionary)!;
            
            for (_, value) in data {
                let dict = (value as? NSDictionary)!;
                self.highscores.append(UserModel(name: (dict["username"] as! String).components(separatedBy: "@")[0], won: dict["won"] as! Int, lost: dict["lost"] as! Int));
                self.highscores = self.highscores.sorted(by: {$0.won > $1.won})
                self.tableView.reloadData();
            }
        }) { (err) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highscores.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highscoreCell") as! HighscoreTableViewCell;
        let user = self.highscores[indexPath.row];
        
        cell.lblName.text = user.name;
        cell.lblWon.text = "W: \(String(user.won))";
        cell.lblLost.text = "L: \(String(user.lost))";
        
        return cell;
    }

}
