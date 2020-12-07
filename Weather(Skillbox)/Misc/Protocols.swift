import Foundation
import UIKit

protocol CurrentWeatherDelegate: class {
    func chooserSelectedAt(index:Int)
}

protocol ImageFetcherDelegate: class {
    func imageFetched(_ image:UIImage,backup:Data?)
}
