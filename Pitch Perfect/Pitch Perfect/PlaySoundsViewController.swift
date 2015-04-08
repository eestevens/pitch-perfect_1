//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erik Stevens on 3/17/15.
//  Copyright (c) 2015 Erik Stevens. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var receivedAudio : RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Connected Action for Chipmunk plays audio with higher pitch
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitchAndSpeed(1000, speed: 1)
    }
    
    //Connected Action for Darth Vader Button plays vader voice (lower pitch)
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitchAndSpeed(-1000, speed: 1)
    }
    
    
    //Rabbit button plays sped up audio
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariablePitchAndSpeed(0 , speed: 1.5)
        
    }
    
    
    //Snail button plays at half speed
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariablePitchAndSpeed(0 , speed: 0.5)
        
    }
    
    //Stop button stops all audio
    @IBAction func stopAudio(sender: UIButton) {
        stopAudio()
    }
    
    //Reusing code to play with different pitches and speeds
    func playAudioWithVariablePitchAndSpeed(pitch: Float, speed: Float) {
        stopAudio()
        
        //Creates audio player node and attaches it to engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Create an effect object
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = speed;
        audioEngine.attachNode(changePitchEffect)
        
        //Connect parts together
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Schedule audio file to be played at start
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //Play audio file
        audioPlayerNode.play()
    }
    
    //Stops audio
    func stopAudio() {
        audioEngine.stop()
        audioEngine.reset()
    }

}
