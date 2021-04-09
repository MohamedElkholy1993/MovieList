//
//  EditNewMovieViewController.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/8/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import UIKit


class EditNewMovieViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField?
    @IBOutlet weak var imageNameField: UITextField?
    @IBOutlet weak var releaseYearField: UITextField?
    @IBOutlet weak var ratingField: UITextField?
    @IBOutlet weak var genreField: UITextField?
    
    var dataSender :SendNewMovieEditedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    @objc func doneButtonPressed(){
        let newMovieToEdit = Movie()
        
        if let title = titleField?.text{
            if  titleField?.text != ""{
                newMovieToEdit.title = title
            }else{
                newMovieToEdit.title = "Title"
            }
        }
        
        if let _ = UIImage(named:imageNameField!.text!){
            newMovieToEdit.image = imageNameField!.text!
        }
        
        if let releaseYear = Int(releaseYearField!.text!){
            newMovieToEdit.releaseYear = releaseYear
        }else{
            newMovieToEdit.releaseYear = 2021
        }
        
        if let rating = Float(ratingField!.text!){
            if rating <= 10 && rating >= 0{
                newMovieToEdit.rating = rating
            }else{
                newMovieToEdit.rating = 0.0
            }
        }
        
        
        if let genre = genreField?.text{
            newMovieToEdit.genre = genre.components(separatedBy: " ")
        }
        
        
        dataSender?.sendNewMovieEditedDataBack(newEditedMovie: newMovieToEdit)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
