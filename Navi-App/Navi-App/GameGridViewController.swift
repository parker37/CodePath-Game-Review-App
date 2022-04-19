//
//  ViewController.swift
//  Navi-App
//
//  Created by Jnya Reese on 3/29/22.
//

import UIKit
import AlamofireImage
import Alamofire
import Parse

class GameGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return searchedGames.count
        }
        return games.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameGridViewCell", for: indexPath) as! GameGridViewCell;
        
        var game: [String:Any] = [:]
        
        if isSearching {
            game = searchedGames[indexPath.item]
        } else {
            game = games[indexPath.item];
        }

        if (game["coverURL"] as! String == "none") {
            cell.coverArt.image = UIImage(named: "missingCoverArt.png");
        } else {
            let coverArtURL = URL(string: game["coverURL"] as! String);
            cell.coverArt.af.setImage(withURL: coverArtURL!);
            gameCovers[game["name"] as! String] = cell.coverArt
        }
        cell.gameTitle.text = game["name"] as? String;
        
        return cell;
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var games : [[String:Any]] = []
    var gameCovers: [String:UIImageView] = [:]
    var currentGame: PFObject!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var gameSearch: String = "";
    var isSearching: Bool = false;
    var searchedGames: [[String:Any]] = []
    var loadMore: Bool = false;
    var loadSet: Int = 0;
    
//    var coverURLs = [String]();
    var numOfGames = 25;
    
    var gameResponse = [GamesAPIResponse]();
    struct GamesAPIResponse: Codable {
        var id: Int?
        var cover: Int?
        var name: String
        var total_rating: Double
        var summary: String
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self);
            id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
            cover = try values.decodeIfPresent(Int.self, forKey: .cover) ?? -1
            name = try values.decode(String.self, forKey: .name)
            total_rating = try values.decode(Double.self, forKey: .total_rating)
            summary = try values.decode(String.self, forKey: .summary)
        }
    }
    
    struct CoverArtResponse: Codable {
        var id: Int?
        var game: Int?
        var height: Int
        var image_id: String
        var width: Int
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self);
            id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
            game = try values.decodeIfPresent(Int.self, forKey: .game) ?? -1
            height = try values.decode(Int.self, forKey: .height)
            image_id = try values.decode(String.self, forKey: .image_id)
            width = try values.decode(Int.self, forKey: .width)
        }
    }
    
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
        
        isSearching = false;
        searchTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        let url = URL(string: "https://api.igdb.com/v4/games")!;
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20);
        request.httpMethod = "POST";
        request.httpBody = "fields name,cover,total_rating,summary; where category = 0 & total_rating > 90 & total_rating_count > 1000; limit 50; sort id desc;".data(using: .utf8, allowLossyConversion: false)
        request.setValue("abo18sby3sk9q1khik70u4tb10xzvj", forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer d8ne6x6cx1a377ktjn6o0gdg6yzk9v", forHTTPHeaderField: "Authorization");

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let decoder = JSONDecoder();
//                 let dataDict = try! String(data: data, encoding: .utf8)
                 let info = try! decoder.decode(Array<GamesAPIResponse>.self, from: data)
//                 self.games = try! JSONDecoder().decode(Array<GamesAPIResponse>.self, from: data)
                 
//                 print("\nresponse: \n\(self.games)")
                 print("\nCount: \(info.count)\nresponse: \n\(info)");
                 self.getImages(info);
             }
        }
        task.resume()
    }
    
    
    func getImages(_ gameResponse: Array<GamesAPIResponse>) {
        if gameResponse.count == 0 {
            return
        }
        
        var idList = ""
        var first = true;
        var index = -1;
        var gameList = gameResponse;
        
        
        
        gameList.forEach { (game) in
            if (game.cover != -1 && game.id != -1) {
                if (first) {
                    idList += "(\(gameResponse[0].cover!)";
                    first = false;
                } else {
                    idList += ", \(game.cover!)";
                }
            }
        }
        
        idList += ")";
        
        print(idList)
        games = [];

        let url = URL(string: "https://api.igdb.com/v4/covers")!;
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20);
        request.httpMethod = "POST";
        request.httpBody = "fields id,game,width,image_id,height; where id = \(idList); sort game desc; limit 50;".data(using: .utf8, allowLossyConversion: false)
        request.setValue("abo18sby3sk9q1khik70u4tb10xzvj", forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer d8ne6x6cx1a377ktjn6o0gdg6yzk9v", forHTTPHeaderField: "Authorization");
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let decoder = JSONDecoder();
               let dataDict = try! String(data: data, encoding: .utf8)
                 print(dataDict)
                 let info = try! decoder.decode(Array<CoverArtResponse>.self, from: data)
                
                 var ind = 0;
                 gameResponse.forEach { game in
                     if (ind < info.count) {
                         if (game.cover! == info[ind].id && info[ind].game != -1 && info[ind].id != -1) {
                             let newGame = [
                                "name": game.name,
                                "coverURL": "https://images.igdb.com/igdb/image/upload/t_cover_big/\(info[ind].image_id).png",
                                "summary": game.summary,
                                "coverWidth": info[ind].width,
                                "coverHeight": info[ind].height
                             ] as [String : Any];
                             
                             self.games.append(newGame)
                             
                             ind += 1;
                         }
                     }
                 }
                 //self.numOfGames = self.games.count;
                 print("\nTotal: \(self.games.count)\nGames Dictionary:\n\(self.games)");
                 self.collectionView.reloadData();
             }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameDetailsViewController, let index = collectionView.indexPathsForSelectedItems?.first {
            var game: [String:Any];
            if (isSearching) {
                game = self.searchedGames[index.row]
            } else {
                game = self.games[index.row]
            }
            print(game)
            dest.selectedGame = game
            
            dest.titleSelection = game["name"] as? String
            
            dest.descriptionSelection = game["summary"] as? String
            
            dest.coverArtView = self.gameCovers[game["name"] as! String]!
            
           
//            if (game["coverURL"] as! String == "none") {
//                dest.coverSelection.image = UIImage(named: "missingCoverArt.png")
//            } else {
//                let coverArtURL = URL(string: game["coverURL"] as! String);
//                dest.coverArtView.af.setImage(withURL: coverArtURL!)
//            }
            
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func onSearch(_ sender: Any) {
        if searchTextField.isHidden {
            searchTextField.isHidden = false;
            let myConst = view.constraintWith(identifier: "topConst");
            myConst?.constant = -25;
            
        } else {
            searchTextField.isHidden = true;
            let myConst = view.constraintWith(identifier: "topConst");
            myConst?.constant = -60;
            isSearching = false;
            collectionView.reloadData()
        }
    }
    
    @IBAction func onSearching(_ sender: Any) {
        if let clear = searchTextField.value(forKey: "clearButton") as? UIButton {
            clear.tintColor = .red
            clear.setImage(UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        searchedGames = []
        isSearching = true;
        
        let gameName = searchTextField.text!;
        
        if gameName == "" {
            isSearching = false;
        } else {
            games.forEach { game in
                if (game["name"] as! String).contains(gameName) {
                    searchedGames.append(game)
                }
            }
        }
        collectionView.reloadData()
    }
    @IBAction func onStopSearching(_ sender: Any) {
        print("------------------------\nediting ended\n---------------------------")
    }
}

extension UIView {
    func constraintWith(identifier: String) -> NSLayoutConstraint?{
        return self.constraints.first(where: {$0.identifier == identifier})
    }
}
