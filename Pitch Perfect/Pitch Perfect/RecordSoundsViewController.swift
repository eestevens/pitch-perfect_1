//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erik Stevens on 3/10/15.
//  Copyright (c) 2015 Erik Stevens. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    //Declaring global variables to use
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //Reset Button and label values
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.hidden = false
        recordingInProgress.text = "tap to record"
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        //Set Button values to recording state
        recordingInProgress.text = "recording"
        stopButton.hidden = false
        recordButton.enabled = false
        
        //Creating date format to name recorded audio file
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        //Saving Audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        //Start recording!
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //If audio was recorded successfully, switch to play sounds view controller
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl : recorder.url, title: recorder.url.lastPathComponent!)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else { //If not, stay on this screen
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    //When we're transitioning to other screen, pass recorded audio object
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    //Stops Audio from recording
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        stopButton.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

