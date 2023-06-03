//
//  ImageManager.swift
//  21byHayyimVital
//
//  Created by vitasiy on 30.05.2023.
//

import Foundation
import FirebaseStorage

class ImageManager {
    
    static var shared = ImageManager()
    
    private let storageRef = Storage.storage().reference()
    
    func fetchImage(from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            guard url == response.url else { return }
            completion(data, response)
        }.resume()
    }
    
    func getURL1(from cardName: String) -> String {
        var imageURL = ""
        let cardRef = storageRef.child("cards/\(cardName).png")
        
        cardRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
                if let url = url {
                    
                    imageURL = url.absoluteString
                    print("")
                    print("")
                    print("getURL1")
                    print(imageURL)
                    print("!!")
                    print("")
                    print("")
                    print("")
            }
        }
        return imageURL
    }
    
    func getURL(from cardName: String, completion: @escaping (URL?) -> Void) {
        let cardRef = storageRef.child("cards/\(cardName).png")
        cardRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let url = url {
                print("")
                print("")
                print("getURL")
                print(url)
                print("!!")
                print("")
                print("")
                print("")
                completion(url)
            }
        }
    }
    
    //    func getImage(from url: URL, completion: @escaping (Data) -> Void) {
    //
    //        let cardRef = Storage.storage(url: url.absoluteString).reference()
    //
    //        cardRef.getData(maxSize: 1024*1024) { data, error in
    //            if let data = data {
    //                completion(data)
    //            } else {
    //                print(error?.localizedDescription ?? "No error description")
    //                return
    //            }
    //        }
    //    }
    
    private init() {}
}
