//
//  GameViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import SocketIO
import Firebase

class GameViewController: UIViewController {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPlayer1: UILabel!
    @IBOutlet weak var player1Holder: UIView!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPlayer2: UILabel!
    @IBOutlet weak var player2Holder: UIView!
    @IBOutlet weak var lblAlgorithm: UILabel!
    
    // segue variables
    public var otherPlayerName: String!;
    public var algorithm: String!;
    public var arr = [Int]();
    public var socket: SocketIOClient!;
    
    // Colores para feedback
    let correctColor = UIColor(red: 39.0/255, green: 161.0/255, blue: 59.0/255, alpha: 1)
    let wrongColor = UIColor(red: 255.0/255, green: 78.0/255, blue: 72.0/255, alpha: 1)
    let selectedColor = UIColor(red: 91.0/255, green: 132.0/255, blue: 255, alpha: 1)
    let defaultColor = UIColor.white
    
    // instance variables
    private var user: User!;
    private var player1Buttons = [UIButton]();
    private var player1Dictionary: [Int: UIButton]!;
    private var player1StackView: UIStackView!;
    private var firstTouched = -1;
    
    private var player2Buttons = [UIButton]();
    private var player2Dictionary: [Int: UIButton]!;
    private var player2StackView: UIStackView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set data
        self.user = Auth.auth().currentUser!;
        self.lblPlayer1.text = self.user.email!;
        self.lblPlayer2.text = self.otherPlayerName;
        self.lblAlgorithm.text = self.algorithm;
        
        createSocketHandlers();
        
        // player 1 views
        player1Buttons = generateButtons(arr: arr);
        player1StackView = UIStackView(arrangedSubviews: player1Buttons);
        
        player1StackView.axis = .horizontal;
        player1StackView.distribution = .fillEqually;
        player1StackView.alignment = .center;
        player1StackView.spacing = 10;
        player1StackView.translatesAutoresizingMaskIntoConstraints = false;
        
        player1Holder.addSubview(player1StackView);
        
