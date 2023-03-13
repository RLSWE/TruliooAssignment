//
//  LoginViewController.swift
//  TruliooAssignment
//
//  Created by Roni Leshes on 12/03/2023.
//

import UIKit

protocol AuthProvider{
    // Result is either an error message, or nil if login was successful
    func login(username: String, password: String) -> String?
    func register(username: String, password: String) -> String?
}

class LoginViewController: UIViewController {
    var authProvider: AuthProvider!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else{
            showErrorDialog(message: "Please fill the username field")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else{
            showErrorDialog(message: "Please fill the password field")
            return
        }
        performLogin(username: username, password: password)
    }
    
    func performLogin(username: String, password: String){
        if let errorMessage = self.authProvider.login(username: username, password: password){
            showErrorDialog(title: "Login failed", message: errorMessage)
        }else{
            self.performSegue(withIdentifier: "success", sender: nil)
        }
    }
    
    private func showErrorDialog(title: String = "Woops", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"{
            let registerVc = segue.destination as! RegisterViewController
            registerVc.authProvider = self.authProvider
        }
    }
}
