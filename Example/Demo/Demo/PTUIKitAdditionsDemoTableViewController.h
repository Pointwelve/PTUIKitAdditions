//
//  PTUIKitAdditionsDemoTableViewController.h
//  Demo
//
//  Created by Kok Hong on 5/7/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTUIKitAdditionsDemoTableViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *demoView;
@property (weak, nonatomic) IBOutlet UITextField *hexStringTextField;
@property (weak, nonatomic) IBOutlet UIImageView *roundedImageView;
@property (weak, nonatomic) UIImage *sampleImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *iosVersionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *screenShotImageView;

@end
