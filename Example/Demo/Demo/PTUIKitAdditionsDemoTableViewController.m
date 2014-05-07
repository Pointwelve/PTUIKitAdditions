//
//  PTUIKitAdditionsDemoTableViewController.m
//  Demo
//
//  Created by Kok Hong on 5/7/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "PTUIKitAdditionsDemoTableViewController.h"
#import <PTUIKitAdditions/PTUIKitAdditions.h>

@interface PTUIKitAdditionsDemoTableViewController ()
{
@private
    UIColor *_originalColor;
}
@end

@implementation PTUIKitAdditionsDemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[@"ffffff" toColor]];
    _originalColor = [[self demoView] backgroundColor];
    self.hexStringTextField.delegate = self;
 
    self.sampleImage = [UIImage imageNamed:@"sunflower.jpg"];
    
    [self detectDevice];
    [self initRoundedImage];
    [self initNormalImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - UIColor+PTUIKitAddition Example

- (IBAction)lightenSliderChanged:(UISlider *)sender
{
    [[self demoView] setBackgroundColor:[_originalColor lightenColorByValue:sender.value]];
}

- (IBAction)darkenSliderChanged:(UISlider *)sender
{
    [[self demoView] setBackgroundColor:[_originalColor darkenColorByValue:sender.value]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.demoView setBackgroundColor:[textField.text toColor]];
    _originalColor = [[self demoView] backgroundColor];
    return YES;
}

#pragma - UIDevice+PTUIKitAddition Example
- (void)detectDevice
{
    // to check isSimulator
    if ([[UIDevice currentDevice] isSimulator])
    {
        [[self deviceLabel] setText:@"Simulator"];
    }
    
    // to check is legacy
    else if ([[UIDevice currentDevice] isLegacy])
    {
        [[self deviceLabel] setText:@"iPhone/iPod"];
    }
    
    // get ios version
    [[self iosVersionLabel] setText:@([UIDevice iosVersion]).stringValue];
}

#pragma - UIImage+PTUIKitAddition Example

-(void)initRoundedImage
{
    [self.roundedImageView setImage:[self.sampleImage roundedCornerImage:200 borderSize:100]];
}

-(void)initNormalImage
{
    [self.imageView setImage:self.sampleImage];
}

- (IBAction)screenShotAction:(id)sender
{
    [self.screenShotImageView setImage:[UIImage screenshot]];
}
- (IBAction)normalImageAction:(id)sender
{
    [self.imageView setImage:self.sampleImage];
}

- (IBAction)applyDarkAction:(id)sender
{
    [self.imageView setImage:[self.sampleImage applyDarkEffect]];
}

- (IBAction)applyLightAction:(id)sender
{
    [self.imageView setImage:[self.sampleImage applyLightEffect]];
}

- (IBAction)applyExtraLightAction:(id)sender
{
    [self.imageView setImage:[self.sampleImage applyExtraLightEffect]];
}

- (IBAction)applyMediumLightAction:(id)sender
{
    [self.imageView setImage:[self.sampleImage applyMediumLightEffect]];
}

@end
