//
//  LobbyViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase
import SocketIO

class LobbyViewController: UIViewController {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnLeaderboard: UIButton!
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress]);
    
    private var socket: SocketIOClient!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StylesHelper.addButtonStyles(button: self.btnSearch);
        StylesHelper.addButtonStyles(button: self.btnLeaderboard);
        self.btnSearch.setTitleColor(UIColor(named: "Disabled"), for: .disabled);
        
        // init socket
        self.socket = manager.defaultSocket;
        createSocketHandlers();
        self.socket.connect();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true);
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }
    
    private func createSocketHandlers() {
        self.socket.on(clientEvent: .connect) { (data, ack) in
            self.lblStatus.text = "Conectado al servidor.";
            self.lblStatus.textColor = UIColor(red: 39.0/255, green: 161.0/255, blue: 59.0/255, alpha: 1);
            self.btnSearch.isEnabled = true;
        }
        
        self.socket.on(clientEvent: .error) { (data, ack) in
            self.lblStatus.text = "No se pudo conectar al servidor.";
            self.lblStatus.textColor = .red;
            self.btnSearch.setTitle("Buscar partida", for: .disabled);
            self.btnSearch.isEnabled = false;
        }
        
        self.socket.on(clientEvent: .reconnectAttempt) { (data, ack) in
            self.lblStatus.text = "Conectando con el servidor...";
            self.lblStatus.textColor = .black;
        }
        
        self.socket.on("waiting_queue") { (data, ack) in
            self.btnSearch.setTitle("Buscando otros jugadores...", for: .disabled);
            self.btnSearch.isEnabled = false;
        }
        
        self.socket.on("entered_game") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let otherPlayer = dict["otherPlayerName"] as! String;
            let algorithm = dict["algorithm"] as! String;
            let arr = (dict["arr"] as! NSArray as? [Int])!;
            
            self.performSegue(withIdentifier: "enterGame", sender: [otherPlayer, algorithm, arr]);
        }
    }

    @IBAction func onSearchPress(_ sender: Any) {
        self.socket.emit("enter_game_queue", Auth.auth().currentUser!.email!, Auth.auth().currentUser!.uid);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "enterGame") {
//            let vc = segue.destination as! GameViewController;
//            let data = sender as! NSArray;
//            vc.otherPlayerName = (data[0] as! String);
//            vc.algorithm = (data[1] as! String);
//            vc.arr = data[2] as! [Int];
//            vc.socket = self.socket;
//        }
    }
}
