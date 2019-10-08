//  ViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var keys : [KeyView] = []
    weak var logoutButton: UIButton?
   
    override func loadView() {
        super.loadView()
        var newView : KeyView
        var newButton : KeyButton
        
        newButton = KeyButton(frame: .zero, key: KeyButton.note[0])
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.tag = 1
        newView = KeyView(frame: .zero, keyButton: newButton)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.tag = 21
        self.view.addSubview(newView)
        constrainFirst(with: newView, and: newButton, to: self.view, heightMult: 55.0/138.0, widthMult: 10.0/219.0)
        keys.append(newView)
        
        let logout = UIButton(frame: .zero)
        logout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logout)
        NSLayoutConstraint.activate([logout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5.0/64.0),
                                     logout.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 25.0/207.0),
                                     logout.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
                                     logout.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)])
        logoutButton = logout
        for button in 1 ... 8{
            newButton = KeyButton(frame: .zero, key: KeyButton.note[button])
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.tag = button + 1
            newView = KeyView(frame: .zero, keyButton: newButton)
            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.tag = 21 + button
            self.view.addSubview(newView)
            constrainOthers(with: newView, and: newButton, to: keys[button - 1], heightMult: 12.0/11.0, leftAnchor: 10)
            keys.append(newView)
        }
        
        for button in 9 ... 16{
            newButton = KeyButton(frame: .zero, key: KeyButton.note[button])
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.tag = button + 1
            newView = KeyView(frame: .zero, keyButton: newButton)
            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.tag = 21 + button
            self.view.addSubview(newView)
            constrainOthers(with: newView, and: newButton, to: keys[button - 1], heightMult: 268.0/285.0, leftAnchor: 8)
            keys.append(newView)
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
    
    private func constrainFirst(with keyView: KeyView, and keyButton: KeyButton, to: UIView, heightMult: CGFloat, widthMult: CGFloat = 1.0){
        NSLayoutConstraint.activate([keyView.heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: heightMult),
                                     keyView.widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: widthMult),
                                     keyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                     keyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                     keyButton.heightAnchor.constraint(equalTo: keyView.heightAnchor),
                                     keyButton.widthAnchor.constraint(equalTo: keyView.widthAnchor),
                                     keyButton.topAnchor.constraint(equalTo: keyView.topAnchor),
                                     keyButton.leftAnchor.constraint(equalTo: keyView.leftAnchor)])
    }
    
    private func constrainOthers(with keyView: KeyView, and keyButton: KeyButton, to: UIView, heightMult: CGFloat, leftAnchor: CGFloat){
        NSLayoutConstraint.activate([keyView.heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: heightMult),
                                     keyView.widthAnchor.constraint(equalTo: to.widthAnchor),
                                     keyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                     keyView.leftAnchor.constraint(equalTo: to.rightAnchor, constant: leftAnchor),
                                     keyButton.heightAnchor.constraint(equalTo: keyView.heightAnchor),
                                     keyButton.widthAnchor.constraint(equalTo: keyView.widthAnchor),
                                     keyButton.topAnchor.constraint(equalTo: keyView.topAnchor),
                                     keyButton.leftAnchor.constraint(equalTo: keyView.leftAnchor)])
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
