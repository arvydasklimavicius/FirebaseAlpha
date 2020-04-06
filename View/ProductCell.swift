
import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var buyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(product: Product) {
        productTitle.text = product.name
    }

    @IBAction func buyBtnTapped(_ sender: Any) {
        
    }

}
