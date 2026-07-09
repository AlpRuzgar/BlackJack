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

    // MARK: - Properties

    private var players: [String: AVAudioPlayer] = [:]
    private var lastPlayTime: [String: TimeInterval] = [:]
    // Rapid chip taps can hammer AVAudioPlayer hard enough to freeze the game;
    // skip any duplicate sound triggered within this window.
    private let throttleInterval: TimeInterval = 0.05

    // MARK: - Init

    init() {
        // .ambient lets the app mix with background media (Music, podcasts, etc.)
        // instead of taking over the audio session on launch.
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // MARK: - Loading

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

    // MARK: - Playback

    func play(_ filename: String) {
        guard let player = players[filename] else { return }
        let now = Date().timeIntervalSinceReferenceDate
        if let last = lastPlayTime[filename], now - last < throttleInterval {
            return
        }
        lastPlayTime[filename] = now
        player.currentTime = 0
        player.play()
    }
}
