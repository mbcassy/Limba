//
//  LoginViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 9/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    weak var emailText : UITextField?
    weak var passwordText : UITextField?
    weak var signInText: UILabel?
    weak var justPlay: UIButton?
    weak var loginButton: UIButton?
    weak var registerButton: UIButton?
    
    var handle: AuthStateDidChangeListenerHandle?

    override func loadView() {
        super.loadView()
      
        let signInText = UILabel(frame: .zero)
        signInText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInText)
        constrain(this: signInText, toFirst: view, toSecond: view, width: 200.0/207.0, height: 50.0/219.0, left: 14, top: 20)
        self.signInText = signInText
        
        let email = UITextField(frame: .zero)
        email.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(email)
        constrain(this: email, toFirst: view, toSecond: signInText, width: 50.0/69.0, height: 25.0/438.0, left: 8, top: 25)
        emailText = email
        
        let password = UITextField(frame: .zero)
        password.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(password)
        constrainOthers(this: password, toFirst: email, toSecond: email, toThird: email, top: 15)
        passwordText = password
        passwordText?.isSecureTextEntry = true

        let login = UIButton(frame: .zero)
        login.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(login)
        constrainOthers(this: login, toFirst: view, toSecond: signInText, toThird: password, width: 50.0/207.0, height: 65.0/867.0, left: 40, top: 25)
        loginButton = login

        let register = UIButton(frame: .zero)
        register.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(register)
        constrainOthers(this: register, toFirst: view, toSecond: view, toThird: login, width: 50.0/207.0, height: 55.0/876.0, left: 80, top: 30)
       //(this: register, toFirst: view, toSecond: login, width: 50.0/207.0, height: 55.0/876.0, left: 10, top: 10.75)
        registerButton = register

        let byPassLogin = UIButton(frame: .zero)
        byPassLogin.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(byPassLogin)
        constrainOthers(this: byPassLogin, toFirst: view, toSecond: register, toThird: login, width: 50.0/207.0, height: 55.0/876.0, left: 150, top: 30)
        justPlay = byPassLogin
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        passwordText?.underline()
        emailText?.underline()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil{
                self.emailText?.text = nil
                self.passwordText?.text = nil
            }
        }
        OrientationLocks.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        OrientationLocks.lockOrientation(.all)
    }
    
    private func setUpView(){
        self.view.backgroundColor = .babyPeach
        signInText?.adjustsFontSizeToFitWidth = true
        signInText?.font = UIFont(name: "HelveticaNeue-Light", size: 70)
        signInText?.text = "SignIn"
        signInText?.textColor = .white
        emailText?.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailText?.borderStyle = .none
        emailText?.adjustsFontSizeToFitWidth = true
        emailText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        emailText?.delegate = self
        passwordText?.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordText?.borderStyle = .none
        passwordText?.adjustsFontSizeToFitWidth = true
        passwordText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        passwordText?.delegate = self
        justPlay?.setTitle("Just Play!", for: .normal)
        justPlay?.setTitleColor(.white, for: .normal)
        justPlay?.backgroundColor = .babyLavender
        justPlay?.titleLabel?.adjustsFontSizeToFitWidth = true
        justPlay?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        justPlay?.addTarget(self, action: #selector(toPlay(_:)), for: .touchUpInside)
        loginButton?.setTitle("Login", for: .normal)
        loginButton?.setTitleColor(.white, for: .normal)
        loginButton?.backgroundColor = .babyLavender
        loginButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        loginButton?.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        registerButton?.setTitle("Register", for: .normal)
        registerButton?.setTitleColor(.white, for: .normal)
        registerButton?.backgroundColor = .babyLavender
        registerButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        registerButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        registerButton?.addTarget(self, action: #selector(registerPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func toPlay(_ sender: UIButton){
        let justPlay = HomeViewController()
        justPlay.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.landscape)
        show(justPlay, sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        let loginToPlay = HomeViewController()
        loginToPlay.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.landscape)

        guard let email = emailText?.text , let password = passwordText?.text, email.count > 0, password.count > 0 else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){ (user, error) in
            if let signInError = error, user == nil{
                let failAlert = UIAlertController(title: "SignIn Failed", message: signInError.localizedDescription, preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failAlert, animated: true, completion: nil)
            }
            else{
                self.show(loginToPlay, sender: self)
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton){
        let register = SignUpViewController()
        register.modalPresentationStyle = .fullScreen
        showDetailViewController(register, sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText{
            passwordText?.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func constrain(this: UIView, toFirst: UIView, toSecond: UIView, width: CGFloat, height: CGFloat, left: CGFloat, top: CGFloat){
        NSLayoutConstraint.activate([this.widthAnchor.constraint(equalTo: toFirst.widthAnchor, multiplier: width),
                                     this.heightAnchor.constraint(equalTo: toFirst.heightAnchor, multiplier: height),
                                     this.leftAnchor.constraint(equalToSystemSpacingAfter: toFirst.leftAnchor, multiplier: left),
                                     this.topAnchor.constraint(equalToSystemSpacingBelow: toSecond.topAnchor, multiplier: top)
        ])
    }
    
    private func constrainOthers(this: UIView, toFirst: UIView, toSecond: UIView, toThird: UIView, width: CGFloat = 1.0, height: CGFloat = 1.0, left: CGFloat = 0.0, top: CGFloat = 0.0 ){
        NSLayoutConstraint.activate([this.widthAnchor.constraint(equalTo: toFirst.widthAnchor, multiplier: width),
                                     this.heightAnchor.constraint(equalTo: toFirst.heightAnchor, multiplier: height),
                                     this.leftAnchor.constraint(equalTo: toSecond.leftAnchor, constant: left),
                                     this.topAnchor.constraint(equalTo: toThird.bottomAnchor, constant: top)])
    }
}
