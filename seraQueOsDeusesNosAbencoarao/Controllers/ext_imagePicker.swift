//
//  ext_imagePicker.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 01/07/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

extension vc_galeriaImagens {
    
    // Salva uma imagem localmente
    func saveImage(image: UIImage, nome: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(nome)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    // Carrega uma única imagem salva
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}
