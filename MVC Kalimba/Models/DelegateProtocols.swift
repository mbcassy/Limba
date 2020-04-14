//
//  HomeViewDelegate.swift
//  MVC Kalimba
//
//  Created by Cassy on 4/11/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit

protocol HomeViewDelegate {
    func logoutButtonPressed()
}

protocol LoginViewDelegate {
    func didPressToPlay()
    func didLogin(email emailText: UITextField?, password passwordText: UITextField?)
    func didPressRegister()
}

protocol RegisterViewDelegate {
    func didPressToPlay()
    func didRegister(email emailText: UITextField?, password passwordText: UITextField?)
}
