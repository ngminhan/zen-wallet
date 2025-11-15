//
//  SignUpViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setupUI()
        }
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 50
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        
        emailView.layer.cornerRadius = emailView.frame.height / 2
        passwordView.layer.cornerRadius = passwordView.frame.height / 2
        confirmPasswordView.layer.cornerRadius = passwordView.frame.height / 2
        userNameView.layer.cornerRadius = userNameView.frame.height / 2
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        
        emailView.clipsToBounds = true
        passwordView.clipsToBounds = true
        signUpButton.clipsToBounds = true
        confirmPasswordView.clipsToBounds = true
        userNameView.clipsToBounds = true
        
        passwordTextfield.isSecureTextEntry = true
        confirmPasswordTextfield.isSecureTextEntry = true
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        print("🔹 signUpBtnTapped called")
        
        guard let name = userNameTextField.text, !name.isEmpty,
              let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextfield.text, !confirmPassword.isEmpty else {
            return
        }
        
        guard password == confirmPassword else {
            showAlert("Confirm password is not correct")
            return
        }
        
        viewModel.signup(name: name, email: email, password: password) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print("Successed signup:", user.name)
                    UserDefaults.standard.set(user.token, forKey: "authToken")
                    UIApplication.sceneDelegate?.goToHome()
                }
            case .failure(let error):
                print("Failed to login:", error.localizedDescription)
            }
        }
    }
    
    private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        UIApplication.sceneDelegate?.goToLogin()
    }
}
