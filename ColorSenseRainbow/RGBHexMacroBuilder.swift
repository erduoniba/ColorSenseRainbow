//
//  RGBHexMacroBuilder.swift
//  ColorSenseRainbow
//
//  Created by yohunl on 16/3/3.
//  Copyright © 2016年 Northern Realities Inc. All rights reserved.
//

import AppKit

class RGBHexMacroBuilder: ColorBuilder {
    
    override func stringForColor( color : NSColor, forSearchResult : SearchResult ) -> String? {
        
        var returnString = ""
        
        if let unwrappedString = forSearchResult.capturedStrings.first {
            returnString = unwrappedString
        } else {
            return nil
        }
        
     
        var hexstring = color.asHexString().lowercaseString
        if let _ = offsetRangeInSearchResult( forSearchResult, forRangeAtIndex: 2 ) {
            hexstring = "0x" + hexstring
        }
        
        if let modifiedString = processCaptureGroupInSearchResult( forSearchResult, forRangeAtIndex: 2, inText: returnString, withReplacementText: hexstring ) {
            returnString = modifiedString
        } else {
            return nil
        }
        
        if color.alphaComponent < 1.0 && forSearchResult.tcr.numberOfRanges == 4 {
            if let modifiedString = processCaptureGroupInSearchResult( forSearchResult, forRangeAtIndex: 3, inText: returnString, withReplacementText: "\(color.alphaComponent)" ) {
                returnString = modifiedString
            } else {
                return nil
            }
        }
        
        
                
        return returnString
    }
    

}
