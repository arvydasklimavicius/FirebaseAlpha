
import UIKit
import Firebase

class RegisterUserVC: UIViewController, UITextFieldDelegate {
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var confirmPswCheckImg: UIImageView!

    //Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPassTxt.delegate = self
        passwordTxt.delegate = self

        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)),
                                 for: UIControl.Event.editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)),
                              for: UIControl.Event.editingChanged)

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else { return }
        if textField == confirmPassTxt {
            passwordCheckImg.isHidden = false
            confirmPswCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passwordCheckImg.isHidden = true
                confirmPswCheckImg.isHidden = true
                confirmPassTxt.text = ""
            }
        }
        if passwordTxt.text == confirmPassTxt.text {
            passwordCheckImg.tintColor = .green
            confirmPswCheckImg.tintColor = .green
        } else {
            passwordCheckImg.tintColor = .red
            confirmPswCheckImg.tintColor = .red
        }
    }

    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty,
            let password = passwordTxt.text , password.isNotEmpty else { return }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        guard let user = Auth.auth().currentUser else { return }

        user.link(with: credential) { (user, error) in
            self.dismiss(animated: true, completion: nil)
        }
    }

//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            if let error = error {
//                self.handleFireAuthError(error)
//                debugPrint(error.localizedDescription)
//                return
//            }
//            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//
//            Auth.auth().signIn(with: credential) { (user, error) in
//                self.dismiss(animated: true, completion: nil)
//            }
//            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
    @IBAction func linkWithFcbTapped(_ sender: Any) {

    }


}
