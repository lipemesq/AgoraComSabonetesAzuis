//
//  vc_galeriaImagens.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

// id das celulas
private let id_cel_imagem = "id_imagem"

// id das telas
private let id_vc_detalhes = "id_detalhes"

class vc_galeriaImagens: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    
    // O controle com as cartas
    var ctrl_dados = ControleDeDados.controle
    
    // Controla se está ou não selecionando
//    @IBOutlet weak var btn_botao_esquerdo: UIBarButtonItem!
    var selecionando : Bool = false
    var cartas_selecionadas = [Carta] ()
    // Vou tentar fazer um hash disso
    var hash_selecionadas : [Bool] = [false]
    
    var excluindo = false
    var snapshotView : UIView!
    var originalSnapshotView : UIView!
    var indexPathSelecionado : IndexPath!
    
    // A view que faz o efeito de blur
    var blur_view : UIView!
    
    var tb : UIView!
    var lbl_tb : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes // TESTAR: isso aqui é pra n ter que castar o tipo toda vez, não é?
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id_cel_imagem)
        
        // Zera o hash de selecionados
        limpaSelecionadas()
        
        // Layout da collection
        let margens_laterais : CGFloat = 6
        let margens_verticais : CGFloat = 6
        let tamanho_item = (collectionView.frame.width - (4*margens_laterais)) / 2 // TEM QUE LEVAR EM CONTA AS CONTRAINTS TAMBÉM
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: margens_verticais, left: margens_laterais, bottom: margens_verticais, right: margens_laterais)
        layout.itemSize = CGSize(width: tamanho_item, height: tamanho_item) // FUTURO: fazer as celulas terem tamanho diferente e ir encaixando
        
        // Atribui o delegate de drag e drop

        
        ctrl_dados.carregar_imagens()
        ctrl_dados.atualiza_cartas()
        
        /* // Excluir tudo
        for c in (ctrl_dados.imagens_salvas as! [Pdata_carta]) {
            ctrl_dados.excluir_imagem_e_notas(id_imagem: c.id_imagem!)
        }
        */
        
        
        let posy_tb = (self.tabBarController?.tabBar.frame.origin.y)!
        let alt_tb = (self.tabBarController?.tabBar.frame.height)!

        let toolbar = UIView(frame: CGRect(x: 0, y: posy_tb, width: view.frame.width, height: alt_tb))
        toolbar.backgroundColor = .red
        
        let lbl_toolbar = UILabel(frame: toolbar.frame)
        lbl_toolbar.frame.size = CGSize(width: view.frame.width, height: alt_tb/2)
        lbl_toolbar.frame.origin = CGPoint(x: 0, y: toolbar.frame.size.height/4)
        //lbl_toolbar.backgroundColor = .blue
        
        let t = "Excluir"
        let range = (t as NSString).range(of: (t))   // "Tamanho" da linha dentro da string inteira. Range tem começo e fim"
        let attribute = NSMutableAttributedString.init(string: t)   // Cria uma string com atributos a partir da string inteira
        // Muda a fonte pra bold no intervalo definido por range
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 40) , range: range)
        
        //lbl_toolbar.attributedText = attribute
        lbl_toolbar.text = "Excluir"
        lbl_toolbar.font = lbl_toolbar.font.withSize(30)
        lbl_toolbar.adjustsFontSizeToFitWidth = true
        lbl_toolbar.textAlignment = .center
        lbl_toolbar.minimumScaleFactor = 0.1
        lbl_toolbar.textColor = .red//.white
        
        toolbar.backgroundColor = .white
        sombreiaView(v: toolbar, blur: 5, y: -1, opacidade: 0.5)
        
        toolbar.alpha = 0
        
        view.addSubview(toolbar)
        toolbar.addSubview(lbl_toolbar)
        tb = toolbar
        lbl_tb = lbl_toolbar
        
        self.navigationController?.hero.navigationAnimationType = .fade
        //self.tabBarController?.hero.tabBarAnimationType = .slide(direction: .left)

        self.collectionView.reloadData()
    }
    
    // Coloca sombra na view
    func sombreiaView (v : UIView!, blur : CGFloat, y: CGFloat, opacidade : Float) {
        v.layer.shadowOffset = CGSize(width: 0, height: y)
        v.layer.shadowRadius = blur
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOpacity = opacidade
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selecionando = false
        // Zera o hash de selecionados
        cancelaSelecionadas()
        limpaSelecionadas()
        atualizaBotoes()
        
        ctrl_dados.carregar_imagens()
        ctrl_dados.atualiza_cartas()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    
    
    // Remove tudo e depois vai acrescentando
    func limpaSelecionadas () {
        if ctrl_dados.num_cartas > 0 {
            hash_selecionadas.removeAll()
            for _ in 0 ... ctrl_dados.num_cartas-1 {
                hash_selecionadas.append(false)
            }
        }
    }
    
    
    // remove todo mundo que ta selecionado, começando de tras pra frente pra não dar erro
    func removeSelecionadas () {
        
        // DEIXAR DE PERMITIR MULTIPLA SELEC'ÃO DE IAMGENS
        for i in (0 ... hash_selecionadas.count-1).reversed() {
            if (hash_selecionadas[i]) {
                ctrl_dados.excluir_imagem_e_notas(id_imagem: ctrl_dados.cartas[i].id)
                ctrl_dados.cartas.remove(at: i)
                //collectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
        }
        ctrl_dados.atualiza_cartas()
        self.collectionView.reloadData()

    }
    
    
    // O que muda na celula quando ela está selecionada
    func selecionaCelula (celula : cel_imagemGaleria!) {
        celula.img_imagem.layer.borderColor = UIColor.green.cgColor
        //celula.img_imagem.backgroundColor = .black
        UICollectionView.animate(withDuration: 0.2, animations: {
            celula.img_imagem.layer.borderWidth = 6
            celula.alpha = 0.4
        })
    }
    
    
    // Como a celula fica quando não está selecionada
    func deselecionaCelula (celula : cel_imagemGaleria!) {
        //celula.img_imagem.backgroundColor = .clear
        UICollectionView.animate(withDuration: 0.2, animations: {
            celula.img_imagem.layer.borderWidth = 0
            celula.alpha = 1
        })
    }
    
    
    // Volta todo mundo pro estado normal
    func cancelaSelecionadas () {
        if (ctrl_dados.cartas.count > 0) {
            for i in 0 ... ctrl_dados.cartas.count-1 {
                if let celula = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? cel_imagemGaleria {
                    deselecionaCelula(celula: celula)
                }
            }
        }
    }
    
    
    
    
    // Selecionar/Cancelar
    @IBAction func botaoEsquerdo(_ sender: UIBarButtonItem) {
        selecionando = !selecionando
        atualizaBotoes()
    }
    


}


// -- Collection
extension vc_galeriaImagens {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Numero de seções
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Número de celulas
        return ctrl_dados.cartas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Pega a célula
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: id_cel_imagem, for: indexPath) as! cel_imagemGaleria
        
        // Configura a celula
        celula.carta = ctrl_dados.cartas[indexPath.row]
        celula.img_imagem.image = celula.carta.imagem // TESTAR: usar o viewWillAppear da celula
        celula.img_imagem.contentMode = .scaleAspectFill;
        celula.tag = indexPath.row
        celula.v_viewImagem.hero.id = String(celula.tag)
        //celula.img_imagem.hero.id = String(celula.tag)
        
        // Se a celula estiver selecionada
        if (selecionando) {
            if (hash_selecionadas[indexPath.row]) {
                selecionaCelula(celula: celula)
            }
            else {
                deselecionaCelula(celula: celula)
            }
        }
        else {   // Se não estiver selecionando
            deselecionaCelula(celula: celula)
        }
        
        let gestureLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(sender:)))
        gestureLongPressRecognizer.delegate = self
        celula.addGestureRecognizer(gestureLongPressRecognizer)
        
        celula.tag = indexPath.row
        
        celula.isMultipleTouchEnabled = true
        
        return celula
    }
    
    
    // MARK: UICollectionViewDelegate

    // Movendo a célula
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false//!selecionando
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {            ctrl_dados.cartas.insert(ctrl_dados.cartas.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    // Tocando na célula
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celula = collectionView.cellForItem(at: indexPath) as! cel_imagemGaleria
        
        if (selecionando) {   // Se está selecionando
            hash_selecionadas[indexPath.row] = !hash_selecionadas[indexPath.row]
            if (hash_selecionadas[indexPath.row]) {
                selecionaCelula(celula: celula)
            }
            else {
                deselecionaCelula(celula: celula)
            }
        }
        else {   // Caso não esteja selecionando
            if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_detalhes) as? vc_detalhesCarta {
                    vc.hid = String(celula.tag)
                    vc.carta = celula.carta // troquei da carta do controle para a carta da celula
                    vc.id_carta = celula.carta.id//(ctrl_dados.imagens_salvas[indexPath.row] as! Pdata_carta).id_imagem
                    self.navigationController?.show(vc, sender: self)
            }
        }
    }
    
}


