//
//  PremiseData.h
//  Table
//
//  Created by Renato Casanova on 4/28/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ArchiveKind {
    archiveKindFolder = 0,
    archiveKindTextFile = 1,
    };

@interface PremiseData : NSObject

@property (nonatomic) NSNumber * archiveKind;
@property (nonatomic) NSString * archiveName;
@property (nonatomic) NSMutableArray * folderContent;


//+(PremiseData*)newFolder:(NSString*)folderName;
//+(PremiseData*)newTextFile:(NSString*)fileName;
//-(id)initWithNewArchive:(NSString*)archiveName AsKind:(NSNumber*)kind WithContents:(NSMutableArray*)contents;
//-(id)initWithNewFile:(NSString *)archiveName AsKind:(NSNumber *)kind;

@end
