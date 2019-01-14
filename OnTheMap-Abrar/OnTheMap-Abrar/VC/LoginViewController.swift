//
//  ViewController.swift
//  OnTheMap
//
//  Created by Abrar on ٢٥‏/١٢‏/٢٠١٨.
//  Copyright © ٢٠١٨ Abrar. All rights reserved.
//
import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        emailTextField.delegate = self as! UITextFieldDelegate
        passwordTextField.delegate = self as! UITextFieldDelegate
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email!.isEmpty) || (password!.isEmpty) {
            
            let requiredInfoAlert = UIAlertController (title: "Error", message: "Please fill both the email and password", preferredStyle: .alert)
            
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            
        ActivityIndicator.startActivityIndicator(view: self.loginButton)
        API.postSession_login(username: emailTextField.text!, password: passwordTextField.text!) { (errorString) in
            guard errorString == nil else {
                ActivityIndicator.stopActivityIndicator()
                self.showAlert(title: "Error", message: errorString!)
                return
            }
            DispatchQueue.main.async {
                ActivityIndicator.stopActivityIndicator()
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
            }
        }
    }
}
