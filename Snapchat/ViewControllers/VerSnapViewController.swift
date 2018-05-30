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

class VerSnapViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Label.text? = snap.descrip
        ImageView.sd_setImage(with: URL(string: snap.imagenURL))

    }

    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
            print("se elimino la imagen correctamente")
        }
    }
    

}
