//
//  ViewController.swift
//  view
//
//  Created by Ikhtiar Ahmed on 1/11/21.
//

import UIKit
import AVFoundation
import MediaPlayer

//MARK: Variables and constants
    var mpMediapicker: MPMediaPickerController!
    var mediaItems = [MPMediaItem]()
    var audioPlayer = AVAudioPlayer()

var songList : [String] = []
var songImage : [String] = []

var activeSong = 0
var activeIndex = 0
var name = ""
var artist = ""
var albumArtist = ""


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
//MARK: Outlets
    
    @IBOutlet weak var table: UITableView!


    
//MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        getSongs()
        tableViewSetup()
    }    
 
    override func viewDidAppear(_ animated: Bool) {
        if mediaItems.count == 0 {
            checkMediaPermission()
            
        }
        
    }
   
    
//MARK: Actions
    
    

    
    
//MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.label.text = mediaItems[indexPath.row].title
        cell.aLabel.text = mediaItems[indexPath.row].artist
        if let artwork: MPMediaItemArtwork = mediaItems[indexPath.row].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
            cell.aImage.image = artwork.image(at: CGSize(width: 40, height: 40))}
        else{
            cell.aImage.image  = UIImage(named: "og_image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = mediaItems[indexPath.row]
        let url = item.assetURL
        activeIndex = indexPath.row
        name = item.title!
        
        if item.artist != nil{
            artist = item.artist!
        }
        else{
            if item.albumArtist != nil{
                artist = item.albumArtist!
            }
            else{
                artist = ""
            }
            
        }
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
//        //vc.test = item.title!
//        
//        if let artwork: MPMediaItemArtwork = mediaItems[indexPath.row].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
//            vc.artistImage.image = artwork.image(at: CGSize(width: 350, height: 220))}
//        else{
//            vc.artistImage.image  = UIImage(named: "og_image")
//        }
//        self.present(vc, animated: true, completion: nil)
        
        
        print("---------------")
        print("index : \(indexPath.row)")
        print("title : \(item.title!)")
        print("url : \(url!)")
        print("---------------")
        
        playSong(url: url!)
        
        tableView.deselectRow(at: indexPath, animated: true)
         }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 57
    }
    
    
    
//MARK: Functions

    
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
    
    func checkMediaPermission () {
        
        
        
        let alertController = UIAlertController (title: "This app is not authorized to use Music. Please allow ' Media & Apple Music' to access Music.", message: "Go to Settings > Media & Apple Music > On", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func tableViewSetup () {
        table.delegate = self
        table.dataSource = self
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.idetifier)
    }
    
    func getSongs() {
        if MPMediaQuery.songs().items != nil {
        mediaItems = MPMediaQuery.songs().items!
        }

        print("\n\n\n\tNumber of Songs in Device : \(mediaItems.count)\n\n\n")
    }
}

