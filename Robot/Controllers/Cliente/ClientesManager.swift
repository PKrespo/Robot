//
//  ClientesManager.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 21/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import CoreData

class ClientesManager {
    static let shared = ClientesManager()
    var clientes: [Client] = []
    
    func loadClientes(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            clientes = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deleteCliente(index: Int, context: NSManagedObjectContext){
        let cliente = clientes[index]
        context.delete(cliente)
        do {
            try context.save()
            clientes.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // This function return last number of the Client
    //
    func getLastIdNumber(with context: NSManagedObjectContext) -> Int32 {
        var lastNumber: Int32 = 0
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            clientes = try context.fetch(fetchRequest)
            lastNumber = (clientes[0]).id
            loadClientes(with: context)
        } catch  {
            print(error.localizedDescription)
        }

        return lastNumber
    }
    
    private init() {
        
    }
}
