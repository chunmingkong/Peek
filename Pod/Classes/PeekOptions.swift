//
//  PeekOptions.swift
//  Peek
//
//  Created by Shaps Mohsenin on 22/04/2016.
//  Copyright © 2016 Snippex. All rights reserved.
//

import Foundation

public enum PeekActivationMode {
  case Auto
  case Shake
}

/// Defines various options to use when enabling Peek
public final class PeekOptions: NSObject {
  
   /// Defines how Peek is activated/de-activated
  public var activationMode = PeekActivationMode.Auto
  
   /// Defines whether Peek should ignore pure containers (i.e. UIView's (NOT subclassed) where subviews.count > 0)
  public var shouldIgnoreContainers = true
  
}
