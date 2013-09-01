//
//  SelecterCell.h
//  Table
//
//  Created by Renato Casanova on 4/28/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelecterProtocol <NSObject>

-(void)didSelectListCellAtIndexPath:(NSIndexPath*)indexPath fromTableView:(UITableView*)tableView;
-(void)didDeselectListCellAtIndexPath:(NSIndexPath*)indexPath fromTableView:(UITableView*)tableView;


@end
@interface SelecterCell : UITableViewCell

@property (nonatomic) BOOL selectedCell;
@property (nonatomic,assign) id <SelecterProtocol> delegate;

-(void)activateImagesForSelectedState:(BOOL)selected;

@end
