//
//  RGBHexMacroSeeker.swift
//  ColorSenseRainbow
//
//  Created by yohunl on 16/3/3.
//  Copyright © 2016年 Northern Realities Inc. All rights reserved.
//
//NSColorHexFromRGB(0x620f2f);
//UIColorHexFromRGBAlpha(0x622848,0.6);
//UIColorWithHex(0xc81fa3)
//NSColor(red: 2, green: 2, blue: 3, alpha: 0.2);
//NSColor(hexString: "0x620f2f")
//NSColor(hexString: "#620f2f")
//UIColor( red: 143.0/255, green: 87.0/255.0, blue: 233.0/255.0, alpha: 1.0 )
//UIColor( red: 227.3/255, green: 183.5/255.0, blue: 180.1/255.0, alpha: 1.0 )
import AppKit

class RGBHexMacroSeeker: Seeker {
    override init () {
        super.init()
        
        var error : NSError?
        
        var regex: NSRegularExpression?
        
        do {
            regex = try NSRegularExpression ( pattern: "(UI|NS)ColorHexFromRGB\\(\\s*(0[xX][0-9a-fA-F]{6})\\s*\\)", options: [])
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
        
        if regex == nil {
            print ( "Error creating OC with hex marco regex = \(error?.localizedDescription)" )
        } else {
            regexes.append( regex! )
        }
        
        do {
            regex = try NSRegularExpression ( pattern: "(UI|NS)ColorWithHex\\(\\s*(0[xX][0-9a-fA-F]{6})\\s*\\)", options: [])
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
        
        if regex == nil {
            print ( "Error creating OC with hex marco regex = \(error?.localizedDescription)" )
        } else {
            regexes.append( regex! )
        }
        
        
        
        do {
            regex = try NSRegularExpression ( pattern: "(UI|NS)ColorHexFromRGBAlpha\\(\\s*(0[xX][0-9a-fA-F]{6})\\s*,\\s*([01]\\.?[0-9]*f?)\\s*\\)", options: [])
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
        
        if regex == nil {
            print ( "Error creating OC with hex marco regex = \(error?.localizedDescription)" )
        } else {
            regexes.append( regex! )
        }
        
        
        
        
    }
    
    
    override func processMatch ( match : NSTextCheckingResult, line : String ) -> SearchResult? {
        
        if ( ( match.numberOfRanges == 3)) {
            let alphaValue : CGFloat = 1.0
            
            let matchString = stringFromRange( match.range, line: line )
            let hexString = stringFromRange( match.rangeAtIndex( 2 ), line: line )
            let capturedStrings = [ matchString, hexString ]
            
            var color = NSColor ( hexString: hexString )
            
            if ( alphaValue != 1.0 ) {
                color = color.colorWithAlphaComponent( alphaValue )
            }
            
            var searchResult = SearchResult ( color: color, textCheckingResult: match, capturedStrings: capturedStrings )
            searchResult.creationType = .RGBHexMacro
            searchResult.language = .ObjectiveC
            return searchResult
        }
        else if ( ( match.numberOfRanges == 4)) {
            var alphaValue : CGFloat = 1.0
            
            let matchString = stringFromRange( match.range, line: line )
            let hexString = stringFromRange( match.rangeAtIndex( 2 ), line: line )
            var capturedStrings = [ matchString, hexString ]
            
            let alphaString = stringFromRange( match.rangeAtIndex( 3 ), line: line )
            alphaValue = CGFloat ( (alphaString as NSString).doubleValue )
            capturedStrings.append( alphaString )

            
            var color = NSColor ( hexString: hexString )
            
            if ( alphaValue != 1.0 ) {
                color = color.colorWithAlphaComponent( alphaValue )
            }
            
            var searchResult = SearchResult ( color: color, textCheckingResult: match, capturedStrings: capturedStrings )
            searchResult.creationType = .RGBHexMacro
            searchResult.language = .ObjectiveC
            return searchResult
        }
        
        return nil
    }

}