// -- Image Picker
extension vc_galeriaImagens {
    // Deixa o usuario pegar uma foto da galeria
    // Precisa dar permissão em info.plist
    func imagemDaGaleria () {
        let imagem = UIImagePickerController()
        imagem.delegate = self
        
        imagem.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagem.allowsEditing = false
        print("VAI GALERIA!")
        self.present(imagem, animated: true) {
            // Completion
        }
    }
    
    
    // Controlador para pegar imagens da galeria. É chamada automaticamente.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagem = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("DEU CERRTO< ADDENDO")
            
            let number = Int.random(in: 0 ... 1000000)
            let chave = "Img_" + String(number)
            saveImage(image: imagem, nome: chave)
            
            ctrl_dados.cartas.append(Carta(id: chave, imagem: imagem))
            ctrl_dados.salvar_nova_imagem(id_imagem: chave)
            ctrl_dados.atualiza_cartas()
            
            self.collectionView.reloadData()
        }
        else {
            // Print Error, invalid format
            print("Formato zoouy")
        }
        
        self.dismiss(animated: true, completion: {
            self.collectionView.reloadData()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: id_vc_detalhes) as? vc_detalhesCarta {
                vc.hid = String(self.ctrl_dados.cartas.count-1)
                vc.carta = self.ctrl_dados.cartas[self.ctrl_dados.cartas.count-1] // troquei da carta do controle para a carta da celula
                vc.id_carta = vc.carta.id//(ctrl_dados.imagens_salvas[indexPath.row] as! Pdata_carta).id_imagem
                self.navigationController?.show(vc, sender: self)
            }
        }) // No completion?
    }
}


