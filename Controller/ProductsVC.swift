

import UIKit
import Firebase
import CodableFirebase

class ProductsVC: UIViewController {

    //Variables
    var selectedCategory: Category!
    var products = [Product]()

    //Otlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(selectedCategory.name)


    }
    override func viewDidAppear(_ animated: Bool) {
        Firestore.firestore().collection("categories").document(selectedCategory.id).collection("products")
            .addSnapshotListener { (snapshot, error) in

            if let error = error {
                debugPrint(error.localizedDescription)
            }
                self.products.removeAll()
                snapshot?.documents.forEach({ (product) in
                    do {
                        let newProduct = try FirestoreDecoder().decode(Product.self, from: product.data())
                        self.products.append(newProduct)
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                })
                self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEditProduct" {
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = selectedCategory
            }
        }
    }
   
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC()
        vc.product = products[indexPath.row]
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }


}
