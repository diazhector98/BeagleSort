//
//  LoginViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 11/17/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit
import Firebase

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
        
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: "loginSegue", sender: nil);
        }
        
        self.btnContinue.setTitleColor(UIColor(named: "Disabled"), for: .disabled);
        self.btnCreateAccount.setTitleColor(UIColor(named: "Disabled"), for: .disabled);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func showAlert(_ message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: false);
    }
    
    @IBAction func onContinuarPress(_ sender: Any) {
        if self.txtEmail.text?.count == 0 || self.txtPassword.text?.count == 0 {
            showAlert("Por favor ingresar usuario y contraseña.");
            return;
        }
        
        self.btnContinue.isEnabled = false;
        self.btnCreateAccount.isEnabled = false;
        
        // authenticate
        let email = self.txtEmail.text! + "@beaglesort.com";
        let password = self.txtPassword.text!;
        Auth.auth().signIn(withEmail: email, password: password) { (auth, err) in
            if err == nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil);
            } else {
                self.showAlert(err?.localizedDescription ?? "No se pudo iniciar sesión.");
                self.btnContinue.isEnabled = true;
                self.btnCreateAccount.isEnabled = true;
            }
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true);
    }
    
    
    @IBAction func onPantallaPrincipalPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
