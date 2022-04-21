//
//  ReviewViewController.swift
//  Navi-App
//
//  Created by Brandon Mack on 4/9/22.
//

import UIKit
import Parse

class ReviewViewController: UIViewController {

    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var Star_1: UIImageView!
    @IBOutlet weak var Star_2: UIImageView!
    @IBOutlet weak var Star_3: UIImageView!
    @IBOutlet weak var Star_4: UIImageView!
    @IBOutlet weak var Star_5: UIImageView!
    
    var selectedGame: String!
    var rating: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Reviews")
        
        post["reviewText"] = reviewField.text!
        post["author"] = PFUser.current()!
        post["game"] = selectedGame
        post["rating"] = rating
        
        
        post.saveInBackground { (success, error) in
            if (success){
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }
            else {
                print("error!")
            }
        }
        
        
        
        performSegue(withIdentifier: "back2ThePast" , sender: self)
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func StarTap1(_ sender: Any) {
        Star_2.image = Star_2.image?.withRenderingMode(.alwaysTemplate)
        Star_2.tintColor = UIColor.lightGray
        Star_3.image = Star_3.image?.withRenderingMode(.alwaysTemplate)
        Star_3.tintColor = UIColor.lightGray
        Star_4.image = Star_4.image?.withRenderingMode(.alwaysTemplate)
        Star_4.tintColor = UIColor.lightGray
        Star_5.image = Star_5.image?.withRenderingMode(.alwaysTemplate)
        Star_5.tintColor = UIColor.lightGray
        rating = 1
    }
    @IBAction func StarTap2(_ sender: Any) {
        Star_2.image = Star_2.image?.withRenderingMode(.alwaysTemplate)
        Star_2.tintColor = UIColor.systemYellow
        Star_3.image = Star_3.image?.withRenderingMode(.alwaysTemplate)
        Star_3.tintColor = UIColor.lightGray
        Star_4.image = Star_4.image?.withRenderingMode(.alwaysTemplate)
        Star_4.tintColor = UIColor.lightGray
        Star_5.image = Star_5.image?.withRenderingMode(.alwaysTemplate)
        Star_5.tintColor = UIColor.lightGray
        rating = 2
    }
    @IBAction func StarTap3(_ sender: Any) {
        Star_2.image = Star_2.image?.withRenderingMode(.alwaysTemplate)
        Star_2.tintColor = UIColor.systemYellow
        Star_3.image = Star_3.image?.withRenderingMode(.alwaysTemplate)
        Star_3.tintColor = UIColor.systemYellow
        Star_4.image = Star_4.image?.withRenderingMode(.alwaysTemplate)
        Star_4.tintColor = UIColor.lightGray
        Star_5.image = Star_5.image?.withRenderingMode(.alwaysTemplate)
        Star_5.tintColor = UIColor.lightGray
        rating = 3
    }
    @IBAction func StarTap4(_ sender: Any) {
        Star_2.image = Star_2.image?.withRenderingMode(.alwaysTemplate)
        Star_2.tintColor = UIColor.systemYellow
        Star_3.image = Star_3.image?.withRenderingMode(.alwaysTemplate)
        Star_3.tintColor = UIColor.systemYellow
        Star_4.image = Star_4.image?.withRenderingMode(.alwaysTemplate)
        Star_4.tintColor = UIColor.systemYellow
        Star_5.image = Star_5.image?.withRenderingMode(.alwaysTemplate)
        Star_5.tintColor = UIColor.lightGray
        rating = 4
    }
    @IBAction func StarTap5(_ sender: Any) {
        Star_2.image = Star_2.image?.withRenderingMode(.alwaysTemplate)
        Star_2.tintColor = UIColor.systemYellow
        Star_3.image = Star_3.image?.withRenderingMode(.alwaysTemplate)
        Star_3.tintColor = UIColor.systemYellow
        Star_4.image = Star_4.image?.withRenderingMode(.alwaysTemplate)
        Star_4.tintColor = UIColor.systemYellow
        Star_5.image = Star_5.image?.withRenderingMode(.alwaysTemplate)
        Star_5.tintColor = UIColor.systemYellow
        rating = 5
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
