//
//  RegistrationViewController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: RegisterViewModel = RegisterViewModel()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.applyCustomTF(placeholder: "Name")
        return textField
    }()
    
    private let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.applyCustomTF(placeholder: "Surname")
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.applyCustomTF(placeholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.applyCustomTF(placeholder: "Password")
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.applyCustomTF(placeholder: "Confirm Password")
        return textField
    }()
    
    private lazy var signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 184/255.0, green: 106/255.0, blue: 196/255.0, alpha: 0.2)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var backToLoginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstTitle: "Already have an account? ", secondTitle: "Sign in", ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        configureNotifications()
    }
    
    // MARK: - Action
    
    @objc func signUpClicked() {
        guard let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        AuthService.registerUser(withCredentials: AuthCredentials(name: name,
                                                                  surname: surname,
                                                                  email: email,
                                                                  password: password), completion: { error in
            if let error = error {
                print("DEBUG: Failed to register the user \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true)
        })
        
        
    }
    
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChanged(sender: UITextField) {
        switch sender {
        case nameTextField:
            viewModel.name = nameTextField.text
        case surnameTextField:
            viewModel.surname = surnameTextField.text
        case emailTextField:
            viewModel.email = emailTextField.text
        case passwordTextField:
            viewModel.password = passwordTextField.text
        case confirmPasswordTextField:
            viewModel.confirmPassword = confirmPasswordTextField.text
        default:
            print("Default case")
        }
        
        signUpBtn.backgroundColor = viewModel.buttonBackgroundColor
        signUpBtn.isEnabled = viewModel.formIsValid
        
    }
    
    // MARK: - Helper
    
    private func configureUi() {
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemCyan.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        let stack = UIStackView(arrangedSubviews: [nameTextField, surnameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpBtn])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 32,
        paddingRight: 32)
        
        navigationController?.navigationBar.isHidden = true
        
        
        
        view.addSubview(backToLoginBtn)
        backToLoginBtn.centerX(inView: view)
        backToLoginBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureNotifications() {
        nameTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }

}
