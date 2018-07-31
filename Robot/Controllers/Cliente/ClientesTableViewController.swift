//
//  ClientesTableViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit
import CoreData

class ClientesTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var fetchedResultController: NSFetchedResultsController<Client>!
    var emptyTable = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyTable.text = "Você não tem Clientes Cadastrados"
        emptyTable.textAlignment = .center

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        loadClientes()
    }

    func loadClientes(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "nome contains [c] %@", filtering)
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
        if segue.identifier! == "viewClienteSegue" {
            let vc = segue.destination as! ClienteViewController
            if let clientes = fetchedResultController.fetchedObjects {
                vc.client = clientes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? emptyTable : nil

        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCliente", for: indexPath) as! ClienteTableViewCell

        guard let client = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepare(with: client)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cliente = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(cliente)
        }
    }
}

extension ClientesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .delete:
                if let indexpath = indexPath { tableView.deleteRows(at: [indexpath], with: .fade) }
            default:
                tableView.reloadData()
        }
    }
}

extension ClientesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadClientes()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadClientes(filtering: searchBar.text!)
        tableView.reloadData()
    }
}

