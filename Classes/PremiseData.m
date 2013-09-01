//
//  PremiseData.m
//  Table
//
//  Created by Renato Casanova on 4/28/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "PremiseData.h"
#import "AlertStrings.h"
#define keyFileName @"file"
#define keyBoolSelection @"bool"
#define keySelecterBools @"selecterBools"
@implementation PremiseData
- (id)initWithFileName:(NSString *)fileName OfKind:(enum ArchiveKind)kind
{
    self = [super init];
    if (self) {
        _archiveName = [fileName copy];
        _archiveKind = [NSNumber numberWithInt:kind];
        _folderContent = [NSMutableArray array];
        
    }
    return self;
}
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        _fileName = [aDecoder decodeObjectForKey:keyFileName];
//        _isSelectedFile = [aDecoder decodeBoolForKey:keyBoolSelection];
//        _selecterBools = [aDecoder decodeObjectForKey:keySelecterBools];
//    }
//    return self;
//}
//-(id)initWithFileName:(NSString *)fileName
//{
//    self = [super init];
//    if (self) {
//        _isSelectedFile = NO;
//        _fileName =fileName;
//        _selecterBools = [NSMutableArray array];
//    }
//    return self;
//}
//
//
//-(void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.fileName forKey:keyFileName];
//    
//    [aCoder encodeBool:self.isSelectedFile forKey:keyBoolSelection];
//    [aCoder encodeObject:self.selecterBools forKey:keySelecterBools];
//    
//}


@end
