//
//  ProposalNumberViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 21/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class ProposalNumberViewController: UIViewController {
    
    var proposta: Proposal!
    
    @IBOutlet weak var lbProposta: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        lbProposta.text = proposta.proposalID
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func finishProposal(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
