//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pieri Laura on 28/03/15.
//  Copyright (c) 2015 Pieri Laura. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recorderAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        restartButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        restartButton.hidden = true
        println("recording in progress")
        //record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath
, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //step 1 save the recorded audio
            recorderAudio = RecordedAudio(filePathUrl:recorder.url, title: recorder.url.lastPathComponent!)
            //step2 move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recorderAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            restartButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as
                PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        recordingInProgress.text = "Tap to record"
        restartButton.hidden = false
        pauseButton.hidden = true
        stopButton.hidden = true
        audioRecorder.pause()
    }
 
    @IBAction func restartAudio(sender: UIButton) {
        recordingInProgress.text = "Recording in progress"
        restartButton.hidden = true
        pauseButton.hidden = false
        stopButton.hidden = false
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.text = "Tap to record"
        //stop recording user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

