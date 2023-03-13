//
//  RegisterViewController.swift
//  TruliooAssignment
//
//  Created by Roni Leshes on 12/03/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    var authProvider: AuthProvider!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else{
            showErrorDialog(message: "Please fill the username field")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else{
            showErrorDialog(message: "Please fill the password field")
            return
        }
        guard let passwordVerification = verifyPasswordTextField.text, !passwordVerification.isEmpty else{
            showErrorDialog(message: "Please fill the verify password field")
            return
        }
        guard password == passwordVerification else{
            showErrorDialog(message: "Passwords must match!")
            return
        }
        performRegister(username: username, password: password)
    }
    
    func performRegister(username: String, password: String){
        if let errorMessage = self.authProvider.register(username: username, password: password){
            showErrorDialog(title: "Account creation failed", message: errorMessage)
        }else{
            self.showSuccessDialog()
        }
    }
    
    private func showErrorDialog(title: String = "Woops", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func showSuccessDialog(){
        let alert = UIAlertController(title: "Success", message: "Account created successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
