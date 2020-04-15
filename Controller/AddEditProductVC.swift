
import UIKit
import CropViewController
import CodableFirebase
import Firebase

class AddEditProductVC: UIViewController {

    private var croppingStyle = CropViewCroppingStyle.default
    private var addedProductImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
}

extension AddEditProductVC: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        addedProductImage = image
        //productImage.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

