//
//  FinderControllerProtocols.h
//  Table
//
//  Created by Renato Casanova on 6/20/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>
//Navigation Protocol
@protocol FinderNavigationProtocol <NSObject>

-(BOOL)shouldDismissPresentedViewControllerAndSetNewTextTo:(NSString *)newName fromOlfName:(NSString *)oldName AndIsMovingRows:(BOOL)isMoving;
@end

//Archive Protocol
@protocol FinderArchiveReferenceProtocol <NSObject>

-(void)finderControllerWantsToCorroborateNewArchivesAtDepth:(NSArray *)depthLevel ComparedWithArchiveReferences:(NSArray *)references;
-(void)finderControllerWantsToCorroborateDeletedArchivesAtDepth:(NSArray*)depthLevel ComparedWithArchiveReferences:(NSArray *)references;

-(void)finderControllerWantsToCreateNewArchiveReference:(NSArray*)refrence AtDepth:(NSArray*)depthLevel;
-(void)finderControllerWantsToDeleteArchiveReferences:(NSArray*)indexPaths AtDepth:(NSArray*)depthLevel;

-(void)finderControllerMovedArchiveFrom:(NSIndexPath*)fromPath ToIndexPath:(NSIndexPath*)toIndexPath AtDepth:(NSMutableArray*)depthLevel;
//-(NSMutableArray *)finderControllerWantsToCorroborateBranchAtDepth:(NSArray *)depthLevel;

@end
