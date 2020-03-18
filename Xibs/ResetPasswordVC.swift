
import UIKit
import Firebase

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func cancelTapped(_ sender: Any) {
        guard let email = emailTxt.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            self.dismiss(animated: true, completion: nil)
        }

    }

    @IBAction func resetPswTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }



}
