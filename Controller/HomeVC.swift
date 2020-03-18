

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func logBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "LoginScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "loginVC")
        self.present(controller, animated: true, completion: nil)
    }

}
