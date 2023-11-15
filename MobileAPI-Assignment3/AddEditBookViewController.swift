//
//  AddEditBookViewController.swift
//  MobileAPI-Assignment3
//
//  Created by Ilham Sheikh on 2023-11-14.
//

import UIKit

class AddEditTVShowFirestoreViewController: UIViewController {

    // UI References
    @IBOutlet weak var AddEditTitleLabel: UILabel!
    @IBOutlet weak var UpdateButton: UIButton!
    
    // TV Show Fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var genresTextField: UITextField!
    @IBOutlet weak var creatorsTextField: UITextField!
    @IBOutlet weak var composersTextField: UITextField!
    @IBOutlet weak var castTextField: UITextField!
    @IBOutlet weak var networkTextField: UITextField!
    @IBOutlet weak var seasonsTextField: UITextField!
    @IBOutlet weak var episodesTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var originalReleaseTextField: UITextField!
    
    var tvShow: TVShows?
    var tvShowViewController: TVShowFirestoreCRUDViewController?
    var tvShowUpdateCallback: (() -> Void)?
    var posterURL : String!
    var showTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tvShow = tvShow {
            // Editing existing show
            titleTextField.text = tvShow.title
            languageTextField.text = tvShow.language
            genresTextField.text = tvShow.genres.joined(separator: ", ")
            creatorsTextField.text = tvShow.creators.joined(separator: ", ")
            composersTextField.text = tvShow.composers.joined(separator: ", ")
            castTextField.text = tvShow.cast.joined(separator: ", ")
            seasonsTextField.text = "\(tvShow.seasons)"
            episodesTextField.text = "\(tvShow.episodes)"
            descriptionTextView.text = tvShow.description
            networkTextField.text = tvShow.network
            originalReleaseTextField.text = tvShow.originalRelease
            posterURL = tvShow.imageURL
            showTitle = tvShow.title
            
            AddEditTitleLabel.text = "Edit TV Show"
            UpdateButton.setTitle("Update", for: .normal)
        } else {
            AddEditTitleLabel.text = "Add TV Show"
            UpdateButton.setTitle("Add", for: .normal)
        }
    }
    
    @IBAction func CancelButton_Pressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateButton_Pressed(_ sender: UIButton) {
        guard
              let title = titleTextField.text,
              let genres = genresTextField.text,
              let creators = creatorsTextField.text,
              let composers = composersTextField.text,
              let cast = castTextField.text,
              let language = languageTextField.text,
              let network = networkTextField.text,
              let seasonsString = seasonsTextField.text,
              let seasons = Int(seasonsString),
              let episodesString = episodesTextField.text,
              let episodes = Int(episodesString),
              let description = descriptionTextView.text,
              let originalRelease = originalReleaseTextField.text else {
            print("Invalid data")
            return
        }
        
        //print("!!!!!Just printing", showTitle)

        let db = Firestore.firestore()

        if let tvShow = tvShow {
            // Update existing show
            guard let documentID = tvShow.documentID else {
                print("Document ID not available.")
                return
            }
            
            print("Show title given", tvShow.title)
            
            if(title != showTitle){
                getPoster(title) { image in
                    DispatchQueue.main.async {
                        //print("Updated title", image!)
                        let showRef = db.collection("TVShows").document(documentID)
                        showRef.updateData([
                            "title": title,
                            "genres": genres.components(separatedBy: ", "),
                            "creators": creators.components(separatedBy: ", "),
                            "composers": composers.components(separatedBy: ", "),
                            "cast": cast.components(separatedBy: ", "),
                            "description": description,
                            "seasons": seasons,
                            "episodes": episodes,
                            "language": language,
                            "network": network,
                            "imageURL": image ?? "",
                            "originalRelease": originalRelease
                        ]) { [weak self] error in
                            if let error = error {
                                print("Error updating TV Show: \(error)")
                            } else {
                                print("TV Show updated successfully.")
                                self?.dismiss(animated: true) {
                                    self?.tvShowUpdateCallback?()
                                }
                            }
                        }
                    }
                    
                }
            }
            else {
                let showRef = db.collection("TVShows").document(documentID)
                showRef.updateData([
                    "title": title,
                    "genres": genres.components(separatedBy: ", "),
                    "creators": creators.components(separatedBy: ", "),
                    "composers": composers.components(separatedBy: ", "),
                    "cast": cast.components(separatedBy: ", "),
                    "description": description,
                    "seasons": seasons,
                    "episodes": episodes,
                    "language": language,
                    "network": network,
                    "imageURL": posterURL!,
                    "originalRelease": originalRelease
                ]) { [weak self] error in
                    if let error = error {
                        print("Error updating TV Show: \(error)")
                    } else {
                        print("TV Show updated successfully.")
                        self?.dismiss(animated: true) {
                            self?.tvShowUpdateCallback?()
                        }
                    }
                }
            }
        } else {
            //Invoking function to get the show thumbnail
            print("Title printing for adding show", title)
            getPoster(title) { image in
                DispatchQueue.main.async {
                    var imageURL = image
                    
                    // Add new show
                    let newTVShow     = [
                        "title": title,
                        "genres": genres.components(separatedBy: ", "),
                        "creators": creators.components(separatedBy: ", "),
                        "composers": composers.components(separatedBy: ", "),
                        "cast": cast.components(separatedBy: ", "),
                        "description": description,
                        "seasons": seasons,
                        "episodes": episodes,
                        "language": language,
                        "network": network,
                        "imageURL": imageURL!,
                        "originalRelease": originalRelease
                    ] as [String : Any]

                    //var ref: DocumentReference? = nil
                    db.collection("TVShows").addDocument(data: newTVShow) { [weak self] error in
                        if let error = error {
                            print("Error adding TV Show: \(error)")
                        } else {
                            print("TV Show added successfully.")
                            self?.dismiss(animated: true) {
                                self?.tvShowUpdateCallback?()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //To get thumbnail from Omdb API
    func getPoster(_ showTitle: String, completion: @escaping (String?) -> Void) {
        let apiKey = "290a4bca"
        let searchTVShow = showTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        //print(searchTVShow)
        let url = URL(string: "https://www.omdbapi.com/?i=tt3896198&apikey=\(apiKey)&t=\(searchTVShow)")!
                
        //API call to get the Poster
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let imageURLString = json["Poster"] as? String{
                    DispatchQueue.main.async {
                        completion(imageURLString)
                    }
                }
                else {
                    completion(nil)
                }
            }
            catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}