// -- Botões
extension vc_galeriaImagens {
    // Muda os icones dos botoes da navigation bar
    func atualizaBotoes () {
        if (selecionando) {   // Agora está selecionando. O que você deve ver quando estiver selecionando?
            //btn_botao_esquerdo.title = "Cancelar"
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(botaoDireito)) //UIBarButtonItem.SystemItem.trash
        }
        else {   // Agora não está selecionano. Quanis suas opções de ação?
            //btn_botao_esquerdo.title = "Selecionar"
//            for i in 0 ... hash_selecionadas.count-1 { // Tudo que estava selecionado
//                hash_selecionadas[i] = false
//            }
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(botaoDireito)) //UIBarButtonItem.SystemItem.trash
            cancelaSelecionadas()   // Tira as cores de quem tava selecionado
        }
    }
    
    
    // Botao da direita
    @objc // pra usar no selector
    func botaoDireito () {
        if (selecionando) {   // Remover
            /*
             remove das cartas quem está selecionado,
             reinicia o hash com false e o tamanho certo (n é muito otimizado)
             deixa de selecionar automaticamente
             atualiza o icone dos botoes
             */
            removeSelecionadas()
            limpaSelecionadas()
            selecionando = false
            atualizaBotoes()
        }
        else {   // Adicionar carta
            imagemDaGaleria()
        }
    }

}


