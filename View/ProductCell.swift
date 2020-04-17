
import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var buyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.layer.cornerRadius = 8

    }

    func configureCell(product: Product) {
        productTitle.text = product.name
        productDescription.text = product.description
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
    }

    @IBAction func buyBtnTapped(_ sender: Any) {
        
    }

}
