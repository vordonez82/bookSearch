//
//  ViewController.swift
//  bookSearch2
//
//  Created by Vicente Ordoñez Garcia on 12/2/18.
//  Copyright © 2018 Vicente Ordoñez Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var ISBN : String? = ""
    
    @IBOutlet weak var txtResult: UITextView!
    @IBOutlet weak var txtISBN: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtResult.text = ""
        txtISBN.delegate=self
    }

    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        ISBN = txtISBN.text
        txtResult.text = "Buscando..."
        if ISBN != ""
        {
            //sincrono(isbn: ISBN!)
            asincrono(isbn: ISBN!)
        }
        textField.resignFirstResponder()
    }
    
    func sincrono(isbn : String) {
        do {
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
            let url = try NSURL(string: urls)
            let datos:NSData? = try NSData(contentsOf: url! as URL)
            let texto = try NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
            if texto != "{}" {
                txtResult.text = texto! as String
            }
            else {
                txtResult.text = "No se encontraron coincidencias"
            }
        }
        catch {
            //Handle the error
            var alert = UIAlertView(title:"No internet connection", message: "No hay conexion a internet", delegate: nil, cancelButtonTitle: "OK")
        }
    }
    
    func asincrono(isbn:String) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        guard let url =  URL(string: urls) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) {
            (data, response, error) in
            if (error != nil) {
                //_ = UIAlertView(title:"Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                print(error!.localizedDescription)
                self.txtResult.text = error!.localizedDescription
            }
            guard let data = data else { return }
            let texto =  NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if texto != "{}" {
                self.txtResult.text = texto! as String
            }
            else {
                self.txtResult.text = "No se encontraron coincidencias"
            
            }
        }.resume()
            
    
        
        
    }

}

