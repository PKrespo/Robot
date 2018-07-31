//
//  PropostasTableViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit
import CoreData

class PropostasTableViewController: UITableViewController {

    var emptyTable = UILabel()
    var fetchedResultController: NSFetchedResultsController<Proposal>!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.placeholder = "digite número proposta"
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        emptyTable.text = "Você não tem Propostas Cadastradas"
        emptyTable.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)

        loadPropostas()
        tableView.reloadData()
    }
    
    func loadPropostas(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Proposal> = Proposal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "proposalID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "proposalID contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProposal"{
            let vc = segue.destination as! PropostaViewController
            if let propostas = fetchedResultController.fetchedObjects {
                vc.proposta = propostas[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? emptyTable : nil
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProposta", for: indexPath) as! PropostaTableViewCell
        
        guard let proposta = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        if proposta.client == nil && proposta.platform == nil {
            context.delete(proposta)
            try! context.save()
        } else {
            cell.prepare(with: proposta)
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let proposta = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(proposta)
        }
    }
}

extension PropostasTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            return
        default:
            tableView.reloadData()
        }
    }
}

extension PropostasTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadPropostas()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadPropostas(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
