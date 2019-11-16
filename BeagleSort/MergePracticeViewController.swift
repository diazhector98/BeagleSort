//
//  MergePracticeViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 16/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class MergePracticeViewController: UIViewController {

    
    @IBOutlet weak var levelOneView: UIView!
    @IBOutlet weak var levelTwoView: UIView!
    @IBOutlet weak var levelThreeView: UIView!
    @IBOutlet weak var levelFourView: UIView!
    
    var array: [Int]!
    
    var arrayViewsDictionary: [Int: UIView]!
    var numViews: [UIView]!
    
    var stackLevelTwoContainerViews: [UIView]!
    var stackLevelThreeContainerViews: [UIView]!
    var stackLevelFourContainerViews: [UIView]!
    
    
    var stackLevelTwo: UIStackView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Creating the general stacks for the four levels
        print("Loading MergePracticeViewController")
        
        // Creating the array element views for the first level
        numViews = generateNumViews(arr: array)
        let stackLevelOne = UIStackView(arrangedSubviews: numViews)
        stackLevelOne.axis = .horizontal
        stackLevelOne.distribution = .fillEqually
        stackLevelOne.alignment = .center
        //stackLevelOne.spacing = 10
        
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
        
        stackLevelTwoContainerViews = generateContainerViews(num: 4)
        
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
        
        stackLevelThreeContainerViews = generateContainerViews(num: 2)
        let stackLevelThree = UIStackView(arrangedSubviews: stackLevelThreeContainerViews)
        stackLevelThree.axis = .horizontal
        stackLevelThree.distribution = .fillEqually
        stackLevelThree.alignment = .center
        stackLevelThree.spacing = 10
        stackLevelThree.translatesAutoresizingMaskIntoConstraints = false
        
        //Adding one containers to level four
        stackLevelFourContainerViews = generateContainerViews(num: 1)
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
            withVisualFormat: "H:|-10-[stackView]-10-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelTwoDictionary)
        
        let stackViewLevelTwo_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[stackView]-10-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelTwoDictionary)
        
        
        levelTwoView.addConstraints(stackViewLevelTwo_H)
        levelTwoView.addConstraints(stackViewLevelTwo_V)
        
        
        //Adding constraints to stack of level 3
        
        levelThreeView.addSubview(stackLevelThree)
        
        let stackLevelThreeDictionary = ["stackView":stackLevelThree]
        
        let stackViewLevelThree_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[stackView]-10-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelThreeDictionary)
        
        let stackViewLevelThree_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[stackView]-10-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelThreeDictionary)
        
        
        levelThreeView.addConstraints(stackViewLevelThree_H)
        levelThreeView.addConstraints(stackViewLevelThree_V)
        
        //Adding constraints to stack of level 4
        
        levelFourView.addSubview(stackLevelFour)
        
        let stackLevelFourDictionary = ["stackView":stackLevelFour]
        
        let stackViewLevelFour_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[stackView]-10-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: stackLevelFourDictionary)
        
        let stackViewLevelFour_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[stackView]-10-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: stackLevelFourDictionary)
        
        
        levelFourView.addConstraints(stackViewLevelFour_H)
        levelFourView.addConstraints(stackViewLevelFour_V)

        
        //Adding constraints to all containers
        
        for numView in numViews {
            numView.heightAnchor.constraint(equalTo: numView.widthAnchor).isActive = true
        }
        
        for v in stackLevelTwoContainerViews {
            v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
        }
        
        for v in stackLevelThreeContainerViews {
            v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
        }
        
        for v in stackLevelFourContainerViews {
            v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
        }
        
        
        //Adding a stack to each of the containers of level two
        for v in stackLevelTwoContainerViews {
            
        }
        
    }
    
    func generateContainerViews(num: Int) -> [UIView] {
        var views: [UIView] = []
        var index = 0
        for _ in 1...num {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            numView.backgroundColor = .blue
            //Agregar la vista al arreglo
            views.append(numView)
            //Agregar la vista al diccionario de vistas(index, view)
        }
        return views
    }
    
    func generateNumViews(arr: [Int]) -> [UIView] {
        arrayViewsDictionary = [:]
        var views: [UIView] = []
        var index = 0
        for _ in arr {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            numView.backgroundColor = .blue
            //Agregar la vista al arreglo
            views.append(numView)
            //Agregar la vista al diccionario de vistas(index, view)
            arrayViewsDictionary[index] = numView
            index += 1
        }
        return views
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
