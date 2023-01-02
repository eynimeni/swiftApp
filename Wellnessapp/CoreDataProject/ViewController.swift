//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Magdalena on 12.12.22.
//


import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate {

    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var StorageButton: UIButton!
    @IBOutlet weak var ImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Label.text = NSLocalizedString("Your Oasis", comment: "")
        StorageButton.setTitle(NSLocalizedString("Store Data", comment: ""), for: .normal)
    
        ImageButton.setTitle(NSLocalizedString("Get Image", comment: ""), for: .normal)
        
        firstNameTextField.placeholder = NSLocalizedString("Name", comment: "")
        location.placeholder =  NSLocalizedString("Desired Location", comment: "")
        
        textView.text = ""
    }
    
    @IBAction func storeDataButton(_ sender: Any) {
        
        let firstname = firstNameTextField.text
        let lastname = location.text
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appdelegate.persistentContainer.viewContext
         
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
            person.setValue(firstname, forKey: "firstname")
            person.setValue(lastname, forKey: "location")

        do  {
            try managedContext.save()
            self.textView.alpha = 0
            let alertController = UIAlertController(title: NSLocalizedString("Take a deep breath", comment: ""), message: NSLocalizedString("Are you now ready to go on your personal jourey?", comment: ""), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (action) in
                self.displayData()
            }
            
            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive) { (action) in
                self.textView.text.append(contentsOf: NSLocalizedString("Relax! When ever you feel ready, click again.", comment: ""))
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
            UIView.animate(withDuration: 2.0, delay: 1.0, animations: {
                self.textView.alpha = 100
            })
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func displayData() {
        textView.text = NSLocalizedString("Welcome", comment: "")
        textView.text.append(contentsOf: NSLocalizedString("Text Message", comment: ""))

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appdelegate.persistentContainer.viewContext

        let personsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let persons = try! managedContext.fetch(personsFetch) as! [Person]
        
        for p in persons {
            if(p.firstname == firstNameTextField.text) {
                self.textView.text.append(contentsOf: "\(p.firstname ?? "") "+NSLocalizedString("Your Destination", comment: "")+" \(p.location ?? "")\n")
            }
        }
        
    }
    
    @IBAction func getImage(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         imagePicker.dismiss(animated: true, completion: nil)
         ImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
     }
  
}

