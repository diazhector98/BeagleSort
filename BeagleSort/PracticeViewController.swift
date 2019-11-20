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
    var quickOrder = [0, 1, 2, 3, 4, 5, 6]
    var dictionary: [Int: UIButton]!;
    var constraints: [[NSLayoutConstraint]]!
    var buttonStackView: UIStackView!
    var originalArray: [Int]!
    
    // Colores para feedback
    let correctColor = UIColor(red: 39.0/255, green: 161.0/255, blue: 59.0/255, alpha: 1)
    let wrongColor = UIColor(red: 255.0/255, green: 78.0/255, blue: 72.0/255, alpha: 1)
    let selectedColor = UIColor(red: 91.0/255, green: 132.0/255, blue: 255, alpha: 1)
    let defaultColor = UIColor.white
    
    // Variables de segue
    var array : [Int]!
    var algorithm: Algorithm!
    var isAscending: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints = []
        originalArray = array
        buttons = generateButtons(arr: originalArray)
        buttonStackView = UIStackView(arrangedSubviews: buttons)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonHolder.addSubview(buttonStackView)
        
        //Agregar constrainst de la stack
        let viewsDictionary = ["stackView":buttonStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        constraints.append(stackView_H)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        constraints.append(stackView_V)
        buttonHolder.addConstraints(stackView_H)
        buttonHolder.addConstraints(stackView_V)
        
        for button in buttons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        }
        
        
        

       lbEstado.textColor = correctColor
