//
//  SoundManager.swift
//  blackjack
//
//  Created by Alp Rüzgar on 1.07.2026.
//

import Foundation
import AVFoundation

@Observable
class SoundManager {
    private var players: [String: AVAudioPlayer] = [:]
    
    func load(_ filename: String) {
        let parts = filename.split(separator: ".")
        let name = String(parts[0])
        let ext = String(parts[1])
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file not found: \(filename)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            players[filename] = player
        } catch {
            print("Failed to load \(filename): \(error)")
        }
    }
    
    func play(_ filename: String) {
        guard let player = players[filename] else { return }
        player.currentTime = 0
        player.play()
    }
}
