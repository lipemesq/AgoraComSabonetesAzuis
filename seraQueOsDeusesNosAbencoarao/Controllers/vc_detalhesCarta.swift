//
//  vc_detalhesCarta.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 14/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import Hero
import CoreData

/*
 Tela de detalhes da carta, onde mostra a imagem dela e as notas a respeito da imagem.
 Tem que redirecionar para uma tela de zoom quando clicar na imagem
 e permitir editar as notas, mandando para outra tela com Hero
*/
// id das celulas
private let id_cel_nota = "id_nota"
private let id_cel_addNota = "id_addNota"

// id das telas
private let id_vc_editarNota = "id_editarNota"
private let id_vc_zoomImagem = "id_zoomImg"


class vc_detalhesCarta: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var carta : Carta!
    var id_carta : String!
    
    // O controle com as cartas
    var ctrl_dados = ControleDeDados.controle
    
    // A grande imagem da carta
    @IBOutlet weak var img_imagemCarta: UIImageView!
    
    // e a view onde fica a imagem (moldura)
    @IBOutlet weak var v_molduraImagem: UIView!
    
    // A table view das notas
    @IBOutlet weak var tv_notas: UITableView!
    
    // TESTE: Scroll view
    @IBOutlet weak var scv_quadro: UIView!
    
    @IBOutlet weak var lbl_texto: UILabel!
    
    var hid : String!
    
    // A scroll view que da imagem
    @IBOutlet weak var scv_scroll: UIScrollView!
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        v_molduraImagem.hero.id = hid
        //img_imagemCarta.hero.id = hid
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Atribui os controladores da tabela a isso aqui
        tv_notas.delegate = self
        tv_notas.dataSource = self
        
        // Avisa a table view que as celulas terão tamanhos distintos
        tv_notas.rowHeight = UITableView.automaticDimension
        tv_notas.estimatedRowHeight = tv_notas.frame.height
        
        // Coloca os botoes na navigation bar
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(botaoDireita))
        
        // Hora de atribuir as sombras para a imagem
        sombreiaView(v: v_molduraImagem, blur: 7, y: 2, opacidade: 0.6)
        
        // Seta a transição padrão da navigation controller como fade. Fica mais fofinha quando junta com a Hero
        self.navigationController?.hero.navigationAnimationType = .fade
        
        // O título desta tela
        self.navigationItem.title = "Nota"
        
        scv_scroll.delegate = self
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Atualiza a imagem para a carta atual
        img_imagemCarta.image = carta.imagem
        
        // Procura a carta atual nas existentes
        ctrl_dados.carregar_imagens()
        ctrl_dados.carregar_notas()
        
        /*
        // Exclui todas as notas
        for n in (ctrl_dados.notas_salvas as! [Pdata_nota]) {
            ctrl_dados.excluir_nota(id_imagem: n.id_imagem!, id_nota: n.id_nota!)
        }
        */
        
        // Procura a nota sendo mostrada
        var achou = false
        for (i, imagem) in (ctrl_dados.imagens_salvas as! [Pdata_carta]).enumerated() {
            if imagem.id_imagem == id_carta {
                //img_imagemCarta.image = ctrl_dados.cartas[i].imagem
                achou = true
            }
        }
        if !achou {
            dismiss(animated: true, completion: nil)
        }
        
        carta.notas.removeAll()
        for nota in (ctrl_dados.notas_salvas as! [Pdata_nota]){
            if nota.id_imagem == id_carta {
                carta.notas.append(Nota(id: nota.id_nota!, texto: nota.texto!, cor: Int(nota.cor)))
            }
        }
        
        if carta.notas.count == 0 {
            addNota()
        }
        
        // Atualiza os dados da tabela (porque muda na tela de edição e eu não sei fazer de outra forma)
        tv_notas.reloadData()
        
        //lbl_texto.text = carta.notas[0].texto
        //scv_quadro.backgroundColor = .lightGray
        
    }
    
    
    // Coloca sombra na view
    func sombreiaView (v : UIView!, blur : CGFloat, y: CGFloat, opacidade : Float) {
        v.layer.shadowOffset = CGSize(width: 0, height: y)
        v.layer.shadowRadius = blur
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOpacity = opacidade
    }

    
    // Adiciona uma nota
    func addNota () {
        // Salva a nova nota nos dados com a sua própria chave
        let number = Int.random(in: 0 ... 1000000)
        let chave = "Nota_" + String(number)
        ctrl_dados.salvar_nova_nota(id_imagem: id_carta, id_nota: chave, texto: "Nova nota: ", cor: 0)
        
        carta.notas.append(Nota(id: chave, texto: "nova nota", cor: 0))
        
        // Pega o índice de onde vai inserir (-1 porque acabou de aumentar o tamanho, inserindo ao final)
        let index = IndexPath(row: carta.notas.count-1, section: 0)
        
        // Coloca lá com uma animação
        tv_notas.insertRows(at: [index], with: .automatic)
    }
    
    
    // Arruma uma string em uma lbl para que a primeira linha fique em negrito
    func arrumaTexto (t : String, lbl : UILabel) {
        let titulo = t.components(separatedBy: CharacterSet.newlines).first ?? ""   // Pega a primeira linha separando a string em endl
        print("T= \(titulo)")
        
        let range = (t as NSString).range(of: (titulo))   // "Tamanho" da linha dentro da string inteira. Range tem começo e fim"
        let attribute = NSMutableAttributedString.init(string: t)   // Cria uma string com atributos a partir da string inteira
        // Muda a fonte pra bold no intervalo definido por range
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17) , range: range)
        
        lbl.attributedText = attribute
    }
    
    func arrumaTexto2 (t : String, lbl : UITextView) {
        let titulo = t.components(separatedBy: CharacterSet.newlines).first ?? ""   // Pega a primeira linha separando a string em endl

        let range = (t as NSString).range(of: (titulo))   // "Tamanho" da linha dentro da string inteira. Range tem começo e fim"
        let attribute = NSMutableAttributedString.init(string: t)   // Cria uma string com atributos a partir da string inteira
        attribute.addAttribute(.font, value: UIFont(name: "Helvetica", size: 20)!, range: (t as NSString).range(of: (t)))
        // Muda a fonte pra bold no intervalo definido por range
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 20)!, range: range)
        
        lbl.attributedText = attribute
    }
    
    
    // Delegate da Scroll View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img_imagemCarta
    }
    

    
    // MARK: - Data Source Table View
    
    // Numero de sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Numero de celulas, +1 pela de adicionar uma nota
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//carta.notas.count
    }
    
    
    // test
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //.celula.lbl_texto.frame.height + 24
    }

    
    
    // Decide se uma celula pode ou não ser editada
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // Exclui a celula
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // Retira dos salvos
            ctrl_dados.excluir_nota(id_imagem: id_carta, id_nota: carta.notas[indexPath.row].id)
            
            // Tira dos dados
            carta.notas.remove(at: indexPath.row)
            
            // Tira da tableview
            tv_notas.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // Decide se uma celula pode ou não ser movida
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false//true
    }
    
    
    // Move uma celula
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        carta.notas.insert(carta.notas.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    
    // Cria a celula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: id_cel_nota, for: indexPath) as! cel_notaDetalhes

        //celula.lbl_texto.text = carta.notas[indexPath.row].texto
        
        // Atribui o texto já com titulo na lbl

        arrumaTexto2(t: carta.notas[indexPath.row].texto, lbl: celula.txf_mural)// celula.lbl_texto)
        //celula.txf_mural.font = UIFont(name: "Helvetica", size: 20)

        // Coloca cor no quadrinho da celula
        celula.v_fundoNota.backgroundColor = ctrl_dados.cores_notas[carta.notas[indexPath.row].cor]
        
        // Coloca a sombra no quadrinho da celula
        sombreiaView(v: celula.v_fundoNota, blur: 5, y: 1, opacidade: 0.5)
        
        // Hero ID para a transição fofinha
        celula.hero.id = "cel_\(indexPath.row)"
        celula.v_fundoNota.hero.id = "f_cel_\(indexPath.row)"
        
        // Permite mover a celula quando estiver editando
        celula.showsReorderControl = true
        
        //celula.v_fundoNota.sizeToFit()
        // Tamanho mínimo da célula
        celula.minHeight = tv_notas.frame.height//, celula.lbl_texto.frame.height + 24)
        //celula.textLabel?.sizeToFit()
        celula.hero.modifiers = [.translate(y: tv_notas.frame.height)]
        
        return celula
    }
    
    
    // Trata o toque na celula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_editarNota) as? vc_editarNota {
            //vc.nota = carta.notas[indexPath.row]
            vc.id_imagem = id_carta
            vc.id_nota = carta.notas[indexPath.row].id
            
            let celula = tv_notas.cellForRow(at: indexPath) as! cel_notaDetalhes
            vc.hid = celula.v_fundoNota.hero.id   // Coloca o heroID certo na view de lá
            ///self.navigationController?.present(vc, animated: true, completion: nil) //.show(vc, sender: self)
            self.navigationController?.show(vc, sender: self)
        }
    }
    
    
    // MARK: - Interface
    
    // Tocou na ultima celula, a de adicionar notas
    @IBAction func botaoAdicionarCarta(_ sender: UIButton) {
        addNota()
    }
    
    
    // Tocou no botao da direita
    @objc
    func botaoDireita () {
        tv_notas.isEditing = !(tv_notas.isEditing)
        if (tv_notas.isEditing) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(botaoDireita))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(botaoDireita))
        }
    }
    
    
    // Função que capta o toque na tela
    @IBAction func gestoToque(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_zoomImagem) as? vc_zoomImagem {
            vc.imagem = carta.imagem
            ///self.navigationController?.present(vc, animated: true, completion: nil) //.show(vc, sender: self)
            self.navigationController?.pushViewController(vc, animated: true)//(vc, sender: self)
        }
    }
    

}
