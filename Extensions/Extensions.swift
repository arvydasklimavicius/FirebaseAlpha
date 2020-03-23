
import Foundation
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension UIViewController {
    func handleFireAuthError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Accont not found for specified user. Please check and try again"
        case .userDisabled:
            return "You account has been disabled. Please contact support"
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter valid email"
        case .networkError:
            return "Network error. Please try again"
        case .weakPassword:
            return "Your password is too weak.The password must be 6 characters long or more"
        case .wrongPassword:
            return "Your password or email is incorrect"

        default:
            return "Sorry, something go wrong"
        }
    }
}
