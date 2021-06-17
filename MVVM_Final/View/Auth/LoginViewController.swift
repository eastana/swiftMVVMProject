//
//  LoginViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 11.06.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var loginViewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        loginButton.layer.masksToBounds = true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        callLoginWithFirebase(email: email, password: password)
    }

}
extension LoginViewController {
    private func callLoginWithFirebase(email: String, password: String) {
        self.loginViewModel = LoginViewModel(email, password)
        self.loginViewModel.bindLoginViewModelToController = {
            self.setupData()
        }
    }
    
    private func setupData() {
        if self.loginViewModel?.errorMessage == "It has error" {
            print(self.loginViewModel.errorMessage ?? "error")
        } else {
            self.performSegue(withIdentifier: "goToMenuFromLogin", sender: nil)
        }
    }
}
