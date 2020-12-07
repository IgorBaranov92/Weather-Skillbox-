import Foundation

class ImageFetcher {
    
    static weak var delegate: ImageFetcherDelegate?
    
    static func fetch(_ url:URL) {
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
