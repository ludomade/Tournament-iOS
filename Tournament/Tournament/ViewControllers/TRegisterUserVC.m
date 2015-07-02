//
//  TRegisterUserVC.m
//  Tournament
//
//  Created by Eugene Heckert on 6/23/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TRegisterUserVC.h"
#import <Parse/Parse.h>

@interface TRegisterUserVC ()

@end

@implementation TRegisterUserVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) validateUserInformation
{
    if(self.userNameTextField.text.length <= 0)
    {
        return NO;
    }
    
    NSString* emailStr = self.emailTextField.text;
    
    if (emailStr.length > 0)
    {
        NSRange range = [emailStr rangeOfString:@"@"];
        
        if (range.location == NSNotFound || range.location == 0 || range.location == emailStr.length - 1)
        {
            
            DLog(@"Invalied Email Address!");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email"
//                                                            message:[NSString stringWithFormat:@"%@ is not a valid email. Please try again.", emailStr]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid email" message:[NSString stringWithFormat:@"%@ is not a valid email. Please try again.", emailStr] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                           }];
            
            [alert addAction:deleteAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return NO;
            
        }
    }
    
    if(![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        return NO;
    }
    
    if(self.passwordTextField.text.length < 6)
    {
        return NO;
    }
    
    return YES;
}

- (IBAction)onRegisterAccount:(id)sender
{
    if([self validateUserInformation])
    {
        PFUser* newUser = [PFUser user];
        
        newUser.username = self.userNameTextField.text;
        newUser.password = self.passwordTextField.text;
        newUser.email = self.emailTextField.text;
        
#ifdef DEBUG
        newUser[@"challongeAPIKey"] = @"WIiseZtSUiYjYLz6dpCfCQO0TkeFjgX5SYjHGIdE";
#endif
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (!error)
            {
                // Hooray! Let them use the app now.
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action)
                                               {
                                               }];
                
                [alert addAction:deleteAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

- (IBAction)onCancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.userNameTextField)
    {
        [self.emailTextField becomeFirstResponder];
    }
    else
    if(textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    if(textField == self.passwordTextField)
    {
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else
    if(textField == self.confirmPasswordTextField)
    {
        [self onRegisterAccount:nil];
    }
    
    return YES;
}

@end
