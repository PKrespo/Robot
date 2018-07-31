//
//  PlataformaManager.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import CoreData

class PlataformaManager {
    static let shared = PlataformaManager()
    var plataformas: [Platform] = []
    
    func loadPlataformas(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Platform> = Platform.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "platformName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            plataformas = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deletePlataforma(index: Int, context: NSManagedObjectContext){
        let plataforma = plataformas[index]
        context.delete(plataforma)
        do {
            try context.save()
            plataformas.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
