
import UIKit
import CropViewController
import CodableFirebase
import Firebase

class AddEditProductVC: UIViewController {

    //Variables

    private var croppingStyle = CropViewCroppingStyle.default
    private var addedProductImage : UIImage?
    var selectedCategory: Category!

    //Outlets

    @IBOutlet weak var addEditProductImage: UIImageView!
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productDescriptionTxt: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        addEditProductImage.addGestureRecognizer(tap)


    }

    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }
    
    @IBAction func addProductTapped(_ sender: Any) {
        guard let image = addedProductImage,
            let description = productDescriptionTxt.text,
            let name = productNameTxt.text else {
                AlertService.simpleAlert(title: "Error", message: "Must add information to all fields", vc: self)
                return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                AlertService.simpleAlert(title: "Error", message: "Unable to upload image", vc: self)
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    AlertService.simpleAlert(title: "Error", message: "Unable to retrieve image", vc: self)
                    return
                }

                guard let url = url else { return }
                let newDocRef = Firestore.firestore().collection("categories").document(self.selectedCategory.id).collection("products").document()

                let newProduct = Product.init(name: name,
                                              category: self.selectedCategory.id,
                                              imageUrl: url.absoluteString,
                                              description: description)

                do {
                    let data = try FirebaseEncoder().encode(newProduct)
                    newDocRef.setData(data as! [String : Any]) { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                            AlertService.simpleAlert(title: "Error", message: "Unable to upload new product document", vc: self)
                            return
                        }
                        self.navigationController?.popViewController(animated: true)
//                        self.dismiss(animated: true, completion: nil)
//                        AlertService.simpleAlert(title: "OK", message: "Product added press back", vc: self)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
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
        addEditProductImage.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

