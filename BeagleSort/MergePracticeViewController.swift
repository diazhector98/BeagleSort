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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Creating the general stacks for the four levels
        
        let stackLevelTwo = UIStackView()
        let stackLevelThree = UIStackView()
        let stackLevelFour = UIStackView()
        
        
        // Creating the array element views for the first level
        numViews = generateNumViews(arr: array)
        let stackLevelOne = UIStackView(arrangedSubviews: numViews)
        
        //Creating the containers array views for second level (4 comparisosn)
        var levelOneContainers: [UIView] = []
        var levelTwoContainers: [UIView] = []
        var levelThreeContainers: [UIView] = []
        var levelFourContainers: [UIView] = []
        
        
        //Adding one container to level one
        let containerLevelOne = UIView()
        levelOneContainers.append(containerLevelOne)
        //Adding four containers to level two
        for _ in 1...4 {
            let v = UIView()
            levelTwoContainers.append(v)
        }
        //Adding two containers to level three
        for _ in 1...2 {
            let v = UIView()
            levelThreeContainers.append(v)
        }
        //Adding one containers to level four
        let containerLevelFour = UIView()
        levelFourContainers.append(containerLevelFour)

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
