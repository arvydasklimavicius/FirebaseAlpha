

import UIKit
import Firebase
import CropViewController
import CodableFirebase

class AdminVC: UIViewController {
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!

    private var croppingStyle = CropViewCroppingStyle.default
    private var addedCategoryImage: UIImage?

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

    @IBAction func addCategoryTapped(_ sender: Any) {
        guard let image = addedCategoryImage,
            let categoryName  = categoryText.text, !categoryName.isEmpty else {
            AlertService.simpleAlert(title: "Error", message: "Must add category image", vc: self)
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let  imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                AlertService.simpleAlert(title: "Error", message: "Unable to upload image", vc: self )
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    AlertService.simpleAlert(title: "Error", message: "Unable to retrieve image url", vc: self)
                    return
                }
                guard let url = url else { return }
                let newDocumentRef = Firestore.firestore().collection("categories").document()
                let newCategory = Category.init(name: categoryName,
                                                id: newDocumentRef.documentID,
                                                imageUrl: url.absoluteString)
                do {
                    let data = try FirebaseEncoder().encode(newCategory)
                    newDocumentRef.setData(data as! [String : Any]) { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                            AlertService.simpleAlert(title: "Error", message: "unable to retrieve image url", vc: self)
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }

            }
        }

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
