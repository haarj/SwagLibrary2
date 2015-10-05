//
//  BookDetailVC2.swift
//  Swag Library 2
//
//  Created by Justin Haar on 10/2/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

import UIKit


class BookDetailVC2: UIViewController {

    var book = Book()

    @IBOutlet weak var labelTitleAuthor: UILabel?
    @IBOutlet weak var labelDetails: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.book.title

        //Title/Author label UI
        self.labelTitleAuthor!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.labelTitleAuthor!.numberOfLines = 0
        self.labelTitleAuthor!.font = UIFont.systemFontOfSize(20)
        self.labelTitleAuthor!.textColor = UIColor.blueColor()
        self.labelTitleAuthor!.text = "\(self.book.title)\n\(self.book.author)"

        //Detail Label UI
        self.labelDetails!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.labelDetails!.numberOfLines = 0
        self.labelDetails!.font = UIFont.systemFontOfSize(14)
        self.labelDetails!.textColor = UIColor.grayColor()
        self.labelDetails!.text = "Publisher: \(self.book.publisher)\nCategories: \(self.book.category)\nLastCheckedOutBy:\n\(self.book.lastCheckedOutBy) \(self.book.lastCheckedOut)"
    }

    //Alertview for adding name to book.lastCheckedOutBy property
    @IBAction func checkoutButtonTapped(sender: UIButton) {

        let alert: UIAlertController = UIAlertController.init(title: "Checkout", message: "Who is checking the book out?", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Enter Name"
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            textField.addTarget(self, action:"alertTextFieldDidChange:", forControlEvents: UIControlEvents.AllEvents)

        })

        let cancel: UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)

        //Set lastCheckedOutBy and lastCheckedOut properties for book.
        let add: UIAlertAction = UIAlertAction.init(title: "Add", style: UIAlertActionStyle.Default) {

            (UIAlertAction) -> Void in

            //TextField Text = lastCheckedOutBy
            let textfield: UITextField = (alert.textFields?.first)!
            self.book.lastCheckedOutBy = textfield.text

            //Current date
            let formatter: NSDateFormatter = NSDateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            formatter.timeZone = NSTimeZone.localTimeZone()
            let dateString: String = formatter.stringFromDate(NSDate())
            self.book.lastCheckedOut = dateString

            Book.updateBook(self.book)

            self.view.endEditing(true)

            self.navigationController!.popViewControllerAnimated(true)

        }

        alert.addAction(cancel)
        alert.addAction(add)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    //Target method for CheckoutButtonTapped Alert
    func alertTextFieldDidChange(sender: UITextField) {

        let tf = sender
        var resp : UIResponder = tf
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        let alert = resp as! UIAlertController
        (alert.actions[1] as UIAlertAction).enabled = (tf.text != "")
    }

    //Share button in top left of NavBar
    @IBAction func shareBook(sender: UIBarButtonItem) {
        let items: NSMutableArray = NSMutableArray()
        let message: String = "Hey everyone! Check out this amazing book I just got from the Swag library. If you're not reading this book, you don't have your swag on! Here are the details:\nTitle:\(self.book.title)\nAuthor:\(self.book.author)\nPublisher:\(self.book.publisher)\nCategory:\(self.book.category)"
        items.addObject(message)
        let activityController: UIActivityViewController = UIActivityViewController(activityItems:items as [AnyObject], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
}
