//
//  MenuViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    private var logoutViewModel: LogoutViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        callLogoutWithFirebase()
    }
}
extension MenuViewController {
    
    private func callLogoutWithFirebase() {
        self.logoutViewModel = LogoutViewModel()
        self.setupData()
    }
    
    private func setupData() {
        if self.logoutViewModel.errorMessage! == "It has error" {
            print(self.logoutViewModel.errorMessage ?? "error")
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
