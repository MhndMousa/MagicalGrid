//
//  ViewController.swift
//  Magical Grid
//
//  Created by Muhannad Alnemer on 11/12/19.
//  Copyright © 2019 Muhannad Alnemer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    let numViewPerRow = 10
    var cells = [String: UIView]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.width / CGFloat(numViewPerRow)
        
        for j in 0...30{
            for i in 0...numViewPerRow{
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.frame = CGRect(x: width * CGFloat(i), y: CGFloat(j) * width, width: width, height:width)
                cellView.layer.borderWidth = 0.25
                cellView.layer.borderColor = UIColor.gray.cgColor
                    
                view.addSubview(cellView)
                
                let key = "\(i)|\(j)"
                cells[key] = cellView
                
            }
        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handlePan)))
        view.addGestureRecognizer(UIHoverGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }

    var label = UILabel()
    var selectedCell: UIView?
    @objc func handlePan(gesture: UIGestureRecognizer ){
        let location = gesture.location(in: view)
//        print(location)
        label.alpha = 1
        let width = view.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        print(i,j)
        
        var loopCount = 0

        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else {return}

        
        
        if selectedCell != cellView{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
                self.selectedCell?.backgroundColor = self.randomColor()
                self.label.removeFromSuperview()
              }, completion: nil)
        }
        
        if selectedCell != cellView{
            selectedCell = cellView
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.view.bringSubviewToFront(cellView)

                self.selectedCell?.backgroundColor = self.randomColor()
                
                self.view.addSubview(self.label)
                self.label.text = "\(Int.random(in: 0...100))"
                self.label.translatesAutoresizingMaskIntoConstraints = false
                self.label.centerYAnchor.constraint(equalTo: self.selectedCell!.centerYAnchor).isActive = true
                self.label.centerXAnchor.constraint(equalTo: self.selectedCell!.centerXAnchor).isActive = true
                cellView.layer.transform = CATransform3DMakeScale(3,3,1)
            }, completion: nil)
            
        }
        

        
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 6, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
                self.selectedCell?.backgroundColor = self.randomColor()
                
                self.label.alpha = 0
            }, completion: {(_) in
                self.selectedCell = nil
            })
        }
        
    }

    fileprivate func randomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }

}

