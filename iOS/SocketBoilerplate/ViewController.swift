//
//  ViewController.swift
//  SocketBoilerplate
//
//  Created by reynolds on 6/24/15.
//  Copyright (c) 2015 Patrick Reynolds. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var drawImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationVerticalSpacingToTopLayoutGuide: NSLayoutConstraint!
    @IBOutlet weak var canvasView: UIView!
    
    let path = UIBezierPath()
    var lastPoint = CGPoint()

    let socket = SocketIOClient(socketURL: "localhost:4000")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addHandlers()
        self.socket.connect()
        notificationVerticalSpacingToTopLayoutGuide.constant = -60
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.socket.disconnect(fast: true)
    }
    
    // Socket Handlers
    func addHandlers() {
        
        self.socket.on("connect") { data, ack in
            println("socket connected")
        }
        
        self.socket.on("ios-like-photo-notification") { [weak self] data, ack in
            if let notificaiton = data?[0] as? String {
                self?.handleLikeNotification(notificaiton)
            }
        }
        
        self.socket.on("disconnect") {data, ack in
            exit(0)
        }
        
        self.socket.onAny {
            println("Got event: \($0.event), with items: \($0.items)")
        }
    }
    
    func handleLikeNotification(notification: String) {
        self.notificationLabel.text = notification
        notificationVerticalSpacingToTopLayoutGuide.constant = 0
        UIView.animateWithDuration(0.3,
            animations: { () in
                self.view.layoutIfNeeded()
            }) { [weak self](value: Bool) -> Void in
                self?.notificationVerticalSpacingToTopLayoutGuide.constant = -60
                UIView.animateWithDuration(0.3,
                    delay: 1.5,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: { () in
                        self?.view.layoutIfNeeded()
                    },
                    completion: { (value: Bool) -> Void in
                })
        }
    }
    
    @IBAction func handleLikeButtonPressed(sender: UIButton) {
        self.socket.emit("ios-like-photo", ["Patrick liked your photo"])
    }
    
    @IBAction func handleCanvasPanGesture(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.locationInView(self.canvasView)
        switch sender.state {
            case .Began:
                println("Began: (\(touchPoint.x), \(touchPoint.y))")
                self.drawImage.image = nil
                self.socket.emit("canvas-began-location", ["x": touchPoint.x, "y": touchPoint.y])
                lastPoint = touchPoint
            case .Changed:
                println("Changed: (\(touchPoint.x), \(touchPoint.y))")
                self.socket.emit("canvas-changed-location", ["x": touchPoint.x, "y": touchPoint.y])
                
                strokeLineFromPoint(lastPoint, toPoint: touchPoint)
                
                self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
                self.drawImage.alpha = 1
                
                lastPoint = touchPoint;
            case .Ended:
                println("Ended: (\(touchPoint.x), \(touchPoint.y))")
                self.socket.emit("canvas-ended-location", ["x": touchPoint.x, "y": touchPoint.y])
                strokeLineFromPoint(lastPoint, toPoint: touchPoint)
                UIGraphicsBeginImageContext(self.drawImage.frame.size);
                self.drawImage.image?.drawInRect(CGRect(x: 0, y: 0, width: self.drawImage.frame.size.width, height: self.drawImage.frame.size.height));
                self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            
            default:
                println("")
        }
    }
    
    func strokeLineFromPoint(lastPoint: CGPoint, toPoint touchPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        self.drawImage.image?.drawInRect(CGRect(x: 0, y: 0, width: self.canvasView.frame.size.width, height:self.canvasView.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0 );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
}

