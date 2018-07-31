//
//  CRUD_PropostasViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class CRUD_PropostasViewController: UIViewController {

    @IBOutlet weak var tfEmpresa: UITextField!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var tvDescritivo: UITextView!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var proposta: Proposal!
    var plataforma: Platform!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    } ()
    
    var propostasManager = PropostasManager.shared
    var clientesManager = ClientesManager.shared
    var sequenciesManager = SequenciesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareProposalTextField()
        lbPlataforma.text = ""
        lbPlataforma.isHidden = true
        
        if proposta == nil {
            btAddEdit.setTitle("Salvar e Gerar Proposta", for: .normal)
        } else {
            // Se trata de uma alteração
            // Somente Plataforma e a Descrição podem ser alterados
            tvDescritivo.text = proposta.descricao
            tfEmpresa.text = proposta.client?.nome!
            if let nomePlataforma = proposta.client?.platform?.platformName!, let releasePlataforma = proposta.client?.platform?.lastRelease! {
                    lbPlataforma.text =  nomePlataforma  + " - Release: " + releasePlataforma
            } else {
                lbPlataforma.text = "(Plataforma não atribuída/localizada)"
            }
            
            lbPlataforma.isHidden = false
            ivLogo.image = proposta.client?.logo as? UIImage
            tfEmpresa.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //propostasManager.loadProposals(with: context)
        clientesManager.loadClientes(with: context)
        resetProposta()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmpresa.resignFirstResponder()
        tvDescritivo.resignFirstResponder()
        resetProposta()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProposalNumberViewController
        vc.proposta = proposta
    }
    
    func resetProposta() {
        if (tfEmpresa.text?.isEmpty)! {
            lbPlataforma.isHidden = true
            ivLogo.image = nil
        }
    }
    
    func prepareProposalTextField() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44) )
        toolBar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btRlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(cancel))
        toolBar.items = [btCancel, btRlexibleSpace, btDone]
        
        tfEmpresa.inputView = pickerView
        tfEmpresa.inputAccessoryView = toolBar
        lbPlataforma.isHidden = tfEmpresa.text?.isEmpty ?? false
    }
    
    @objc func cancel() {
        resetProposta()
        tfEmpresa.resignFirstResponder()
    }
    
    @objc func done() {
        tfEmpresa.text =  clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].nome!
        lbPlataforma.text = (clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].platform?.platformName!)! + " - Release: " + (clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].platform?.lastRelease!)!
        lbPlataforma.isHidden = false
        plataforma = clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].platform
        ivLogo.image = clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].logo as? UIImage
        plataforma = clientesManager.clientes[pickerView.selectedRow(inComponent: 0)].platform!
        cancel()
    }
    
    @IBAction func addEditProposta(_ sender: UIButton) {
        let novo: Bool = proposta == nil
        
        if proposta == nil {
            proposta = Proposal(context: context)
        }

        proposta.descricao = tvDescritivo.text
        if novo {
            if !tfEmpresa.text!.isEmpty {
                let client = clientesManager.clientes[pickerView.selectedRow(inComponent: 0)]
                proposta.client = client
                proposta.proposalID = sequenciesManager.getProposalNumber(about: client, with: context)
                if !lbPlataforma.text!.isEmpty {
                    proposta.platform = plataforma
                }
            }
            proposta.solicitacao = Date()
        }
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
}

extension CRUD_PropostasViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clientesManager.clientes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cliente = clientesManager.clientes[row]
        return cliente.nome
    }
}
