//
//  GetImage.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation
import UIKit

class GetImage{
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    static func downloadImage(from url: URL, imageView: UIImageView) {
     //   print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
     //     print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
