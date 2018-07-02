//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by yonny on 30/05/18.
//  Copyright © 2018 Yonnyr Team. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var Audio: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    var snap = Snap()
    var audioPlayer : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        Audio.backgroundColor = UIColor.blue
        Audio.layer.cornerRadius = Audio.frame.height / 2
        Audio.setTitleColor(UIColor.white, for: .normal)
        Audio.layer.shadowColor = UIColor.red.cgColor

        Label.text? = snap.descrip
        ImageView.sd_setImage(with: URL(string: snap.imagenURL))

    }

    @IBAction func reproducir(_ sender: Any) {
        do {
            let audioURL: URL = NSURL(string: snap.audioURL)! as URL
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
            audioPlayer!.play()
        } catch {}
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
            print("se elimino la imagen correctamente")
        }
    }
    

}
