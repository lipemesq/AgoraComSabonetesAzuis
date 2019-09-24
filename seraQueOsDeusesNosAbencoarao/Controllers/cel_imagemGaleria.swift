//
//  cel_imagemGaleria.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

/*
 Esta é a célula da collection "Galeria".
 Ela tem que mostrar a imagem da carta
 e mandar para a página com os detalhes da carta, com a imagem e as notas.
*/
class cel_imagemGaleria: UICollectionViewCell {
    
    // A carta que ela está mostrando
    var carta : Carta!
    
    // A view da imagem
    @IBOutlet weak var v_viewImagem: UIView!
    
    // A imagem
    @IBOutlet weak var img_imagem: UIImageView!
    
    
}
