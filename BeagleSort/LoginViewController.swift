//
//  LoginViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StylesHelper.addButtonStyles(button: self.btnContinue);
        StylesHelper.addButtonStyles(button: self.btnCreateAccount);
        StylesHelper.addViewStyles(view: self.emailView);
        StylesHelper.addViewStyles(view: self.passwordView);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true);
    }
}
