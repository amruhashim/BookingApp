//
//  Booking+CoreDataProperties.swift
//  A1
//
//  Created by Amru Hashim on 2/5/24.
//
//

import Foundation
import CoreData


extension Booking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Booking> {
        return NSFetchRequest<Booking>(entityName: "Booking")
    }

    @NSManaged public var discount: Double
    @NSManaged public var endTime: String?
    @NSManaged public var event: String?
    @NSManaged public var numberOfVisitors: Int16
    @NSManaged public var pricePerVisitor: Double
    @NSManaged public var selectedDate: Date?
    @NSManaged public var startTime: String?
    @NSManaged public var subtotal: Double
    @NSManaged public var total: Double

}

extension Booking : Identifiable {

}
