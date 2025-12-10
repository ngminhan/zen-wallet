//
//  ProfileViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editProfileContainerView: UIView!
    @IBOutlet weak var fixedTransactionContainerView: UIView!
    @IBOutlet weak var settingContainerView: UIView!
    @IBOutlet weak var supportContainerView: UIView!
    @IBOutlet weak var aboutUsContainerView: UIView!
    @IBOutlet weak var logOutContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        editProfileContainerView.layer.cornerRadius = editProfileContainerView.frame.height / 2
        fixedTransactionContainerView.layer.cornerRadius = fixedTransactionContainerView.frame.height / 2
        settingContainerView.layer.cornerRadius = settingContainerView.frame.height / 2
        supportContainerView.layer.cornerRadius = supportContainerView.frame.height / 2
        aboutUsContainerView.layer.cornerRadius = aboutUsContainerView.frame.height / 2
        logOutContainerView.layer.cornerRadius = logOutContainerView.frame.height / 2
    }
    
}
