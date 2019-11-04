//
//  LobbyViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 10/25/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase
import SocketIO

class LobbyViewController: UIViewController {

    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress]);
    
    private var socket: SocketIOClient!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = manager.defaultSocket;
        self.socket.connect();
        createSocketHandlers();
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }
    
    private func createSocketHandlers() {
        self.socket.on("waiting_queue") { (data, ack) in
            self.showAlert("In queue");
        }
        
        self.socket.on("entered_game") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let otherPlayer = dict["otherPlayerName"] as! String;
            let algorithm = dict["algorithm"] as! String;
            let arr = (dict["arr"] as! NSArray as? [Int])!;
            
            self.performSegue(withIdentifier: "enterGame", sender: [otherPlayer, algorithm, arr]);
        }
    }
    
    @IBAction func onBuscarPress(_ sender: Any) {
        self.socket.emit("enter_game_queue", Auth.auth().currentUser!.email!, Auth.auth().currentUser!.uid);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "enterGame") {
            let vc = segue.destination as! GameViewController;
            let data = sender as! NSArray;
            vc.otherPlayerName = (data[0] as! String);
            vc.algorithm = (data[1] as! String);
            vc.arr = data[2] as! [Int];
            vc.socket = self.socket;
            }
    }
}
