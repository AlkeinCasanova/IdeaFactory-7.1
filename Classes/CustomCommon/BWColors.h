//
//  BWColors.h
//  Table
//
//  Created by Renato Casanova on 6/3/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>

#define hexColor(hexValue) (UIColor*)[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define rgb(r,g,b) (UIColor*)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define UIColorFrom255RGB(red,green,blue) (UIColor*)[UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:1.0]

#define UIColorFromHexRGB(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


//*** Primary Color:

#define kColorPButton  0x4F10AD // rgb(79,16,173)
#define kColorPBackGround  0x4D2982  //rgb(77,41,130)
#define kColorPContext  0x300571  //rgb(48,5,113)
#define kColorPSuplement 0x7F44D6  //rgb(127,68,214)
#define kColorPWeak  0x966BD6  //rgb(150,107,214)
/*
 BUtton Colors
 86
 55
 194
 */

//*** Complementary Color:
//
#define kColorYButton   0xFFE500
#define kColorYBackGround 0xBFB130
#define kColorYContext  0xA69500
#define kColorYSuplemnt 0xFFEC40
#define kColorYWeak     0xFFF173 
//


