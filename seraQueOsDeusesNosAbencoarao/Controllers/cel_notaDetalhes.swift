//
//  cel_notaDetalhes.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 14/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

/*
 Célula da table view da tela de "Detalhes da Carta".
 Precisa conter uma caixa que vai ser colorida
 e o texto da nota.
 */
class cel_notaDetalhes: UITableViewCell {
    
    // Fundo colorido
    @IBOutlet weak var v_fundoNota: UIView!
    
    // Texto da nota
    @IBOutlet weak var lbl_texto: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
