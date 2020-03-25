

import UIKit
import Firebase

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    self.handleFireAuthError(error)
                }
            }
        }

    }
    @IBAction func logBtnTapped(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        if !user.isAnonymous {
            try! Auth.auth().signOut()
        }

        let storyboard = UIStoryboard.init(name: "LoginScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "loginVC")
        self.present(controller, animated: true, completion: nil)
    }

}
