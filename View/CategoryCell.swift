

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!

    override func awakeFromNib() {
        categoryImage.layer.cornerRadius = 5
    }

    func configureCell(category: Category) {
        categoryName.text = category.name
    }

}
