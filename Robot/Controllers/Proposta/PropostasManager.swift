//
//  PropostasManager.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 21/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import CoreData

class PropostasManager {
    static let shared = PropostasManager()
    var proposals: [Proposal] = []


    func loadProposals(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Proposal> = Proposal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "solicitacao", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            proposals = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }

    func deleteProposal(index: Int, context: NSManagedObjectContext){
        let proposal = proposals[index]
        context.delete(proposal)
        do {
            try context.save()
            proposals.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    

    private init() {
        
    }
}
