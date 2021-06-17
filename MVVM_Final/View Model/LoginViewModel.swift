//
//  LoginViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class LoginViewModel: NSObject {
    private var apiService: ApiService!
    
    private(set) var errorMessage: String! {
        didSet {
            self.bindLoginViewModelToController()
        }
    }
    
    var bindLoginViewModelToController: (() -> ()) = {}
    
    init(_ email: String, _ password: String) {
        super.init()
        self.apiService = ApiService()
        self.callLoginWithFirebase(email: email, password: password)
    }
}
extension LoginViewModel {
    private func callLoginWithFirebase(email: String, password: String) {
        self.apiService.loginWithFirebase(email: email, password: password) { (error) in
            self.errorMessage = error
        }
     }
}
