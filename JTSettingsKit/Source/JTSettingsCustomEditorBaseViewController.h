//
//  JTSettingsCustomEditorBaseViewController.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 25/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
#import "JTSettingsEditing.h"
#import "JTSettingsEditorDelegate.h"

@interface JTSettingsCustomEditorBaseViewController : UIViewController<JTSettingsEditing>
@property(nonatomic) JTSettingsGroup *settingsGroup;
@property(nonatomic) NSString *settingsKey;
@property(nonatomic) id selectedValue;

@property(nonatomic) NSDictionary *data;
@property id<JTSettingsEditorDelegate> delegate;
@end
