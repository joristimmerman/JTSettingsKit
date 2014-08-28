//
//  JTSettingsEditorDelegate.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 25/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
@protocol JTSettingsEditorDelegate<NSObject>
- (void)settingsEditorViewController:(UIViewController *)viewController
         selectedValueChangedToValue:(id)value;
@end
