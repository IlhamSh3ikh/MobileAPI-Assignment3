//
//  BooksListViewController.swift
//  MobileAPI-Assignment3
//
//  Created by Ilham Sheikh on 2023-11-14.
//

import UIKit

class BooksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet weak var tableView: UITableView!
//    var tvShows: [TVShows] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchTVShowsFromFirestore()
//    }
//
//    func fetchTVShowsFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("TVShows").getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetching documents: \(error)")
//                return
//            }
//
//            var fetchedTVShows: [TVShows] = []
//
//            for document in snapshot!.documents {
//                let data = document.data()
//
//                do {
//                    var tvShow = try Firestore.Decoder().decode(TVShows.self, from: data)
//                    tvShow.documentID = document.documentID // Set the documentID
//                    fetchedTVShows.append(tvShow)
//                } catch {
//                    print("Error decoding TV Show data: \(error)")
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.tvShows = fetchedTVShows
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tvShows.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowCell", for: indexPath) as! BooksTableViewCell
//
//        let tvShow = tvShows[indexPath.row]
//
//        cell.showTitleLabel?.text = tvShow.title
//        cell.networkLabel?.text = tvShow.network
//        cell.seasonsLabel?.text = "\(tvShow.seasons)"
//
//        //Invoking function to get the show thumbnail
//        generateImage(tvShow.imageURL) { image in
//            DispatchQueue.main.async {
//                if(image != nil){
//                    cell.thumbnail.image = image
//                }
//                else {
//                    cell.thumbnail.image = UIImage(named: "BrokenImage")
//                }
//            }
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let tvShow = tvShows[indexPath.row]
//            showDeleteConfirmationAlert(for: tvShow) { confirmed in
//                if confirmed {
//                    self.deleteShow(at: indexPath)
//                }
//            }
//        }
//    }
//
//    @IBAction func addButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "AddEditSegue", sender: nil)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddEditSegue" {
//            if let addEditVC = segue.destination as? AddEditTVShowFirestoreViewController {
//                addEditVC.tvShowViewController = self
//                if let indexPath = sender as? IndexPath {
//                    let tvShow = tvShows[indexPath.row]
//                    addEditVC.tvShow = tvShow
//
//                    generateImage(tvShow.imageURL) { image in
//                        DispatchQueue.main.async {
//                            addEditVC.thumbnailImageView.image = image
//                        }
//                    }
//
//                } else {
//                    addEditVC.tvShow = nil
//                    addEditVC.thumbnailImageView = nil
//                }
//
//                addEditVC.tvShowUpdateCallback = { [weak self] in
//                    self?.fetchTVShowsFromFirestore()
//                }
//            }
//        }
//    }
//
//    func showDeleteConfirmationAlert(for tvShow: TVShows, completion: @escaping (Bool) -> Void) {
//        let alert = UIAlertController(title: "Delete Show", message: "Are you sure you want to delete this show?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            completion(false)
//        })
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
//            completion(true)
//        })
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    func deleteShow(at indexPath: IndexPath) {
//        let tvShow = tvShows[indexPath.row]
//
//        guard let documentID = tvShow.documentID else {
//            print("Invalid document ID")
//            return
//        }
//
//        let db = Firestore.firestore()
//        db.collection("TVShows").document(documentID).delete { [weak self] error in
//            if let error = error {
//                print("Error deleting document: \(error)")
//            } else {
//                DispatchQueue.main.async {
//                    print("TV Show deleted successfully.")
//                    self?.tvShows.remove(at: indexPath.row)
//                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
//                }
//            }
//        }
//    }
//
//
//    func generateImage(_ imageURL: String, completion: @escaping (UIImage?) -> Void) {
//        guard let url = URL(string: imageURL) else {
//            completion(nil)
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading image: \(error)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data, let image = UIImage(data: data) else {
//                completion(nil)
//                return
//            }
//
//            completion(image)
//        }.resume()
//    }
}

