//  ViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    weak var logoutButton: UIButton?
    weak var keyStackView: UIStackView?
   
    override func loadView() {
        super.loadView()
        var newButton : KeyButton
        setUpStackView()
        newButton = KeyButton(frame: .zero, key: KeyButton.note[0])
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.tag = 1
        
        let logout = UIButton(frame: .zero)
        logout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logout)
        NSLayoutConstraint.activate([logout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5.0/64.0),
                                     logout.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 25.0/207.0),
                                     logout.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
                                     logout.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)])
        logoutButton = logout
        
        for button in 1 ... 16{
            newButton = KeyButton(frame: .zero, key: KeyButton.note[button])
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.tag = button + 1
            keyStackView?.addArrangedSubview(newButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
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
    
    private func setUpMainView(){
        self.view.backgroundColor = .babyPeach
        logoutButton?.backgroundColor = .babyLavender
        logoutButton?.setTitle("LogOut", for: .normal)
        logoutButton?.setTitleColor(.white, for: .normal)
        logoutButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        logoutButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        logoutButton?.addTarget(self, action: #selector(logoutPressed(_:)), for: .touchUpInside)
        logoutButton?.isHidden = true
    }
    
    private func setUpStackView(){
        let stackViewKeys = UIStackView(frame: .zero)
        stackViewKeys.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackViewKeys)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([stackViewKeys.leadingAnchor.constraint(equalTo: margins.leadingAnchor), stackViewKeys.trailingAnchor.constraint(equalTo: margins.trailingAnchor)])
               
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                stackViewKeys.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: stackViewKeys.bottomAnchor, multiplier: 1.0)
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                stackViewKeys.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: stackViewKeys.bottomAnchor, constant: standardSpacing)
            ])
        }
        
        stackViewKeys.distribution = .fillEqually
        stackViewKeys.spacing = 8.0
        keyStackView = stackViewKeys
    }
    
    @IBAction func logoutPressed(_ sender: UIButton){
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
