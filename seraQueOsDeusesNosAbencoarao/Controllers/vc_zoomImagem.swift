//
//  vc_zoomImagem.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 21/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

class vc_zoomImagem: UIViewController, UIScrollViewDelegate {
    
    // A Scroll View (onde o zoom é dado)
    @IBOutlet weak var scv_scroll: UIScrollView!
    
    // A imagem apresentada
    var imagem : UIImage!
    @IBOutlet weak var img_imagem: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scv_scroll.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Seta a imagem sempre que for aparecer
        img_imagem.image = imagem
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Delegate da Scroll View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img_imagem
    }
    
}
