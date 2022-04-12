//
//  ProfileViewController.swift
//  Navi-App
//
//  Created by Gerone Hamilton Jr. on 4/11/22.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
        
    }
    

    @IBOutlet weak var SubmitTopGame: UIButton!
    @IBOutlet weak var TopGame: UITextField!
    @IBOutlet weak var PickerView: UIPickerView!
    let data = ["Action", "Sports", "RPG", "Fighting", "Adventure", "Racing"]
    @IBOutlet weak var ProfilePicture: UIImageView!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        PickerView.delegate = self
        PickerView.dataSource = self
        // Do any additional setup after loading the view.
        let user = PFUser.current()!
        PickerView.selectRow(user["TopGenre"] as! Int, inComponent: 1, animated: false)
        TopGame.text = user["TopGame"] as? String
        ProfilePicture.image = user["ProfilePicture"] as? UIImage
        
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        let user = PFUser.current()!
       
        user["TopGenre"] = PickerView.selectedRow(inComponent: 1)
        user["TopGame"] = TopGame.text!
       
        user.saveInBackground(block: { success, Error in
            if (Error != nil){
                print(Error!)
            }
                else if success{
                   print("profile picture updated")
                }
        })
    }
    
    @IBAction func onProfilePicChange(_ sender: Any) {
        let picker =  UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        print("pictureupdated")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 144, height: 144)
        let scaleImage = image.af.imageAspectScaled(toFill: size, scale: nil)
        ProfilePicture.image = scaleImage
        
        let user = PFUser.current()!
        let imagedata = ProfilePicture.image!.pngData()
        let file = PFFileObject(name: "Profileimage.png", data: imagedata!)
        user["ProfilePicture"] = file!
        user.saveInBackground(block: { success, Error in
            if (Error != nil){
                print(Error!)
            }
                else if success{
                   print("profile picture updated")
                }
        })
        

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
