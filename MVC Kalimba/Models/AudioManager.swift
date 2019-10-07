//
//  AudioManager.swift
//  MVC Kalimba
//
//  Created by Cassy on 8/30/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate{
    
    static let sharedInstance = AudioManager()  //singleton class
    
    private override init() { }
    
    var players = [URL: AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    func playSound(soundFileName: String) {
        guard let bundle = Bundle.main.path(forResource: soundFileName, ofType: "m4a", inDirectory: "Kalimba Sound Files") else { print("Unable to play sound"); return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)
        
        if let player = players[soundFileNameURL] {
            if !player.isPlaying {
                player.prepareToPlay()
                player.play()
            } else {
                do {
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)
                    duplicatePlayer.delegate = self
                    duplicatePlayers.append(duplicatePlayer)
                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } else { //player does not exist, create a new player
            do {
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopSound(soundFileName: String) {
        guard let bundle = Bundle.main.path(forResource: soundFileName, ofType: "m4a", inDirectory: "Kalimba Sound Files") else { print("Unable to stop sound"); return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)
        
        if let player = players[soundFileNameURL] {
            player.stop()
            for duplicate in duplicatePlayers where duplicate.url == player.url{
            duplicate.stop()
            print("Player stopped")
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
            duplicatePlayers.remove(at: index)
        }
    }
}
