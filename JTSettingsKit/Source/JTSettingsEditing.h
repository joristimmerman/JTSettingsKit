//
//  JTSettingsEditing.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 24/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
#import "JTSettingsEditorDelegate.h"
@class JTSettingsGroup;
@protocol JTSettingsEditing<NSObject>

@property(nonatomic) JTSettingsGroup *settingsGroup;
@property(nonatomic) NSString *settingsKey;
@property(nonatomic) id selectedValue;

@property(nonatomic) NSDictionary *data;
@property (nonatomic, weak) id<JTSettingsEditorDelegate> delegate;

@end