// -- Gestures
extension vc_galeriaImagens {
    
    // Aperta e segura
    @objc
    func longPressGesture (sender: UILongPressGestureRecognizer) {
        print("Segurou")
        let v = sender.view!
        
        if sender.state == .began {
            collectionView.isScrollEnabled = false
            UIView.animate(withDuration: 0.1) {
                self.tabBarController?.tabBar.alpha = 0
                self.tb.alpha = 1
            }
            
            // resposta tátil
            let vibrar = UIImpactFeedbackGenerator(style: .light)
            vibrar.impactOccurred()
            //view.bringSubviewToFront(tb)
            
            indexPathSelecionado = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView))
            originalSnapshotView = (collectionView.cellForItem(at: indexPathSelecionado))!
            
            let snapshot = originalSnapshotView.snapshotView(afterScreenUpdates: true)
            collectionView.addSubview(snapshot!)
            
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.alpha = 0.0
            blurEffectView.backgroundColor = .white
            blurEffectView.frame = collectionView.frame//self.view.frame
            collectionView.addSubview(blurEffectView)
            blur_view = blurEffectView
            blur_view.frame.origin = CGPoint(x: blur_view.frame.origin.x, y: collectionView.contentOffset.y)
            
            UIView.animate(withDuration: 0.2) {
                self.blur_view.alpha = 0.35
            }
            
            collectionView.bringSubviewToFront(snapshot!)

            snapshot!.frame = originalSnapshotView.frame
            snapshotView = snapshot!
            sombreiaView(v: snapshotView, blur: 5, y: 1, opacidade: 1)
            
            originalSnapshotView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                self.snapshotView.center = sender.location(in: self.collectionView)
                self.snapshotView.frame.size = CGSize(width: v.frame.size.width*0.85, height: v.frame.size.height*0.85)
            }
            
        }
        
        if sender.state == .changed {

            // Move a imagem até o local de toque
            UIView.animate(withDuration: 0.2) {
                self.snapshotView.center = sender.location(in: self.collectionView)
            }
            
            // Muda a aparência do botão de excluir
            if tb.frame.contains(sender.location(in: self.view)) {
                UIView.animate(withDuration: 0.2) {
                    self.tb.backgroundColor = .red
                    self.lbl_tb.textColor = .white
                }
            }
            else {
                UIView.animate(withDuration: 0.2) {
                    self.tb.backgroundColor = .white
                    self.lbl_tb.textColor = .red
                }
            }
        }
        
        // Quando acaba o long press porque o usuario levantou o dedo, ou ele foi cancelado porque o toque foi interrompido
        if sender.state == .ended || sender.state == .cancelled {
            collectionView.isScrollEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 1
                self.tb.alpha = 0
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.blur_view.alpha = 0
            }) { (true) in
                self.blur_view.removeFromSuperview()
            }
            
            if sender.location(in: self.view).y > self.view.frame.height*0.85 {
                ctrl_dados.excluir_imagem_e_notas(id_imagem: ctrl_dados.cartas[indexPathSelecionado.row].id)
                ctrl_dados.cartas.remove(at: indexPathSelecionado.row)
                collectionView.deleteItems(at: [indexPathSelecionado])
                UIView.animate(withDuration: 0.2, animations: {
                    self.snapshotView.alpha = 0
                }) { (true) in
                    self.snapshotView.removeFromSuperview()
                }
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.snapshotView.frame.origin = self.originalSnapshotView.frame.origin
                    self.snapshotView.frame.size = CGSize(width: v.frame.size.width, height: v.frame.size.height)
                }) { (true) in
                    self.originalSnapshotView.isHidden = false
                    self.snapshotView.removeFromSuperview()
                }
                
                if sender.location(in: self.view).y > self.view.frame.height*0.75 {
                    excluindo = true
                    //let index = IndexPath(row: sender.view!.tag, section: 0)
                    //collectionView.deleteItems(at: [index])
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
