//
//  LoginView.swift
//  MVC Kalimba
//
//  Created by Cassy on 4/10/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit

class HomeView: UIView {
    weak var keyStackView: UIStackView?
    weak var logoutButton: UIButton?
    var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        setUpMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSubviews() {
        var newButton : KeyButton
               setUpStackView()
               newButton = KeyButton(frame: .zero, key: KeyButton.note[0])
               newButton.translatesAutoresizingMaskIntoConstraints = false
               newButton.tag = 1
               
               let logout = UIButton(frame: .zero)
               logout.translatesAutoresizingMaskIntoConstraints = false
               self.addSubview(logout)
               NSLayoutConstraint.activate([logout.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 5.0/64.0),
                                            logout.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 25.0/207.0),
                                            logout.bottomAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
                                            logout.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor)])
               logoutButton = logout
               
               for button in 1 ... 16{
                   newButton = KeyButton(frame: .zero, key: KeyButton.note[button])
                   newButton.translatesAutoresizingMaskIntoConstraints = false
                   newButton.tag = button + 1
                   keyStackView?.addArrangedSubview(newButton)
               }
    }
    
    private func setUpStackView(){
           let stackViewKeys = UIStackView(frame: .zero)
           stackViewKeys.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(stackViewKeys)
           let margins = self.layoutMarginsGuide
           NSLayoutConstraint.activate([stackViewKeys.leadingAnchor.constraint(equalTo: margins.leadingAnchor), stackViewKeys.trailingAnchor.constraint(equalTo: margins.trailingAnchor)])
                  
           if #available(iOS 11, *) {
               let guide = self.safeAreaLayoutGuide
               NSLayoutConstraint.activate([
                   stackViewKeys.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                   guide.bottomAnchor.constraint(equalToSystemSpacingBelow: stackViewKeys.bottomAnchor, multiplier: 1.0)
               ])
           } else {
               let standardSpacing: CGFloat = 8.0
               NSLayoutConstraint.activate([
                stackViewKeys.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: standardSpacing),
                self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackViewKeys.bottomAnchor, constant: standardSpacing)
               ])
           }
           
           stackViewKeys.distribution = .fillEqually
           stackViewKeys.spacing = 8.0
           keyStackView = stackViewKeys
    }
    
    private func setUpMainView(){
           self.backgroundColor = .babyPeach
           logoutButton?.backgroundColor = .babyLavender
           logoutButton?.setTitle("LogOut", for: .normal)
           logoutButton?.setTitleColor(.white, for: .normal)
           logoutButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
           logoutButton?.titleLabel?.adjustsFontSizeToFitWidth = true
           logoutButton?.addTarget(self, action: #selector(logoutPressed(_:)), for: .touchUpInside)
           logoutButton?.isHidden = true
    }
    
    @IBAction func logoutPressed(_ sender: UIButton){
        self.delegate?.logoutButtonPressed()
    }
}
