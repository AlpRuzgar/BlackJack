//
//  SoundManager.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import AVFoundation
import Observation

@Observable
class SoundManager {
    static let shared = SoundManager()

    private var players: [String: AVAudioPlayer] = [:]

    func load(_ filename: String) {
        let base = (filename as NSString).deletingPathExtension
        let ext  = (filename as NSString).pathExtension
        guard let url = Bundle.main.url(forResource: base, withExtension: ext.isEmpty ? nil : ext) else { return }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
        player.prepareToPlay()
        players[filename] = player
    }

    func play(_ filename: String) {
        players[filename]?.play()
    }

    func playImportedEffect(named name: String) {
        for ext in ["mp3", "wav", "aif", "caf", "m4a"] {
            let key = "\(name).\(ext)"
            if let player = players[key] {
                player.currentTime = 0
                player.play()
                return
            }
            if let url = Bundle.main.url(forResource: name, withExtension: ext) {
                guard let player = try? AVAudioPlayer(contentsOf: url) else { continue }
                player.prepareToPlay()
                players[key] = player
                player.play()
                return
            }
        }
    }
}
