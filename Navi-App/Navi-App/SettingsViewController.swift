//
//  SettingsViewController.swift
//  Navi-App
//
//  Created by Jnya Reese on 4/7/22.
//

import UIKit
import AlamofireImage
import Parse

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let user = PFUser.current()!
        if (user["profileImage"] != nil) {
            let imageFile = user["profileImage"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            profileImageView.af.setImage(withURL: url)
        } else {
            profileImageView.image = UIImage(named: "profile-photo-filled.png")
        }
    }
    

    @IBAction func onSaveButton(_ sender: Any) {
        let userInfo = PFUser.current()!
        
        userInfo["username"] = usernameTextField.text!
        userInfo["password"] = passwordTextField.text!
        
        
//        let imageQuery = PFQuery(className: "User")
//        imageQuery.whereKeyExists("profileImage")
//        imageQuery.whereKey("profileImage", doesNotMatch: imageQuery)

        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(name: "profileImage.png", data: imageData!)
        
        userInfo["profileImage"] = file
        
        userInfo.saveInBackground() { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
    }

    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        profileImageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
