//
//  MergePracticeViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 16/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Space {
    var level: Int!
    var container: Int!
    var space: Int!
}

class Number{
    var numView: UIView!
    var value: Int!
}

class State {
    var space: Space!
    var number: Number!
}

class MergePracticeViewController: UIViewController {

    
    @IBOutlet weak var levelOneView: UIView!
    @IBOutlet weak var levelTwoView: UIView!
    @IBOutlet weak var levelThreeView: UIView!
    @IBOutlet weak var levelFourView: UIView!
    
    var array: [Int]!
    
    var arrayViewsDictionary: [Int: UIView]!
    //Views in respect to stack
    var numViews: [UIView]!
    //Views in respect to the whole view
    var numSuperViews: [UIView]!
    
    var stackLevelTwoContainerViews: [UIView]!
    var stackLevelThreeContainerViews: [UIView]!
    var stackLevelFourContainerViews: [UIView]!
    
    
    var stackLevelTwo: UIStackView!
    
    
    
    var numberViewIndexSelected: Int!
    
    
    /*
     
     -#Level(Staring at level 2)
     ---#Container
     -------#Space
     
     Ex: spaces[0][1][1] Space of level 2, second container, second space
     Ex: spaces[2][0][4] Space of level 4, first container, fifth space
 
 
 
    */
    var spacesViews: [[[UIView]]]!
    var isNumberSelected: Bool!
    var numberSelected: Number!
    var numbers: [Number]!
    
    var spaces: [[[Space]]]!
    
    var correctStates: [[State]]!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelOneView.backgroundColor = .clear
        levelTwoView.backgroundColor = .clear
        levelThreeView.backgroundColor = .clear
        levelFourView.backgroundColor = .clear
        
        isNumberSelected = false
        spacesViews = []
        numbers = []
        spaces = []
        correctStates = []
        
        // Do any additional setup after loading the view.
        
        //Creating the general stacks for the four levels
        print("Loading MergePracticeViewController")
        
        // Creating the array element views for the first level
        numViews = generateNumViews(arr: array)
        let stackLevelOne = UIStackView(arrangedSubviews: numViews)
        stackLevelOne.axis = .horizontal
        stackLevelOne.distribution = .fillEqually
        stackLevelOne.alignment = .center
        stackLevelOne.spacing = 10
        stackLevelOne.translatesAutoresizingMaskIntoConstraints = false

        levelOneView.addSubview(stackLevelOne)
        
        let stackLevelOneDictionary = ["stackView":stackLevelOne]
        
