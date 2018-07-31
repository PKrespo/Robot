//
//  PlataformaTableViewCell.swift
//  Robot
//
//  Created by Paulo Crespo Pereira on 15/07/18.
//  Copyright © 2018 EGEAH Digital Innovation. All rights reserved.
//

import UIKit

class PlataformaTableViewCell: UITableViewCell {

    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var lbRelease: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepare(with plataforma: Platform) {
        lbPlataforma.text = plataforma.platformName ?? ""
        lbRelease.text = plataforma.lastRelease ?? ""
    }
}
