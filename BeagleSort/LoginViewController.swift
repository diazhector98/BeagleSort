//
//  LoginViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 10/25/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // check if authenticated
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "login", sender: nil);
        }
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }
    
    @IBAction func onIngresarPress(_ sender: Any) {
        if self.txtEmail.text?.count == 0 || self.txtPassword.text?.count == 0 {
            showAlert("Por favor ingresar usuario y contraseña.");
            return;
        }
        
        // authenticate
        let email = self.txtEmail.text!;
        let password = self.txtPassword.text!;
        Auth.auth().signIn(withEmail: email, password: password) { (auth, err) in
            if err == nil {
                self.performSegue(withIdentifier: "login", sender: nil);
            } else {
                self.showAlert(err?.localizedDescription ?? "No se pudo iniciar sesión.");
            }
        }
    }
}
