//
//  CRUD_ClientesViewController.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class CRUD_ClientesViewController: UIViewController {
    
    @IBOutlet weak var tfNomeEmpresa: UITextField!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var tfPlataforma: UITextField!
    @IBOutlet weak var dpDesde: UIDatePicker!
    @IBOutlet weak var btLogo: UIButton!
    @IBOutlet weak var btAddEditClient: UIButton!
    
    var client: Client!
    var sequency: Sequency!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    } ()
    var plataformasManager = PlataformaManager.shared
    var clienteManager = ClientesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if client != nil {
            title = "Alterar Cliente"
            btAddEditClient.setTitle("ALTERAR", for: .normal)
            tfNomeEmpresa.text = client.nome
            let plataforma = client.platform
            plataformasManager.loadPlataformas(with: context)
            let index = plataformasManager.plataformas.index(of: plataforma!)
           // if let plataforma = client.platform, let index = plataformasManager.plataformas.index(of: plataforma) {
            tfPlataforma.text = (plataforma?.platformName!)! + " - Release: " + (plataforma?.lastRelease!)!
            pickerView.selectRow(index!, inComponent: 0, animated: false)
            //}
            if let desde = client.desde {
                dpDesde.date = desde
            }
            if let image = client.logo as? UIImage {
                ivLogo.image = image
            } else {
                ivLogo.image = UIImage(named: "noCover.png")
            }
            if client.logo != nil {
                btLogo.setTitle(nil, for: .normal)
            }
        }
        
        prepareClientTextField()
    }
    
    func prepareClientTextField() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44) )
        toolBar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btRlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(cancel))
        toolBar.items = [btCancel, btRlexibleSpace, btDone]

        tfPlataforma.inputView = pickerView
        tfPlataforma.inputAccessoryView = toolBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfPlataforma.resignFirstResponder()
        tfNomeEmpresa.resignFirstResponder()
    }
    
    @objc func cancel() {
        tfPlataforma.resignFirstResponder()
    }
    
    @objc func done() {
        tfPlataforma.text = plataformasManager.plataformas[pickerView.selectedRow(inComponent: 0)].platformName! + " - Release: " + plataformasManager.plataformas[pickerView.selectedRow(inComponent: 0)].lastRelease!
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plataformasManager.loadPlataformas(with: context)
    }
    
    @IBAction func btLogo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar logo:", message: "De onde você quer escolher seu Logo?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btAddEdit(_ sender: UIButton) {
        if client == nil {
            client = Client(context: context)
            client.id = clienteManager.getLastIdNumber(with: context) + 1
            sequency = Sequency(context: context)
            sequency.numberOfSequency = -1
            client.sequency = sequency
        }
        client.nome = tfNomeEmpresa.text
        client.desde = dpDesde.date
        if !tfPlataforma.text!.isEmpty {
            let plataforma = plataformasManager.plataformas[pickerView.selectedRow(inComponent: 0)]
            client.platform = plataforma
        }
        client.logo = ivLogo.image
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension CRUD_ClientesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plataformasManager.plataformas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let plataforma = plataformasManager.plataformas[row]
        return plataforma.platformName! + " - Release: " + plataforma.lastRelease!
    }
}

extension CRUD_ClientesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        ivLogo.image = image
        btLogo.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}























