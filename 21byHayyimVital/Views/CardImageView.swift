//
//  CardImageView.swift
//  21byHayyimVital
//
//  Created by vitasiy on 30.05.2023.
//

import UIKit

class CardImageView: UIImageView {
    
    func fatchImage(from hand: String) {
        ImageManager.shared.getURL(from: hand) { url in
            if let url = url {
                if let cachedImage = self.getCachedImage(from: url) {
                    self.image = cachedImage
                    return
                } else {
                    ImageManager.shared.fetchImage(from: url) { data, response in
                        if data == data, response == response {
                            DispatchQueue.main.async {
                                self.image = UIImage(data: data)
                                self.saveDataToCache(with: data, and: response)
                            }
                        } else {
                            self.image = UIImage(named: hand)
                        }
                    }
                }
            } else {
                self.image = UIImage(named: hand)
            }
        }
    }
    
    // - MARK: - Cache methods
    func getCachedImage(from url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cacheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
    }
    
}
