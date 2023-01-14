//
//  ViewController.swift
//  iosCalci
//
//  Created by Ankush Ganesh on 13/01/23.
//

import UIKit

class ViewController: UIViewController {

   
    
    @IBOutlet weak var calculatorWorking: UILabel!
    @IBOutlet weak var calculatorResult: UILabel!
    
    var working: String = ""
    var result: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }
    
    func clearAll(){
        working = ""
        calculatorWorking.text = ""
        calculatorResult.text = ""
    }
    
    func addToWorking(value: String){
        working = working + value
        calculatorWorking.text = working
    }
    
    func fomatResult(result: Double) -> String {
        if (result.truncatingRemainder(dividingBy: 1) == 0) {
            return String(format: "%.0f", result)
        } else {
            return String(format: "%.2f", result)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let keyPressed = (sender.titleLabel?.text)!
        switch keyPressed {
        case "AC":
            clearAll()
        case ".":
            addToWorking(value: ".")
        case "%":
            addToWorking(value: "%")
        case "+":
            addToWorking(value: "+")
        case "-":
            addToWorking(value: "-")
        case "/":
            addToWorking(value: "/")
        case "x":
            addToWorking(value: "*")
        default:
            addToWorking(value: keyPressed)
        }
    }
    
    @IBAction func calculateResult(_ sender: UIButton) {
        if validInput() {
            var checkWorkingForPercent = working.replacingOccurrences(of: "%", with: "*0.01")
            if !(checkWorkingForPercent.contains(".")){
                checkWorkingForPercent = checkWorkingForPercent + ".0"
            }
            let exp = NSExpression(format: checkWorkingForPercent)
            guard let res = exp.expressionValue(with: nil, context: nil) else {
                return
            }
            guard let result = res as? Double else {
                return
            }
            print(exp)
            let resultString = fomatResult(result: result)
            calculatorResult.text = resultString
            working = resultString
            calculatorWorking.text = resultString
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Calculator unable to do math", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func validInput() -> Bool{
        var count = 0
        var funcCharIndex = [Int]()
        for char in working{
            if specialChar(char: char) {
                funcCharIndex.append(count)
            }
            count += 1
        }
        var previous: Int = -1
        for index in funcCharIndex{
            if index == 0 {
                return false
            }
            if index == result.count - 1{
                return false
            }
            if previous != -1{
                if index - previous == 1{
                    return false
                }
            }
            previous = index
        }
        return true
    }
    
    func specialChar(char: Character) -> Bool {
        if char == "+"{
            return true
        }
        if char == "-"{
            return true
        }
        if char == "*"{
            return true
        }
        if char == "/"{
            return true
        }
        if char == "."{
            return true
        }
        if char == "%"{
            return true
        }
        return false
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if !(working.isEmpty) {
            working.removeLast()
            calculatorWorking.text = working
        }
    }
}
