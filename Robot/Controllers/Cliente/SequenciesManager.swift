//
//  SequenciesManager.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 23/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import CoreData

class SequenciesManager {
    
    static let shared = SequenciesManager()
    var sequencies: [Sequency] = []
    
    func loadSequencies(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Sequency> = Sequency.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "numberOfSequency", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            sequencies = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func getProposalNumber(about client: Client, with context: NSManagedObjectContext) -> String {
        let hoje = Date()
        let useCalendar = Calendar.current
        let myComponent: Set<Calendar.Component> = [
            .year ,
            .month
        ]
        let toUseDate = useCalendar.dateComponents(myComponent, from: hoje)
        let sequency = client.sequency!
        sequency.numberOfSequency = sequency.numberOfSequency + 1
        
        do {
            try context.save()  // add incremental number into sequency controler
            let proposalNumber = String(format: "%04d.%04d.%05d-%02d", toUseDate.year ?? 0000, client.id, sequency.numberOfSequency, toUseDate.month ?? 00)
            return proposalNumber
            
        } catch  {
            print(error.localizedDescription)
        }
        return ""
    }
    
    private init() {
        
    }
}
