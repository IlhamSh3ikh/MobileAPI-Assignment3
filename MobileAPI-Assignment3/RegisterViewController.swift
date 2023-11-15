//
//  RegisterViewController.swift
//  MobileAPI-Assignment3
//
//  Created by Ilham Sheikh on 2023-11-14.
//

import UIKit

class RegisterViewController: UIViewController
{
    
    // Connect TextFields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    @IBAction func registerButton_Pressed(_ sender: UIButton) {
        guard let firstname = firstNameTextField.text,
              let lastname = lastNameTextField.text,
              let username = usernameTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else {
                print("Please enter valid matching passwords.")
                ViewController.shared?.displayErrorMessage(message: "Please enter valid matching passwords.")
            return
        }

        //Replace with API call
        registerUser(firstname: firstname, lastname: lastname, username: username, password: password) {result in
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
                            // Handle successful response
                            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                            
                            let alertController = UIAlertController(title: "Success", message: "User Registered!", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                ViewController.shared?.ClearLoginTextFields() // Clear text fields and set focus to username
                            })

                            DispatchQueue.main.async
                            {
                                self.present(alertController, animated: true)
                                self.dismiss(animated: true, completion: nil)
                            }
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
                // Handle error
                self.displayErrorMessage(message: error.localizedDescription)
                    print("Error: \(error.localizedDescription)")
                }
        }
        }
    
    func registerUser(firstname: String, lastname: String, username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let apiUrl = "http://localhost:3000/auth/register"
        
        // Create URL
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        // Create JSON data from parameters
        let parameters = ["firstName": firstname, "lastName": lastname, "username": username, "password": password]
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

    @IBAction func CancelButton_Pressed(_ sender: UIButton) {
        ViewController.shared?.ClearLoginTextFields()
        dismiss(animated: true, completion: nil)
    }
    
    
    func displayErrorMessage(message: String)
        {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                ViewController.shared?.ClearLoginTextFields() // Clear text fields and set focus to username
            })
            
            DispatchQueue.main.async
            {
                self.present(alertController, animated: true)
            }
        }
    }


