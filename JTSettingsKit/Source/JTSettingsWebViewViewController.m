//
//  JTSettingsWebViewViewController.m
//  JTSettingsKit
//
//  Created by Joris Timmerman on 18/12/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//

#import "JTSettingsWebViewViewController.h"

@interface JTSettingsWebViewViewController () <UIWebViewDelegate>
{
	UIWebView *_webView;
	UIActivityIndicatorView *_spinner;
	
	NSArray *spinnerConstraints;
}
@end

@implementation JTSettingsWebViewViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_webView = [[UIWebView alloc] init];
	_webView.translatesAutoresizingMaskIntoConstraints = NO;
	_webView.delegate = self;
	_webView.hidden = YES;
	_webView.alpha = 0;
	
	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_spinner.translatesAutoresizingMaskIntoConstraints = NO;
	_spinner.hidesWhenStopped = YES;
	
	[self.view addSubview:_webView];
	[self.view addSubview:_spinner];
	
	[self setLayoutConstraints];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSURL *url  = (NSURL *) [self.settingsGroup settingValueForSettingWithKey:self.settingsKey];
	[_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void) setLayoutConstraints {
	spinnerConstraints = @[[NSLayoutConstraint constraintWithItem:_spinner
														attribute:NSLayoutAttributeCenterX
														relatedBy:NSLayoutRelationEqual
																	toItem:self.view attribute:NSLayoutAttributeCenterX
																multiplier:1 constant:0],
									
									[NSLayoutConstraint constraintWithItem:_spinner
																 attribute:NSLayoutAttributeCenterY
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.view attribute:NSLayoutAttributeCenterY
																multiplier:1 constant:0]
									];
	
	[self.view addConstraints:spinnerConstraints];
	[self.view addConstraints:@[
								
								
								[NSLayoutConstraint constraintWithItem:_webView
															 attribute:NSLayoutAttributeLeft
															 relatedBy:NSLayoutRelationEqual
																toItem:self.view
															 attribute:NSLayoutAttributeLeft
															multiplier:1 constant:0],
								
								[NSLayoutConstraint constraintWithItem:_webView
															 attribute:NSLayoutAttributeRight
															 relatedBy:NSLayoutRelationEqual
																toItem:self.view
															 attribute:NSLayoutAttributeRight
															multiplier:1 constant:0],
								
								[NSLayoutConstraint constraintWithItem:_webView
															 attribute:NSLayoutAttributeTop
															 relatedBy:NSLayoutRelationEqual
																toItem:self.view
															 attribute:NSLayoutAttributeTop
															multiplier:1 constant:0],
								
								[NSLayoutConstraint constraintWithItem:_webView
															 attribute:NSLayoutAttributeBottom
															 relatedBy:NSLayoutRelationEqual
																toItem:self.view
															 attribute:NSLayoutAttributeBottom
															multiplier:1 constant:0],
								]];
	
	[self.view layoutIfNeeded];
}

-(void) stopSpinning {
	[_spinner stopAnimating];
	
	[self.view removeConstraints:spinnerConstraints];
	spinnerConstraints = nil;
	
	[_spinner removeFromSuperview];
	_spinner = nil;
}

-(void) showErrorAlert:(NSError *) error {
	if ([UIAlertController class])
	{
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
																	   message:nil
																preferredStyle:UIAlertControllerStyleAlert];
		
		//action
		[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel
												handler:^(__unused UIAlertAction *action) {
													[self.navigationController popViewControllerAnimated:YES];
												}]];
		
		[self presentViewController:alert animated:YES completion:NULL];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
														message:nil
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
	}
}

#pragma mark - WebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self stopSpinning];
	webView.hidden = NO;
	
	[UIView animateWithDuration:0.3 animations:^{
		webView.alpha = 1;
	}];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self stopSpinning];
	[self showErrorAlert:error];
}

@end