        let stackViewOne_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelOneDictionary)
        
        let stackViewOne_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelOneDictionary)
        
        levelOneView.addConstraints(stackViewOne_H)
        levelOneView.addConstraints(stackViewOne_V)

        //Creating the containers array views for second level (4 comparisosn)
        var levelOneContainers: [UIView] = []
        var levelTwoContainers: [UIView] = []
        var levelThreeContainers: [UIView] = []
        var levelFourContainers: [UIView] = []
        
        //Adding one container to level one
        let containerLevelOne = UIView()
        containerLevelOne.backgroundColor = .yellow
        levelOneContainers.append(containerLevelOne)
        
        //Adding four containers to level two and adding them to stack
        for _ in 1...4 {
            let v = UIView()
            v.backgroundColor = .red
            levelTwoContainers.append(v)
        }
        print("Creating container views of level two:" , levelTwoContainers)
        
        stackLevelTwoContainerViews = generateContainerViews(num: 4, color: .blue, level: 2, container: -1)
        
        stackLevelTwo = UIStackView(arrangedSubviews: stackLevelTwoContainerViews)
        stackLevelTwo.axis = .horizontal
        stackLevelTwo.distribution = .fillEqually
        stackLevelTwo.alignment = .center
        stackLevelTwo.spacing = 10
        stackLevelTwo.translatesAutoresizingMaskIntoConstraints = false

        
        //Adding two containers to level three
        for _ in 1...2 {
            let v = UIView()
            v.backgroundColor = .blue
            levelThreeContainers.append(v)
        }
        
        stackLevelThreeContainerViews = generateContainerViews(num: 2, color: .blue, level: 3, container: -1)
        let stackLevelThree = UIStackView(arrangedSubviews: stackLevelThreeContainerViews)
        stackLevelThree.axis = .horizontal
        stackLevelThree.distribution = .fillEqually
        stackLevelThree.alignment = .center
        stackLevelThree.spacing = 10
        stackLevelThree.translatesAutoresizingMaskIntoConstraints = false
        
        //Adding one containers to level four
        stackLevelFourContainerViews = generateContainerViews(num: 1, color: .blue, level: 4, container: -1)
        let stackLevelFour = UIStackView(arrangedSubviews: stackLevelFourContainerViews)
        stackLevelFour.axis = .horizontal
        stackLevelFour.distribution = .fillEqually
        stackLevelFour.alignment = .center
        stackLevelFour.spacing = 10
        stackLevelFour.translatesAutoresizingMaskIntoConstraints = false
        
        

        //Adding constraints to stack of level 2
        levelTwoView.addSubview(stackLevelTwo)

        let stackLevelTwoDictionary = ["stackView":stackLevelTwo]
        
        let stackViewLevelTwo_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelTwoDictionary)
        
        let stackViewLevelTwo_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelTwoDictionary)
        
        
        levelTwoView.addConstraints(stackViewLevelTwo_H)
        levelTwoView.addConstraints(stackViewLevelTwo_V)
        
        
        //Adding constraints to stack of level 3
        
        levelThreeView.addSubview(stackLevelThree)
        
        let stackLevelThreeDictionary = ["stackView":stackLevelThree]
        
        let stackViewLevelThree_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelThreeDictionary)
        
        let stackViewLevelThree_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelThreeDictionary)
        
        
        levelThreeView.addConstraints(stackViewLevelThree_H)
        levelThreeView.addConstraints(stackViewLevelThree_V)
        
        //Adding constraints to stack of level 4
        
        levelFourView.addSubview(stackLevelFour)
        
        let stackLevelFourDictionary = ["stackView":stackLevelFour]
        
        let stackViewLevelFour_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelFourDictionary)
        
        let stackViewLevelFour_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelFourDictionary)
        
        
        levelFourView.addConstraints(stackViewLevelFour_H)
        levelFourView.addConstraints(stackViewLevelFour_V)

        
        //Adding constraints to all containers
        
        for numView in numViews {
            numView.heightAnchor.constraint(equalTo: numView.widthAnchor).isActive = true
        }
        
        for container in stackLevelTwoContainerViews {
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        }
        
        for container in stackLevelThreeContainerViews {
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        }
        
        for container in stackLevelFourContainerViews {
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        }
        
        var i = 0
        //Adding a stack with views to the containers of level two
        var spacesViewsLevelTwo: [[UIView]] = []
        var spacesLevelTwo: [[Space]] = []
        
        while (i < 4){
            let container = stackLevelTwoContainerViews[i]
            //Create views where numbers will be
            let num = i == 3 ? 1 : 2
            //level 2, container i
            let vistas = generateContainerViews(num: num, color: .cyan, level: 2, container: i)
            let spaces = generateSpacesObjects(num: num, level: 2, container: i)
            
            spacesViewsLevelTwo.append(vistas)
            spacesLevelTwo.append(spaces)
            //Create stack view with it
            let stackView = UIStackView(arrangedSubviews: vistas)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            //Add stack view to container
            container.addSubview(stackView)
            
            //Add constraints
            let stackDictionary = ["stackView":stackView]
            
            let stackView_H = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: stackDictionary)
            
            let stackView_V = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil,
                views: stackDictionary)
            
            container.addConstraints(stackView_H)
            container.addConstraints(stackView_V)
            
            //Add constraints to views inside this stack
            for vista in vistas {
                vista.heightAnchor.constraint(equalTo: vista.widthAnchor).isActive = true
            }
            
            i += 1
        }
        spacesViews.append(spacesViewsLevelTwo)
        spaces.append(spacesLevelTwo)
        
        
        
        
        i = 0
        //Adding a stack with views to each of the containers of level three
        var spacesViewsLevelThree: [[UIView]] = []
        var spacesLevelThree: [[Space]] = []
        
        for container in stackLevelThreeContainerViews {
            
            //Create views where numbers will be
            let vistas = generateContainerViews(num: 4, color: .cyan, level: 3, container: i)
            let spaces = generateSpacesObjects(num: 4, level: 3, container: i)
            
            spacesViewsLevelThree.append(vistas)
            spacesLevelThree.append(spaces)
            //Create stack view with it
            let stackView = UIStackView(arrangedSubviews: vistas)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            //Add stack view to container
            container.addSubview(stackView)
            
            //Add constraints
            let stackDictionary = ["stackView":stackView]
            
            let stackView_H = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: stackDictionary)
            
            let stackView_V = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil,
                views: stackDictionary)
            
            container.addConstraints(stackView_H)
            container.addConstraints(stackView_V)
            
            //Add constraints to views inside this stack
            for vista in vistas {
                 vista.heightAnchor.constraint(equalTo: vista.widthAnchor).isActive = true
            }
            i += 1
        }
        
        spacesViews.append(spacesViewsLevelThree)
        spaces.append(spacesLevelThree)
        
        
        i = 0
        //Adding a stack with views to each of the containers of level four
        var spacesViewsLevelFour: [[UIView]]! = []
        var spacesLevelFour: [[Space]] = []
        
        for container in stackLevelFourContainerViews {
            
            //Create views where numbers will be
            let vistas = generateContainerViews(num: 7, color: .cyan, level: 4, container: i)
            let spaces = generateSpacesObjects(num: 7, level: 4, container: i)
            
            spacesViewsLevelFour.append(vistas)
            spacesLevelFour.append(spaces)
            
            //Create stack view with it
            let stackView = UIStackView(arrangedSubviews: vistas)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            //Add stack view to container
            container.addSubview(stackView)
            
            //Add constraints
            let stackDictionary = ["stackView":stackView]
            
            let stackView_H = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-1-[stackView]-1-|",  //horizontal constraint 20 points from left and right side
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: stackDictionary)
            
            let stackView_V = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-1-[stackView]-1-|", //vertical constraint 30 points from top and bottom
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil,
                views: stackDictionary)
            
            container.addConstraints(stackView_H)
            container.addConstraints(stackView_V)
            
            //Add constraints to views inside this stack
            for vista in vistas {
                vista.heightAnchor.constraint(equalTo: vista.widthAnchor).isActive = true
            }
            i += 1
        }
        spacesViews.append(spacesViewsLevelFour)
        spaces.append(spacesLevelFour)
        
        i = 0
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //After knowing constraints and actual frames
        numSuperViews = generateNumSuperViews(nums: numViews)
        var i = 0
        for numView in numSuperViews {
            //Crear label y ajustar propiedades
            let numLabel = UILabel()
            numLabel.text = "\(array[i])"
            numLabel.textColor = .black
            numLabel.textAlignment = .center
            //translatesAutoresizingMaskIntoConstraints es importante hacer
            numLabel.translatesAutoresizingMaskIntoConstraints = false
            //Agregar label al view antes de poner constraints..
            numView.addSubview(numLabel)
            //Agregar constraints
            numLabel.centerYAnchor.constraint(equalTo: numView.centerYAnchor).isActive = true
            numLabel.centerXAnchor.constraint(equalTo: numView.centerXAnchor).isActive = true
            
            numView.heightAnchor.constraint(equalTo: numView.widthAnchor).isActive = true
            i += 1
        }
        
        generateStatesInOrder()
    }

    
    func getViewInSpace(space: Space) -> UIView{
        return spacesViews[space.level-2][space.container][space.space]
    }
    
    @objc func spacePressed (_ sender: MergeSpaceViewTapGestureRecognizer) {
        
        if (isNumberSelected) {
            let space = Space()
            space.level = sender.level
            space.container = sender.container
            space.space = sender.space
            
            let spaceView = getViewInSpace(space: space)
            let numView = numberSelected.numView
            
            let isCorrect = isCorrectMove(space: space, number: numberSelected, level: space.level)
            if (isCorrect){
                spaceView.backgroundColor = .green
                
                //Get correct coordinates
                let spacesStack = spaceView.superview
                let containerView = spacesStack?.superview
                let pointInRespectToContainer = spacesStack?.convert(spaceView.frame.origin, to: containerView)
                let containersStack = containerView?.superview
                let pointInRespectToContainersStack = containerView?.convert(pointInRespectToContainer!, to: containersStack)
                let levelView = containersStack?.superview
                let pointInRespectToLevelView = containersStack?.convert(pointInRespectToContainersStack!, to: levelView)
                var pointInRespectToTheWholeView = levelView?.convert(pointInRespectToLevelView!, to: view)
                
                
                //Get frames
                let spaceFrame: CGRect = spaceView.frame
                let numViewFrame: CGRect = numView!.frame
                UIView.animate(withDuration: 1, animations: {
                    let diffBetweenHeights = numViewFrame.size.height - spaceFrame.size.height
                    let diffBetweenWidths = numViewFrame.size.width - spaceFrame.size.width
                    pointInRespectToTheWholeView?.x -= diffBetweenWidths / 2
                    pointInRespectToTheWholeView?.y -= diffBetweenHeights / 2
                    numView?.frame.origin = pointInRespectToTheWholeView!
                    numView?.backgroundColor = .orange
                }) { (true) in
                    self.isNumberSelected = false
                }
            } else if (!isCorrect){
                UIView.animate(withDuration: 1, animations: {
                    spaceView.backgroundColor = .red
                }) { (true) in
                    UIView.animate(withDuration: 0.5, animations: {
                        spaceView.backgroundColor = .clear
                    }, completion: { (true) in

                    })
                }
            }
        } else if (!isNumberSelected){
            
        }
    }
    
    func isCorrectMove(space: Space!, number: Number!, level: Int) -> Bool {
        
        for state in correctStates[level - 2] {
            if state.number.numView == number.numView && areSpacesEqual(spaceA: state.space, spaceB: space) {
                return true
            }
        }
        return false
    }
    
    func areSpacesEqual(spaceA: Space, spaceB: Space) -> Bool {
        return spaceA.container == spaceB.container && spaceA.level == spaceB.level && spaceA.space == spaceB.space
    }
    
    func generateContainerViews(num: Int, color: UIColor, level: Int, container: Int) -> [UIView] {
        var views: [UIView] = []
        var index = 0
        for i in 1...num {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            if (container != -1){
                let gestureRecognizer = MergeSpaceViewTapGestureRecognizer(target: self, action: #selector(self.spacePressed(_:)))
                gestureRecognizer.level = level
                gestureRecognizer.container = container
                gestureRecognizer.space = i - 1
                numView.addGestureRecognizer(gestureRecognizer)
            }
            numView.layer.borderWidth = 1
            numView.layer.borderColor = color.cgColor
            numView.backgroundColor = .clear
            //Agregar la vista al arreglo
            views.append(numView)
            //Agregar la vista al diccionario de vistas(index, view)
        }
        return views
    }
    
    func generateSpacesObjects(num: Int, level: Int, container: Int) -> [Space] {
        var views: [Space] = []
        for i in 1...num {
            let space = Space()
            space.container = container
            space.level = level
            space.space = i - 1
            views.append(space)
            //Agregar la vista al diccionario de vistas(index, view)
        }
        return views
    }
    
    @objc func numberViewPressed (_ sender: MergeNumberViewTapGestureRecognizer) {
        
        if (isNumberSelected){
            let old = numberSelected.numView
            UIView.animate(withDuration: 0.5, animations: {
                self.numberViewIndexSelected = sender.index
                self.isNumberSelected = true
                self.numberSelected = sender.number
                let new = sender.number.numView
                old?.backgroundColor = .orange
                new?.backgroundColor = .blue
            }) { (true) in
            }
        } else {
            numberViewIndexSelected = sender.index
            isNumberSelected = true
            numberSelected = sender.number
            let v = sender.number.numView
            UIView.animate(withDuration: 0.5) {
                v?.backgroundColor = .blue
            }
        }
        
    }
    
    func generateNumViews(arr: [Int]) -> [UIView] {
        arrayViewsDictionary = [:]
        var views: [UIView] = []
        var index = 0
        for i in arr {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            numView.backgroundColor = .clear
            
            numView.tag = i
            
            let gestureRecognizer = MergeNumberViewTapGestureRecognizer(target: self, action: #selector(self.numberViewPressed(_:)))
            gestureRecognizer.index = index
            gestureRecognizer.value = i
            
            numView.addGestureRecognizer(gestureRecognizer)
            
            //Agregar la vista al arreglo
            views.append(numView)
            //Agregar la vista al diccionario de vistas(index, view)
            arrayViewsDictionary[index] = numView
            index += 1
        }
        return views
    }
    
    func generateNumSuperViews(nums: [UIView]) -> [UIView] {
        var views: [UIView] = []
        var index = 0
        for numView in nums {
            //Get frame with respect to whole view
            let stackView = numView.superview
            let levelView = stackView?.superview
            
            let pointWithRespectToLevel = stackView?.convert(numView.frame.origin, to: levelView)
            let pointWithRespectToWholeView = levelView?.convert(pointWithRespectToLevel!, to: view)
            
            var frame = numView.frame
            frame.origin = pointWithRespectToWholeView!
            
            //Create super num view with that frame
            let superNumView = UIView(frame: frame)
            
            
            //Create Number object with that view and add it to array
            let number = Number()
            number.numView = superNumView
            number.value = array[index]
            numbers.append(number)
            
            //Create and add gesture recognizer
            let gestureRecognizer = MergeNumberViewTapGestureRecognizer(target: self, action: #selector(self.numberViewPressed(_:)))
            gestureRecognizer.index = index
            gestureRecognizer.value = array[index]
            gestureRecognizer.number = number
            superNumView.addGestureRecognizer(gestureRecognizer)

            //Change background
            superNumView.backgroundColor = .orange
            
            //Add to view
            view.addSubview(superNumView)
            //Add to array of superviews
            views.append(superNumView)
            
            index += 1
        }
        return views
    }
    
    func generateStatesInOrder() {
        let statesLevelTwo: [State] = generateStatesOfLevelTwo()
        let statesLevelThree: [State] = generateStatesOfLevelThree()
        let statesLevelFour: [State] = generateStatesOfLevelFour()
        correctStates.append(statesLevelTwo)
        correctStates.append(statesLevelThree)
        correctStates.append(statesLevelFour)

    }
    
    func generateStatesOfLevelTwo () -> [State] {
        let level = 2
        var container = 0
        let (state1, state2) = createLevelTwoState(numberA: numbers[0], numberB: numbers[1], space0: spaces[level-2][container][0], space1: spaces[level-2][container][1])
        
        container = 1
        let (state3, state4) = createLevelTwoState(numberA: numbers[2], numberB: numbers[3], space0: spaces[level-2][container][0], space1: spaces[level-2][container][1])
        
        container = 2
        let (state5, state6) = createLevelTwoState(numberA: numbers[4], numberB: numbers[5], space0: spaces[level-2][container][0], space1: spaces[level-2][container][1])
        
        container = 3
        let state7 = State()
        state7.number = numbers[6]
        state7.space = spaces[level - 2][container][0]
        
        return [state1, state2, state3, state4, state5, state6, state7]
    }
    
    func generateStatesOfLevelThree () -> [State] {
        var numbersContainer1: [Number] = []
        var numbersContainer2: [Number] = []
        
        for i in 0...3 {
            numbersContainer1.append(numbers[i])
        }
        for i in 4...6 {
            numbersContainer2.append(numbers[i])
        }
        
        var spacesContainer1: [Space] = []
        var spacesContainer2: [Space] = []
        
        for space in spaces[1][0] {
            spacesContainer1.append(space)
        }
        for space in spaces[1][1] {
            spacesContainer2.append(space)
        }
        
        let _ = spacesContainer2.popLast()
        
        print("Creating states of level 3 container 1")
        let statesContainer1: [State] = createLevelThreeState(nums: numbersContainer1, spaces: spacesContainer1)
        print("Creating states of level 3 container 2")
        let statescContainer2: [State] = createLevelThreeState(nums: numbersContainer2, spaces: spacesContainer2)
        
        var result: [State] = []
        
        for state in statesContainer1 {
            result.append(state)
        }
        for state in statescContainer2 {
            result.append(state)
        }
        return result
        
    }
    
    func createLevelTwoState (numberA: Number, numberB: Number, space0: Space, space1: Space)->(State, State){
        let stateA = State()
        stateA.number = numberA
        let stateB = State()
        stateB.number = numberB
        
        if (numberA.value <= numberB.value) {
            stateA.space = space0
            stateB.space = space1
        } else {
            stateA.space = space1
            stateB.space = space0
        }
        return (stateA, stateB)
    }
    
    func createLevelThreeState (nums: [Number], spaces: [Space])->[State] {
        
        var numbersIndices: [Int] = []
        for i in 0...nums.count-1{
            numbersIndices.append(i)
        }
        
        for i in 0...numbersIndices.count-1 {
            print(i+1, numbersIndices.count - 1)
            var j = i + 1
            while (j <= numbersIndices.count - 1) {
                if (nums[numbersIndices[j]].value < nums[numbersIndices[i]].value){
                    let temp = numbersIndices[i]
                    numbersIndices[i] = numbersIndices[j]
                    numbersIndices[j] = temp
                }
                j += 1
            }
        }
        var levelThreeStates: [State] = []
        var i = 0
        for space in spaces {
            let state = State()
            print("i:", i)
            state.number = nums[numbersIndices[i]]
            state.space = space
            i += 1
            levelThreeStates.append(state)
        }
        
        return levelThreeStates
    }
    
    func generateStatesOfLevelFour() -> [State] {
        var nums: [Number] = []
        for n in numbers {
            nums.append(n)
        }
        
        var spacesContainer: [Space] = []
        for space in spaces[2][0] {
            spacesContainer.append(space)
        }
        
        let result:[State] = createLevelThreeState(nums: nums, spaces: spacesContainer)
        
        return result
    }
 
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
