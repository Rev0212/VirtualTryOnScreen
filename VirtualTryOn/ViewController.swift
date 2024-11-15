import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var apprealCollectionView: UICollectionView!
    @IBOutlet weak var generateBtn: UIButton!
    
    // Arrays to store images
    private var photoImages: [UIImage] = [UIImage(named: "person1")!, UIImage(named: "person2")!]
    private var apparelImages: [UIImage] = [UIImage(named: "dress1")!, UIImage(named: "dress2")!, UIImage(named: "dress3")!]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the XIB files for collection view cells
        photoCollectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        apprealCollectionView.register(UINib(nibName: "ApprealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApparelCell")
        
        // Set up the horizontal layout for photoCollectionView
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .horizontal
        photoLayout.itemSize = CGSize(width: 100, height: 100)
        photoLayout.minimumInteritemSpacing = 10
        photoLayout.minimumLineSpacing = 10
        photoCollectionView.collectionViewLayout = photoLayout
        
        // Set up the grid layout for apprealCollectionView
        let apparelLayout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let itemWidth = (apprealCollectionView.bounds.width - totalSpacing) / itemsPerRow
        apparelLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        apparelLayout.minimumInteritemSpacing = spacing
        apparelLayout.minimumLineSpacing = spacing
        apprealCollectionView.collectionViewLayout = apparelLayout
        
        // Set data sources and delegates
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        apprealCollectionView.dataSource = self
        apprealCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return photoImages.count + 1 // +1 for the button cell
        } else {
            return apparelImages.count + 1 // +1 for the button cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            if indexPath.row == 0 {
                // Button cell
                let button = UIButton(type: .system)
                button.setTitle("+", for: .normal)
                button.frame = CGRect(x: 10, y: cell.bounds.height / 2 - 15, width: cell.bounds.width - 20, height: 40)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                button.layer.cornerRadius = 10
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOpacity = 0.3
                button.layer.shadowOffset = CGSize(width: 2, height: 2)
                button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
                cell.contentView.addSubview(button)
            } else {
                // Image cell
                let imageView = UIImageView(frame: cell.contentView.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = photoImages[indexPath.row - 1]
                cell.contentView.addSubview(imageView)
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApparelCell", for: indexPath) as! ApprealCollectionViewCell
            
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            if indexPath.row == 0 {
                // Button cell
                let button = UIButton(type: .system)
                button.setTitle("+", for: .normal)
                button.frame = CGRect(x: 10, y: cell.bounds.height / 2 - 15, width: cell.bounds.width - 20, height: 40)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                button.layer.cornerRadius = 10
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOpacity = 0.3
                button.layer.shadowOffset = CGSize(width: 2, height: 2)
                button.addTarget(self, action: #selector(apparelButtonTapped), for: .touchUpInside)
                cell.contentView.addSubview(button)
            } else {
                // Image cell
                let imageView = UIImageView(frame: cell.contentView.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = apparelImages[indexPath.row - 1]
                cell.contentView.addSubview(imageView)
            }
            return cell
        }
    }
     
    @objc func photoButtonTapped() {
        showImagePickerOptions(for: .photo)
    }
    
    @objc func apparelButtonTapped() {
        showImagePickerOptions(for: .apparel)
    }
    
    // Enum to track which collection view triggered the image picker
    private enum PickerSource {
        case photo
        case apparel
    }
    
    private func showImagePickerOptions(for source: PickerSource) {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera, for: source)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary, for: source)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType, for source: PickerSource) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type \(sourceType) is not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        
        // Store the source type in the picker's tag property
        picker.view.tag = source == .photo ? 0 : 1
        
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            print("No image selected")
            return
        }
        
        // Add the image to the appropriate array based on the picker's tag
        if picker.view.tag == 0 {
            photoImages.append(image)
            photoCollectionView.reloadData()
        } else {
            apparelImages.append(image)
            apprealCollectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
