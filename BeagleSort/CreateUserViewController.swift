//
//  CreateUserViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 10/25/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

class CreateUserViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetype: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }
    
    @IBAction func onConfirmarPress(_ sender: Any) {
        if self.txtEmail.text?.count == 0 || self.txtPassword.text?.count == 0 || self.txtRetype.text?.count == 0 {
            showAlert("Por favor llenar todas los campos.");
            return;
        }
        
        // check that passwords are the same
        if self.txtPassword.text! != self.txtRetype.text! {
            showAlert("Las contraseñas no son iguales.");
            return;
        }
        
        // crear cuenta
        let email = self.txtEmail.text!;
        let password = self.txtPassword.text!;
        Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
            if err == nil {
                self.performSegue(withIdentifier: "login", sender: nil);
            } else {
                self.showAlert(err?.localizedDescription ?? "No se pudo crear la cuenta nueva.");
            }
        }
    }
}
