//
//  vc_editarNota.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 14/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import Hero

class vc_editarNota: UIViewController {
    
    // A nota que está editando
    var nota : Nota!
    var hid : String!
    
    // Text Field onde é possivel editar a nota
    @IBOutlet weak var txf_editarTexto: UITextView!
    

    // Quadrinho da nota
    @IBOutlet weak var v_moldura: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        v_moldura.hero.id = hid
        
        // Vem e volta por fade. Não sei se isso faz diferença
        self.hero.modalAnimationType = .fade
        
        // Se inscreve pra receber os eventos do teclado
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)

    }
    
    
    // Pra mudar a HeroID da view antes de começar as animações
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v_moldura.hero.id = hid
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Coloca os dados da nota
        v_moldura.backgroundColor = nota.cor
        txf_editarTexto.text = nota.texto
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nota.texto = txf_editarTexto.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Keyboard
    
    // Trata a notificação de que o teclado vai aparecer
    @objc func UIKeyboardWillShow (_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let f = txf_editarTexto.frame
            txf_editarTexto.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: view.frame.height - keyboardHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        }
    }
    
    // Trata a notificação de que o teclado vai sumir
    @objc func UIKeyboardWillHide () {
        let f = txf_editarTexto.frame
        txf_editarTexto.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
        // Da pra usar isso pra salvar?
        nota.texto = txf_editarTexto.text
    }

}
