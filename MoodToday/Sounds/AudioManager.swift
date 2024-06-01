//
//  AudioManager.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 5/6/23.
//

import Foundation
import AVFoundation
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private init() {
        let clock = ContinuousClock()
        print("loadSFX: \(clock.measure(loadSFX))")
        print("loadSongs: \(clock.measure(loadSongs))")
    }
    enum SFXTag: String, CaseIterable {
        case completeSFX = "CompleteSFXMood"
        case deleteSFX = "deleteSFXMood"
        case leftTap = "LowPop"
        case rightTap = "HighPop"
    }
    
    var musicPlayer: AVAudioPlayer?
    var songList = [String : URL]()
    var soundEffects = [SFXTag : URL]()
    var soundPlayers = [String: AVAudioPlayer]()

    @Published var sfxVolume: Float = 1.0 {
        didSet {
            for player in soundPlayers.values {
                player.volume = sfxMute ? 0 : sfxVolume
            }
        }
    }

    @Published var musicVolume: Float = 1.0 {
        didSet {
            musicPlayer?.volume = musicMute ? 0 : musicVolume
            print("Mute : \(musicMute)")
        }
    }

    @Published var sfxMute: Bool = false {
        didSet {
            for player in soundPlayers.values {
                player.volume = sfxMute ? 0 : sfxVolume
            }
        }
    }

    @Published var musicMute: Bool = false {
        didSet {
            musicPlayer?.volume = musicMute ? 0 : musicVolume
        }
    }

  
    func playMusic(_ songName: String, after seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.playMusic(songName)
        }
    }

    func playSFX(_ SFX: SFXTag, after seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.playSFX(SFX)
        }
    }

    private func loadSFX() {
        //I (main thread) give the task to the manager (background thread)
        DispatchQueue.global().async{ [weak self] in //make sure they know that I might move on without them
            let lock = NSLock() //this is the master lock so that the interns take turns
            let concurrentQueue = DispatchQueue(label: "loadsfx.concurrent.queue", attributes: .concurrent) //queue the interns
            
            for sound in SFXTag.allCases {
                concurrentQueue.async { [weak self] in //give one task to each intern
                    print("Started \(sound.rawValue)")
                    let url = AudioManager.soundURL(sound.rawValue)//intern does slow work on their own time
                    do {
                        let player = try AVAudioPlayer(contentsOf: url)//intern does slow work on their own time
                        lock.lock() //the intern claims the dictionary
                        self?.soundPlayers[sound.rawValue] = player //stores their answer
                        lock.unlock() //the intern returns the dictionary
                    } catch {
                        print("Error loading sound effect: \(sound.rawValue). Error: \(error)")
                    }
                    print("Finished \(sound.rawValue)")
                }
            }
        }
    }
    private func loadSongs() {
        songList = [:]
    }


    func playSFX(_ tag: SFXTag) {
        guard let player = soundPlayers[tag.rawValue] else {
            print("Error: Sound effect player not found for tag '\(tag)'")
            return
        }

        player.volume = sfxMute ? 0 : sfxVolume
        player.currentTime = 0
        player.play()
    }
    
    
    func pauseMusic() {
        musicPlayer?.pause()
    }

    func resumeMusic() {
        musicPlayer?.play()
    }
    
    func playMusic(_ name: String) {
        if let url = songList[name] {
            print("Playing music: \(name)")
            do {
                if musicPlayer == nil {
                    musicPlayer = try AVAudioPlayer(contentsOf: url)
                } else {
                    musicPlayer?.stop()
                    musicPlayer = try AVAudioPlayer(contentsOf: url)
                }
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.prepareToPlay()
                musicPlayer?.volume = musicMute ? 0 : musicVolume
                musicPlayer?.play()
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        } else {
            print("Error: unable to load music file.")
        }
    }


    static func soundURL(_ name: String) -> URL {
        let defaultExt = "mp3"
        var finalExt = defaultExt
        var components = name.components(separatedBy: ".")
        if components.count > 1, let ext = components.popLast()?.lowercased() {
            finalExt = ext
        }
        let fileName = components.joined(separator: ".")
        guard let url = Bundle.main.url(forResource: fileName, withExtension: finalExt) else {
            fatalError("Could not find sound file: \(fileName).\(finalExt)")
        }
        return url
    }
}
