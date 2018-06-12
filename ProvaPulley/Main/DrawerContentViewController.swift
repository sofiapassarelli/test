//
//  PuViewController.swift
//  ProvaPulley
//
//  Created by Lorenzo Caso on 22/05/18.
//  Copyright © 2018 Lorenzo Caso. All rights reserved.
//

import UIKit
import Pulley
import QuartzCore



class DrawerContentViewController: UIViewController, UITabBarDelegate, UITableViewDelegate{
    
    @IBOutlet weak var Send: UIButton!
    @IBOutlet weak var Gripper: UIView!
    @IBOutlet weak var AskQuestionTextField: UITextField!
    
    @IBOutlet weak var AnyButton: UICustomButton!
    @IBOutlet weak var TourismButton: UICustomButton!
    @IBOutlet weak var NightLifeButton: UICustomButton!
    @IBOutlet weak var FoodButton: UICustomButton!
    @IBOutlet weak var ArtButton: UICustomButton!
    @IBOutlet weak var CityInfoButton: UICustomButton!

    @IBOutlet weak var Tourism2Button: UICustomButton!
    
    var messageTable = UITableView(frame: CGRect(x: 0, y: 120, width: 375, height: 500))

    var topicBool: [Bool] = [true, false, false, false, false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.Gripper.layer.cornerRadius = 3
        
//      tableView
        self.messageTable.delegate = self
        
        self.messageTable.dataSource = self
        
        self.messageTable.register(PulleyTableViewCell.self, forCellReuseIdentifier: "cell")
        self.messageTable.separatorStyle = .none
        
        self.view.addSubview(messageTable)
        
//      topic buttons
        AnyButton.borderColor = UIColor.gray.cgColor
        CityInfoButton.borderColor = UIColor.gray.cgColor
        Tourism2Button.borderColor = UIColor.gray.cgColor
        TourismButton.borderColor = UIColor.gray.cgColor
        ArtButton.borderColor = UIColor.gray.cgColor
        NightLifeButton.borderColor = UIColor.gray.cgColor
        FoodButton.borderColor = UIColor.gray.cgColor
        
        setupTable()
    }
    
    
    func setupTable() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "data"), object: nil)
        
        
    }
    
    @objc func reload() {
        self.messageTable.reloadData()
        dismissKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
          
     
    }

    @IBAction func askQuestion(_ sender: Any) {
        self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
        
        
        
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        dismissKeyboard()
        
        
// self.pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
        let user = SingletonServer.singleton.retrieveUserState()
        let radar = DBRadar(posX: 1, posY: 2, range: 100)
        let data = dateFromTimeout(timeout: 3)
        self.pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
        SingletonServer.singleton.POST_insertNewQuestion(text: AskQuestionTextField.text!, dateFine: data, userOwner: user, radar: radar, topic: 1) { (result) in
            let decoder = JSONDecoder()
            let da = result?.data(using: .utf8)
            do{
                let question = try decoder.decode(DBQuestion.self, from: da!)
                if(question.ID != nil){
                    SingletonServer.singleton.user?.myQuestions?.append(question)
                    SingletonServer.singleton.saveUserState(user: SingletonServer.singleton.user!)
                    print(question.text!)
                    
                }
            }catch{
                print("errore di serializzazione|LATOCLIENT")
               
            }
            
            
        }
    }
    
    @IBAction func anyButtonTap(_ sender: Any) {
        if !topicBool[0] {
            for i in 1...6 {
                self.topicBool[i] = false
            }
            allButtonsOff()
            
            buttonOn(button: AnyButton, topicNum: 0)
            topicBool[0] = true
        }
        else {
            buttonOff(button: AnyButton)
            topicBool[0] = false
        }
        
    }
    
    @IBAction func tourismButtonTap(_ sender: Any) {
        if !topicBool[1] {
            if topicBool[0] {
                buttonOff(button: AnyButton)
                topicBool[0] = false
            }
            buttonOn(button: TourismButton, topicNum: 1)
            topicBool[1] = true
        }
        else {
            buttonOff(button: TourismButton)
            topicBool[1] = false
        }
    }
    
    @IBAction func nightlifeButtonTap(_ sender: Any) {
        if !topicBool[2] {
            if topicBool[0] {
                buttonOff(button: AnyButton)
                topicBool[0] = false
            }
            buttonOn(button: NightLifeButton, topicNum: 2)
            topicBool[2] = true
        }
        else {
            buttonOff(button: NightLifeButton)
            topicBool[2] = false
        }
    }
    
    @IBAction func foodButtonTap(_ sender: Any) {
        if !topicBool[3] {
            if topicBool[0] {
                buttonOff(button: AnyButton)
                topicBool[0] = false
            }
            buttonOn(button: FoodButton, topicNum: 3)
            topicBool[3] = true
        }
        else {
            buttonOff(button: FoodButton)
            topicBool[3] = false
        }
    }
    
    @IBAction func artButtonTap(_ sender: Any) {
        if !topicBool[4] {
            if topicBool[0] {
                buttonOff(button: AnyButton)
                topicBool[0] = false
            }
            buttonOn(button: ArtButton, topicNum: 4)
            topicBool[4] = true
        }
        else {
            buttonOff(button: ArtButton)
            topicBool[4] = false
        }
    }
    
    @IBAction func cityinfoButtonTap(_ sender: Any) {
        if !topicBool[5] {
            if topicBool[0] {
                buttonOff(button: AnyButton)
                topicBool[0] = false
            }
            buttonOn(button: CityInfoButton, topicNum: 5)
            topicBool[5] = true
        }
        else {
            buttonOff(button: CityInfoButton)
            topicBool[5] = false
        }
    }
    
    @IBAction func Tourism2Tap(_ sender: Any) {
        
            if !topicBool[6] {
                if topicBool[0] {
                    buttonOff(button: AnyButton)
                    topicBool[0] = false
                }
                buttonOn(button: Tourism2Button, topicNum: 6)
                topicBool[6] = true
            }
            else {
                buttonOff(button: Tourism2Button)
                topicBool[6] = false
            }
        }
    
}
extension DrawerContentViewController {
    private func buttonOn(button: UICustomButton, topicNum: Int) {
        
        switch topicNum {
        case 0:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.mainColor}))
        case 1:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.foodColor}))
        case 2:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.nightlifeColor}))
        case 3:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.artColor}))
        case 4:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.shopsColor}))
        case 5:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.cityInfoColor}))
        case 6:
            UIView.animate(withDuration: 0.3, animations: ({button.backgroundColor = DataManager.shared.tourismColor}))
        default:
            print("")
        }
        
