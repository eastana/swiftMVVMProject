//
//  LogoutViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class LogoutViewModel: NSObject {
    private var apiService: ApiService!
    
    private(set) var errorMessage: String!
    
    override init() {
        super.init()
        self.apiService = ApiService()
        self.callLogoutWithFirebase()
    }
}
extension LogoutViewModel {
    private func callLogoutWithFirebase() {
        self.apiService.logoutWithFirebase() { (error) in
            self.errorMessage = error
        }
    }
}
