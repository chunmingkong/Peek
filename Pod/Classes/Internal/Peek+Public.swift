/*
  Copyright © 23/04/2016 Shaps

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

import UIKit

struct ContextAssociationKey {
  static var Inspectors: UInt8 = 1
}

/**
 Defines the available inspector set's
 
 - Primary:   The primary inspectors include: Attributes, View, Layer, Layout & Controller
 - Secondary: The secondary inspectors include: Application, Device & Screen
 */
@objc public enum InspectorSet: Int {
  // MARK: - The primary inspectors include: Attributes, View, Layer, Layout & Controller
  case Primary = 1
  // MARK: - The secondary inspectors include: Application, Device & Screen
  case Secondary = 2
}

extension InspectorSet {
  
  func inspectors() -> [Inspector] {
    if self == .Primary {
      return [ .Attributes, .View, .Layer, .Layout, .Controller ]
    } else {
      return [ .Application, .Device, .Screen ]
    }
  }
  
}

/**
 Defines the available inspectors
 
 - Attributes:  The Attributes inspector is used to present contextual properties
 - View:        The View inspector is used to present UIView properties
 - Layer:       The Layer inspector is used to present CALayer properties
 - Layout:      The Layout inspector is used to present view layout properties
 - Controller:  The Controller inspector is used to present UIViewController properties
 - Application: The Application inspector is used to present UIApplication properties
 - Device:      The Device inspector is used to present UIDevice properties
 - Screen:      The Screen inspector is used to present UIScreen properties
 */
@objc public enum Inspector: Int {
  // MARK: - The Attributes inspector is used to present contextual properties
  case Attributes
  // MARK: - The View inspector is used to present UIView properties
  case View
  // MARK: - The Layer inspector is used to present CALayer properties
  case Layer
  // MARK: - The Layout inspector is used to present view layout properties
  case Layout
  // MARK: - The Controller inspector is used to present UIViewController properties
  case Controller
  // MARK: - The Application inspector is used to present UIApplication properties
  case Application
  // MARK: - The Device inspector is used to present UIDevice properties
  case Device
  // MARK: - The Screen inspector is used to present UIScreen properties
  case Screen
}

extension Inspector: CustomStringConvertible {
  
    /// Returns the TabBar title for an inspector
  public var description: String {
    switch self {
    case .Attributes: return "Attributes"
    case .View: return "View"
    case .Layer: return "Layer"
    case .Layout: return "Layout"
    case .Controller: return "Controller"
    case .Application: return "Application"
    case .Device: return "Device"
    case .Screen: return "Screen"
    }
  }
  
}

extension Inspector {
  
    /// Returns the TabBar icon for an inspector
  public var image: UIImage? {
    return Images.inspectorImage(self)
  }
  
}

/// A configuration describes the properties available for that configuration
@objc public protocol Configuration: class {
  
  /**
   Returns the specified keyPaths as Peek Properties
   
   - parameter keyPaths: The keyPaths to use for representing properties in Peek
   
   - returns: An array of Properties
   */
  func addProperties(keyPaths: [String]) -> [Property]
  
  /**
   Adds the specified keyPath as a Peek Property
   
   - parameter keyPath:           The keyPath to use for representing this property
   - parameter displayName:       The display name for this property (optional) -- If you pass nil, the keyPath will be used -- Peek will automatically convert it to a readable string
   - parameter cellConfiguration: An optional cell configuration for this property -- this allows you to provide custom logic for updating your property cell at runtime
   
   - returns: A new Property
   */
  func addProperty(keyPath: String, displayName: String?, cellConfiguration: PropertyCellConfiguration) -> Property
  
  /**
   Adds the specified value as a Peek Property
   
   - parameter value:             The value representing this property's value
   - parameter displayName:       The display name for this property (optional) -- If you pass nil, the keyPath will be used -- Peek will automatically convert it to a readable string
   - parameter cellConfiguration: An optional cell configuration for this property -- this allows you to provide custom logic for updating your property cell at runtime
   
   - returns: A new Property
   */
  func addProperty(value value: AnyObject?, displayName: String?, cellConfiguration: PropertyCellConfiguration) -> Property
}

/// A context represents the current Peek context when its activated. You can use this context to add properties and categories to your inspectors
@objc public protocol Context: class {
  
    /// Returns the properties associated with this Context
  var properties: [Property] { get }
  
  /**
   Use this method from your View's to configure the context's properties
   
   - parameter inspector:     The inspector to configure
   - parameter category:      The category to add/configure
   - parameter configuration: The configuration to apply to this context
   */
  func configure(inspector: Inspector, _ category: String, @noescape configuration: (config: Configuration) -> Void)
}

/// Defines a property cell configuration block
public typealias PropertyCellConfiguration = ((cell: UITableViewCell, object: AnyObject, value: AnyObject) -> Void)?

/// A property defines a property that can be presented in Peek to represent a value for a given model
@objc public protocol Property: class {
  
    /// Get/set the value associated with this Property
  weak var value: AnyObject? { get set }
  
    /// Returns the keyPath associated with this Property
  var keyPath: String { get }
  
    /// Returns the display name associated with this Property
  var displayName: String { get }
  
    /// Returns the category this Property is associated with -- this is used to provide grouping/sectioning
  var category: String { get }
  
    /// Returns the inspector this Property is associated with
  var inspector: Inspector { get }
  
    /// Returns the cell configuration block associated with this Property
  var configurationBlock: PropertyCellConfiguration { get }
  
    /// Returns the preferred cell height associated with this Property
  var cellHeight: CGFloat { get set }
  
  /**
   Initializes a new property for the associated keyPath
   
   - parameter keyPath:       The keyPath for this property
   - parameter displayName:   The display name for this property (optional)
   - parameter value:         The associated value for this property (optional)
   - parameter category:      The category this property belongs to
   - parameter inspector:     The inspector this property belongs to
   - parameter configuration: The cell configuration for this property
   
   - returns: A newly configured Property
   */
  init(keyPath: String, displayName: String?, value: AnyObject?, category: String, inspector: Inspector, configuration: PropertyCellConfiguration)
  
  /**
   Returns the value runtime associated with this property
   
   - parameter model: The model to use for looking up its keyPath's value
   
   - returns: The underlying runtime value associated with this model
   */
  func value(forModel model: AnyObject) -> AnyObject?
  
}
