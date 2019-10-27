//
//  GameViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 10/26/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import SocketIO
import Firebase

class GameViewController: UIViewController {
    @IBOutlet weak var player1Holder: UIView!
    @IBOutlet weak var player2Holder: UIView!
    @IBOutlet weak var lblPlayer1: UILabel!
    @IBOutlet weak var lblPlayer2: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    // instance variables
    private var user: User!;
    private var player1Frames = [CGPoint]();
    private var player2Frames = [CGPoint]();
    private var firstTouched = -1;
    
    // segue variables
    public var otherPlayerName: String!;
    public var algorithm: String!;
    public var arr = [Int]();
    public var socket: SocketIOClient!;
    
    // Colores para feedback
    let correctColor = UIColor(red: 39.0/255, green: 161.0/255, blue: 59.0/255, alpha: 1)
    let wrongColor = UIColor(red: 255.0/255, green: 78.0/255, blue: 72.0/255, alpha: 1)
    let selectedColor = UIColor(red: 91.0/255, green: 132.0/255, blue: 255, alpha: 1)
    let defaultColor = UIColor.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = Auth.auth().currentUser!;
        self.lblPlayer1.text = self.user.email!;
        self.lblPlayer2.text = self.otherPlayerName;
        createSocketHandlers();
        
        // create buttons
        let fullWidth = self.player1Holder.frame.size.width;
        let buttonWidth = fullWidth / 7.0;
        for i in 0...6 {
            let button = UIButton(type: .system);
            button.frame = CGRect(x: 4 + CGFloat(i) * buttonWidth, y: 0, width: buttonWidth - 8, height: buttonWidth);
            button.setTitle(String(self.arr[i]), for: .normal);
            button.setTitleColor(.black, for: .normal);
            button.backgroundColor = defaultColor;
            button.tag = i + 1;
            button.addTarget(self, action: #selector(buttonPress(sender:)), for: .touchUpInside);
            self.player1Frames.append(button.frame.origin);
            self.player1Holder.addSubview(button);
        }
        
        // create other player numbers
        for i in 0...6 {
            let button = UIButton(type: .system);
            button.frame = CGRect(x: 4 + CGFloat(i) * buttonWidth, y: 0, width: buttonWidth - 8, height: buttonWidth);
            button.setTitle(String(self.arr[i]), for: .normal);
            button.setTitleColor(.black, for: .normal);
            button.backgroundColor = defaultColor;
            button.tag = i + 1;
            button.isEnabled = false;
            button.action
            self.player2Frames.append(button.frame.origin);
            self.player2Holder.addSubview(button);
        }
    }
    
    private func createSocketHandlers() {
        self.socket.on("player_move_response") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let res = dict["res"] as! String;
            
            if (res == "Incorrecto") {
                self.lblStatus.text = res;
                self.lblStatus.textColor = self.wrongColor;
                self.lblStatus.isHidden = false;
            } else if (res == "Correcto") {
                self.lblStatus.isHidden = true;
            }
        }
        
        self.socket.on("other_player_move") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let fromIndex = dict["fromIndex"] as! Int;
            let toIndex = dict["toIndex"] as! Int;
            
            // get buttons
            let firstButton = self.player2Holder.viewWithTag(fromIndex + 1) as! UIButton;
            let secondButton = self.player2Holder.viewWithTag(toIndex + 1) as! UIButton;
            
            // swap
            let tempTag = firstButton.tag;
            firstButton.tag = secondButton.tag;
            secondButton.tag = tempTag;
            
            // animate
            UIView.animate(withDuration: 0.5, animations: {
                firstButton.frame.origin = self.player2Frames[toIndex];
                secondButton.frame.origin = self.player2Frames[fromIndex];
            })
            
        }
    }
    
    @objc func buttonPress(sender: UIButton!) {
        if (firstTouched == sender.tag) {
            firstTouched = -1;
            sender.backgroundColor = defaultColor;
        } else if (firstTouched != -1) {
            let firstButton = self.player1Holder.viewWithTag(firstTouched) as! UIButton;
            let fromIndex = firstButton.tag - 1;
            let toIndex = sender.tag - 1;
            
            // swap
            let tempTag = firstButton.tag;
            firstButton.tag = sender.tag;
            sender.tag = tempTag;
            
            // animate swap
            UIView.animate(withDuration: 0.5, animations: {
                firstButton.frame.origin = self.player1Frames[toIndex];
                sender.frame.origin = self.player1Frames[fromIndex];
            })
            
            // reset values
            firstTouched = -1;
            firstButton.backgroundColor = defaultColor;
            
            // send packet
            self.socket.emit("player_move", fromIndex, toIndex);
        } else {
            firstTouched = sender.tag;
            sender.backgroundColor = selectedColor;
        }
    }
}
