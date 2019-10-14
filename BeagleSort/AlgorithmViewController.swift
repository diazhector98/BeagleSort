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
    
    var algorithm : Algorithm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbPromedio.text = algorithm.averageCase
        lbPeor.text = algorithm.worstCase
        lbMemoria.text = algorithm.spaceComplexity
        lbCodigo.text = algorithm.implementation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "demostracion" {
            let vista = segue.destination as! DemonstrationViewController
            vista.algorithm = algorithm
            vista.array = [3,4,2,5,2,8,7]
            
        } else if segue.identifier == "practica" {
            let vista = segue.destination as! PracticeViewController
            vista.algorithm = algorithm
            vista.array = [3,4,2,5,2,8,7]
        }
    }

}
