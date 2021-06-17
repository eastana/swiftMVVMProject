//
//  RegistrationViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class RegistrationViewModel: NSObject {
    private var apiService: ApiService!
    
    private(set) var errorMessage: String! {
        didSet {
            self.bindRegistrationViewModelToController()
        }
    }
    var bindRegistrationViewModelToController: (() -> ()) = {}
    
    init(_ email: String, _ password: String) {
        super.init()
        self.apiService = ApiService()
        self.callRegistrationWithFirebase(email: email, password: password)
    }
}
extension RegistrationViewModel {
    private func callRegistrationWithFirebase(email: String, password: String) {
        self.apiService.registrationWithFirebase(email: email, password: password) { (error) in
            self.errorMessage = error
        }
    }
}
