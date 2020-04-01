
import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseFirestore

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    //Variables
    let loginManager = LoginManager()
    var firstTimeFbLogin = false

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
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else if result?.isCancelled ?? true {
                //Do something
            } else {
                self.signinFirebaseFacebook()
            }
        }
    }

    func signinFirebaseFacebook() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let isNewUser = result?.additionalUserInfo?.isNewUser {
                if isNewUser {
                    self.handleNewUser()
                } else {
                    self.handlePotentialFirstTimeFbLogin()
                }
            }
        }
    }
    func handlePotentialFirstTimeFbLogin() {
        guard let user = Auth.auth().currentUser else { return }
        Firestore.firestore().collection("users").document(user.uid).getDocument { (snap, error) in
            if let data = snap?.data() {
                guard let hasSetup = data["hasSetupAccount"] as? Bool else { return }
                if hasSetup {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.firstTimeFbLogin = true
                    self.presentFirstTimeAlert()
                }
            }
        }
    }

    func handleNewUser() {
        firstTimeFbLogin = true
        guard let user = Auth.auth().currentUser else { return }
        //let newUser = User()
        var userData = [String: Any]()
        userData = [
            "email": "",
            "username": "",
            "avatarUrl": "",
            "hasSetupAccount": false,
            "isGuest": false

        ]

        Firestore.firestore().collection("users").document(user.uid).setData(userData) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.handleFireAuthError(error)
                return
            }
            self.presentFirstTimeAlert()
        }

        
    }

    func presentFirstTimeAlert() {
        let alert = UIAlertController(title: "Welcome!", message: "Look's like you are new here. Let's get you set up", preferredStyle: .alert)
        let notNow = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in

        }
        let okActioin = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.performSegue(withIdentifier: "toRegister", sender: self)
        }
        alert.addAction(notNow)
        alert.addAction(okActioin)
        present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegister" {
            if let destination = segue.destination as? RegisterUserVC{
                destination.firstTimeFbLogin = firstTimeFbLogin
            }
        }
    }

    @IBAction func forgotPswTapped(_ sender: Any) {
        let forgotPswVC = ResetPasswordVC()
        forgotPswVC.modalPresentationStyle = .overCurrentContext
        forgotPswVC.modalTransitionStyle = .crossDissolve
        present(forgotPswVC, animated: true, completion: nil)
    }


}

