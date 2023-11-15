//
//  ViewController.swift
//  MobileAPI-Assignment3
//
//  Created by Ilham Sheikh on 2023-11-14.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    static var shared: ViewController?

    // Register TextField Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Set the delegate for the text fields
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Set the default border color
        usernameTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderColor = UIColor.gray.cgColor

        // Set the border width
        usernameTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
            
        // Add show password button
        let showPasswordButton = UIButton(type: .custom)
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.tintColor = .systemGray // Set initial color to gray
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        showPasswordButton.contentHorizontalAlignment = .left // Align the image to the left
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        // Create a container view for padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20)) // Width without padding
        containerView.addSubview(showPasswordButton)

        passwordTextField.rightView = containerView
        passwordTextField.rightViewMode = .always
    }
        
    @objc func togglePasswordVisibility()
    {
        passwordTextField.isSecureTextEntry.toggle()
        if let containerView = passwordTextField.rightView,
            let showPasswordButton = containerView.subviews.first as? UIButton {
            showPasswordButton.tintColor = passwordTextField.isSecureTextEntry ? .systemGray : .systemRed
        }
    }
        
    // UITextFieldDelegate method to change border color when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderColor = UIColor.black.cgColor
    }

    // UITextFieldDelegate method to change border color back to default when editing ends
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.layer.borderColor = UIColor.gray.cgColor
    }

    
    func ClearLoginTextFields()
    {
        usernameTextField.text = ""
        passwordTextField.text = ""
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func LoginButton_Pressed(_ sender: UIButton)
    {
        guard let username = usernameTextField.text else {
            print("Please enter username.")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("Please enter password.")
            return
        }
        
        if(username.isEmpty || password.isEmpty){
            self.displayErrorMessage(message: "Enter both username and password.")
        }
        else{
            // API call for authentication
            loginUser(username: username, password: password) { result in
                switch result {
                
                case .success(let data):
                    do {
                        // Try to parse the JSON data
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // Check if the JSON contains an "error" property
                            if let errorMessage = json["error"] as? String {
                                print("API Error: \(errorMessage)")

                                // Show error in alert
                                DispatchQueue.main.async {
                                    self.displayErrorMessage(message: errorMessage)
                                }
                            } else {
                                // Handle success and navigate to BookListViewController
                                print("API Success: \(json)")
                                
                                //Navigate to BookListViewController (UNCOMMENT)
//                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                let newViewController = storyBoard.instantiateViewController(withIdentifier:"BookListViewController")
//                                newViewController.modalPresentationStyle = .fullScreen
//                                newViewController.isModalInPresentation = true
//                                self.present(newViewController, animated: true, completion: nil)
                            }
                        } else {
                            // JSON parsing fails
                            print("Error parsing JSON")
                            
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        // Handle the case where JSON parsing throws an exception
                    }

                case .failure(let error):
                    // Handle error and display alert
                    print("Login Error: \(error.localizedDescription)")
                    self.displayErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let apiUrl = "http://localhost:3000/auth/login"
        
        // Create URL
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        // Create JSON data from parameters
        let parameters = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NSError(domain: "Invalid JSON data", code: 0, userInfo: nil)))
            return
        }

        // Create and configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            

            completion(.success(data))
        }

        // Start the task
        task.resume()
    }
    
    func displayErrorMessage(message: String)
        {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.ClearLoginTextFields() // Clear text fields and set focus to username
            })
            
            DispatchQueue.main.async
            {
                self.present(alertController, animated: true)
            }
        }
    
    @IBAction func RegisterButton_Pressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "RegisterSegue", sender: nil)
    }
    
    @IBAction func unwindToLoginViewController(_ unwindSegue: UIStoryboardSegue)
    {
        // This is the action method for the unwind segue.
        // It will be called when the unwind segue is performed, allowing you to handle any necessary actions.
        ClearLoginTextFields()
    }


}

