import Foundation

extension NSError {
    static func error(message: String, domain: String = "co.jp.IrohaExample", code: Int = 0) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
