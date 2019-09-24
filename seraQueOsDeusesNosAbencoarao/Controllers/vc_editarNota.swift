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
    //var nota : Nota!
    var data_nota : Pdata_nota!
    var id_imagem : String!
    var id_nota : String!
    var hid : String!
    
    @IBOutlet var btn_cores : [UIBarButtonItem]!
    var n_cor : Int!
    
    
    @IBOutlet weak var tb_toolbar: UIToolbar!
    
    // O controle com as cartas
    var ctrl_dados = ControleDeDados.controle
    
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

        tb_toolbar.frame.size = CGSize(width: tb_toolbar.frame.width, height: (self.tabBarController?.tabBar.frame.height)!)
        tb_toolbar.transform = self.tb_toolbar.transform.translatedBy(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)! - self.tb_toolbar.frame.origin.y)
        
        
    }
    
    
    // Pra mudar a HeroID da view antes de começar as animações
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v_moldura.hero.id = hid
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for (i, b) in btn_cores.enumerated() {
            if let v = b.customView {
                //let v = b.value(forKey: "view") as? UIView
                v.layer.borderWidth = 5
                v.layer.borderColor = UIColor.gray.cgColor
                v.layer.cornerRadius = 5
            }
            b.tintColor = ctrl_dados.cores_notas[i]
        }
        
        // Procura a nota sendo mostrada
        var achou = false
        for (i, nota) in (ctrl_dados.notas_salvas as! [Pdata_nota]).enumerated() {
            if nota.id_imagem == id_imagem && nota.id_nota == id_nota {
                txf_editarTexto.text = nota.texto
                // Coloca os dados da nota
                n_cor = Int(nota.cor)
                v_moldura.backgroundColor = ctrl_dados.cores_notas[Int(nota.cor)]//.lightGray//nota.cor
                achou = true
            }
        }
        if !achou {
            dismiss(animated: true, completion: nil)
        }
        
        self.tabBarController?.tabBar.alpha = 0
        self.tabBarController?.tabBar.layer.zPosition = -1

        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //nota.texto = txf_editarTexto.text
        self.tabBarController?.tabBar.alpha = 1
        self.tabBarController?.tabBar.layer.zPosition = 0

        //atualizar_nota(texto: txf_editarTexto.text, nota: data_nota)
        ctrl_dados.excluir_nota(id_imagem: id_imagem, id_nota: id_nota)
        ctrl_dados.salvar_nova_nota(id_imagem: id_imagem, id_nota: id_nota, texto: txf_editarTexto.text, cor: n_cor)
    }
    
    
    // Atualiza uma nota
    func atualizar_nota (texto: String, nota: Pdata_nota!) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // atualiza a entidade
        nota.texto = texto
        nota.cor = Int32(n_cor)
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
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
        //nota.texto = txf_editarTexto.text
        ctrl_dados.excluir_nota(id_imagem: id_imagem, id_nota: id_nota)
        ctrl_dados.salvar_nova_nota(id_imagem: id_imagem, id_nota: id_nota, texto: txf_editarTexto.text, cor: 0)
    }
    
    @IBAction func botao_cor(_ sender: UIBarButtonItem) {
        
        v_moldura.backgroundColor = ctrl_dados.cores_notas[sender.tag]
        n_cor = sender.tag
        
    }
    

}
