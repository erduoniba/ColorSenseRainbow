//
//  DefaultWhiteBuilder.swift
//  ColorSenseRainbow
//
//  Created by Reid Gravelle on 2015-08-05.
//  Copyright (c) 2015 Northern Realities Inc. All rights reserved.
//

import AppKit

class DefaultWhiteBuilder: ColorBuilder {

    /**
    Generates a String containing the code required to create a color object for the specified color in the method detailed by the SearchResults.  While a new string could be generated more easily by just entering the values into a template replacing the values in the existing string will keep the formatting the way the user prefers.  This involves moving backwards through the values as the new values may be different lengths and would change the ranges for later values.
    
    - parameter color:            The new color that will be described by the string.
    - parameter forSearchResults: A SearchResults object containing the ranges for text to replace.
    
    - returns: A String object containing code how to create the color.
    */
    
    override func stringForColor( color : NSColor, forSearchResult : SearchResult ) -> String? {
        
        var returnString = ""
        
        if let unwrappedString = forSearchResult.capturedStrings.first {
            returnString = unwrappedString
        } else {
            return nil
        }
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "us")
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = ColorBuilder.maximumFractionDigits
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.decimalSeparator = "."
        
        
        // First thing to do is to convert the color to the Calibrated White ColorSpace.
        
        if let whiteColor = color.colorUsingColorSpace( NSColorSpace.genericGrayColorSpace() ) {
            
            // While it always has an alpha component there may be an extension at a later date that
            // removes it so keep this in there.  It doesn't hurt.
            
            if ( forSearchResult.tcr.numberOfRanges == 3 ) {
                if let modifiedString = processCaptureGroupInSearchResult( forSearchResult, forRangeAtIndex: 2, inText: returnString, withReplacementText: "\(whiteColor.alphaComponent)" ) {
                    returnString = modifiedString
                } else {
                    return nil
                }
            } else if ( whiteColor.alphaComponent < 1.0 ) {
                // User has changed the alpha so we need to add it to the code.
                
                if let modifiedString = processCaptureGroupInSearchResult( forSearchResult, forRangeAtIndex: 2, inText: returnString, withReplacementText: forSearchResult.capturedStrings[2] + ", alpha: \(whiteColor.alphaComponent)" ) {
                    returnString = modifiedString
                } else {
                    return nil
                }
            }
            
            
            if let component = numberFormatter.stringFromNumber( Double ( whiteColor.whiteComponent ) ) {
                if let modifiedString = processCaptureGroupInSearchResult( forSearchResult, forRangeAtIndex: 1, inText: returnString, withReplacementText: component ) {
                    returnString = modifiedString
                } else {
                    return nil
                }
            } else {
                print ( "Error converting white component with value of \(whiteColor.whiteComponent) to a string." )
                return nil
            }
            
            
            return returnString
        }
        
        print ( "Error converting the color to calibrated white colorspace." )
        return nil
        
    }

}
