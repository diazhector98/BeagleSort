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
    @IBOutlet weak var lbEstado: UILabel!
    
    // Variables para control de movimientos
    var frames = [CGPoint]()
    var storedFrames = [CGPoint]()
    var storedTags = [1, 2, 3, 4, 5, 6, 7]
    var currentState = ArrayState(array: [0, 1, 2, 3, 4, 5, 6])
    var states = [ArrayState]()
    var stateIndex = 1
    var firstTouched = -1
    
    // Colores para feedback
    let correctColor = UIColor(red: 39.0/255, green: 161.0/255, blue: 59.0/255, alpha: 1)
    let wrongColor = UIColor(red: 255.0/255, green: 78.0/255, blue: 72.0/255, alpha: 1)
    let selectedColor = UIColor(red: 91.0/255, green: 132.0/255, blue: 255, alpha: 1)
    let defaultColor = UIColor.lightGray
    
    // Variables de segue
    var array : [Int]!
    var algorithm: Algorithm!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbEstado.textColor = correctColor
        
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
        storedFrames = frames
        
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
    
    func verifyState () {
        print(currentState.array)
        print(states[stateIndex].array)
        if (currentState.compareWith(other: states[stateIndex])) {
            if (stateIndex+1 == states.count) {
                lbEstado.text = "Terminaste!"
            } else {
                lbEstado.text = "Correcto"
                stateIndex += 1
            }
            lbEstado.textColor = correctColor
            
            // Guardar informacion de estado actual
            storedFrames[0] = button0.frame.origin
            storedFrames[1] = button1.frame.origin
            storedFrames[2] = button2.frame.origin
            storedFrames[3] = button3.frame.origin
            storedFrames[4] = button4.frame.origin
            storedFrames[5] = button5.frame.origin
            storedFrames[6] = button6.frame.origin
            for i in 0...storedFrames.count-1 {
                frames[i].x += 15
                frames[i].y += 15
            }
            
            storedTags[0] = button0.tag
            storedTags[1] = button1.tag
            storedTags[2] = button2.tag
            storedTags[3] = button3.tag
            storedTags[4] = button4.tag
            storedTags[5] = button5.tag
            storedTags[6] = button6.tag
        } else {
            lbEstado.text = "Incorrecto"
            lbEstado.textColor = wrongColor
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
            verifyState()
            
            // Resettear valores
            firstTouched = -1
            firstButton.backgroundColor = defaultColor
        } else {
            firstTouched = sender.tag
            sender.backgroundColor = selectedColor
        }
    }
    
    
    @IBAction func undo(_ sender: UIButton) {
        // Cargar ultimo estado correcto
        currentState.array = states[stateIndex-1].array
        button0.frame.origin = storedFrames[0]
        button0.tag = storedTags[0]
        button1.frame.origin = storedFrames[1]
        button1.tag = storedTags[1]
        button2.frame.origin = storedFrames[2]
        button2.tag = storedTags[2]
        button3.frame.origin = storedFrames[3]
        button3.tag = storedTags[3]
        button4.frame.origin = storedFrames[4]
        button4.tag = storedTags[4]
        button5.frame.origin = storedFrames[5]
        button5.tag = storedTags[5]
        button6.frame.origin = storedFrames[6]
        button6.tag = storedTags[6]
        
        lbEstado.text = "Correcto"
        lbEstado.textColor = correctColor
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
