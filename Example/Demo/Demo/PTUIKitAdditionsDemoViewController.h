//
//  PTUIKitAdditionsDemoViewController.h
//  Demo
//
//  Created by Ryne Cheow on 3/23/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import UIKit;

@interface PTUIKitAdditionsDemoViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *sampleColorView;

@property (weak, nonatomic) IBOutlet UISlider *lightenSlider;
@property (weak, nonatomic) IBOutlet UITextField *hexStringTextField;

@end
