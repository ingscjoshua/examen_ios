//
//  ViewController.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit
import FirebaseStorage
import NVActivityIndicatorView
import FirebaseRemoteConfig

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  private var testData: TestData?
  private var questions: [Question] = []
  private var image: UIImage?
  private var name: String = ""
  private let storage = Storage.storage().reference()
  var loader:NVActivityIndicatorView!
  private var color: UIColor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupUI()
    chartFetchData()
    setupRemoteConfig()
  }
  
  func setupUI(){
    tableView.register(UINib(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
    tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
    tableView.register(UINib(nibName: "ChartCell", bundle: nil), forCellReuseIdentifier: "ChartCell")
    tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    tableView.keyboardDismissMode = .onDrag
    loader = self.activityIndicator(height: 160)
    view.addSubview(loader)
    color = .white
  }
  
  func chartFetchData(){
    Chart.fetchData { testData in
      DispatchQueue.main.async {
        self.testData = testData
        self.questions = testData.questions
        self.tableView.reloadData()
      }
    } onFailure: { error in
      self.displayAlert(title: "Alert", message: error)
    }
  }
  
  func setupRemoteConfig(){
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 10
    let remoteConfig = RemoteConfig.remoteConfig()
    remoteConfig.configSettings = settings
    remoteConfig.setDefaults(["DarkMode" : NSNumber(false)])
    
    remoteConfig.fetchAndActivate { status, error in
      if status != .error {
        let darkMode = remoteConfig.configValue(forKey: "DarkMode").boolValue
        DispatchQueue.main.async {
          if darkMode {
            self.color = .lightGray
            self.view.backgroundColor = .lightGray
            self.tableView.reloadData()
          } else {
            self.color = .white
            self.view.backgroundColor = .white
            self.tableView.reloadData()
          }
        }
      
      }
    }
    
  }
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0, 1:
      return 1
    case 2:
      return questions.count
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section{
    case 0:
      return nameCell(indexPath: indexPath)
    case 1:
      return photoCell(indexPath: indexPath)
    case 2:
      return chartCell(indexPath: indexPath)
    default:
      return buttonCell(indexPath: indexPath)
    }
  }
  func nameCell(indexPath: IndexPath) -> UITableViewCell{
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? NameCell else {fatalError("")}
    cell.delegate = self
    cell.backgroundColor = color
    return cell
  }
  func photoCell(indexPath: IndexPath) -> UITableViewCell{
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {fatalError("")}
    cell.bindWithImage(image: image)
    cell.backgroundColor = color
    return cell
  }
  func chartCell(indexPath: IndexPath) -> UITableViewCell{
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else {fatalError("")}
    let question = questions[indexPath.row]
    cell.bindWithQuestion(question: question)
    cell.backgroundColor = color
    return cell
  }
  func buttonCell(indexPath: IndexPath) -> UITableViewCell{
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else {fatalError("")}
    cell.delegate = self
    cell.backgroundColor = color
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      if indexPath.row == 0 {
        let pictureSource = PictureSelector(title: "Load Photo", parentController: self)
        pictureSource.imagePicker.delegate = self
        self.present(pictureSource, animated: true, completion: nil)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let screen = UIScreen.main.bounds
    switch indexPath.section {
    case 0:
      return screen.height * 0.2
    case 1:
      return screen.height * 0.6
    case 2:
      return screen.height * 0.7
    default:
      return screen.height * 0.2
    }
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      self.image = image
      self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    dismiss(animated: true, completion: nil)
   }
}

extension ViewController: NameCellDelegate {
  func getName(name: String) {
    self.name = name
  }
}

extension ViewController: ButtonCellDelegate {
  func send() {
    if name != "" {
      loader.startAnimating()
      guard let imageData = image?.pngData() else {return}
      debugPrint(imageData, " IMAGE DATA")
      storage.child("images/\(name).png").putData(imageData, metadata: nil) { _, error in
        guard error == nil else {
          debugPrint("Failed to upload")
          return
        }
        self.storage.child("images/\(self.name).png").downloadURL { url, error in
          guard let url = url, error == nil else {return}
          let urlString = url.absoluteString
          self.loader.stopAnimating()
          self.displayAlert(title: "Notification", message: "Download image in next url \(urlString)")
        }
      }
    } else {
      displayAlert(title: "Alert", message: "the (name) is required")
    }
  }
}
