//
//  CardImageView.swift
//  21byHayyimVital
//
//  Created by vitasiy on 30.05.2023.
//

import UIKit

class CardImageView: UIImageView {
    
    func fatchImage(from hand: String) {
        // здесь скорее лучше убрать это мигание карт... или нет? 
//        image = UIImage(named: "back")
        ImageManager.shared.getURL(from: hand) { url in
            if let url = url {
                if let cachedImage = self.getCachedImage(from: url) {
                    self.image = cachedImage
                    return
                }
                ImageManager.shared.fetchImage(from: url) { data, response in
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                        self.saveDataToCache(with: data, and: response)
                    }
                }
            }
        }
    }
    
    // - MARK: - Cache methods
    private func getCachedImage(from url: URL) -> UIImage? {
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
