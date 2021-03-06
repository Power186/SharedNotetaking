//
//  MessagesViewController.swift
//  CoLab Notes MessagesExtension
//
//  Created by Power186 on 2/5/20.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, CompactDelegate, ExpandedDelegate {
    let compactID:String = "compact"
    let expandedID:String = "expanded"
    var shouldClear:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    // added the method didBecomeActive for consistent layout
    override func didBecomeActive(with conversation: MSConversation) {
        presentVC(presentationStyle: self.presentationStyle)
    }
        
    
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    func presentVC(presentationStyle:MSMessagesAppPresentationStyle) {
        let identifier = (presentationStyle == .compact) ? compactID : expandedID
        let controller = storyboard!.instantiateViewController(identifier: identifier)
        
        
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        // add new controller whether it is expanded or compact to messages app vc
        addChild(controller)
        
        // reset the frame and add it as a subview
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        // reset anchors
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // call to parent vc
        controller.didMove(toParent: self)
        
        if let compact = controller as? CompactViewController {
            compact.delegate = self
        }
        else if let expanded = controller as? ExpandedViewController {
            expanded.delegate = self
            if shouldClear {
                expanded.clearText()
                shouldClear = false
            }
            
            // defining delegate then checking to see if there is URL
            else if let url = self.activeConversation?.selectedMessage?.url {
                expanded.didOpen(from: url)
            }
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        // call present vc method when transition happens between the view controllers
        presentVC(presentationStyle: presentationStyle)
    }
    
    func newNote() {
        shouldClear = true
        self.requestPresentationStyle(.expanded)
    }
    
    func sendMessage(title: String, note: String) {
        let session = self.activeConversation?.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: session)
        let layout = MSMessageTemplateLayout()
        layout.caption = note
        layout.subcaption = title
        
        // identify user when sending a message in sent/edited notes
        let user:String =
            self.activeConversation?.localParticipantIdentifier.uuidString ?? "Unknown"
        layout.trailingSubcaption = "Edited by $\(user)" //use $ to add user in view
        
        message.layout = layout
        message.url = getMessageURL(title: title, note: note)
        self.activeConversation?.insert(message, completionHandler: { (e:Error?) in
            print("complete!")
        })
        self.dismiss()
    }
    
    func getMessageURL(title:String,note:String) -> URL {
        var components = URLComponents()
        let qTitle = URLQueryItem(name: "title", value: title)
        let qNote = URLQueryItem(name: "note", value: note)
        components.queryItems = [qTitle, qNote]
        return components.url!
    }

}