//            UIView.animate(withDuration: 0.3,
//
//                           animations: ({button.backgroundColor = UIColor.blue}))

            UIView.animate(withDuration: 0.3, animations: ({button.layer.borderColor = UIColor.white.cgColor}))
        
            UIView.animate(withDuration: 0.3, animations:  ({button.setTitleColor(UIColor.white, for: UIControlState.normal)}))
        
//        button.backgroundColor = UIColor.blue
//        button.layer.borderColor = UIColor.white.cgColor
//        button.setTitleColor(UIColor.white, for: UIControlState.normal)
    
}
/*
    se è un evento colori solo il bordo if-- switch
     se è una chat coloro tutto
*/
    
    private func buttonOff(button: UICustomButton) {
        
            UIView.animate(withDuration: 0.25,
                       
                       animations: ({button.backgroundColor = UIColor.white}))
        
            UIView.animate(withDuration: 0.25,
                       
                       animations: ({button.layer.borderColor = UIColor.gray.cgColor}))
        
        
            UIView.animate(withDuration: 0.25,
                       
                       animations: ({button.setTitleColor(UIColor.gray, for: UIControlState.normal)}))
        
//        button.backgroundColor = UIColor.white
//        button.layer.borderColor = UIColor.black.cgColor
//        button.setTitleColor(UIColor.black, for: UIControlState.normal)
    }
    
    private func allButtonsOff() {
        buttonOff(button: TourismButton)
        buttonOff(button: NightLifeButton)
        buttonOff(button: FoodButton)
        buttonOff(button: ArtButton)
        buttonOff(button: CityInfoButton)
        buttonOff(button: Tourism2Button)
    }
    
    
}

extension DrawerContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(SingletonServer.singleton.user?.myQuestions != nil){
            return (SingletonServer.singleton.user?.myQuestions?.count)!
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PulleyTableViewCell
        
        let imgprof = SingletonServer.singleton.user?.socialAvatar as! NSString
        let indexProf = imgprof.integerValue as! Int
        
