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
    
    var cardURLKeys = [String : URL]()
    
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
    
    func getURL(from cardName: String, completion: @escaping (URL?) -> Void) {
        let cardRef = storageRef.child("cards/\(cardName).png")
        cardRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let url = url {
                completion(url)
            }
        }
    }
    
    func fatchImages(from deck: [String]) {
        for card in deck {
            getURL(from: card) { url in
                if let url = url {
                    DispatchQueue.main.async {
                        self.cardURLKeys[card] = url
                        self.fetchImage(from: url) { data, response in
                            if data == data, response == response {
                                self.saveDataToCache(with: data, and: response)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // - MARK: - Cache methods
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cacheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
    }
    
    private init() {}
}
