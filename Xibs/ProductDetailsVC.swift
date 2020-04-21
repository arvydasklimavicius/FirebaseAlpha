

import UIKit

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!

    var product: Product!


    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = product.name
        productDescription.text = product.description

        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }


    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func keepShoppingTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
