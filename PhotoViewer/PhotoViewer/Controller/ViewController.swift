//
//  ViewController.swift
//  PhotoViewer
//
//  Created by admin on 3/30/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ViewController: UIViewController {

    var photos: [Photo] = []
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        getPhotos()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailViewController = segue.destination as? DetailViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            view.endEditing(true)
            detailViewController.photo = photos[indexPath.row]
        }
    }
    
    
}

//MARK: - Collection View
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageURL = photo.smallImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeader", for: indexPath)
        }
        return reusableView
    }
}
//MARK: - Collection View Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

//MARK: - SearchBar
extension ViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if searchBar.text == "" {
            let alert = UIAlertController(title: "Bad query", message: NSLocalizedString("Please enter a character or word", comment: " "), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            getPhotos(searchText: searchBar.text)
        }
    }
}

//MARK: - Networking
extension ViewController {
    func getPhotos(searchText: String? = nil) {
        MBProgressHUD.showAdded(to: view, animated: true)
        fetchPhotos(searchText: searchText) { [weak self] (photos) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            
            if let photos = photos {
                strongSelf.photos = photos
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    func fetchPhotos(searchText: String? = nil, completion: (([Photo]?) -> Void)? = nil) {
        let url = URL(string: "https://api.flickr.com/services/rest/")!
        var parameters = [
            "method" : "flickr.interestingness.getList",
            "api_key" : "ec7633152e0fdfca65b984e2d8472409",
            "sort" : "relevance",
            "per_page" : "500",
            "format" : "json",
            "nojsoncallback" : "1",
            "extras": "url_q,url_z"
        ]
        if let searchText = searchText {
            parameters["method"] = "flickr.photos.search"
            parameters["text"] = searchText
        }
    
        Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data, let json = try? JSON(data: data) else {
                        print("ERROR while parsing Response")
                        completion?(nil)
                        return
                    }
                    
                    let photosJSON = json["photos"]["photo"]
                    let photos = photosJSON.arrayValue.compactMap{ Photo(json: $0) }
                    completion?(photos)
                    //print(photosJSON)
                case .failure(let error):
                    print("Error while fetching photos: \(error.localizedDescription)")
                    completion?(nil)
                }
        }
    }
    
   
}

