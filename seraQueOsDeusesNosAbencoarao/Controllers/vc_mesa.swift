//
//  vc_mesa.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 24/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

// id das telas
private let id_vc_detalhes = "id_detalhes"

// Esta tela serve para mostrar as mesas.
// Quando alguém toca numa mesa da galeria, esta tela é chamada e a "mesa" é atribuída.
class vc_mesa: UIViewController, UIGestureRecognizerDelegate {
    
    // A mesa sendo apresentada
    var mesa : Mesa!
    var nMesa : Int!
    var id_mesa : String!
    
    // O controle com as cartas
    var ctrl_dados = ControleDeDados.controle
    
    // Um array de ponteiros para as cartas da mesa?
    var cartas = [UIView] ()
    
    // View onde estão as cartas
    @IBOutlet weak var v_conteudo: UIView!
    
    // Botões da tela
    @IBOutlet weak var btn_botaoDireito: UIButton!
    @IBOutlet weak var btn_botaoEsquerdo: UIBarButtonItem!
    
    // Está ou não editando
    var editando = false
    
    // UIView selecionada, nil se não está selecionando
    var selecionada : UIView?
    
    // A toolbar, porqwue não consegui me referir a ela de outra maneira
    @IBOutlet weak var tb_toolbar: UIToolbar!
    
    // Pra receber a resposta quando a galeria devolver os dados
    var escolheu : Bool!
    var cartaEscolhida : Carta!
    
    // Algumas constantes para facilitar minha vida
    var maxLargImg : CGFloat!
    var maxAltuImg : CGFloat!
    var menorDimen : CGFloat = 120
    
    // Ajusta a imagem para só andarem de grid em grid
    var grid : Int = 5
    
