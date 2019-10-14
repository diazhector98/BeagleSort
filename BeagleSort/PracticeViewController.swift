//
//  PracticeViewController.swift
//  BeagleSort
//
//  Created by Pedro Villezca on 10/13/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController {
    // Outlets
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var buttonHolder: UIView!
    
    // Variables para control de movimientos
    var frames = [CGPoint]()
    var currentState = ArrayState(array: [0, 1, 2, 3, 4, 5, 6])
    var states = [ArrayState]()
    var stateIndex = 0
    var firstTouched = -1
    
    // Colores para feedback
    let correctColor = UIColor(red: 120.0/255, green: 255.0/255, blue: 131.0/255, alpha: 1)
    let wrongColor = UIColor(red: 255.0/255, green: 78.0/255, blue: 72.0/255, alpha: 1)
    let selectedColor = UIColor(red: 91.0/255, green: 132.0/255, blue: 255, alpha: 1)
    let defaultColor = UIColor.lightGray
    
    // Variables de segue
    var array : [Int]!
    var algorithm: Algorithm!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asignar valores a botones
        button0.setTitle("\(array[0])", for: .normal)
        button1.setTitle("\(array[1])", for: .normal)
        button2.setTitle("\(array[2])", for: .normal)
        button3.setTitle("\(array[3])", for: .normal)
        button4.setTitle("\(array[4])", for: .normal)
        button5.setTitle("\(array[5])", for: .normal)
        button6.setTitle("\(array[6])", for: .normal)
        
        // Formar arreglo de frames
        frames.append(button0.frame.origin)
        frames.append(button1.frame.origin)
        frames.append(button2.frame.origin)
        frames.append(button3.frame.origin)
        frames.append(button4.frame.origin)
        frames.append(button5.frame.origin)
        frames.append(button6.frame.origin)
        for i in 0...frames.count-1 {
            frames[i].x += 15
            frames[i].y += 15
        }
        
        // Formar arreglo de estados
        createStates()
    }
    
    func createStates() {
        let algorithmName = algorithm.name
        switch(algorithmName) {
        case "BubbleSort":
            bubbleSortStates()
        case .none:
            print("What")
        case .some(_):
            print("What")
        }
    }
    
    // Crea ArrayStates para Bubble Sort 
    func bubbleSortStates() {
        var changed = true
        var limit = array.count-2
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        while (changed && limit > 0) {
            changed = false
            for i in 0...limit {
                if (array[i] > array[i+1]) {
                    let temp = array[i]
                    array[i] = array[i+1]
                    array[i+1] = temp
                    let temp2 = order[i]
                    order[i] = order[i+1]
                    order[i+1] = temp2
                    states.append(ArrayState(array: order))
                    changed = true
                }
            }
            limit -= 1
        }
    }
    
    
    @IBAction func touched(_ sender: UIButton) {
        if (firstTouched == sender.tag) {
            firstTouched = -1
            sender.backgroundColor = defaultColor
        } else if (firstTouched != -1) {
            let firstButton = buttonHolder.viewWithTag(firstTouched) as! UIButton
            // Usa tags para actualizar el estado
            let tempState = currentState.array[firstButton.tag-1]
            currentState.array[firstButton.tag-1] = currentState.array[sender.tag-1]
            currentState.array[sender.tag-1] = tempState
            
            // Intercambia tags
            let tempTag = firstButton.tag
            firstButton.tag = sender.tag
            sender.tag = tempTag
            
            // Usa nuevas tags para actualizar posiciones con animacion
            UIView.animate(withDuration: 0.5, animations: {
                firstButton.frame.origin = self.frames[firstButton.tag-1]
                sender.frame.origin = self.frames[sender.tag-1]
            })
            
            // Verificar si el cambio resulta en un estado correcto
            
            // Resettear valores
            firstTouched = -1
            firstButton.backgroundColor = defaultColor
        } else {
            firstTouched = sender.tag
            sender.backgroundColor = selectedColor
        }
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
