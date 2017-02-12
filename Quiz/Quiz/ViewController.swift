//
//  ViewController.swift
//  Quiz
//
//  Created by Hisham Abraham on 2/12/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var quetionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
        "What is 7 + 7?",
        "What is the capital of Vermont?",
        "What is cognac made from?" ]
    
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes" ]
    
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quetionLabel.text = questions[currentQuestionIndex]
    }
    
    
    @IBAction func showNextQuestion(_ sender: UIButton){
        currentQuestionIndex += 1
        if(currentQuestionIndex == questions.count){
            currentQuestionIndex = 0
        }
        
        quetionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
        
    }
    
    @IBAction func showAnswer(_ sender: UIButton){
        answerLabel.text = answers[currentQuestionIndex]
    }
    




}

