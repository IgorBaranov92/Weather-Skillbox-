import Foundation
import Alamofire
import UIKit

class ImageFetcher_Alamofire {
    
    static weak var delegate: ImageFetcherDelegate?
    
    static func fetch(_ url:URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url).response { response in
                if let data = response.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.delegate?.imageFetched(image)
                    }
                }
            }
        }
    }
    
    
}
