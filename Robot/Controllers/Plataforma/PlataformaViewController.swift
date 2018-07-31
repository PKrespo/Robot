//
//  PlataformaViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class PlataformaViewController: UIViewController {

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var lbRelease: UILabel!
    
    var plataforma: Platform!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if plataforma != nil {
            lbNome.text = plataforma.platformName
            lbRelease.text = plataforma.lastRelease
        }
    }
    
    @IBAction func editPlataforma(_ sender: UIBarButtonItem) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "editPlataformaSegue" {
            let vc = segue.destination as! CRUD_PlataformasViewController
            vc.plataforma = plataforma
        }
    }

}