//        // Hacer los botones desde cero
//        let fullWidth = self.buttonHolder.frame.size.width
//
//        buttonHolder.backgroundColor = selectedColor
//        let buttonWidth = buttonHolder.frame.size.width / 7.0
//
//        let margin: CGFloat = 10.0;
//        let width = fullWidth - 2.0 * margin;
//        var availableWidth = width / 7.0;
//        var padding = (availableWidth - buttonWidth) / 2.0;
//
//        if (padding < 0) {
//            padding = 0;
//            availableWidth = (width - buttonWidth) / (7.0 - 1.0);
//        }
//
//        padding += margin;
//        let y: CGFloat = 0;
//
//        for i in 0...6 {
//            let button = UIButton(type: .system)
//            let x = CGFloat(i) * availableWidth + padding;
//            button.frame = CGRect(x: x, y: y, width: buttonWidth - padding, height: buttonWidth)
//
//            button.setTitle(String(self.array[i]), for: .normal)
//            button.setTitleColor(.black, for: .normal)
//            button.backgroundColor = defaultColor
//            button.tag = i + 1
//            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//            frames.append(button.frame.origin)
//            buttonHolder.addSubview(button)
//            buttons.append(button)
//
//        }
        storedFrames = frames
        buttonUndo.setTitle("Reiniciar", for: .normal)
        StylesHelper.addButtonStyles(button: buttonUndo);

        // Formar arreglo de estados
        createStates()
    }
    
    func generateButtons(arr: [Int]) -> [UIButton] {
        dictionary = [:];
        var views: [UIButton] = []
        var index = 0
        for i in arr {
            //Crear la vista contenedor del numero y agregar propiedades
            let button = UIButton()
            button.setTitle(String(i), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = defaultColor
            button.tag = index + 1;
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            StylesHelper.addNodeStyles(node: button);
            
            frames.append(button.frame.origin)
            buttons.append(button)
            //Agregar la vista al arreglo
            views.append(button)
            //Agregar la vista al diccionario de vistas(index, view)
            dictionary[index] = button;
            
            index += 1
        }
        return views
    }
    
    func compare(actual: Int, comparedTo: Int) -> Bool {
        if (isAscending) {
            if (actual > comparedTo) {
                return true
            } else {
                return false
            }
        } else {
            if (actual < comparedTo) {
                return true
            } else {
                return false
            }
        }
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
        case "QuickSort":
            states.append(ArrayState(array: quickOrder))
            quickSortStates(startIndex: 0, endIndex: array.count-1)
        case .none:
            print("What")
        case .some(_):
            print("What")
        }
    }
    
    // Crea ArrayStates para Bubble Sort
    func bubbleSortStates2() {
        var changed = true
        var limit = array.count-2
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        while (changed && limit > 0) {
            changed = false
            for i in 0...limit {
                if (compare(actual: array[i], comparedTo: array[i+1])) {
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
    
    func bubbleSortStates () {
        let n = array.count
        var i = n - 1
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        while (i >= 1) {
            for j in 0...i-1 {
                if (compare(actual: array[j], comparedTo: array[j+1])) {
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                    let temp2 = order[j]
                    order[j] = order[j+1]
                    order[j+1] = temp2
                    states.append(ArrayState(array: order))
                }
            }
            i = i - 1
        }
    }
    /*
     func initBubbleSortTransitions() {
         let n = array.count
         var i = n - 1
         while (i >= 1){
             for j in 0...i-1{
                 var sign: String!
                 if (isAscending) {
                     sign = ">"
                 } else {
                     sign = "<"
                 }
                 let comparison = Comparison(indexA: j, indexB: j + 1, valueA: array[j], valueB: array[j+1], sign: sign)
                 steps.append(comparison)
                 if (compare(actual: array[j], comparedTo: array[j+1])) {
                     let transition = Transition(from: j, to: j+1, fromValue: array[j], toValue: array[j+1])
                     steps.append(transition)
                     let temp = array[j]
                     array[j] = array[j+1]
                     array[j+1] = temp
                 }
             }
             i = i - 1
         }
     }
     */
    
    func insertionSortStates() {
        var curr = 1
        let n = array.count
        var order = [0, 1, 2, 3, 4, 5, 6]
        states.append(ArrayState(array: order))
        while (curr < n) {
            var c = curr - 1
            while (c >= 0 && compare(actual: array[c], comparedTo: array[c+1])) {
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
                if (isAscending) {
                    if (array[j] < array[minimum]) {
                        minimum = j
                    }
                } else {
                    if (array[j] > array[minimum]) {
                        minimum = j
                    }
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
    
    func quickSortStates(startIndex: Int, endIndex: Int) {
        if (startIndex > endIndex) {
            return
        }
        let pivot = array[startIndex]
        let pivot2 = quickOrder[startIndex]
        var left = startIndex + 1
        var right = endIndex
        while (left <= right) {
            var shouldSwap = false
            if (isAscending) {
                if (array[left] > pivot && array[right] < pivot) {
                    shouldSwap = true
                }
            } else {
                if (array[left] < pivot && array[right] > pivot) {
                    shouldSwap = true
                }
            }
            if (shouldSwap && left != right) {
                let temp = array[left]
                array[left] = array[right]
                array[right] = temp
                let temp2 = quickOrder[left]
                quickOrder[left] = quickOrder[right]
                quickOrder[right] = temp2
                states.append(ArrayState(array: quickOrder))
            }
            if (isAscending){
                if (array[left] <= pivot) {
                    left += 1
                }
                if (array[right] >= pivot) {
                    right -= 1
                }
            } else {
                if (array[left] >= pivot) {
                    left += 1
                }
                if (array[right] <= pivot) {
                    right -= 1
                }
            }
        }
        if (startIndex != right) {
            array[startIndex] = array[right]
            array[right] = pivot
            quickOrder[startIndex] = quickOrder[right]
            quickOrder[right] = pivot2
            states.append(ArrayState(array: quickOrder))
        }
        quickSortStates(startIndex: startIndex, endIndex: right-1)
        quickSortStates(startIndex: right+1, endIndex: endIndex)
    }
    /*
     func QuickSort(startIndex: Int, endIndex: Int){
         
         if (startIndex > endIndex){
             return;
         }
         //Pivot Selection
         let pivot = array[startIndex]
         steps.append(PivotSelection(index: startIndex, value: pivot))
         var left = startIndex + 1
         var right = endIndex
         while(left <= right){
             //Comparison of both left and right pointers
             steps.append(Comparison(indexA: left, indexB: right, valueA: array[left], valueB: array[right], sign: " > pivot and pivot > "))
             if (array[left] > pivot && array[right] < pivot){
                 
                 //Swap of both pointers
                 steps.append(Transition(from: left, to: right, fromValue: array[left], toValue: array[right]))
                 let temp = array[left]
                 array[left] = array[right]
                 array[right] = temp
             }
             //Comparison of pivot and left
             steps.append(Comparison(indexA: left, indexB: startIndex, valueA: array[left], valueB: pivot, sign: "<="))
             if (array[left] <= pivot){
                 left += 1;
             }
             //Comparison of pivot and right
             steps.append(Comparison(indexA: right, indexB: startIndex, valueA: array[right], valueB: pivot, sign: ">="))
             if (array[right] >= pivot){
                 right -= 1;
             }
         }
         //Swap of right and pivot (if swapping with pivot, should DESELECT pivot in animation)
         steps.append(Transition(from: startIndex, to: right, fromValue: pivot, toValue: array[right]))
         array[startIndex] = array[right]
         array[right] = pivot
         
         QuickSort(startIndex: startIndex, endIndex: right-1)
         QuickSort(startIndex: right+1, endIndex: endIndex)
         
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
            let firstButton = buttonStackView.viewWithTag(firstTouched) as! UIButton
            let indexA = firstButton.tag - 1;
            let indexB = sender.tag - 1;
            
            // Usa tags para actualizar el estado
            let tempState = currentState.array[indexA]
            currentState.array[indexA] = currentState.array[indexB]
            currentState.array[indexB] = tempState
            
            // hacer hidden las views que se van a mover
            let originalViewA = dictionary[indexA];
            let originalViewB = dictionary[indexB];
            disappearView(vista: originalViewA!);
            disappearView(vista: originalViewB!);
            
            // obtener los frames de esos elementos
            let frameA: CGRect = buttons[indexA].frame;
            let frameB: CGRect = buttons[indexB].frame;
            
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
            
            StylesHelper.addNodeStyles(node: buttonA);
            StylesHelper.addNodeStyles(node: buttonB);

            // agregar a stackview
            buttonStackView.addSubview(buttonA);
            buttonStackView.addSubview(buttonB);
            
            // Intercambia tags
            let tempTag = buttonA.tag
            buttonA.tag = buttonB.tag
            buttonB.tag = tempTag
            
            // updatear diccionario de views
            dictionary[indexA] = buttonB;
            dictionary[indexB] = buttonA;
            
            // animar
            UIView.animate(withDuration: 0.5, animations: {
                let tempFrame = buttonA.frame.origin;
                buttonA.frame.origin = buttonB.frame.origin;
                buttonB.frame.origin = tempFrame;
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
    
    func disappearView(vista: UIView) {
        vista.alpha = 0;
        for sv in vista.subviews {
            sv.removeFromSuperview();
        }
    }
    
    @IBAction func undo(_ sender: UIButton) {
        for view in buttonHolder.subviews{
            view.removeFromSuperview()
        }
        buttonHolder.removeConstraints(constraints[0])
        buttonHolder.removeConstraints(constraints[1])
        constraints.removeAll()
        frames.removeAll()
        storedTags = [1, 2, 3, 4, 5, 6, 7]
        currentState = ArrayState(array: [0, 1, 2, 3, 4, 5, 6])
        stateIndex = 1
        firstTouched = -1
        
        
        buttonStackView = UIStackView(arrangedSubviews: buttons)
        buttons = generateButtons(arr: originalArray)
        buttonStackView = UIStackView(arrangedSubviews: buttons)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonHolder.addSubview(buttonStackView)
        
        let viewsDictionary = ["stackView":buttonStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        constraints.append(stackView_H)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        constraints.append(stackView_V)
        buttonHolder.addConstraints(stackView_H)
        buttonHolder.addConstraints(stackView_V)
        
        for button in buttons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        }
        storedFrames = frames
        lbEstado.text = "Reiniciado"
        lbEstado.textColor = defaultColor
        /*
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
         */
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
