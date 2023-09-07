//
//  AuthenticationViewModel.swift
//  TaxScan
//
//  Created by Gadirli on 07.09.23.
//

import UIKit

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor(red: 184/255.0, green: 106/255.0, blue: 196/255.0, alpha: 1) : UIColor(red: 184/255.0, green: 106/255.0, blue: 196/255.0, alpha: 0.2)
    }
    
}

struct RegisterViewModel: AuthenticationViewModel {
    
    var name: String?
    var surname: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    
    var formIsValid: Bool {
        return name?.isEmpty == false && surname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && confirmPassword == password
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor(red: 184/255.0, green: 106/255.0, blue: 196/255.0, alpha: 1) : UIColor(red: 184/255.0, green: 106/255.0, blue: 196/255.0, alpha: 0.2)
    }
    
    
}
