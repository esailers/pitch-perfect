//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Sailers on 3/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var stopButton: UIButton!

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var recordedAudio: RecordedAudio?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Play"
        
        if let url = recordedAudio?.filePathURL {
            do {
                audioEngine = AVAudioEngine()
                try audioFile = AVAudioFile(forReading: url)
            } catch {
                print("Audio not available")
            }
        }
        
        stopButton.enabled = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        resetAudio()
    }
    
    // MARK: - Actions
    
    @IBAction func playAudioSlowly(sender: UIButton) {
        changeAudioTime(0.5, pitch: nil)
    }
    
    @IBAction func playAudioFast(sender: UIButton) {
        changeAudioTime(2.0, pitch: nil)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        changeAudioTime(nil, pitch: 1000.0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        changeAudioTime(nil, pitch: -1000.0)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = 80.0
        playAudioWithEffect(changeReverbEffect)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.delayTime = 1
        playAudioWithEffect(changeEchoEffect)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        resetAudio()
        
        stopButton.enabled = false
    }
    
    func changeAudioTime(time: Float?, pitch: Float?) {
        let changeEffect = AVAudioUnitTimePitch()
        if let time = time {
            changeEffect.rate = time
        }
        if let pitch = pitch {
            changeEffect.pitch = pitch
        }
        playAudioWithEffect(changeEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioNode){
        resetAudio()
        
        stopButton.enabled = true
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        do {
            try audioEngine.start()
        } catch {
            //
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioPlayerNode.play()
    }
    
    func resetAudio() {
        audioEngine.stop()
        audioEngine.reset()
    }

}
