//
//  PlataformasTableViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit
import CoreData

class PlataformasTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Platform>!
    var emptyTable = UILabel()
    let searchController = UISearchController(searchResultsController: nil)
    var plataformaManager = PlataformaManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyTable.text = "Você não tem Plataformas Cadastradas"
        emptyTable.textAlignment = .center
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        loadPlataformas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier! == "plataformaSegue" {
                let vc = segue.destination as! PlataformaViewController
                if let plataformas = fetchedResultController.fetchedObjects {
                    vc.plataforma = plataformas[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadPlataformas(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Platform> = Platform.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "platformName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "platformName contains [c] %@", filtering)
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? emptyTable : nil
        
        return count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlataforma", for: indexPath) as! PlataformaTableViewCell

        guard let plataforma = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: plataforma)
 
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            plataformaManager.deletePlataforma(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension PlataformasTableViewController: NSFetchedResultsControllerDelegate {
    
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

extension PlataformasTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadPlataformas()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadPlataformas(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
