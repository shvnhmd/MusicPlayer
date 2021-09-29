//
//  CoreDataSupport.swift
//  Ringtone
//
//  Created by Twinbit Sabuj on 19/1/20.
//  Copyright © 2020 Twinbit. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    init(){}
    
    
    class func insertData(Title :String, Url : URL, folderName: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let song = NSEntityDescription.insertNewObject(forEntityName: "PlayList", into: context) as! PlayList
        
//        song.folderName = folder_name
//        song.isFavourite = mark
//        song.urls = image_name
        song.title = Title
        song.url = Url.absoluteString
        song.folderName = folderName

        do {
            
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
//    class func updateData(newName : String, oldName : String){
//
//
//        var listArray = [PlayList]()
//
//        let request : NSFetchRequest <PlayList>  = PlayList.fetchRequest()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let context = appDelegate.persistentContainer.viewContext
//        request.predicate = NSPredicate(format: "folderName = %@", oldName)
//
//        do{
//            listArray = try context.fetch(request)
//            for data in listArray{
//                if(data.folderName == oldName){
//                    let song = NSEntityDescription.insertNewObject(forEntityName: "PlayList", into: context) as! PlayList
//                    context.delete(data)
//                    song.folderName = newName
//
//                    song.urls = data.urls
//
//                }
//            }
//            do {
//
//                try context.save()
//            } catch {
//                print("Failed saving")
//            }
//        }
//        catch{
//            print("Error loading data \(error)")
//        }
//
//    }
   
    class func deleteData(name : String){
        
        var listArray = [PlayList]()
        
        let request : NSFetchRequest <PlayList>  = PlayList.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "title = %@", name)
         do
         {
             listArray = try context.fetch(request)
                 for data in listArray{
                     if(data.title == name){
                        
                         context.delete(data)
                     }
                 }
                 do {
                     
                     try context.save()
                 } catch {
                     print("Failed saving")
                 }
             }
             catch{
                 print("Error loading data \(error)")
             }
    }
    
    class func deleteFromFavourite(name: String)
    {
        var listArray = [PlayList]()
        
        let request : NSFetchRequest <PlayList>  = PlayList.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "url = %@", name)
        
        do
        {
            listArray = try context.fetch(request)
                for data in listArray{
                    if(data.url == name){
                       
                        context.delete(data)
                    }
                }
                do {
                    
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
            catch{
                print("Error loading data \(error)")
            }
        
        
        
        
        
        
    }
    
    
    class func delete(name: String)
    {
        var listArray = [PlayList]()
        
        let request : NSFetchRequest <PlayList>  = PlayList.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "folderName = %@", name)
        
        do
        {
            listArray = try context.fetch(request)
                for data in listArray{
                    if(data.folderName == name){
                       
                        context.delete(data)
                    }
                }
                do {
                    
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
            catch{
                print("Error loading data \(error)")
            }
        
        
        
        
        
        
    }
    
    
    
    class func fetchData() -> [PlayList]{
        var listArray = [PlayList]()
        
        let request : NSFetchRequest <PlayList>  = PlayList.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        do{
            listArray = try context.fetch(request)
            return listArray
        }
        catch{
            print("Error loading data \(error)")
        }
        return listArray
    }
    
}

