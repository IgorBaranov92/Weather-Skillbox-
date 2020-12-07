import Foundation
import UIKit

protocol ImageFetcherDelegate: class {
    func imageFetched(_ image:UIImage)
}


class ImageFetcher {
    
    static weak var delegate: ImageFetcherDelegate?
    
    static func fetch(_ url:URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if let data = data,
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.delegate?.imageFetched(image)
                    }
                }
            }
            task.resume()
        }
    }
    
    static func fetch(_ url:URL,completion: @escaping (Data) -> Void) {
        if let data = try? Data(contentsOf: url) {
            completion(data)
        }
        
        
    }
    
    
}
