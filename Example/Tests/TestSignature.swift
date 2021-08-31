import CryptoKit
import Sodium
import XCTest

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

class TestSignature: XCTestCase {

    private let messageToSign = "14616c69636528776f6e6465726c616e640016c71b6100000000a08601000000000000"
    private let publicKeyString = "e555d194e8822da35ac541ce9eec8b45058f4d294d9426ef97ba92698766f7d3"
    private let privateKeyString = "de757bcb79f4c63e8fa0795edc26f86dfdba189b846e903d0b732bb644607720"
    private let sodium = Sodium()
    
    func test() throws {
        guard let privateKeyData = privateKeyString.hexadecimal, let messageData = messageToSign.hexadecimal else {
            XCTFail()
            return
        }
        
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        guard let publicKeyData = publicKeyString.hexadecimal else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(publicKeyData, privateKey.publicKey.rawRepresentation)
        
        guard let hash = sodium.genericHash.hash(message: messageData.map { $0 }) else {
            XCTFail()
            return
        }
        
        let signature = try privateKey.signature(for: hash).map { $0 }
        XCTAssert(privateKey.publicKey.isValidSignature(signature, for: hash))
    }
}
