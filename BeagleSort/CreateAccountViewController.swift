//
//  CreateAccountViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetype: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StylesHelper.addButtonStyles(button: self.btnContinue);
        StylesHelper.addViewStyles(view: self.emailView);
        StylesHelper.addViewStyles(view: self.nameView);
        StylesHelper.addViewStyles(view: self.passwordView);
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }

    @IBAction func onContinuarPress(_ sender: Any) {
        if self.txtEmail.text?.count == 0 || self.txtPassword.text?.count == 0 || self.txtRetype.text?.count == 0 {
            showAlert("Por favor llenar todas los campos.");
            return;
        }
        
        // check that passwords are the same
        if self.txtPassword.text! != self.txtRetype.text! {
            showAlert("Las contraseñas no son iguales.");
            return;
        }
        
        self.btnContinue.isEnabled = false;
        
        // crear cuenta
        let email = self.txtEmail.text!;
        let password = self.txtPassword.text!;
        Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
            if err == nil {
                self.performSegue(withIdentifier: "continueSegue", sender: nil);
            } else {
                self.showAlert(err?.localizedDescription ?? "No se pudo crear la cuenta nueva.");
                self.btnContinue.isEnabled = true;
            }
        }
    }
    
    @IBAction func ontap(_ sender: Any) {
        view.endEditing(true);
    }
}
