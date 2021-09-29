//
//  PlaylistViewController.swift
//  view
//
//  Created by Ikhtiar Ahmed on 1/25/21.
//

import UIKit
import MediaPlayer
import AVFoundation

//MARK: Global Variables

var pName = ""
var pArtist = ""
var pAlbumArtist = ""
var pUrl = ""

class PlaylistViewController: UIViewController {

//MARK: Outlets
    
    @IBOutlet weak var playlistView: UITableView!
    
    
//MARK: Variables
    
    var selectedFolderName: String?
    var  songsArray = CoreDataManager.fetchData()
    var ganArray = [PlayList]()
    
    
    
    
//MARK: Life Cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playlistView.delegate = self
        playlistView.dataSource = self
        
        playlistView.register(UINib(nibName: "SongsTableViewCell", bundle: nil), forCellReuseIdentifier: "SongsTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        playlistView.reloadData()
    }

    
    
//MARK: Actions
    
    
    
    @IBAction func add(_ sender: UIButton) {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.allowsPickingMultipleItems = false
        mediaPicker.showsItemsWithProtectedAssets = false // These items usually cannot be played back
        mediaPicker.showsCloudItems = false // MPMediaItems stored in the cloud don't have an assetURL
        mediaPicker.delegate = self
        mediaPicker.prompt = "Pick a track"
        present(mediaPicker, animated: true, completion: nil)
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
    
}


//MARK: TableView


extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongsTableViewCell.idetifier, for: indexPath) as! SongsTableViewCell
        let song = songsArray[indexPath.row]
        
        cell.artTitle.text = song.title
        //CoreDataManager.fetchData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            let imagePath = self.songsArray[indexPath.row] as? URL
//            let imageName = imagePath?.lastPathComponent
//
//            let folderName = selectedFolderName!
            CoreDataManager.deleteData(name: pName)
            CoreDataManager.deleteFromFavourite(name: pUrl)
            //CoreDataManager.fetchData()

            playlistView.reloadData()
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("title ----- \(songsArray[indexPath.row].title!)")
        print("folderName ----- \(songsArray[indexPath.row].folderName!)")
        print("url ----- \(songsArray[indexPath.row].url!)")
        playSong(url: URL(fileURLWithPath: songsArray[indexPath.row].url!))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 57
    }
    
    
}



//MARK: Media Picker




extension PlaylistViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        guard let item = mediaItemCollection.items.first else {
            print("no item")
            return
        }
        print("Title :  \(item.title!)")
        pName = item.title!
        
        guard let url = item.assetURL else {
            return print("no url")
        }
        print("url : \(url)")
        pUrl = url.absoluteString
        
        CoreDataManager.insertData(Title: item.title!, Url: url.absoluteURL, folderName: selectedFolderName! )
        
        dismiss(animated: true)
//        { [weak self] in
//            self?.startEngine(playFileAt: url)
//        }
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
