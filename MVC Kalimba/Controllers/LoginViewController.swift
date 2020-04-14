//
//  LoginViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 9/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController , UITextFieldDelegate, LoginViewDelegate {

    var thisView: LoginView {
        return view as! LoginView
    }
    
    var handle: AuthStateDidChangeListenerHandle?

    override func loadView() {
        super.loadView()
        let loginView = LoginView()
        loginView.loginViewDelegate = self
        loginView.emailText?.delegate = self
        loginView.passwordText?.delegate = self
        view = loginView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        thisView.passwordText?.underline()
        thisView.emailText?.underline()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil{
                self.thisView.emailText?.text = nil
                self.thisView.passwordText?.text = nil
            }
        }
        OrientationLocks.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        OrientationLocks.lockOrientation(.all)
    }
    //MARK: - LoginViewDelegate

    func didPressToPlay() {
        let justPlay = HomeViewController()
        justPlay.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.landscape)
        show(justPlay, sender: self)
    }
        
    func didLogin(email emailText: UITextField?, password passwordText: UITextField?) {
        let loginToPlay = HomeViewController()
        loginToPlay.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.landscape)

        guard let email = emailText?.text , let password = passwordText?.text, email.count > 0, password.count > 0 else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){ (user, error) in
            if let signInError = error, user == nil {
                let failAlert = UIAlertController(title: "SignIn Failed", message: signInError.localizedDescription, preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failAlert, animated: true, completion: nil)
            }
            else {
                self.show(loginToPlay, sender: self)
            }
        }
    }
    
    func didPressRegister(){
        let register = SignUpViewController()
        register.modalPresentationStyle = .fullScreen
        showDetailViewController(register, sender: self)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == thisView.emailText {
            thisView.passwordText?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
}