        let color = SingletonServer.singleton.user?.myQuestions![indexPath.row].topic
        let indexTopic = Int(color!)
        //        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PulleyTableViewCell1
        
        //        if indexPath.row == 0{
        cell.improf?.image = SingletonServer.singleton.logoImage[indexProf]
        cell.backView?.backgroundColor = SingletonServer.singleton.colori[indexTopic]
        cell.backView?.layer.cornerRadius = 32.0
        cell.descrizione?.text = SingletonServer.singleton.domande?.text
        cell.descrizione?.textColor = .white
        cell.nickname?.text = SingletonServer.singleton.user?.nickname
        cell.nickname?.textColor = .white
        cell.nickname?.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.numero?.layer.cornerRadius = 12.0
        cell.numero?.clipsToBounds = true
        cell.numero?.text = "\(SingletonServer.singleton.domande?.answers?.count)"
        cell.numero?.backgroundColor = .white
        cell.numero?.textColor = SingletonServer.singleton.colori[indexTopic]
        cell.numero?.textAlignment = .center
        cell.data?.text =  SingletonServer.singleton.domande?.dateFine
        cell.data?.textColor = .white
        cell.backView?.addTarget(self, action: #selector(performe), for: .touchDown)
        
        
        
        return cell
        //        }else{
        //            cell1.improf1.image = #imageLiteral(resourceName: "Giorgio")
        //            cell1.inizio1.text = "22:00"
        //            cell1.inizio1.textColor = .black
        //            cell1.num1.text = "14"
        //            cell1.num1.textColor = .white
        //            cell1.num1.backgroundColor = .black
        //            cell1.num1.textAlignment = .center
        //            cell1.num1.layer.cornerRadius = 12.0
        //            cell1.num1.clipsToBounds = true
        //            cell1.desc1.text = "O DRAGGGGGGGGGGGGGGGGGGGGGGGG"
        //            cell1.desc1.textColor = .black
        //            cell1.nick1.text = "Giorgia"
        //            cell1.nick1.textColor = .black
        //            cell1.divisore.text = "-"
        //            cell1.divisore.textColor = .black
        //            cell1.sfondo1.layer.borderWidth = 1
        //            cell1.fine.text = "2:00"
        //            cell1.fine.textColor = .black
        //            cell1.sfondo1.layer.borderColor = UIColor(red: 0/255, green: 90/255, blue: 50/255, alpha: 1.0).cgColor
        //            return cell1
        //        }
    }
    
    @objc func performe(){
        self.performSegue(withIdentifier: "seguePulleyMessage", sender: nil)
    }
    
    func createNewQuestion(){
        self.pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
        let user = SingletonServer.singleton.retrieveUserState()
        let radar = DBRadar(posX: 1, posY: 2, range: 100)
        let data = dateFromTimeout(timeout: 3)
        SingletonServer.singleton.POST_insertNewQuestion(text: AskQuestionTextField.text!, dateFine: data, userOwner: user, radar: radar, topic: 1) { (result) in
            let decoder = JSONDecoder()
            let da = result?.data(using: .utf8)
            do{
                let question = try decoder.decode(DBQuestion.self, from: da!)
                if(question.ID != nil){
                    SingletonServer.singleton.user?.myQuestions?.append(question)
                    SingletonServer.singleton.saveUserState(user: SingletonServer.singleton.user!)
                    print(question.text!)
                }
            }catch{
                print("errore di serializzazione|LATOCLIENT")
            }
            
            
        }
    }
    
    func createNewEvent(){
        let user = SingletonServer.singleton.user
        let radar = DBRadar(posX: 1, posY: 2, range: 10)
        let event = DBEvent(name: "Neasy", oraFine: "23", radar: radar, user: user!, topic: 1)
        SingletonServer.singleton.POST_insertNewEvent(event: event) { (result) in
            let decoder = JSONDecoder()
            let da = result?.data(using: .utf8)
            
            do{
                let e = try decoder.decode(DBEvent.self, from: da!)
                
                if(e.id != nil){
                    
                    
                    SingletonServer.singleton.user?.myEvents?.append(e)
                    SingletonServer.singleton.saveUserState(user: SingletonServer.singleton.user!)
                    
                }
            }catch{
                print("errore di serializzazione|LATOCLIENT")
            }
            
            
        }
    }
    
}




