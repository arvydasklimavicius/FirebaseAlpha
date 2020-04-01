
import UIKit
import Firebase
import FBSDKLoginKit
import Kingfisher

class RegisterUserVC: UIViewController, UITextFieldDelegate {
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var confirmPswCheckImg: UIImageView!
    @IBOutlet weak var fbAvatar: UIImageView!

    //Variables
    var firstTimeFbLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if firstTimeFbLogin {
            fetchFacebookData()
        }

    }

    func setupView() {
        confirmPassTxt.delegate = self
        passwordTxt.delegate = self

        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)),
                                 for: UIControl.Event.editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)),
                              for: UIControl.Event.editingChanged)

    }

    func fetchFacebookData() {
        let request = GraphRequest(graphPath: "me", parameters:
            ["fields": "id, name, first_name, last_name, email, picture.type(large)" ],
                                   httpMethod: HTTPMethod(rawValue: "GET"))
        request.start { (connection, result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let dictionary = result as? [String: Any] else { return }
            guard let firstName = dictionary["first_name"] as? String,
                let lastName = dictionary["last_name"] as? String,
                let email = dictionary["email"] as? String else { return }
            guard let pictureObject = dictionary["picture"] as? [String: Any],
                let pictureData = pictureObject["data"] as? [String: Any],
                let urlString = pictureObject["url"] as? String else { return }

            let url = URL(string: urlString)
            let image = UIImage(named: "Placeholder")
            self.fbAvatar.kf.setImage(with: url, placeholder: image)

            self.emailTxt.text = email
            self.usernameTxt.text = firstName

        }
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