        // stack constraints
        let viewsDictionary = ["stackView":player1StackView];
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[stackView]-16-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        );
        
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[stackView]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        );
        
        player1Holder.addConstraints(stackView_H);
        player1Holder.addConstraints(stackView_V);
        
        for button in player1Buttons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true;
        }
        
        // player 2 views
        player2Buttons = generateButtons2(arr: arr);
        player2StackView = UIStackView(arrangedSubviews: player2Buttons);
        
        player2StackView.axis = .horizontal;
        player2StackView.distribution = .fillEqually;
        player2StackView.alignment = .center;
        player2StackView.spacing = 10;
        player2StackView.translatesAutoresizingMaskIntoConstraints = false;
        
        player2Holder.addSubview(player2StackView);
        
        // stack constraints
        let viewsDictionary2 = ["stackView":player2StackView];
        let stackView_H2 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[stackView]-16-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary2
        );
        
        let stackView_V2 = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[stackView]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary2
        );
        
        player2Holder.addConstraints(stackView_H2);
        player2Holder.addConstraints(stackView_V2);
        
        for button in player2Buttons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true);
    }

    private func generateButtons(arr: [Int]) -> [UIButton] {
        player1Dictionary = [:];
        var views: [UIButton] = [];
        var index = 0;
        for i in arr {
            let button = UIButton();
            button.setTitle(String(i), for: .normal);
            button.setTitleColor(.black, for: .normal);
            button.backgroundColor = defaultColor;
            button.tag = index + 1;
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside);
            StylesHelper.addNodeStyles(node: button);

            player1Buttons.append(button);
            views.append(button);
            player1Dictionary[index] = button;
            
            index += 1;
        }
        
        return views;
    }
    
    private func generateButtons2(arr: [Int]) -> [UIButton] {
        player2Dictionary = [:];
        var views: [UIButton] = [];
        var index = 0;
        for i in arr {
            let button = UIButton();
            button.setTitle(String(i), for: .normal);
            button.setTitleColor(.black, for: .normal);
            button.backgroundColor = defaultColor;
            button.tag = index + 1;
            button.isEnabled = false;
            StylesHelper.addNodeStyles(node: button);
            
            player2Buttons.append(button);
            views.append(button);
            player2Dictionary[index] = button;
            
            index += 1;
        }
        
        return views;
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if (firstTouched == sender.tag) {
            firstTouched = -1;
            sender.backgroundColor = defaultColor;
        } else if (firstTouched != -1) {
            let firstButton = player1StackView.viewWithTag(firstTouched) as! UIButton;
            let indexA = firstButton.tag - 1;
            let indexB = sender.tag - 1;
            
            // hacer hidden las views que se van a mover
            let originalViewA = player1Dictionary[indexA];
            let originalViewB = player1Dictionary[indexB];
            originalViewA!.alpha = 0;
            originalViewB!.alpha = 0;
            
            // obtener los frames de esos elementos
            let frameA: CGRect = player1Buttons[indexA].frame;
            let frameB: CGRect = player1Buttons[indexB].frame;
            
            // crear buttons con esos frames
            let buttonA = UIButton(frame: frameA);
            let buttonB = UIButton(frame: frameB);
            
            // poner valores a botones nuevos
            buttonA.setTitle(String(originalViewA!.titleLabel!.text!), for: .normal);
            buttonA.setTitleColor(.black, for: .normal);
            buttonA.backgroundColor = defaultColor;
            buttonA.tag = originalViewA!.tag;
            buttonA.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside);
            
            buttonB.setTitle(String(originalViewB!.titleLabel!.text!), for: .normal);
            buttonB.setTitleColor(.black, for: .normal);
            buttonB.backgroundColor = defaultColor;
            buttonB.tag = originalViewB!.tag;
            buttonB.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside);
            
            // styles
            StylesHelper.addNodeStyles(node: buttonA);
            StylesHelper.addNodeStyles(node: buttonB);
            
            // agregar a stackview
            player1StackView.addSubview(buttonA);
            player1StackView.addSubview(buttonB);
            
            // intercambia tags
            let tempTag = buttonA.tag;
            buttonA.tag = buttonB.tag;
            buttonB.tag = tempTag;
            
            // updatear diccionario de views
            player1Dictionary[indexA] = buttonB;
            player1Dictionary[indexB] = buttonA;
            
            // animar
            UIView.animate(withDuration: 0.5, animations: {
                let tempFrame = buttonA.frame.origin;
                buttonA.frame.origin = buttonB.frame.origin;
                buttonB.frame.origin = tempFrame;
            });
            
            // resetear valores
            firstTouched = -1;
            firstButton.backgroundColor = defaultColor;
            
            // send packet
            let fromIndex = indexA;
            let toIndex = indexB;
            self.socket.emit("player_move", fromIndex, toIndex);
        } else {
            firstTouched = sender.tag;
            sender.backgroundColor = selectedColor;
        }
    }
    
    private func createSocketHandlers() {
        // listen for when server determines if move was correct or not
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
        
        // listen for when other player makes a move so we can animate
        self.socket.on("other_player_move") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let indexA = dict["fromIndex"] as! Int;
            let indexB = dict["toIndex"] as! Int;

            // hacer hidden las views que se van a mover
            let originalViewA = self.player2Dictionary[indexA];
            let originalViewB = self.player2Dictionary[indexB];
            originalViewA!.alpha = 0;
            originalViewB!.alpha = 0;
            
            // obtener los frames de esos elementos
            let frameA: CGRect = self.player2Buttons[indexA].frame;
            let frameB: CGRect = self.player2Buttons[indexB].frame;
            
            // crear buttons con esos frames
            let buttonA = UIButton(frame: frameA);
            let buttonB = UIButton(frame: frameB);
            
            // poner valores a botones nuevos
            buttonA.setTitle(String(originalViewA!.titleLabel!.text!), for: .normal);
            buttonA.setTitleColor(.black, for: .normal);
            buttonA.backgroundColor = self.defaultColor;
            buttonA.tag = originalViewA!.tag;
            buttonA.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside);
            
            buttonB.setTitle(String(originalViewB!.titleLabel!.text!), for: .normal);
            buttonB.setTitleColor(.black, for: .normal);
            buttonB.backgroundColor = self.defaultColor;
            buttonB.tag = originalViewB!.tag;
            buttonB.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside);
            
            // styles
            StylesHelper.addNodeStyles(node: buttonA);
            StylesHelper.addNodeStyles(node: buttonB);
            
            // agregar a stackview
            self.player2StackView.addSubview(buttonA);
            self.player2StackView.addSubview(buttonB);
            
            // intercambia tags
            let tempTag = buttonA.tag;
            buttonA.tag = buttonB.tag;
            buttonB.tag = tempTag;
            
            // updatear diccionario de views
            self.player2Dictionary[indexA] = buttonB;
            self.player2Dictionary[indexB] = buttonA;
            
            // animar
            UIView.animate(withDuration: 0.5, animations: {
                let tempFrame = buttonA.frame.origin;
                buttonA.frame.origin = buttonB.frame.origin;
                buttonB.frame.origin = tempFrame;
            });
        }
        
        // listen for when the game has ended
        self.socket.on("game_ended") { (data, ack) in
            let dict = (data[0] as? NSDictionary)!;
            let won = dict["won"] as! Bool;
            
            if (won) {
                self.lblStatus.text = "Has ganado!!!";
                self.lblStatus.textColor = self.correctColor;
            } else {
                self.lblStatus.text = "Has perdido.";
                self.lblStatus.textColor = self.wrongColor;
            }
            self.lblStatus.isHidden = false;
            
            // disable buttons
            for i in 0...6 {
                self.player1Dictionary[i]!.isEnabled = false;
            }
            
            // allow player to go back
            if (self.navigationController != nil) {
               self.navigationController!.setNavigationBarHidden(false, animated: true);
            }
        }
    }
}
