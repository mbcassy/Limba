//
//  HomeViewDelegate.swift
//  MVC Kalimba
//
//  Created by Cassy on 4/11/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func logoutButtonPressed()
}

protocol LoginViewDelegate: AnyObject {
    func didPressToPlay()
    func didLogin(_ loginView: LoginView, email emailText: UITextField?, password passwordText: UITextField?)
    func didPressRegister()
}

protocol RegisterViewDelegate: AnyObject {
    func didPressToPlay()
    func didRegister(_ registerView: RegisterView, email emailText: UITextField?, password passwordText: UITextField?)
}
