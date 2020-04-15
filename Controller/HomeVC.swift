

import UIKit
import Firebase
import FBSDKLoginKit
import CodableFirebase

class HomeVC: UIViewController {

    //Outlets
    @IBOutlet weak var loginOutBtn: RoundedButton!
    @IBOutlet weak var collectionView: UICollectionView!

    //Variables
    let loginManager = LoginManager()
    var categories = [Category]()
    var selectedCategory: Category!
    var listener : ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        Firestore.firestore().collection("categories").addSnapshotListener { (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            self.categories.removeAll()
            snapshot?.documents.forEach({ (category) in
                do {
                    let newCategory = try FirestoreDecoder().decode(Category.self, from: category.data())
                    self.categories.append(newCategory)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            })
            self.collectionView.reloadData()
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    self.handleFireAuthError(error)
                }
            }
        }
        if let user = Auth.auth().currentUser {
            if !user.isAnonymous {
                loginOutBtn.setTitle("Logout", for: .normal)
            } else {
                loginOutBtn.setTitle("Login", for: .normal)
            }

        }
    }

    @IBAction func logBtnTapped(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        if !user.isAnonymous {
            do {
                try Auth.auth().signOut()
            } catch {
                debugPrint(error.localizedDescription)
            }
            loginManager.logOut()
        }

        let storyboard = UIStoryboard.init(name: "LoginScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "loginVC")
//        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.5

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: "toProducts", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProducts" {
            if let destination  = segue.destination as? ProductsVC {
                destination.selectedCategory = selectedCategory
            }
        }
    }


}
