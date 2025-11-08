//
//  LoginViewController.swift
//  zenwallet
//
//  Created by Nguyễn Minh An on 26/10/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var googleBtnView: UIView!
    @IBOutlet weak var appleBtnView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        
        emailView.clipsToBounds = true
        passwordView.clipsToBounds = true
        loginBtn.clipsToBounds = true
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        // Todo: login logic
        UIApplication.sceneDelegate?.goToHome()
    }
}
