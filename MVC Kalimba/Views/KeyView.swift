//
//  KeyView.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit

class KeyView : UIView {
    
    static let noteNames = Notes()
    weak var keyButton : KeyButton?
    
    init(frame: CGRect, keyButton: KeyButton) {
        self.keyButton = keyButton
        super.init(frame: frame)
        setUpView()
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deallocating KeyButton.")
    }
    
    private func setUpView(){
        backgroundColor = .white
        guard let addedButton = keyButton else{ return }
        self.addSubview(addedButton)
        let leftSwipeKey = UISwipeGestureRecognizer(target: self, action: #selector(keySwiped(_:)))
        let rightSwipeKey = UISwipeGestureRecognizer(target: self, action: #selector(keySwiped(_:)))
        let upSwipeKey = UISwipeGestureRecognizer(target: self, action: #selector(keyStop(_:)))
        leftSwipeKey.direction = .left
        rightSwipeKey.direction = .right
        upSwipeKey.direction = .up
        addGestureRecognizer(rightSwipeKey)
        addGestureRecognizer(leftSwipeKey)
        addGestureRecognizer(upSwipeKey)
    }
    
    @objc func keySwiped(_ sender: UISwipeGestureRecognizer){
        guard let viewIndex = sender.view?.tag else{ return }
        AudioManager.sharedInstance.playSound(soundFileName: KeyView.noteNames.sounds[viewIndex - 21])
        print("button swiped")
    }
    
    @objc func keyStop(_ sender: UISwipeGestureRecognizer){
        guard let viewIndex = sender.view?.tag else{ return }
        AudioManager.sharedInstance.stopSound(soundFileName: KeyView.noteNames.sounds[viewIndex - 21])
        print("note stopped playing")
    }
}
