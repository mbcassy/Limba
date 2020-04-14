//  ViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.

import UIKit
import Firebase

class HomeViewController: UIViewController, HomeViewDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    weak var logoutButton: UIButton?
    weak var keyStackView: UIStackView?
   
    override func loadView() {
        super.loadView()
        let homeView = HomeView()
        homeView.delegate = self
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateDevice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil{
                self.logoutButton?.isHidden = false
            }
        }
        OrientationLocks.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        OrientationLocks.lockOrientation(.all)
    }
    
    func rotateDevice(){
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true) 
    }
    
    //MARK: - HomeViewDelegate
    
    func logoutButtonPressed() {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }
        catch let logoutError as NSError{
            print("Error signing out: \(logoutError)")
            let failAlert = UIAlertController(title: "LogOut Failed", message: logoutError.localizedDescription, preferredStyle: .alert)
            failAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(failAlert, animated: true, completion: nil)
        }
        let login = LoginViewController()
        login.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.portrait)
        show(login, sender: self)
    }
}
