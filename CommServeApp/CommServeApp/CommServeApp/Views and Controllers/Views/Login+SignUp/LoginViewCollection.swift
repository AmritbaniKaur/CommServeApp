//
//  LoginViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class LoginViewCollection: UIView
{
    var loginAction: (() -> Void)?
    var signupAction: (() -> Void)?
    
    let backgroundImageView: UIImageView =
    {
        let img = UIImageView()
        img.image = UIImage(named: "Background10")
        img.contentMode = .scaleToFill
        return img
    }()
    
    let emailTextField: UITextField =
    {
        let tf = UITextField(title: "Email", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        return tf
    }()
    
    let passwordTextField: UITextField =
    {
        let tf = UITextField(title: "Password", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton =
    {
        let button = UIButton(title: "Login", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    let signUpButton: UIButton =
    {
        let button = UIButton(title: "Sign Up", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    @objc func handleLogin()
    {
        loginAction?()
    }
    
    @objc func handleSignUp()
    {
        signupAction?()
    }
    
    func setupView()
    {
        let stackView = createStackView(views: [emailTextField, passwordTextField, loginButton, signUpButton])
        
        addSubview(backgroundImageView)
        addSubview(stackView)
        
        backgroundImageView.setAnchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        stackView.setAnchor(width: self.frame.width - 150, height: 150)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
