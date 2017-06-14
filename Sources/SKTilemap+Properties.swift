//
//  SKTilemap+Properties.swift
//  SKTiled
//
//  Created by Michael Fessenden on 8/12/16.
//  Copyright © 2016 Michael Fessenden. All rights reserved.
//

import SpriteKit


public extension SKTilemap {
    // MARK: - Properties
    /**
     Parse properties from the Tiled TMX file.
     */
    public func parseProperties(completion: (() -> ())?) {

        if (ignoreProperties == true) { return }
        
        for (attr, value) in properties {
            
            let lattr = attr.lowercased()
            
            if (lattr == "name") {
                name = value
            }
            
            if (lattr == "type") {
                type = value
            }
            
            if ["zdelta", "zdeltaforlayers", "layerdelta"].contains(lattr){
                zDeltaForLayers = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : zDeltaForLayers
            }
            
            if ["debug", "debugmode", "debugdraw"].contains(lattr){
                debugDraw = boolForKey(value)
                debugMode = boolForKey(value)
            }
            
            if (lattr == "gridcolor") {
                gridColor = SKColor(hexString: value)
                allLayers().forEach {$0.gridColor = gridColor}
            }
            
            if (lattr == "gridopacity") {
                baseLayer.gridOpacity = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : 0.10
                allLayers().forEach {$0.gridOpacity = self.baseLayer.gridOpacity}
            }
            
            if (lattr == "framecolor") {
                frameColor = SKColor(hexString: value)
                allLayers().forEach {$0.frameColor = frameColor}
            }
            
            if (lattr == "highlightcolor") {
                highlightColor = SKColor(hexString: value)
                allLayers().forEach {$0.highlightColor = highlightColor}
            }
            
            // initial world scale.
            if (lattr == "worldscale") {
                worldScale = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : worldScale
            }
            
            if (lattr == "allowzoom") {
                allowZoom = boolForKey(attr)
            }
            
            if (lattr == "allowmovement") {
                allowMovement = boolForKey(attr)
            }
            
            if (lattr == "zposition") {
                zPosition = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : zPosition
            }
            
            // aspect scaling
            if (lattr == "aspect") {
                yScale *= (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : 1
            }
            
            if (lattr == "linewidth") {
                //lineWidth = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : lineWidth
            }
            
            if (lattr == "tileoverlap") {
                tileOverlap = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : tileOverlap
            }
            
            if (lattr == "minzoom") {
                minZoom = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : minZoom
            }
            
            if (lattr == "maxzoom") {
                maxZoom = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : maxZoom
            }
            
            if (lattr == "ignorebackground") {
                ignoreBackground = boolForKey(attr)
            }
            
            if (lattr == "antialiasLines") {
                antialiasLines = boolForKey(attr)
            }
            
            if (lattr == "autoresize") {
                autoResize = boolForKey(attr)
            }
            
            if (lattr == "showobjects") {
                showObjects = boolForKey(attr)
            }
            
            if (lattr == "xgravity") {
                gravity.dx = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : 0
            }
            
            if (lattr == "ygravity") {
                gravity.dy = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : 0
            }
            
            if (lattr == "showgrid") {
                baseLayer.showGrid = boolForKey(attr)
            }
            
            if (lattr == "cropatboundary") {
                cropAtBoundary = boolForKey(attr)
            }
            
            if (lattr == "overlaycolor") {
                overlayColor = SKColor(hexString: value)
            }
        }
        
        if completion != nil { completion!() }
    }
}


public extension SKTileset {
    // MARK: - Properties
    
    /**
     Parse the tileset's properties value.
     */
    public func parseProperties(completion: (() -> ())?) {
        if (ignoreProperties == true) { return }
        for (attr, value) in properties {
            if (attr == "type") {
                type = value
            }
        }
        if completion != nil { completion!() }
    }
}


public extension TiledLayerObject {
    // MARK: - Properties
    
    /**
     Parse the layer's properties value.
     */
    public func parseProperties(completion: (() -> ())?) {
        if (ignoreProperties == true) { return }
        for (attr, value) in properties {
            
            let lattr = attr.lowercased()
            
            if (lattr == "type") {
                type = value
            }
            
            if (lattr == "zposition") {
                guard let zpos = Double(value) else { return }
                zPosition = CGFloat(zpos)
            }
            
            if (lattr == "color") {
                setColor(color: SKColor(hexString: value))
            }
            
            if (lattr == "backgroundcolor") {
                background.color = SKColor(hexString: value)
                background.colorBlendFactor = 1.0
            }
            
            if (lattr == "hidden") {
                isHidden = boolForKey(attr)
            }
            
            if (lattr == "visible") {
                visible = boolForKey(attr)
            }
            
            if (lattr == "antialiasing") {
                antialiased = boolForKey(attr)
            }
            
            
            if (lattr == "drawbounds") {
                if boolForKey(attr) == true {
                    drawBounds()
                }
            }
            
            if completion != nil { completion!() }
        }
    }
    
    /**
     Returns a named property for the layer.
     
     - parameter name: `String` property name.     
     - returns: `String?` the property value, or nil if it does not exist.
     */
    public func getValue(forProperty name: String) -> String? {
        return properties[name]
    }
    
    /**
     Set a property/value pair.
     
     - parameter name:  `String` property name.
     - parameter value: `String` property value.
     */
    public func setValue(_ value: String, forProperty name: String) {
        properties[name] = value
    }
}


public extension SKTileLayer {
    // MARK: - Properties
    
    /**
     Parse the tile layer's properties.
    */
    override public func parseProperties(completion: (() -> ())?) {
        super.parseProperties(completion: completion)
    }
}


public extension SKObjectGroup {
    // MARK: - Properties
    
    /**
     Parse the object group's properties.
    */
    override public func parseProperties(completion: (() -> ())?) {
        if (ignoreProperties == true) { return }
        for (attr, _ ) in properties {
            let lattr = attr.lowercased()
            
            if (lattr == "linewidth") {
                lineWidth = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : lineWidth
            }
        }
        
        super.parseProperties(completion: completion)
    }
}


public extension SKImageLayer {
    // MARK: - Properties
    /**
     Parse the image layer's properties.
    */
    override public func parseProperties(completion: (() -> ())?) {
        super.parseProperties(completion: completion)
    }
}


public extension SKTileObject {
    // MARK: - Properties
    /**
     Parse the object's properties value.
     */
    public func parseProperties(completion: (() -> ())?) {
        if (ignoreProperties == true) { return }
        for (attr, value) in properties {
            
            let lattr = attr.lowercased()
            
            if (lattr == "color") {
                setColor(hexString: value)
            }
            
            if (lattr == "linewidth") {
                lineWidth = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : lineWidth
            }
            
            if (lattr == "zposition") {
                zPosition = (doubleForKey(attr) != nil) ? CGFloat(doubleForKey(attr)!) : zPosition
            }
        }
        
        // Physics
        let isDynamic:  Bool = boolForKey("isDynamic")
        let isCollider: Bool = boolForKey("isCollider")

        physicsType = Int(isDynamic) ^ Int(isCollider) == 0 ? .none : (isDynamic == true) ? .dynamic : .collision

        if completion != nil { completion!() }
    }
}


public extension SKTilesetData {
    // MARK: - Properties
    /**
     Parse the tile data's properties value.
     */
    public func parseProperties(completion: (() -> ())?) {        
        if (ignoreProperties == true) { return }
        if completion != nil { completion!() }
    }
}
