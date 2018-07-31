//
//  CRUD_PlataformasViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class CRUD_PlataformasViewController: UIViewController {

    @IBOutlet weak var tfPlataformName: UITextField!
    @IBOutlet weak var tfLastRelease: UITextField!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var plataforma: Platform!
    var plataformaManager = PlataformaManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if plataforma != nil {
            title = "Alterar Plataforma"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            
            tfPlataformName.text = plataforma.platformName
            tfLastRelease.text = plataforma.lastRelease
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plataformaManager.loadPlataformas(with: context)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfPlataformName.resignFirstResponder()
        tfLastRelease.resignFirstResponder()
    }

    @IBAction func addEditPlatform(_ sender: UIButton) {
        if plataforma == nil {
            plataforma = Platform(context: context)
        }
        plataforma.platformName = tfPlataformName.text
        plataforma.lastRelease = tfLastRelease.text

        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
}


