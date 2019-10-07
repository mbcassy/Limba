//
//  KeyButton.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit

class KeyButton : UIButton{
    
    static let note = ["D6", "B5", "G5", "E5", "C5", "A4", "F4", "D4", "C4", "E4", "G4", "B4", "D5", "F5", "A5", "C6", "E6"]
    static let noteNames = Notes()
    
    init(frame: CGRect, key: String) {
        super.init(frame: frame)
        setUpButton(forKey: key)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUpButton(forKey key: String) {
        backgroundColor = .goldenYellow
        setTitle(key, for: .normal)
        setTitleColor(.black, for: .normal)
        setTitleColor(.opaqueBlack, for: .highlighted)
        addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func keyPressed(_ sender: UIButton){
        AudioManager.sharedInstance.playSound(soundFileName: KeyButton.noteNames.sounds[sender.tag - 1])
    }
}
