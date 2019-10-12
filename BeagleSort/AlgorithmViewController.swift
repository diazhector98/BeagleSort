//
//  AlgorithmViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 12/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class AlgorithmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            vista.algorithm = BubbleSort.instance
            vista.array = [3,4,2,5,2,8,7]
        }
        
    }

}
