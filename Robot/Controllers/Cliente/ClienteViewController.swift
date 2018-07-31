//
//  ClienteViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class ClienteViewController: UIViewController {

    @IBOutlet weak var lbEmpresa: UILabel!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbDesde: UILabel!
    
    var client: Client!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        lbEmpresa.text = client.nome
        if let plataformText = client.platform?.platformName, !plataformText.isEmpty {
            lbPlataforma.text = (client.platform?.platformName ?? "")!  + " - Release: " + (client.platform?.lastRelease ?? "")!
        } else {
            lbPlataforma.text = "(plataforma não definida)"
        }
        if let releaseDate = client.desde {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "pt-BR")
            lbDesde.text = formatter.string(from: releaseDate)
        }
        if let image = client.logo as? UIImage {
            ivLogo.image = image
        } else {
            ivLogo.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CRUD_ClientesViewController
        vc.client = client
    }
}


