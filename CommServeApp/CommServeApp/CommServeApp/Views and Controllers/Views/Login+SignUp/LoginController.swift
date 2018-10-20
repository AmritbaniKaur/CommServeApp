//
//  LoginController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController
{

    var loginView : LoginViewCollection!
    var defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.cyan
        setupView()
    }
    
    func setupView()
    {
        let mainView = LoginViewCollection(frame: self.view.frame)
        self.loginView = mainView
        self.loginView.loginAction = loginPressed
        self.loginView.signupAction = signupPressed
        
        self.view.addSubview(loginView)
        loginView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginPressed()
    {
        guard let email = loginView.emailTextField.text else { return }
        guard let password = loginView.passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error
            {
                print(err.localizedDescription)
            }
            else
            {
                self.defaults.set(true, forKey: "UserIsLoggedIn")
                
                // Call Tab Bar
                let customTabController = CustomTabBarController()
                customTabController.tabBar.backgroundColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.35)

                self.navigationController?.pushViewController(customTabController, animated: true)
            }
        }
    }
    
    func signupPressed()
    {
        let signUpController = SignUpController()
        present(signUpController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


