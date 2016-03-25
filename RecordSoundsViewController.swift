//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Sailers on 3/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    var recordedAudio: RecordedAudio?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial configuration - only called once
        title = "Record"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Called each time the view loads - Show/hide elements here
        recordingLabel.text = "Tap to Record"
        stopButton.enabled = false
        recordButton.enabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.text = "Recording in Progress"
        stopButton.enabled = true
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        if let filePath = NSURL.fileURLWithPathComponents(pathArray) {
            print(filePath)
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioSession.setActive(true)
                try audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
                audioRecorder.delegate = self
            } catch {
                print("Failed to record")
            }
        }
        
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingLabel.text = " "
        stopButton.enabled = false
        recordButton.enabled = true
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false) // Deactivate the session
        } catch {
            //
        }
        
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    private struct StoryboardSegue {
        static let kSegueToPlaySounds = "segueToPlaySounds"
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            //Save the recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Perform the segue
            performSegueWithIdentifier(StoryboardSegue.kSegueToPlaySounds, sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.enabled = false
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryboardSegue.kSegueToPlaySounds {
            let destination = segue.destinationViewController as? PlaySoundsViewController
            destination?.recordedAudio = sender as? RecordedAudio
        }
    }

}
