//
//  HomeViewController.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/25/20.
//

import UIKit

class PlaylistController: UIViewController {
    
//MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
//MARK: Variable Declaration
    
    var oldName : String = ""
    var newName : String?
    var foldersName : [String] = []
    var selectedFolderName: String?
    
    
    
    
//MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view. typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 185, height: 150)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        //Setup Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register Custom cell Xib file on Collection View
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.idetifier)
        
        self.getImageFromDocumentDirectory()

    }
    
    
//MARK: Actions
    
    
    
    // Create Button Item
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let folderNameTextField = UITextField()
        let alert = UIAlertController(title: "Create New Folder", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Create", style: .default){(action) in
            
            let text = (alert.textFields?.first as! UITextField).text
            let folderName = self.modifyFolder(a : " ", b : "x", targetString : text!)
            
            // Create Folder
            
            let fileManager = FileManager.default
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("folderName")
            let url = NSURL(string: path)!.appendingPathComponent(folderName)
            let urlString: String = url!.absoluteString
            
            if !fileManager.fileExists(atPath: urlString) {

                    try! fileManager.createDirectory(atPath: urlString, withIntermediateDirectories: true, attributes: nil)

            }
            else {
                let msg = folderNameTextField.text!
                if(msg == ""){
                    self.notify(text : "Empty name not allowed")
                }
                else{
                    self.notify(text : "Already created")
                }
            }

            self.getImageFromDocumentDirectory()
            self.collectionView.reloadData()
            self.notify(text : "Folder Created")
            // Folder creattion Finished
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){(action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "New Folder"
            

        }
        present(alert, animated: true, completion: nil)
    }
    


    
//MARK: Functions
    
    
    
    
    // Delete Folder
    
    func deleteReplayFolders(indexPath: IndexPath)
    {
        // path to documents directory
        let folderName = self.foldersName[indexPath.item]
        let folderDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("folderName").appendingPathComponent(folderName)
        if FileManager.default.fileExists(atPath: folderDir.path){
            do {
                try FileManager.default.removeItem(at: folderDir)
                self.foldersName.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                CoreDataManager.deleteData(name: folderName)
            } catch  {
                print(error.localizedDescription)
            }
            
        }
    
    }
    
    // Update Folder
    
    func updateReplayFolders(newName: String, oldPathIndex: IndexPath){
        let oldFolderName = self.foldersName[oldPathIndex.item]
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("folderName")
        let getUrl = URL(fileURLWithPath: path)
        
        let newPath = getUrl.appendingPathComponent(newName).path
        let oldPath = getUrl.appendingPathComponent(oldFolderName).path
        
        if !fileManager.fileExists(atPath: newPath){
            do {try! fileManager.moveItem(atPath: oldPath, toPath: newPath)
                //CoreDataManager.updateData(newName: newName, oldName: oldFolderName)
                
                
            }
           

        }else{
            self.notify(text : "Already dictionary created.")

        }
                        
        self.getImageFromDocumentDirectory()
        self.collectionView.reloadData()
        
    }
    
    
    // UIUpdate
    
    func uiUpdate(indexPath: IndexPath){
  
    var newName_ : String = ""
    
    let alert = UIAlertController(title: "Rename folder", message: "", preferredStyle:  .alert)

    let action = UIAlertAction(title: "Save", style: .default){ [self](action) in
        
        newName_ = alert.textFields![0].text!
    
        self.newName = newName_
        self.updateReplayFolders(newName: newName_, oldPathIndex: indexPath)
//        self.getImageFromDocumentDirectory()
//       self.collectionView.reloadData()
        
    }
    
    alert.addTextField { (alertTextField) in
        alertTextField.text = self.selectedFolderName
        
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)

}
    
    
    // UIdelete
    func uiDelete(indexPath: IndexPath){

    
    let alert = UIAlertController(title: "Delete folder", message: "Are you sure you want to delete this folder ?", preferredStyle:  .alert)


    let action = UIAlertAction(title: "Ok", style: .default){ [self](action) in

       
        self.deleteReplayFolders(indexPath: indexPath)
        
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)

}
    
    
    

    
    
    
    // Long press gesture
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){

        if (gestureRecognizer.state != .ended){
            return
        }

        let p = gestureRecognizer.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p){
           
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Edit Option", message: "", preferredStyle: .actionSheet)

                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    print("Cancel")
                }
                actionSheetControllerIOS8.addAction(cancelActionButton)

                let saveActionButton = UIAlertAction(title: "Rename", style: .default)
                    { _ in
                       print("Renamed")
                    self.uiUpdate(indexPath: indexPath)
                }
                actionSheetControllerIOS8.addAction(saveActionButton)

                let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
                    { _ in
                        print("Deleted")
                    
                    self.uiDelete(indexPath: indexPath)
                    //self.deleteReplayFolders(indexPath: indexPath)
                
                }
                actionSheetControllerIOS8.addAction(deleteActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }

    }
    
    
    // Alert Notification
    func notify(text : String){
        
       
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-250, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
          //  toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = text
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
    

    }
    
    
    // Extra Functions
    func modifyFolder(a : String, b : String, targetString : String) -> String{
        var newString = targetString
        newString = newString.replacingOccurrences(of: a, with: b, options: NSString.CompareOptions.literal, range: nil)
        return newString
    }
    func getDocumentaryPath() -> NSString{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return path
    }
    
    
    // Save Folder In Document Directory
    func getImageFromDocumentDirectory() {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("folderName")
        let getUrl = URL(fileURLWithPath: path)
        
        do{
            self.foldersName = try fileManager.contentsOfDirectory(atPath: getUrl.path)
            self.collectionView.reloadData()

        }
        catch{
            self.notify(text : "Not Found")
        }
        collectionView.reloadData()
    }
    

}






//MARK: Collection View

extension PlaylistController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Number of item in a row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foldersName.count;
    }
    
    // Custom cell recognizer to Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
       // cell.folderLabel.text = self.folderPhoto[indexPath.item]
        
        let folder = modifyFolder(a: "x", b: " ", targetString: self.foldersName[indexPath.item])
//        print("dsdfds  = ", imagePath!.lastPathComponent)
       cell.folderLabel.text = folder
        
        return cell
    }
    
// Collection view layout
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(20)
    }
    
    
// Didselect for action
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getImageFromDocumentDirectory()
        self.selectedFolderName = foldersName[indexPath.item]
        
        // long press gesture
        let lpg = UILongPressGestureRecognizer()
        self.view.addGestureRecognizer(lpg)
        lpg.addTarget(self, action: #selector(handleLongPress))
        self.collectionView.addGestureRecognizer(lpg)
        
        //Jump to Folder ViewController
        let fVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController

        fVC.selectedFolderName = foldersName[indexPath.item]

        self.navigationController?.pushViewController(fVC, animated: true)
        
        self.present(fVC, animated:true, completion:nil)
      
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
//        nextViewController.selectedFolderName = foldersName[indexPath.item]
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.present(nextViewController, animated:true, completion:nil)
        
    }

}
