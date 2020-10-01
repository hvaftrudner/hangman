//
//  ViewController.swift
//  hangman
//
//  Created by Kristoffer Eriksson on 2020-09-24.
//

import UIKit

class ViewController: UIViewController {
    
    var playerLifes: UILabel!
    var lifes: Int = 7 {
        didSet{
            playerLifes.text = "You have: \(lifes)! lives left"
        }
    }
    var scoreLabel: UILabel!
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var word : String = "RYTHMOS"
    var words = [String]()
    
    var answer : UILabel!
    var usedButton = [String]()
    
    var letterButtons = [UIButton]()
    
    var info : UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .darkGray
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(scoreLabel)
        
        playerLifes = UILabel()
        playerLifes.translatesAutoresizingMaskIntoConstraints = false
        playerLifes.textAlignment = .left
        playerLifes.text = "You have: 7! lives left"
        playerLifes.textColor = .white
        playerLifes.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(playerLifes)
        
        answer = UILabel()
        answer.translatesAutoresizingMaskIntoConstraints = false
        answer.textAlignment = .center
        answer.text = "ANSWER"
        answer.textColor = .white
        answer.font = UIFont.systemFont(ofSize: 34)
        view.addSubview(answer)
        
        info = UILabel()
        info.text = "Hangman, Guess the word!"
        info.translatesAutoresizingMaskIntoConstraints = false
        info.textAlignment = .center
        info.textColor = .black
        info.font = UIFont.systemFont(ofSize: 30)
        info.isUserInteractionEnabled = false
        view.addSubview(info)
        
        let letterView = UIView()
        letterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterView)
        
        NSLayoutConstraint.activate([
            //Score label constraints
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            //player lifes constraints
            playerLifes.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
            playerLifes.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            //CurrentChar constraints
            info.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: 20),
            info.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            //answer constraints
            answer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            answer.topAnchor.constraint(equalTo: playerLifes.bottomAnchor,constant: 100),
        
            
            //Letterview Constrains
            letterView.widthAnchor.constraint(equalToConstant: 400),
            letterView.heightAnchor.constraint(equalToConstant: 200),
            //constant in XAnchor a quickfix because the array wouldnt centralize itself
            letterView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 25),
            letterView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40)
            
        ])
        
        let width = 50
        let height = 50
        
        for row in 0..<4{
            for column in 0..<7{
                let letterButton = UIButton()
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.setTitle("O", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
        var promptWord = ""

        for letter in String(word) {
            let strLetter = String(letter)

            if usedButton.contains(strLetter) {
                promptWord += strLetter + " "
            } else {
                promptWord += "_ "
                
            }
        }
        
        answer.text = promptWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for letter in letterButtons{
            letter.layer.borderWidth = 2
            letter.layer.borderColor = CGColor(red: 0.2, green: 0.7, blue: 0.5, alpha: 0.8)
            letter.layer.cornerRadius = 15
        }
        
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
    }
    
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonChar = sender.titleLabel?.text else {return}
        
        usedButton.append(buttonChar.uppercased())
            
        sender.isHidden = true
        
        var promptWord = ""

        for letter in String(word) {
            let strLetter = String(letter)

            if usedButton.contains(strLetter) {
                promptWord += strLetter + " "
            } else {
                promptWord += "_ "
                
            }
        }
        if !promptWord.contains("_ "){
            let ac = UIAlertController(title: "Win!", message: "Next level", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next word", style: .default, handler: nextLevel))
            present(ac, animated: true)
            
            score += 1
        }
        
        if !word.contains(buttonChar){
            lifes -= 1
        }
        
        if lifes < 1 {
            // end game
            let ac = UIAlertController(title: "End", message: "You DIED!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restart))
            //add in handler to start over?
            present(ac, animated: true)
            score = 0
        }
        
        answer.text = promptWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func nextLevel(action: UIAlertAction){
        lifes = 7
        usedButton.removeAll(keepingCapacity: true)
        
        for button in letterButtons {
            button.isHidden = false
        }
        let random = Int.random(in:0...6)
        word = words[random]
        
        var promptWord = ""

        for _ in String(word) {
            promptWord += "_ "
        }
        answer.text = promptWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loadLevel()
    }
    func restart(action: UIAlertAction){
        lifes = 7
        usedButton.removeAll(keepingCapacity: true)
        
        for button in letterButtons {
            button.isHidden = false
        }
        
        let random = Int.random(in:0...6)
        word = words[random]
        
        var promptWord = ""

        for _ in String(word) {
            promptWord += "_ "
        }
        answer.text = promptWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loadLevel()
    }
    
    @objc func loadLevel(){
        
        if let levelFileURL = Bundle.main.url(forResource: "Text", withExtension: ".txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                
                let lines = levelContents.components(separatedBy: "\n")
                
                for word in lines{
                    words.append(word.uppercased())
                    
                }
               
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            
            let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", ""]
            
            guard let buttonsCount = self?.letterButtons.count else {return}
            
            if self?.letterButtons.count == alphabet.count{
                for i in 0..<buttonsCount {
                    self?.letterButtons[i].setTitle(alphabet[i], for: .normal)
                }
            }
        }
    }
}

