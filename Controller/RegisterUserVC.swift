
import UIKit
import Firebase

class RegisterUserVC: UIViewController {
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!

    //Variables

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty,
            let password = passwordTxt.text , password.isNotEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func linkWithFcbTapped(_ sender: Any) {

    }


}
