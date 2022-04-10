//
//  ViewController.swift
//  Navi-App
//
//  Created by Jnya Reese on 3/29/22.
//

import UIKit
import AlamofireImage
import Parse

class GameGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return games.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameGridViewCell", for: indexPath) as! GameGridViewCell;
        let game = games[indexPath.item];
        
        if (game["coverURL"] as! String == "none") {
            cell.coverArt.image = UIImage(named: "missingCoverArt.png");
        } else {
            let coverArtURL = URL(string: game["coverURL"] as! String);
            cell.coverArt.af.setImage(withURL: coverArtURL!);
        }
        cell.gameTitle.text = game["name"] as? String;
        
        return cell;
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var games : [[String:Any]] = []
    
    
    
//    var coverURLs = [String]();
    var numOfGames = 7;
    
//    struct GamesAPIResponse: Decodable {
//        var id: Int
//        var cover: Int
//        var name: String
//    }
    
//    struct CoverArtAPIResponse: Decodable {
//        var url: String
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        
        
        /*
        let url = URL(string: "https://api.igdb.com/v4/games")!;
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        request.httpMethod = "POST";
        request.httpBody = "fields name,cover; limit \(numOfGames);".data(using: .utf8, allowLossyConversion: false)
        request.setValue("abo18sby3sk9q1khik70u4tb10xzvj", forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer d8ne6x6cx1a377ktjn6o0gdg6yzk9v", forHTTPHeaderField: "Authorization");
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let dataDict = try! String(data: data, encoding: .utf8)
//                 self.games = try! JSONDecoder().decode(Array<GamesAPIResponse>.self, from: data)
                 
//                 print("\nresponse: \n\(self.games)")
                 print("\nresponse: \n\(String(describing: dataDict))")
                 
//                 self.getImages();
                 
                 self.collectionView.reloadData()
             }
        }
        task.resume()
        */
        
        let query = PFQuery(className:"Games")
        query.findObjectsInBackground { (gameList: [PFObject]?, error: Error?) in
           if let error = error {
              print(error.localizedDescription)
           } else if let gameList = gameList {
               
               gameList.forEach { game in
                   
                   var newGame: Dictionary<String,String>;
                   
                   newGame = [
                    "name": game["gameName"] as! String,
                    "coverURL": game["coverArtURL"] as! String
                   ]
                   
                   self.games.append(newGame);

                   self.collectionView.reloadData()
               }
               
               while self.games.count < 12 {
                   self.games.append(["name":"More Coming Soon","coverURL":"none"]);
                   
               }
           }
        }
        
        print(self.games)
    }
    
    /*
    func getImages() {
        var idList = "(\(games[0].id)";
        
        games.forEach { (game) in
            idList += ", \(game.id)";
        }
        idList += ")";
        
        print(idList)
        
        let url = URL(string: "https://api.igdb.com/v4/covers")!;
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        request.httpMethod = "POST";
        request.httpBody = "fields name; where id = \(idList) limit \(numOfGames);".data(using: .utf8, allowLossyConversion: false)
        request.setValue("abo18sby3sk9q1khik70u4tb10xzvj", forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer d8ne6x6cx1a377ktjn6o0gdg6yzk9v", forHTTPHeaderField: "Authorization");
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let coverDict = try! JSONDecoder().decode(Array<CoverArtAPIResponse>.self, from: data)
                 
                 var ind = 0;
                 for cover in coverDict {
                     self.coverURLs[ind] = cover.url;
                     ind += 1;
                 }
             }
        }
        task.resume()
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameDetailsViewController, let index = collectionView.indexPathsForSelectedItems?.first {
            
            let game = games[index.row]
            dest.titleSelection = game["name"] as? String
            //dest.descriptionSelection = game["storyline"] as? String
           /*
            if (game["coverURL"] as! String == "none") {
                dest.coverSelection.image = UIImage(named: "missingCoverArt.png")
            } else {
                let coverArtURL = URL(string: game["coverURL"] as! String);
                dest.coverSelection.af.setImage(withURL: coverArtURL!)
            }
            */
        }
    }

}

