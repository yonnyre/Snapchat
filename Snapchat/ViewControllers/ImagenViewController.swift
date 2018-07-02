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
import AVFoundation

class ImagenViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    @IBOutlet weak var grabarAudioBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    var audioID = NSUUID().uuidString
    var audioURLs : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elegirContactoBoton.backgroundColor = UIColor.darkGray
        elegirContactoBoton.layer.cornerRadius = elegirContactoBoton.frame.height / 2
        elegirContactoBoton.setTitleColor(UIColor.white, for: .normal)
        elegirContactoBoton.layer.shadowColor = UIColor.red.cgColor
        
        grabarAudioBoton.backgroundColor = UIColor.darkGray
        grabarAudioBoton.layer.cornerRadius = grabarAudioBoton.frame.height / 2
        grabarAudioBoton.setTitleColor(UIColor.white, for: .normal)
        grabarAudioBoton.layer.shadowColor = UIColor.red.cgColor
        
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        setupRecorder()
        hideKeyBoardWhenTap()

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
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
        let audiosFolder = Storage.storage().reference().child("audios")
        let imageData = UIImagePNGRepresentation(imageView.image!)
        let audioData = NSData(contentsOf:audioURL!)! as Data

        imagesFolder.child("\(imagenID).jpg").putData(imageData!, metadata: nil, completion: { ( metadata, error ) in
            print("Intentando subir la imagen")
            if error != nil {
                print("Ocurrio un error \(String(describing: error))")
            } else {
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
        audiosFolder.child("\(audioID).m4a").putData(audioData, metadata: nil, completion:{(metadata, error) in
            print("Intentando subir audio")
            if error != nil {
                print("Ocurrió un error \(String(describing: error))")
            } else {
                audiosFolder.child("\(self.imagenID).jpg").downloadURL(completion: { (url, error) in
                    print(url)
                    if error != nil{
                        print(error!)
                        return
                    }
                    if url != nil {
                        print(url!.absoluteString)
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url!.absoluteString)
                    }
                })
            }
        })
    }
   
    @IBAction func grabarAudioTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            audioRecorder?.stop()
            
            grabarAudioBoton.setTitle("Record", for: .normal)

        }else{
            audioRecorder?.record()
            
            grabarAudioBoton.setTitle("Stop", for: .normal)
        }
    }
    
    
    func setupRecorder(){
        do {
            // creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Creando una direccion para el archivo audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("******************************")
            print(audioURL!)
            print("******************************")
            
            // Crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // Crear el objeto de grabaciones de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError{
            print(error)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.audioURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.audioID = audioID

    }
}
extension UIViewController {
    
    func hideKeyBoardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SnapsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
