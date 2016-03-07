//
//  RGBMacroSeeker.swift
//  ColorSenseRainbow
//
//  Created by yohunl on 16/3/7.
//  Copyright © 2016年 Northern Realities Inc. All rights reserved.
//
/*
#define ColorA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Color(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ColorS(a)       [FDDModel stringToColor:a]
Color(123,233,234)
ColorA(222,213,123,0.3)
ColorS(@"0x123456")
ColorS(@"123456")
ColorS(@"#123456")
*/
import AppKit

class RGBMacroSeeker: Seeker {
    override init () {
        super.init()
        
        var error : NSError?
        
        var regex: NSRegularExpression?
        
        do {
            regex = try NSRegularExpression ( pattern: "ColorA\\(\\s*([0-9]*\\.?[0-9]*f?)\\s*,\\s*([0-9]*\\.?[0-9]*f?)\\s*,\\s*([0-9]*\\.?[0-9]*f?)\\s*,\\s*([0-9]*\\.?[0-9]*f?)\\s*\\)", options: [])
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
            regex = try NSRegularExpression ( pattern: "Color\\(\\s*([0-9]*\\.?[0-9]*f?)\\s*,\\s*([0-9]*\\.?[0-9]*f?)\\s*,\\s*([0-9]*\\.?[0-9]*f?)\\s*\\)", options: [])
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
            regex = try NSRegularExpression ( pattern: "ColorS\\(\\s*@\"((0x|0X|#)?[0-9a-fA-F]{6})\"\\s*\\)", options: [])
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
        
        if regex == nil {
            print ( "Error creating OC with hex marco regex = \(error?.localizedDescription)" )
        } else {
            regexes.append( regex! )
        }
        
       // "(?:NS|UI)Color\\s*\\(\\s*hexString:\\s*\"#?([0-9a-fA-F]{6})\"\\s*\\)"
        
    }
    
    
    override func processMatch ( match : NSTextCheckingResult, line : String ) -> SearchResult? {
        
        if ( ( match.numberOfRanges == 4) || (match.numberOfRanges == 5)) {
            var alphaValue : CGFloat = 1.0
            
            let matchString = stringFromRange( match.range, line: line )
            let redString = stringFromRange( match.rangeAtIndex( 1 ), line: line )
            let greenString = stringFromRange( match.rangeAtIndex( 2 ), line: line )
            let blueString = stringFromRange( match.rangeAtIndex( 3 ), line: line )
            var capturedStrings = [ matchString, redString, greenString, blueString ]
            
            if ( match.numberOfRanges == 5 ) {
                let alphaString = stringFromRange( match.rangeAtIndex( 4 ), line: line )
                
                alphaValue = CGFloat ( ( alphaString as NSString).doubleValue )
                capturedStrings.append( alphaString )
            }
            
            
            let redValue = CGFloat ( ( redString as NSString).doubleValue )
            let greenValue = CGFloat ( ( greenString as NSString).doubleValue )
            let blueValue = CGFloat ( ( blueString as NSString).doubleValue )
            
            let color = NSColor ( red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue )
            
            var searchResult = SearchResult ( color: color, textCheckingResult: match, capturedStrings: capturedStrings )
            searchResult.creationType = .RGBMacro
            return searchResult
        }
        else if ( ( match.numberOfRanges == 3)) {
            
            let matchString = stringFromRange( match.range, line: line )
            let hexString = stringFromRange( match.rangeAtIndex( 1 ), line: line )
            
            let capturedStrings = [ matchString, hexString ]

            
            let color = NSColor ( hexString: hexString )
            
            var searchResult = SearchResult ( color: color, textCheckingResult: match, capturedStrings: capturedStrings )
            searchResult.creationType = .RGBMacro
            return searchResult
        }

        
        
        return nil
    }

}
