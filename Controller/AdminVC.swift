

import UIKit
import Firebase
import CropViewController

class AdminVC: UIViewController {
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!

    private var croppingStyle = CropViewCroppingStyle.default

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImage.layer.cornerRadius = 5

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.addGestureRecognizer(tap)
    }

    @objc func imageTapped(_ tap: UIGestureRecognizer) {
        launchImagePicker()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
}

extension AdminVC: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropContainer = CropViewController(croppingStyle: croppingStyle, image: image)
        cropContainer.delegate = self

        picker.dismiss(animated: true) {
            self.present(cropContainer, animated: true, completion: nil)
        }
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        categoryImage.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
