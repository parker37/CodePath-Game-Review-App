//
//  ProfileViewController.swift
//  Navi-App
//
//  Created by Ronte' Parker on 4/12/22.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel;
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.text = data[row]
        label.textAlignment = .center
        label.font = UIFont(name: "Zen Dots", size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }
    
    let data = ["Action","Sports","RPG","Fighting","Adventure","Racing"]
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topGenre: UIPickerView!
    @IBOutlet weak var topGame: UITextField!
    @IBAction func onSave(_ sender: Any) {
        let user = PFUser.current()!
        user["topGenre"] = topGenre.selectedRow(inComponent: 0)
        user["topGame"] = topGame.text!
        
        user.saveInBackground { success, error in
            if success {
                print("saved")
            } else {
                print(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topGenre.delegate = self
        topGenre.dataSource = self
        
        topGame.backgroundColor = UIColor .lightGray
        let user = PFUser.current()!
        if user["profileImage"] != nil {
            let image = (user["profileImage"] as! PFFileObject).url!
            profileImage.af.setImage(withURL: URL(string: image)!)
        }
        if user["topGame"] != nil {
            topGame.text = user["topGame"] as? String
        }
        if user["topGenre"] != nil {
            topGenre.selectRow(user["topGenre"] as! Int, inComponent: 0, animated: false)
        }
        
        // Do any additional setup after loading the view.
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
