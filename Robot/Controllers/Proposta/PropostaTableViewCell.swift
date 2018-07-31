//
//  PropostaTableViewCell.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 22/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class PropostaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbEmpresa: UILabel!
    @IBOutlet weak var lbProposta: UILabel!
    @IBOutlet weak var lbSolicitacao: UILabel!
    @IBOutlet weak var ivLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with proposal: Proposal) {
        lbEmpresa.text = proposal.client?.nome ?? ""
        lbProposta.text = proposal.proposalID ?? ""
        ivLogo.image = (proposal.client?.logo as! UIImage)
        if let requestDate = proposal.solicitacao {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "pt-BR")
            lbSolicitacao.text = formatter.string(from: requestDate)
        }
    }
}