    // Controla quem está aparecendo em cima
    var ztopo : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(botaoEditar)), animated: true)
        
        tb_toolbar.frame.size = CGSize(width: tb_toolbar.frame.width, height: tb_toolbar.frame.height + 5)
        
        // Começa com ngm ecolhendo nada, obviamente
        escolheu = false
        
        // Atribui as alturas máximas
        maxLargImg = v_conteudo.frame.size.width + 2
        maxAltuImg = v_conteudo.frame.size.height + 2

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("AParecendo: \(escolheu)")
        // Configura os botoes
        btn_botaoEsquerdo.isEnabled = false
        self.tabBarController?.tabBar.alpha = 1
        self.tabBarController?.tabBar.isHidden = false
        tb_toolbar.transform = self.tb_toolbar.transform.translatedBy(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)! - self.tb_toolbar.frame.origin.y)
        
        // Atribui o tamanho da mesa
        if mesa.tamanho != CGSize.zero {
            v_conteudo.frame = CGRect(origin: mesa.posicao, size: mesa.tamanho)
        }

        // Pega as cartas
        ctrl_dados.carregar_cartas()
        ctrl_dados.carregar_imagens()
        ctrl_dados.atualiza_cartas()
        mesa.conteudo.removeAll()
        if let v_cartas = ctrl_dados.cartas_salvas as? [Pdata_cartaNaMesa] {
            for carta in v_cartas {
                if carta.id_mesa == id_mesa {
                    let config = ControleCartaMesa(nota_mostrada: -1, id_mesa: id_mesa, id_carta: carta.id_carta!)
                    config.posicao = CGPoint(x: carta.pos_x, y: carta.pos_y)
                    config.tamanho = CGSize(width: carta.largura, height: carta.altura)
                    config.z = CGFloat(carta.z)
                    
                    print("a pos e o tam: \(config.posicao), \(config.tamanho), o que eu achei: \(carta.pos_x)")
                    
                    // Procura a imagem da carta
                    var conteudo : Carta!
                    var achou = false
                    for img in ctrl_dados.cartas {
                        if img.id == carta.id_imagem {
                            conteudo = img
                            achou = true
                        }
                    }
                    if achou {
                        mesa.conteudo.append((carta: conteudo, config: config))
                    }
                }
            }
        }
        
        // Cria as views
        ztopo = 0
        for (i, c) in mesa.conteudo.enumerated() {
            criarView(i: i, c: c)
            if cartas[i].layer.zPosition > ztopo {
                ztopo = cartas[i].layer.zPosition
            }
        }
        
        let vetor = cartas.sorted { (a, b) -> Bool in
            return a.layer.zPosition < b.layer.zPosition
        }
        
        for v in vetor {
            print("z: \(v.layer.zPosition)")
            v_conteudo.bringSubviewToFront(v)
        }
        
        // Se chegou aqui após escolher uma imagem
        if escolheu {
            recebeEscolha()
        }
        else if cartas.count == 0 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "id_escolheImagem") as? vc_escolherImagem {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    // Tem que remover toda a tranqueira acumulada
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Inicio")
        
        self.tabBarController?.tabBar.alpha = 1
        self.tabBarController?.tabBar.isHidden = false
        
        print("--------- SAINDO: tamanho = \(mesa.tamanho)")
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Vou salvar as cartas, mas pode dar problema porque a ordem de load não necessariamente respeita isso
        print("meio")
        for (i, par) in mesa.conteudo.enumerated() {
            for carta in ctrl_dados.cartas_salvas as! [Pdata_cartaNaMesa] {
                if carta.id_mesa == id_mesa && carta.id_carta == par.config.id_carta {
                    context.delete(carta)
                    
                    let c = Pdata_cartaNaMesa(context: context)
                    c.pos_x = Double(cartas[i].frame.origin.x) //Double(par.config.posicao.x)
                    c.pos_y = Double(cartas[i].frame.origin.y) //Double(par.config.posicao.y)
                    c.largura = Double(cartas[i].frame.size.width) //Double(par.config.tamanho.width)
                    c.altura = Double(cartas[i].frame.size.height) //Double(par.config.tamanho.height)
                    c.z = Float(cartas[i].layer.zPosition)
                    c.id_carta = par.config.id_carta
                    c.id_mesa = par.config.id_mesa
                    c.id_imagem = par.carta?.id
                    
                    print("Tá, salvei alguma coisa. salvando \(par.config.posicao.x), e foi salvo \(c.pos_x)")
                }
            }
        }
print("semi meio")
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        ctrl_dados.carregar_cartas()
        
        print("fim")
        let renderer = UIGraphicsImageRenderer(size: v_conteudo.bounds.size)
        let image = renderer.image { ctx in
            v_conteudo.drawHierarchy(in: v_conteudo.bounds, afterScreenUpdates: true)
        }
        mesa.icone = view.asImage()
        print("eh o print")
        saveImage(image: mesa.icone, nome: id_mesa)
        print("posimagem")
        for (i, v) in cartas.enumerated() {
            mesa.conteudo[i].config.posicao = v.frame.origin
            mesa.conteudo[i].config.tamanho = v.frame.size
            v.removeFromSuperview()
        }
        cartas.removeAll()
        //v_conteudo.transform = .identity
        print("fim mesmo")
    }

    
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
    
    
    // Cria uma view, coloca na tela e taus
    func criarView (i: Int, c: (carta: Carta?, config: ControleCartaMesa)!) {
        
        let imgLarg = (c.carta?.imagem.size.width)!
        let imgAlt = (c.carta?.imagem.size.height)!
        
        var v = UIView ()
        //v.contentMode = .scaleToFill
        let rx = imgLarg.rounded() - CGFloat(Int(imgLarg.rounded()) % grid)
        let ry = imgAlt.rounded() - CGFloat(Int(imgAlt.rounded()) % grid)
        print("posicao = \(c.config.posicao)")
        if c.config.tamanho == CGSize.zero && c.config.tamanho == .zero {
            print("to zerando")
            v = UIView(frame: CGRect(x: CGFloat(100), y: CGFloat(100), width: rx, height: ry) )
            // ((sf.height < cf.height/5) && (sf.width < cf.height/3))
            // sender.scale < 1 && (sf.height > 100 || sf.width > 100)
            let v_larg = v.frame.size.width
            let v_alt = v.frame.size.height
            if imgLarg > imgAlt {
                if imgLarg > maxLargImg {
                    v.frame.size = CGSize(width: v_larg*(maxLargImg/imgLarg), height: v_alt*maxLargImg/imgLarg)
                }
                else if imgLarg < menorDimen {
                    v.frame.size = CGSize(width: menorDimen, height: imgAlt*menorDimen/imgLarg)
                }
            }
            else {
                if imgAlt > maxAltuImg {
                    v.frame.size = CGSize(width: v_larg*(maxAltuImg/imgAlt), height: v_alt*maxAltuImg/imgAlt)
                }
                else if imgAlt < menorDimen {
                    v.frame.size = CGSize(width: imgLarg*menorDimen/imgAlt, height: menorDimen)
                }
            }
        }
        else {
            v = UIView(frame: CGRect(origin: c.config.posicao, size: c.config.tamanho) )
            v.layer.zPosition = c.config.z
        }
        v.backgroundColor = .orange
        v.tag = i
        let img = UIImageView (image: c.carta?.imagem)
        img.contentMode = .scaleAspectFit
        img.frame.size = v.frame.size
        v.addSubview(img)
        
        // Adiciona constraints na view para eu poder mudar o rect sem me preocupar em ter que mudar as subviews também
        img.translatesAutoresizingMaskIntoConstraints = true
        img.center = CGPoint(x: v.bounds.midX, y: v.bounds.midY)
        img.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        
        // Adiciona os gestures recognizers da view
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        gestureRecognizer.delegate = self
        v.addGestureRecognizer(gestureRecognizer)
        
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        gestureTapRecognizer.delegate = self
        v.addGestureRecognizer(gestureTapRecognizer)
        
        let gesturePinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(_:)))
        gesturePinchRecognizer.delegate = self
        v.addGestureRecognizer(gesturePinchRecognizer)
        
        cartas.append (v)
        v_conteudo.addSubview(v)
        
    }
    
    
    // É chamada quando a galeria termina os esquemas na hora de adicionar uma carta
    func recebeEscolha () {
        // Votlei
        print("ESTOJU DE  VOLTA, SENHORAS E SENHORES")
        if escolheu {
            print("ELE ESCOLHEU, QUE MILAGRE")
            let number = Int.random(in: 0 ... 1000000)
            let chave = "Carta_" + String(number)
            ctrl_dados.salvar_nova_carta(id_mesa: id_mesa, id_carta: chave)
            
            var c : (carta: Carta?, config: ControleCartaMesa)
            c.carta = cartaEscolhida
            c.config = ControleCartaMesa(nota_mostrada: -1, id_mesa: id_mesa, id_carta: chave)
            mesa.conteudo.append(c)
            
            criarView(i: mesa.conteudo.count-1, c: c)
            escolheu = false
        }
    }

    
    // Botao direito
    @IBAction func botaoDireito(_: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "id_escolheImagem") as? vc_escolherImagem {
            //(vc.viewControllers[0] as! vc_galeriaImagens).veioAdd = true
            self.present(vc, animated: true, completion: nil)
            botaoEditar()
            //self.navigationController?.show(vc, sender: self)
        }
    }
    
    
    // Botao esquerdo
    @IBAction func botaoEsquerdo(_: Any) {
        print("Botao esqeurdo")
        if selecionada != nil {   // Verifica pra ter certeza
            cartas.remove(at: selecionada!.tag)   // Tira do vetor de cartas
            mesa.conteudo.remove(at: selecionada!.tag)   // Tira da mesa salva também, pra não ter problemas de duas versões depois
            if cartas.count > selecionada!.tag {   // Verifica se tinham cartas depois dela no vetor
                for aux in selecionada!.tag ... cartas.count-1 {   // Se tinham, passa nelas atualizando as tags
                    cartas[aux].tag = aux
                }
            }
            selecionada!.removeFromSuperview()
            selecionada = nil
            btn_botaoEsquerdo.isEnabled = false
        }
    }
    
    
    // Botao direito 2
    @objc
    func botaoEditar () {
        editando = !editando
        if editando {
            navigationItem.rightBarButtonItem?.title = "Pronto"
            navigationItem.rightBarButtonItem?.style = .done
            tb_toolbar.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                //self.tb_toolbar.transform = self.tb_toolbar.transform.translatedBy(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)! - self.tb_toolbar.frame.origin.y)
                self.tb_toolbar.alpha = 1
                self.tabBarController?.tabBar.alpha = 0
            }, completion: { (true) in
                self.tabBarController?.tabBar.isHidden = true
            })

            if selecionada != nil {
                btn_botaoEsquerdo.isEnabled = true
            }
            else {
                btn_botaoEsquerdo.isEnabled = false
            }
        }
        else {
            navigationItem.rightBarButtonItem?.title = "Editar"
            navigationItem.rightBarButtonItem?.style = .plain
            self.tabBarController?.tabBar.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                //self.tb_toolbar.transform = self.tb_toolbar.transform.translatedBy(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)! - self.tb_toolbar.frame.origin.y)
                self.tb_toolbar.alpha = 0
                self.tabBarController?.tabBar.alpha = 1
            }, completion: nil)
        
            if selecionada != nil {
                descelecionaView(v: selecionada)
            }
        }
    }
    
    
    func salvarMesa () {
        
    }
    
    
    // Gesto de arrastar
    @objc
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let pointQuadro = sender.translation(in: v_conteudo)
        let v = sender.view!
        
        print("PANNNKASN: \(escolheu)")
        //let desloc_x = CGFloat(Int(pointQuadro.x) - (Int(pointQuadro.x) % grid))
        if  abs(pointQuadro.x) >= CGFloat(grid) || abs(pointQuadro.y) >= CGFloat(grid) {
            v.transform = v.transform.translatedBy(x: pointQuadro.x, y: pointQuadro.y)
            sender.setTranslation(CGPoint.zero, in: v_conteudo)
        }
        
        if sender.state == .ended {
            if v.frame.origin.x + v.frame.width > v_conteudo.frame.width {
                UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                    v.frame.origin = CGPoint(x: self.v_conteudo.frame.width - v.frame.width - 1, y: v.frame.origin.y)
                }, completion: nil)
            }
            if v.frame.origin.y + v.frame.height > v_conteudo.frame.height {
                UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                    v.frame.origin = CGPoint(x: v.frame.origin.x, y: self.v_conteudo.frame.height - v.frame.height - 1)
                }, completion: nil)
            }
            if v.frame.origin.x < 0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                    v.frame.origin = CGPoint(x: 1, y: v.frame.origin.y)
                }, completion: nil)
            }
            if v.frame.origin.y < 0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                    v.frame.origin = CGPoint(x: v.frame.origin.x, y: 1)
                }, completion: nil)
            }
        }
    }
    
    
    // Modificacoes ao selecionar uma view
    func selecionaView (v: UIView!) {
        selecionada = v
        selecionada!.layer.borderWidth = 10
        selecionada!.layer.borderColor = UIColor.green.cgColor
        btn_botaoEsquerdo.isEnabled = true
    }
    
    
    // Volta ao view ao normal ao descelecionar
    func descelecionaView (v: UIView!) {
        selecionada!.layer.borderWidth = 0
        selecionada = nil
        btn_botaoEsquerdo.isEnabled = false
    }
    
    // Tap gesture controller
    @objc
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if editando {
            let v = sender.view!
            if v.tag >= 0 {
                v_conteudo.bringSubviewToFront(v)
                v.layer.zPosition = ztopo+1
                ztopo = ztopo+1
                if selecionada == v {
                    descelecionaView(v: v)
                }
                else if selecionada != nil {
                    descelecionaView(v: selecionada)
                    selecionaView(v: v)
                }
                else {
                    selecionaView(v: v)
                }
            }
            else {
                if selecionada != nil {
                    descelecionaView(v: selecionada)
                }
            }
        }
        else {
            if sender.view!.tag >= 0 {
                if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_detalhes) as? vc_detalhesCarta {
                    let n = sender.view!.tag
                    vc.carta = mesa.conteudo[n].carta // troquei da carta do controle para a carta da celula
                    //vc.data_carta = (ctrl_dados.imagens_salvas[indexPath.row] as! Pdata_carta)
                    vc.id_carta = mesa.conteudo[n].carta?.id
                    self.navigationController?.show(vc, sender: self)
                }
            }
        }
    }
    

    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if true {
            print("tag da view do pinch: \(sender.view!.tag)")
            if sender.view!.tag >= 0 {//selecionada != nil {
                let selecionada = sender.view!
                let sf = selecionada.frame
                let cf = v_conteudo.frame
                
                var v_larg = selecionada.frame.size.width
                var v_alt = selecionada.frame.size.height
                var imgLarg = v_larg
                var imgAlt = v_alt
                
//                let rx = imgLarg.rounded() - CGFloat(Int(imgLarg.rounded()) % grid)
//                let ry = imgAlt.rounded() - CGFloat(Int(imgAlt.rounded()) % grid)
                
                if sender.scale > 1 {
                    if ((sf.height < maxAltuImg) && (sf.width < maxLargImg)) {
                        selecionada.frame.size = CGSize(width: v_larg*sender.scale, height: v_alt*sender.scale)
                        let p = selecionada.frame.origin
                        //selecionada.frame.origin = CGPoint(x: p.x + (v_larg*sender.scale - v_larg)/2, y: p.y + (v_alt*sender.scale - v_alt)/2)
                        selecionada.center = sender.location(in: v_conteudo)
                        sender.scale = 1
                    }
                }
                else if sender.scale < 1 && (sf.height > menorDimen || sf.width > menorDimen) {
                    selecionada.frame.size = CGSize(width: v_larg*sender.scale, height: v_alt*sender.scale)
                    let p = selecionada.frame.origin
                    selecionada.center = sender.location(in: v_conteudo)//CGPoint(x: p.x + (v_larg*sender.scale - v_larg)/2, y: p.y + (v_alt*sender.scale - v_alt)/2)
                    sender.scale = 1
                }
                v_larg = selecionada.frame.size.width
                v_alt = selecionada.frame.size.height
                imgLarg = v_larg
                imgAlt = v_alt
                if imgLarg > imgAlt {
                    if imgLarg > maxLargImg {
                        selecionada.frame.size = CGSize(width: v_larg*(maxLargImg/imgLarg), height: v_alt*maxLargImg/imgLarg)
                    }
                    else if imgLarg < menorDimen {
                        selecionada.frame.size = CGSize(width: menorDimen, height: imgAlt*menorDimen/imgLarg)
                    }
                }
                else {
                    if imgAlt > maxAltuImg {
                        selecionada.frame.size = CGSize(width: v_larg*(maxAltuImg/imgAlt), height: v_alt*maxAltuImg/imgAlt)
                    }
                    else if imgAlt < menorDimen {
                        selecionada.frame.size = CGSize(width: imgLarg*menorDimen/imgAlt, height: menorDimen)
                    }
                }
            }
        }
    }
    
    
}

extension UIImage {
    class func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
