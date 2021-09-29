//
//  PlayList+CoreDataProperties.swift
//  Music
//
//  Created by Ikhtiar Ahmed on 2/3/21.
//
//

import Foundation
import CoreData


extension PlayList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayList> {
        return NSFetchRequest<PlayList>(entityName: "PlayList")
    }

    @NSManaged public var title: String?
    @NSManaged public var folderName: String?
    @NSManaged public var url: String?

}

extension PlayList : Identifiable {

}
