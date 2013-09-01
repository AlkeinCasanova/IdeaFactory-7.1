//
//  FolderCell.h
//  Table
//
//  Created by Renato Casanova on 6/7/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FolderCellProtocol <NSObject>

-(void)didSelectListCellAtIndexPath:(NSIndexPath*)indexPath;
-(void)didDeselectListCellAtIndexPath:(NSIndexPath*)indexPath;


@end
@interface FolderCell : UITableViewCell

@end
