//
//  PlayerController.swift
//  test.music
//
//  Created by Ikhtiar Ahmed on 1/4/21.
//

import UIKit
import AVFoundation
import MediaPlayer

//MARK: Global Variables

var indexForSong = activeIndex
var pauseState = activeIndex


class PlayerController: UIViewController ,AVAudioPlayerDelegate  {
    
//MARK: Outlets Abd Variables
    
    @IBOutlet weak var time: UILabel!
        = {
        let label = UILabel()
         label.text = "-:--"
         label.font = UIFont.systemFont(ofSize : 12)
         label.textColor = .green
         return label
     }()
    

    
    @IBOutlet weak var totalTime: UILabel!
        = {
        let label = UILabel()
         label.text = "-:--"
         label.font = UIFont.systemFont(ofSize : 12)
         label.textColor = .green
         return label
     }()
   
    
    @IBOutlet weak var slider: UISlider!
        = {
        
        let slider = UISlider()
        slider.maximumValue = 1000
        slider.minimumValue = 0
        slider.tintColor = UIColor.blue
        slider.addTarget(self, action: #selector(_slider), for: .touchDragInside)
        return slider
    }()
    
    
    @IBOutlet weak var playBtn: UIButton!
        = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(play_pause), for: .touchUpInside)
        return btn
    }()


    @IBOutlet weak var backBtn: UIButton!
        = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(_back), for: .touchUpInside)

        return btn
    }()


    @IBOutlet weak var nextBtn: UIButton!
        = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "next"), for: .normal)
        btn.addTarget(self, action: #selector(_next), for: .touchUpInside)

        return btn
    }()
    
    
    @IBOutlet weak var artistName: UILabel!
//        = {
//        let label = UILabel()
//        label.text = "unknown"
//        label.font = UIFont.systemFont(ofSize : 12)
//        label.textColor = UIColor.lightGray
//        return label
//    }()
    
    
    @IBOutlet weak var songTitle: UILabel!
//        = {
//        let label = UILabel()
//        label.text = "unknown"
//        label.font = UIFont.systemFont(ofSize : 18)
//        label.textColor = UIColor.black
//        return label
//    }()
    
    
    
    @IBOutlet weak var artistImage: UIImageView!
//        = {
//        let image = UIImageView()
//         image.clipsToBounds = true
//         image.layer.cornerRadius = 10
//         image.contentMode = .scaleAspectFill
//         return image
//     }()
    
//MARK: Actions
    
    @IBAction func play_pause(_ sender: UIButton) {
        

        
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            playBtn.setImage(UIImage(named: "play"), for: .normal)
            updateTime()
        }
        else{

            audioPlayer.play()
            playBtn.setImage(UIImage(named: "pause"), for: .normal)
            updateTime()

        }
    }
    
    @IBAction func _slider(_ sender: UISlider) {
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime =  TimeInterval(slider.value)
            audioPlayer.play()
        }else{
            audioPlayer.currentTime = TimeInterval(slider.value)
        }
    }
    

    
//MARK: Functions
    
    

    
    @IBAction func _back(_ sender: UIButton){

        pauseState = 0
        if indexForSong == 0
        {
            indexForSong = mediaItems.count-1
        }
        else
        {
            indexForSong -= 1
        }
        let item = mediaItems[indexForSong]
        let url = item.assetURL
        songTitle.text = item.title!
        
        if item.artist != nil{
            artistName.text = item.artist!
        }
        else{
            if item.albumArtist != nil{
                artistName.text = item.albumArtist!
            }
            else{
                artistName.text = ""
            }
            
        }

        
        playSong(url: url!)
        updateTime()
        if let artwork: MPMediaItemArtwork = mediaItems[indexForSong].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
            artistImage.image = artwork.image(at: CGSize(width: 350, height: 220))}
        else{
            artistImage.image = UIImage(named: "og_image")
        }
        playBtn.setImage(UIImage(named: "pause"), for: .normal)
        
    }
    
    @IBAction func _next(_ sender: UIButton) {
        pauseState = 0
        
        if indexForSong == mediaItems.count - 1
        {
            indexForSong = 0
        }
        else
        {
            indexForSong += 1
        }
        
        
        
        
        let item = mediaItems[indexForSong]
        let url = item.assetURL
        songTitle.text = item.title!
        
        if item.artist != nil{
            artistName.text = item.artist!
        }
        else{
            if item.albumArtist != nil{
                artistName.text = item.albumArtist!
            }
            else{
                artistName.text = ""
            }
            
        }
        
        
        playSong(url: url!)
        updateTime()
        if let artwork: MPMediaItemArtwork = mediaItems[indexForSong].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
            artistImage.image = artwork.image(at: CGSize(width: 350, height: 220))}
        else{
            artistImage.image = UIImage(named: "og_image")
        }
        playBtn.setImage(UIImage(named: "pause"), for: .normal)
        
    }
    
    @objc func update (_timer : Timer ) {
        slider.value = Float(audioPlayer.currentTime)
        time.text =  stringFormatterTimeInterval(interval: TimeInterval(slider.value)) as String
    }
    
    func updateTime() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        slider.maximumValue = Float(audioPlayer.duration)
        totalTime.text = stringFormatterTimeInterval(interval: audioPlayer.duration) as String
    }
    
    func stringFormatterTimeInterval(interval : TimeInterval) ->NSString {
        let ti = NSInteger(interval)
        let second = ti % 60
        let minutes = ( ti / 60) % 60
        return NSString(format: "%0.2d:%0.2d", minutes,second)
    }

    func playSong(url:URL) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)


            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            audioPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
//MARK: Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        
        if audioPlayer.isPlaying {
            updateTime()
            songTitle.text = name
            artistName.text = artist
            if let artwork: MPMediaItemArtwork = mediaItems[indexForSong].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
                artistImage.image = artwork.image(at: CGSize(width: 350, height: 220))}
            
            playBtn.setImage(UIImage(named: "pause"), for: .normal)
            
        }
        else {
            updateTime()
            songTitle.text = name
            artistName.text = artist
            artistImage.image = UIImage(named: "og_image")
            playBtn.setImage(UIImage(named: "play"), for: .normal)
            
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

   
}

