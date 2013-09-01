//
//  NSFileManager+myBWFileManagementAdditions.h
//  Premise
//
//  Created by Renato Casanova on 5/4/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinderControllerProtocols.h"

@interface NSFileManager (myBWFileManagementAdditions)


//-(NSMutableArray*)enumerateDirectoryURLsFromURL:(NSURL*)url;
-(NSMutableArray*)enumerateDirectoryComponentsFromURL:(NSURL*)url;

-(NSMutableArray *)parseTextFileAt:(NSURL*)url;
//-(NSMutableDictionary*)parseAllTextFileAt:(NSURL*)url;

-(id)readDataOfClass:(Class)class FromURL:(NSURL*)url;
-(BOOL)saveData:(id)data ToURL:(NSURL*)url;


-(NSMutableArray* )iterateForBranchInTree:(NSMutableArray*)branchOfBools atDepthLevel:(NSArray*)depth;
-(NSMutableArray* )iterateBoolsTree:(NSMutableArray*)branchOfBools ToUpdateBranch:(NSMutableArray*)newBranch  atDepthLevel:(NSArray*)depth;
-(NSMutableArray *)iterateThroughTreeWhileParsingSelectedTextFiles:(NSArray*)currentBranch AtDepth:(NSURL*)depth;
- (NSMutableArray*)iterateThroughRootHierarchyWhileUpdatingRootArchives:(NSURL*)url WithDepth:(NSMutableArray*)depth AndDelegate:(id <FinderArchiveReferenceProtocol>)referenceDelegate;

-(void)updateReferencesOfRootFile:(NSMutableArray*)rootFile atURL:(NSURL*)url shouldAnimateRows:(UITableView*)tableView  withDepth:(NSMutableArray*)depth AndDelegate:(id <FinderArchiveReferenceProtocol>)referenceDelegate;

-(void)resetLocalizedDataBase;
-(void)resetLocalizedFactory;
@end

@interface NSMutableArray (differenceBetweenArrays)

+(NSMutableArray *)objectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile;
+(NSMutableArray*)indexesOfObjectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile;

@end

@interface NSURL (myBWFileManagementAdditions)

+(NSURL*)URLsetUpFrom:(NSString*)afterBundle;
@end

@interface NSMutableDictionary (KeyManipulation)


-(void)exchangeOldKey:(NSString*)oldKey WithNewKey:(NSString*)newKey;

@end