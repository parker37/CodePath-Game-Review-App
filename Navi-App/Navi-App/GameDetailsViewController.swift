//
//  GameDetailsViewController.swift
//  Navi-App
//
//  Created by Brandon Mack on 4/7/22.
//

import UIKit
import Parse
import MessageInputBar
import AlamofireImage

class GameDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var coverArtView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var titleSelection: String!
    var descriptionSelection: String!
    var coverSelection: UIImageView!
    var reviews = [PFObject]()
    var selectedReview: PFObject!
    var selectedGame: [String:Any]!
    
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleLabel.text = titleSelection
        descriptionLabel.text = (selectedGame["summary"]! as! String)
        
        tableView.keyboardDismissMode = .interactive

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func unwindToDetails(seg: UIStoryboardSegue) {
        viewDidAppear(true)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Reviews")
        query.whereKey("game", equalTo: selectedGame["name"]!)
        query.includeKeys(["author", "author.profileImage", "reviewText", "comments","comments.author", "comments.profileImage"])
        query.findObjectsInBackground {(reviews, error) in
            if (reviews != nil) {
                
                self.reviews = reviews!
                self.tableView.reloadData()
            }
        }
    }
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = selectedReview
        comment["author"] = PFUser.current()!

        selectedReview.add(comment, forKey: "comments")

        selectedReview.saveInBackground{(success, error) in
            if (success){
              print("Comment saved")
            }
            else {
              print("Error saving comment")
            }

        }
        
        tableView.reloadData()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let review = reviews[section]
        let comments = (review["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.section]
        let comments = (review["comments"] as? [PFObject]) ?? []
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            
            let user = review["author"] as! PFUser
            cell.usernameLabel.text = user.username
            cell.reviewLabel.text = review["reviewText"] as? String
            
            
            if (user["profileImage"] != nil) {
                let imageFile = user["profileImage"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                cell.profileView.af.setImage(withURL: url)
            } else {
                cell.profileView.image = UIImage(named: "profile-photo.png")
            }
       
            return cell
        }
        else if (indexPath.row <= comments.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1 ]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            if (user["profileImage"] != nil) {
                let imageFile = user["profileImage"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                cell.profilePicView.af.setImage(withURL: url)
            } else {
                cell.profilePicView.image = UIImage(named: "profile-photo-filled.png")
            }
                        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let review = reviews[indexPath.section]
        let comments = (review["comments"] as? [PFObject]) ?? []
        
        if (indexPath.row == comments.count + 1){
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedReview = review
        }
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ReviewViewController {

            dest.selectedGame = (selectedGame["name"] as! String)
            
        }
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
