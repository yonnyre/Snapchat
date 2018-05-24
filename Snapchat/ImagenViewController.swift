//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by yonny on 22/05/18.
//  Copyright © 2018 Yonnyr Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ImagenViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
   
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoBoton.isEnabled = false
        let imagesFolder = Storage.storage().reference().child("imagenes")
        let imageData = UIImagePNGRepresentation(imageView.image!)
        
        imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imageData!, metadata: nil, completion: { ( metadata, error ) in
            print("Intentando subir la imagen")
            if error != nil {
                print("Ocurrio un error \(String(describing: error))")
            } else {
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
}
