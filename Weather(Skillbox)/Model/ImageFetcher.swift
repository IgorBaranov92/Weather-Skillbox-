import Foundation
import UIKit

class ImageFetcher {
    
    static weak var delegate: ImageFetcherDelegate?
    
    static func fetch(_ url:URL?) {
        if let url = url {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        delegate?.imageFetched(image)
                    }
                }
            }
        }
    }
    
    static func fetch(_ url:URL?,backupData:Data?,completion: ((URL,Data) -> Void)? = nil) {
        if let url = url {

            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        completion?(url,data)
                    }
                }
            }
        }
        
        
    }
    
    
}
