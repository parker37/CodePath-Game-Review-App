//
//  ReviewViewController.swift
//  Navi-App
//
//  Created by Brandon Mack on 4/9/22.
//

import UIKit
import Parse

class ReviewViewController: UIViewController {

    @IBOutlet weak var reviewField: UITextField!
    
    var selectedGame: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Reviews")
        
        post["reviewText"] = reviewField.text!
        post["author"] = PFUser.current()!
        post["game"] = selectedGame
        //post["rating"] =
        
        selectedGame.add(post, forKey: "reviews")
        
        selectedGame.saveInBackground { (success, error) in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
