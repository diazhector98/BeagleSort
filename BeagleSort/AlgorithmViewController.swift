//
//  AlgorithmViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 12/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class AlgorithmViewController: UIViewController {
    @IBOutlet weak var lbPromedio: UILabel!
    @IBOutlet weak var lbPeor: UILabel!
    @IBOutlet weak var lbMemoria: UILabel!
    @IBOutlet weak var lbCodigo: UILabel!
    @IBOutlet weak var btnViewAnimation: UIButton!
    @IBOutlet weak var btnPractice: UIButton!
    @IBOutlet weak var ascendingButton: UIButton!
    
    @IBOutlet weak var descendingButton: UIButton!
    
    var algorithm : Algorithm!
    var randomArray: [Int]!
    var isAscending = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomArray = []
        generateArray()
        lbPromedio.text = algorithm.averageCase
        lbPeor.text = algorithm.worstCase
        lbMemoria.text = algorithm.spaceComplexity
        lbCodigo.text = algorithm.implementation
        
        StylesHelper.addButtonStyles(button: self.btnViewAnimation);
        StylesHelper.addButtonStyles(button: self.btnPractice);
        StylesHelper.addButtonStyles(button: self.ascendingButton);
        StylesHelper.addButtonStyles(button: self.descendingButton);
        ascendingButton.isEnabled = false
        descendingButton.backgroundColor = UIColor(named: "Disabled")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressPractica(_ sender: Any) {
        if (algorithm.name == "MergeSort"){
            performSegue(withIdentifier: "practicaMerge", sender: self)
        } else {
            performSegue(withIdentifier: "practica", sender: self)
        }
    }
    
    
    @IBAction func makeAscending(_ sender: UIButton) {
        isAscending = true
        sender.isEnabled = false
        sender.backgroundColor = UIColor(named: "PrimaryBlue")
        descendingButton.isEnabled = true
        descendingButton.backgroundColor = UIColor(named: "Disabled")
    }
    
    @IBAction func makeDescending(_ sender: UIButton) {
        isAscending = false
        sender.isEnabled = false
        sender.backgroundColor = UIColor(named: "PrimaryBlue")
        ascendingButton.isEnabled = true
        ascendingButton.backgroundColor = UIColor(named: "Disabled")
    }
    
    func generateArray () {
        for _ in 1...7 {
            var num = Int.random(in: 1...99)
            while (randomArray.contains(num)) {
                num = Int.random(in: 1...99)
            }
            randomArray.append(num)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "demostracion" {
            let vista = segue.destination as! DemonstrationViewController
            vista.algorithm = algorithm
            vista.array = randomArray
            vista.isAscending = isAscending
        } else if segue.identifier == "practica" {
            
            let vista = segue.destination as! PracticeViewController
            vista.algorithm = algorithm
            vista.array = randomArray
            vista.isAscending = isAscending
        } else if segue.identifier == "practicaMerge" {
            let vista = segue.destination as! MergePracticeViewController
            vista.array = randomArray
        }
    }

}
