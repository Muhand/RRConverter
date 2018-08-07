//
//  ViewController.swift
//  RRConverter
//
//  Created by Muhand Jumah on 8/6/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /////////////////////////////////
    // Global variables
    /////////////////////////////////
    let defaults = UserDefaults.standard
    
    /////////////////////////////////
    // Outlets
    /////////////////////////////////
    @IBOutlet var realLifeFootTextField: UITextField!
    @IBOutlet var realLifeInchesTextField: UITextField!
    @IBOutlet var rulerFootTextField: UITextField!
    @IBOutlet var rulerInchesTextField: UITextField!
    @IBOutlet var scaleRealFootTextField: UITextField!
    @IBOutlet var scaleRealInchesTextField: UITextField!
    @IBOutlet var scaleRulerFootTextField: UITextField!
    @IBOutlet var scaleRulerInchesTextField: UITextField!
    
    /////////////////////////////////
    // Buttons actions
    /////////////////////////////////
    @IBAction func convertButtonAction(_ sender: Any) {
        let realFootScale = defaults.object(forKey:"realLifeFoot") as? Double ?? -1.0
        let realInchScale = defaults.object(forKey:"realLifeInches") as? Double ?? -1.0
        let rulerFootScale = defaults.object(forKey:"rulerFoot") as? Double ?? -1.0
        let rulerInchScale = defaults.object(forKey:"rulerInches") as? Double ?? -1.0

        if (realFootScale == -1.0 || realInchScale == -1.0 || rulerFootScale == -1.0 || rulerInchScale == -1.0) {
            let alert = UIAlertController(title: "No scale found", message: "Please fill out all scale values, and make sure to hit 'save'", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            // Values were found successfully
            if (realLifeFootTextField.text == "" || realLifeInchesTextField.text == "" ) {
                let alert = UIAlertController(title: "No values", message: "You didn't type values to convert", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            } else {
                // Ready to convert
                // 1. Get total typed values in inches
                // 2. Get total real life scale in inches
                // 3. Get total ruler scale in inches
                // 4. Do cross multiplication
                
                if let realLifeFoot:Double = Double(realLifeFootTextField.text!) {
                    if let realLifeInches:Double = Double(realLifeInchesTextField.text!) {
                        // Take the foot in inches   + any inches typed
                        let typedValuesInInches:Double = (12 * realLifeFoot) + (realLifeInches)
                        let realLifeScalInInches = (12 * realFootScale) + (realInchScale)
                        let rulerLifeScalInInches = (12 * rulerFootScale) + (rulerInchScale)
                        
                        let resultInInches = (typedValuesInInches * rulerLifeScalInInches) / realLifeScalInInches
                        
//
//                        // Now that we have total value in inches
//                        rulerFootTextField.text = String(resultInInches)
                        
                        // Now convert it to feet
                        // 1inch              =   1/12 feet
                        // resultInInches     =   resultsInFeet
                        // resultInFeet = ((1/12) * resultIn Inches) / 1
                        let resultsInFeet:Double = ((1/12) * resultInInches) / 1
                        
                        // Now split it into 2 halves, the foot whole and foot inches
                        var splitted = resultsInFeet.splitAtDecimal()
                        
                        let feetWhole = splitted[0]
                        let feetDecimal = resultsInFeet - Double(splitted[0])
                        
                        rulerFootTextField.text = String(feetWhole)
                        print("FEET WHOLE = \(feetWhole) \n FEET DECIMAL = \(feetDecimal)")
                        // Now convert feetDecimal to inches
                        // 1 foot = 12inches
                        // 12312  = x
                        // resultsInInches = resultsInFeet/(1/12)
                        if feetDecimal > 0 {
//                            let inches = (Double(feetDecimal)/0.08333333333)
                            let inches = Double(feetDecimal * 12)
                            print("THE INCHES ARE: \(inches) AND ROUNDED \n)")
                            print(String(format: "%.2f", inches))
                            rulerInchesTextField.text = String(format: "%.4f", inches)
                        } else {
                            rulerInchesTextField.text = String("0")
                        }
                        
                        
                        
                    } else {
                        let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in real life inches field", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in real life foot field", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                
                
            }
            
        }
    }
    
    @IBAction func saveScaleButtonAction(_ sender: Any) {
        if (scaleRealFootTextField.text == "" || scaleRealInchesTextField.text == "" || scaleRulerFootTextField.text == "" || scaleRulerInchesTextField.text == "") {
            
            let alert = UIAlertController(title: "Incomplete :(", message: "Please fill out all scale values, if doesn't apply then put 0", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            if let scaleRealFoot = Double(scaleRealFootTextField.text!) {
                print("SCALE REAL FOOT TEXT FIELD \(scaleRealFootTextField.text)")
                print("AFTER CONVERTING \(Double(scaleRealFootTextField.text!))")
                print("SETTING \(scaleRealFoot)")
                defaults.set(scaleRealFoot, forKey: "realLifeFoot")
            } else {
                let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in real life scale foot field", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            if let scaleRealInch = Double(scaleRealInchesTextField.text!) {
                print("SCALE REAL INCHES TEXT FIELD \(scaleRealInchesTextField.text)")
                print("AFTER CONVERTING \(Double(scaleRealInchesTextField.text!))")
                print("SETTING \(scaleRealInch)")
                defaults.set(scaleRealInch, forKey: "realLifeInches")
            } else {
                let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in real life scale inch field", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            if let scaleRulerFoot = Double(scaleRulerFootTextField.text!) {
                defaults.set(scaleRulerFoot, forKey: "rulerFoot")
            } else {
                let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in ruler scale foot field", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            if let scaleRulerInch = Double(scaleRulerInchesTextField.text!) {
                defaults.set(scaleRulerInch, forKey: "rulerInches")
            } else {
                let alert = UIAlertController(title: "Not valid", message: "Invalid input was found in ruler scale inch field", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        realLifeFootTextField.delegate = self
//        realLifeInchesTextField.delegate = self
//        rulerFootTextField.delegate = self
//        rulerInchesTextField.delegate = self
//        scaleRealFootTextField.delegate = self
//        scaleRealInchesTextField.delegate = self
//        scaleRulerFootTextField.delegate = self
//        scaleRulerInchesTextField.delegate = self
        
        
        self.hideKeyboardWhenTappedAround()
        
        
        
        let realFootScale = defaults.object(forKey:"realLifeFoot") as? Double ?? -1.0
        let realInchScale = defaults.object(forKey:"realLifeInches") as? Double ?? -1.0
        let rulerFootScale = defaults.object(forKey:"rulerFoot") as? Double ?? -1.0
        let rulerInchScale = defaults.object(forKey:"rulerInches") as? Double ?? -1.0
        
        if realFootScale != -1.0 {
            scaleRealFootTextField.text = String(realFootScale)
        } else {
            scaleRealFootTextField.text = ""
        }
        
        if realInchScale != -1.0 {
            scaleRealInchesTextField.text = String(realInchScale)
        } else {
            scaleRealInchesTextField.text = ""
        }
        
        if rulerFootScale != -1.0 {
            scaleRulerFootTextField.text = String(rulerFootScale)
        } else {
            scaleRulerFootTextField.text = ""
        }
        
        if rulerInchScale != -1.0 {
            scaleRulerInchesTextField.text = String(rulerInchScale)
        } else {
            scaleRulerInchesTextField.text = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Double {
    func splitAtDecimal() -> [Int] {
        return String("\(self)").split(separator: ".").map {
            return Int($0)!
        }
        
    }
}
