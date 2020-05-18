//
//  LoginView.swift
//  MVC Kalimba
//
//  Created by Cassy on 4/14/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit

class LoginView: UIView {
    weak var emailText: UITextField?
    weak var passwordText: UITextField?
    weak var signInText: UILabel?
    weak var justPlay: UIButton?
    weak var loginButton: UIButton?
    weak var registerButton: UIButton?
    weak var loginViewDelegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createSubviews(){
        let signInText = UILabel(frame: .zero)
        signInText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signInText)
        constrain(this: signInText, toFirst: self, toSecond: self, width: 200.0/207.0, height: 50.0/219.0, left: 14, top: 20)
        self.signInText = signInText
        
        let email = UITextField(frame: .zero)
        email.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(email)
        constrain(this: email, toFirst: self, toSecond: signInText, width: 50.0/69.0, height: 25.0/438.0, left: 8, top: 25)
        emailText = email
        
        let password = UITextField(frame: .zero)
        password.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(password)
        constrainOthers(this: password, toFirst: email, toSecond: email, toThird: email, top: 15)
        passwordText = password
        passwordText?.isSecureTextEntry = true
        
        let login = UIButton(frame: .zero)
        login.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(login)
        constrainOthers(this: login, toFirst: self, toSecond: signInText, toThird: password, width: 50.0/207.0, height: 65.0/867.0, left: 40, top: 25)
        loginButton = login
        
        let register = UIButton(frame: .zero)
        register.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(register)
        constrainOthers(this: register, toFirst: self, toSecond: self, toThird: login, width: 50.0/207.0, height: 55.0/876.0, left: 80, top: 30)
        registerButton = register
        
        let byPassLogin = UIButton(frame: .zero)
        byPassLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(byPassLogin)
        constrainOthers(this: byPassLogin, toFirst: self, toSecond: register, toThird: login, width: 50.0/207.0, height: 55.0/876.0, left: 150, top: 30)
        justPlay = byPassLogin
    }
    
    private func setUpView(){
        self.backgroundColor = .babyPeach
        signInText?.adjustsFontSizeToFitWidth = true
        signInText?.font = UIFont(name: "HelveticaNeue-Light", size: 70)
        signInText?.text = "SignIn"
        signInText?.textColor = .white
        emailText?.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailText?.borderStyle = .none
        emailText?.adjustsFontSizeToFitWidth = true
        emailText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        passwordText?.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordText?.borderStyle = .none
        passwordText?.adjustsFontSizeToFitWidth = true
        passwordText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
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
        self.loginViewDelegate?.didPressToPlay()
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        self.loginViewDelegate?.didLogin(self, email: emailText, password: passwordText)
    }
    
    @IBAction func registerPressed(_ sender: UIButton){
        self.loginViewDelegate?.didPressRegister()
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
