//
//  SKTileObject.swift
//  SKTiled
//
//  Created by Michael Fessenden on 3/21/16.
//  Copyright © 2016 Michael Fessenden. All rights reserved.
//

import SpriteKit
import GameplayKit


public enum ObjectType: String {
    case Rectangle
    case Ellipse
    case Polygon
    case Polyline
}


/// simple object class
public class SKTileObject: SKShapeNode, TiledObject {

    weak public var layer: SKObjectGroup!            // layer parent, assigned on add
    public var uuid: String = UUID().uuidString    // unique id
    public var id: Int = 0                           // object id
    public var type: String!                         // object type
    public var objectType: ObjectType = .Rectangle   // shape type
    
    public var points: [CGPoint] = []                // points that describe object shape
    
    public var size: CGSize = CGSize.zero
    public var obstacle: GKObstacle!                 // obstacle type
    public var properties: [String: String] = [:]    // custom properties
    
    // blending/visibility
    public var opacity: CGFloat {
        get { return self.alpha }
        set { self.alpha = newValue }
    }
    
    public var visible: Bool {
        get { return !self.isHidden }
        set { self.isHidden = !newValue }
    }
    
    // MARK: - Init
    override public init(){
        super.init()
        drawObject()
    }
    
    public init?(attributes: [String: String]) {
        // required attributes
        guard let objectID = attributes["id"] else { return nil }        
        guard let xcoord = attributes["x"] else { return nil }        
        guard let ycoord = attributes["y"] else { return nil }        
        
        id = Int(objectID)!
        super.init()
        
        let startPosition = CGPoint(x: CGFloat(Double(xcoord)!), y: CGFloat(Double(ycoord)!))
        position = startPosition
        
        if let objectName = attributes["name"] {
            self.name = objectName
        }
        
        // size properties
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if let objectWidth = attributes["width"] {            
            width = CGFloat(Double(objectWidth)!)
        }
        
        if let objectHeight = attributes["height"] {
            height = CGFloat(Double(objectHeight)!)
        }
        
        if let objType = attributes["type"] {
            type = objType
        }
        
        // Rectangular and ellipse objects need initial points.
        if (width > 0) && (height > 0) {
            points = [CGPoint(x: 0, y: 0),
                      CGPoint(x: width, y: 0),
                      CGPoint(x: width, y: height),
                      CGPoint(x: 0, y: height)
            ]
        }
        
        self.size = CGSize(width: width, height: height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    /**
     Set the fill & stroke colors (with optional alpha component for the fill)
     
     - parameter color: `SKColor` fill & stroke color.
     - parameter alpha: `CGFloat` alpha component for fill.
     */
    public func setColor(_ color: SKColor, withAlpha alpha: CGFloat=0.2) {
        self.strokeColor = color
        
        if !(self.objectType == .Polyline)  {
            self.fillColor = color.withAlphaComponent(alpha)
        }
    }
    
    /**
     Draw the path.
     */
    public func drawObject() {
        guard let layer = layer else { return }
        guard points.count > 1 else { return }
        
        // draw the anchor/first point
        childNode(withName: "Anchor")?.removeFromParent()
        
        let anchorRadius: CGFloat = layer.tileHeight > 16 ? 2.5 : 1.5
        let anchor = SKShapeNode(circleOfRadius: anchorRadius)
        anchor.name = "Anchor"
        addChild(anchor)
        anchor.strokeColor = SKColor.clear
        anchor.fillColor = self.strokeColor
        anchor.isAntialiased = true
        
        
        if let vertices = getVertices() {
            switch objectType {
            case .Ellipse:
                self.path = bezierPath(vertices.map{$0.invertedY}, radius: layer.tileHeightHalf)
            default:
                self.path = polygonPath(vertices.map{$0.invertedY})
            }
            // polyline objects should have no fill
            self.fillColor = (self.objectType == .Polyline) ? SKColor.clear : self.fillColor
        }
    }
    
    // MARK: - Polygon Points
    /**
     Add polygons points.
     
     - parameter points: `[[CGFloat]]` array of coordinates.
     - parameter closed: `Bool` close the object path.
     */
    public func addPoints(_ coordinates: [[CGFloat]], closed: Bool=true) {
        self.objectType = (closed == true) ? ObjectType.Polygon : ObjectType.Polyline
        
        // create an array of points from the given coordinates
        points = coordinates.map { CGPoint(x: $0[0], y: $0[1]) }
    }
    
    /**
     Add points from a string.
     
     - parameter points: `String` string of coordinates.
     */
    public func addPointsWithString(_ points: String) {
        var coordinates: [[CGFloat]] = []
        let pointsArray = points.components(separatedBy: " ")
        for point in pointsArray {
            let coords = point.components(separatedBy: ",").flatMap { x in Double(x) }
            coordinates.append(coords.flatMap { CGFloat($0) })
        }
        addPoints(coordinates)
    }
    
    /**
     Return the current points.
     
     - returns: `[CGPoint]?` array of points.
     */
    fileprivate func getVertices() -> [CGPoint]? {
        guard let layer = layer else { return nil}
        guard points.count > 1 else { return nil}
        
        var vertices: [CGPoint] = []
        for point in points {
            var offset = layer.pixelToScreenCoords(point)
            offset.x -= layer.origin.x
            vertices.append(offset)
        }
        return vertices
    }
}



extension SKTileObject {
    
    override public var hashValue: Int {
        return id.hashValue
    }
    
    override public var description: String {
        let objectName: String = name != nil ? "\"\(name!)\"" : "(null)"
        return "\(String(describing: objectType)) Object: \(objectName), id: \(self.id)"
    }
    
    override public var debugDescription: String {
        return description
    }
}
