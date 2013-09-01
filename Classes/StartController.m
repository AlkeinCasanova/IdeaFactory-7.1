//
//  StartController.m
//  Table
//
//  Created by Renato Casanova on 6/26/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "StartController.h"
#import "PremiseController.h"


@interface StartController ()

@end

@implementation StartController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [NSTimer timerWithTimeInterval:3 target:self selector:@selector(presentStuff) userInfo:nil repeats:NO];
//    [self.iOutlet setAlpha:0];
//    [self.fOutlet setAlpha:0];
    [UIView animateWithDuration:1 animations:^{
        [self.viewF setCenter:CGPointMake(230, self.viewF.center.y)];
        [self.viewI setCenter:CGPointMake(80,  self.viewI.center.y)];


        [self.viewF setAlpha:1];
        [self.viewI setAlpha:1];
        

    }completion:^(BOOL finished)
     {
         [self performSelector:@selector(presentStuff) withObject:nil afterDelay:2];

     }];

	// Do any additional setup after loading the view.
}
-(void)presentStuff
{

    PremiseController * prem = [self.storyboard instantiateViewControllerWithIdentifier:@"factoryController"];
    [self presentViewController:prem animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
