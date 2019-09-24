//
//  Carta.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

class Carta {
    
    // Identificador da carta
    var id : String
    
    // Imagem da carta
    var imagem : UIImage
    
    // Anotações da carta
    var notas = [Nota] ()
    
    init (id : String, imagem: UIImage) {
        self.id = id
        self.imagem = imagem
    }
    
    
}
