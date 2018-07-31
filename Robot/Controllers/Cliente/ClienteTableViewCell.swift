//
//  ClienteTableViewCell.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class ClienteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbEmpresa: UILabel!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var lbDesde: UILabel!
    @IBOutlet weak var ivLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func prepare(with client: Client) {
        lbEmpresa.text = client.nome ?? ""
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
            // Implementar caso não haja imagem
            ivLogo.image = UIImage(named: "noCover.png")
        }
    }
}
