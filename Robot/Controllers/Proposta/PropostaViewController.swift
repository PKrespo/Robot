//
//  PropostaViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class PropostaViewController: UIViewController {

    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbEmpresa: UILabel!
    @IBOutlet weak var lbPropostaID: UILabel!
    @IBOutlet weak var lbSolicitacao: UILabel!
    @IBOutlet weak var tvDescricao: UITextView!
    @IBOutlet weak var lbPlataforma: UILabel!
    
    var proposta: Proposal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ivLogo.image = proposta.client?.logo as? UIImage
        lbEmpresa.text = proposta.client?.nome ?? ""
        lbPropostaID.text = proposta.proposalID!
        if let requestDate = proposta.solicitacao {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "pt-BR")
            lbSolicitacao.text = formatter.string(from: requestDate)
        }
        lbPlataforma.text = (proposta.client?.platform?.platformName!)! + " - Release: " +  (proposta.client?.platform?.lastRelease!)!
        tvDescricao.text = proposta.descricao
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProposal" {
           let vc = segue.destination as! CRUD_PropostasViewController
           vc.proposta = proposta
        }
    }
}
