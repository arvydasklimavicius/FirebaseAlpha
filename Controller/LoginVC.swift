
import UIKit
import Firebase

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    //Variables

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else { return }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.handleFireAuthError(error)
                debugPrint(error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }


    }

    @IBAction func createNewUserTapped(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: self)

    }

    @IBAction func loginWithFacebookTapped(_ sender: Any) {

    }

    @IBAction func forgotPswTapped(_ sender: Any) {
        let forgotPswVC = ResetPasswordVC()
        forgotPswVC.modalPresentationStyle = .overCurrentContext
        forgotPswVC.modalTransitionStyle = .crossDissolve
        present(forgotPswVC, animated: true, completion: nil)
    }


}

