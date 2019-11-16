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
    @IBOutlet weak var buttonHolder: UIView!
    @IBOutlet weak var lbEstado: UILabel!
    @IBOutlet weak var buttonUndo: UIButton!
    
    // Variables para control de movimientos
    var frames = [CGPoint]()
    var storedFrames = [CGPoint]()
    var storedTags = [1, 2, 3, 4, 5, 6, 7]
    var currentState = ArrayState(array: [0, 1, 2, 3, 4, 5, 6])
    var states = [ArrayState]()
    var buttons = [UIButton]()
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
        // Hacer los botones desde cero
        let fullWidth = self.buttonHolder.frame.size.width
        let buttonWidth = fullWidth / 7.0
        for i in 0...6 {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 20 + CGFloat(i) * buttonWidth, y: 0, width: buttonWidth - 8, height: buttonWidth - 8)
            button.setTitle(String(self.array[i]), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = defaultColor
            button.tag = i + 1
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            frames.append(button.frame.origin)
            buttonHolder.addSubview(button)
            buttons.append(button)
            
        }
        storedFrames = frames
        StylesHelper.addButtonStyles(button: buttonUndo);
        
        // Formar arreglo de estados
        createStates()
    }
    
    func createStates() {
        let algorithmName = algorithm.name
        switch(algorithmName) {
        case "BubbleSort":
            bubbleSortStates()
        case "InsertionSort":
            insertionSortStates()
        case "SelectionSort":
            selectionSortStates()
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
    
    func insertionSortStates() {
        var curr = 1
        let n = array.count
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        while (curr < n) {
            var c = curr - 1
            while (c >= 0 && array[c] > array[c+1]) {
                let temp = array[c+1]
                array[c+1] = array[c]
                array[c] = temp
                let temp2 = order[c+1]
                order[c+1] = order[c]
                order[c] = temp2
                states.append(ArrayState(array: order))
                c -= 1
            }
            curr += 1
        }
    }
    
    func selectionSortStates() {
        let n = array.count;
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        for i in 0...n-1 {
            var minimum = i
            var j = i + 1
            while(j < n) {
                if (array[j] < array[minimum]) {
                    minimum = j
                }
                j += 1
            }
            if (minimum != i) {
                let temp = array[i]
                array[i] = array[minimum]
                array[minimum] = temp
                let temp2 = order[i]
                order[i] = order[minimum]
                order[minimum] = temp2
                states.append(ArrayState(array: order))
            }
        }
    }
    /*
     func initSelectionSort(){
         let n = array.count;
         for i in 0...n-1{
             var minimum = i
             for j in i + 1 ... n-1 {
                 if (array[j] < array[minimum]){
                     minimum = j
                 }
             }
             let temp = array[i]
             array[i] = array[minimum]
             array[minimum] = temp
         }
     }
     */
    
    func verifyState () {
        if (currentState.compareWith(other: states[stateIndex])) {
            if (stateIndex+1 == states.count) {
                lbEstado.text = "Terminaste!"
                for i in 0...6 {
                    buttons[i].isEnabled = false
                }
                buttonUndo.isEnabled = false
            } else {
                lbEstado.text = "Correcto"
                stateIndex += 1
            }
            lbEstado.textColor = correctColor
            
            // Guardar informacion de estado actual
            for i in 0...6 {
                storedFrames[i] = buttons[i].frame.origin
                storedTags[i] = buttons[i].tag
            }
        } else {
            lbEstado.text = "Incorrecto"
            lbEstado.textColor = wrongColor
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
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
        for i in 0...6 {
            buttons[i].frame.origin = storedFrames[i]
            buttons[i].tag = storedTags[i]
            buttons[i].backgroundColor = defaultColor
        }
        firstTouched = -1
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
