//
//  UIViewController+PulleyViewController.swift
//  BatChat
//
//  Created by Antonio Terrano on 25/05/18.
//  Copyright © 2018 Lorenzo Caso. All rights reserved.
//

import UIKit
import Pulley

public extension UIViewController {
    
    /// If this viewController pertences to a PulleyViewController, return it.
    public var pulleyViewController: PulleyViewController? {
        var parentVC = parent
        while parentVC != nil {
            if let pulleyViewController = parentVC as? PulleyViewController {
                return pulleyViewController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }
    
}
