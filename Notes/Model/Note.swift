//
//  Note.swift
//  Notes
//
//  Created by Dzmitry Bosak on 6/29/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation
import CoreData

public class Note: NSManagedObject {
    
    //MARK: Properties
    
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var date: Date?
    @NSManaged public var images: [String]?
}
