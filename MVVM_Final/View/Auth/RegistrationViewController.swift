//
//  RegistrationViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 11.06.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    private var registrationViewModel: RegistrationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.layer.cornerRadius = 4
        registrationButton.layer.masksToBounds = true
        passwordTextField.textContentType = .oneTimeCode
    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        callRegistrationWithFirebase(email: email, password: password)
    }
}
extension RegistrationViewController {
    private func callRegistrationWithFirebase(email: String, password: String) {
        self.registrationViewModel = RegistrationViewModel(email, password)
        self.registrationViewModel.bindRegistrationViewModelToController = {
            self.setupData()
        }
    }
    
    private func setupData() {
        if self.registrationViewModel?.errorMessage != "No error" {
            print(self.registrationViewModel.errorMessage ?? "error")
        } else {
            self.performSegue(withIdentifier: "goToMenuFromRegistration", sender: nil)
        }
    }
}
