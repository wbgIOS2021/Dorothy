//
//  PageDescriptionViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 23/08/21.
//

import UIKit

class PageDescriptionViewController: UIViewController {

    @IBOutlet weak var textContent: UITextView!
    let htmlString = "<!DOCTYPE html><html><head><title>Page Title</title></head><body><h1>Terms and Conditions</h1><p>Welcome to Agama suya !<br>These terms and conditions outline the rules and regulations for the use of HTMLCSS3 Tutorials’s Website, located at By accessing this website we assume you accept these terms and conditions. Do not continue to use HTMLCSS3 Tutorials if you do not agree to take all of the terms and conditions stated on this page.<br>The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.</p><h3>Cookies</h3><p>We employ the use of cookies. By accessing HTMLCSS3 Tutorials, you agreed to use cookies in agreement with the HTMLCSS3 Tutorials’s Privacy Policy.Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.</p><h3>License</h3><p>Unless otherwise stated, HTMLCSS3 Tutorials and/or its licensors own the intellectual property rights for all material on HTMLCSS3 Tutorials. All intellectual property rights are reserved. You may access this from HTMLCSS3 Tutorials for your own personal use subjected to restrictions set in these terms and conditions.</p><p>Republish material from HTMLCSS3 TutorialsSell, rent or sub-license material from HTMLCSS3 TutorialsReproduce, duplicate or copy material from HTMLCSS3TutorialsHTMLCSS3 Tutorials reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.<br>You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;<br>The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacyThe Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.You hereby grant HTMLCSS3 Tutorials a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.<br>Hyperlinking to our ContentThe following organizations may link to our Website without prior written approval:<p></body></html>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyData(htmlString:htmlString)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
}

extension PageDescriptionViewController
{
    func applyData(htmlString:String)
    {
        let htmlString = htmlString

        let data = htmlString.data(using: String.Encoding.unicode)! // mind "!"
        let attrStr = try? NSAttributedString( // do catch
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)

        self.textContent.attributedText = attrStr


    }
}
