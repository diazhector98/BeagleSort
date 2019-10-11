//
//  ViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 07/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnPracticar: UIButton!
    @IBOutlet weak var btnJugarOnline: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StylesHelper.addButtonStyles(button: self.btnPracticar);
        StylesHelper.addButtonStyles(button: self.btnJugarOnline);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

