//
//  RegisterView.swift
//  MVC Kalimba
//
//  Created by Cassy on 4/14/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    weak var emailText : UITextField?
    weak var passwordText : UITextField?
    weak var signUpText: UILabel?
    weak var registerButton: UIButton?
    weak var justPlay: UIButton?
    var delegate: RegisterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func createSubviews() {
        let signUpText = UILabel(frame: .zero)
        signUpText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signUpText)
        constrain(this: signUpText, toFirst: self, toSecond: self, width: 200.0/207.0, height: 50.0/219.0, left: 14, top: 20)
        self.signUpText = signUpText
        
        let email = UITextField(frame: .zero)
        email.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(email)
        constrain(this: email, toFirst: self, toSecond: signUpText, width: 50.0/69.0, height: 25.0/438.0, left: 8, top: 25)
        emailText = email
        
        let password = UITextField(frame: .zero)
        password.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(password)
        constrainOthers(this: password, toFirst: email, toSecond: email, toThird: email, top: 15)
        passwordText = password

        let register = UIButton(frame: .zero)
        register.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(register)
        constrainOthers(this: register, toFirst: self, toSecond: signUpText, toThird: password, width: 50.0/207.0, height: 65.0/876.0, left: 45, top: 25)
        registerButton = register

        let byPassLogin = UIButton(frame: .zero)
        byPassLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(byPassLogin)
        constrainOthers(this: byPassLogin, toFirst: self, toSecond: register, toThird: register, width: 50.0/207.0, height: 55.0/876.0, left: 55, top: 20)
        justPlay = byPassLogin
    }
    
    private func setUpView() {
        self.backgroundColor = .babyPeach
        signUpText?.adjustsFontSizeToFitWidth = true
        signUpText?.font = UIFont(name: "HelveticaNeue-Light", size: 70)
        signUpText?.text = "SignUp"
        signUpText?.textColor = .white
        emailText?.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailText?.borderStyle = .none
        emailText?.adjustsFontSizeToFitWidth = true
        emailText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        passwordText?.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordText?.borderStyle = .none
        passwordText?.adjustsFontSizeToFitWidth = true
        passwordText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        passwordText?.isSecureTextEntry = true
        registerButton?.setTitle("Register", for: .normal)
        registerButton?.setTitleColor(.white, for: .normal)
        registerButton?.backgroundColor = .babyLavender
        registerButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 33)
        registerButton?.addTarget(self, action: #selector(registerUser(_:)), for: .touchUpInside)
        registerButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        justPlay?.setTitle("Just Play!", for: .normal)
        justPlay?.setTitleColor(.white, for: .normal)
        justPlay?.backgroundColor = .babyLavender
        justPlay?.titleLabel?.adjustsFontSizeToFitWidth = true
        justPlay?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        justPlay?.addTarget(self, action: #selector(toPlay(_:)), for: .touchUpInside)
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        self.delegate?.didRegister(email: emailText, password: passwordText)
    }
    
    @IBAction func toPlay(_ sender: UIButton) {
        self.delegate?.didPressToPlay()
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
