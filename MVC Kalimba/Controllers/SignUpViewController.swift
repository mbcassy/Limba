//
//  SignUpViewController.swift
//  MVC Kalimba
//
//  Created by Cassy on 9/11/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate, RegisterViewDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    var thisView: RegisterView {
        return view as! RegisterView
    }
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = delegate.database
    }
    
    override func loadView() {
        super.loadView()
        let registerView = RegisterView()
        registerView.delegate = self
        registerView.emailText?.delegate = self
        registerView.passwordText?.delegate = self
        view = registerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        thisView.emailText?.underline()
        thisView.passwordText?.underline()
    }
    
    //possible memory leak
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
    
    //MARK: - RegisterViewDelegate
    func didRegister(_ registerView: RegisterView, email emailText: UITextField?, password passwordText: UITextField?) {
        guard let email = emailText?.text , let password = passwordText?.text, email.count > 0, password.count > 0 else{
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            guard let _ = authResult?.user, error == nil else {
            let failAlert = UIAlertController(title: "SignUp Failed", message: error?.localizedDescription, preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failAlert, animated: true, completion: nil)
                return
            }
            // Add a new document with a generated ID
            var ref: DocumentReference? = nil
            self.db.collection("users").document(email).setData(["username": email]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    ref = self.db.collection("users").document(email)
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            let loginToPlay = HomeViewController()
            loginToPlay.modalPresentationStyle = .fullScreen
            OrientationLocks.lockOrientation(.landscape)
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let signInError = error, user == nil{
                    let failAlert = UIAlertController(title: "SignIn Failed", message: signInError.localizedDescription, preferredStyle: .alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(failAlert, animated: true, completion: nil)
                }
                else {
                    self.show(loginToPlay, sender: self)
                }
            }
        }
    }
    
    func didPressToPlay(){
        let justPlay = HomeViewController()
        justPlay.modalPresentationStyle = .fullScreen
        OrientationLocks.lockOrientation(.landscape)
        show(justPlay, sender: self)
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
