//
//  JTSettingsContainerViewController.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 25/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
#import "JTSettingsGroup.h"

@protocol JTSettingsViewControllerDelegate;
@interface JTSettingsViewController : UINavigationController
@property id<JTSettingsViewControllerDelegate> settingDelegate;

@property BOOL autoStoreValuesInUserDefaults;

- (id)initWithSettingsVisualizerClass:(Class)settingsViewControllerClass;

- (NSUInteger) numSettingsGroups;

- (void)addSettingsGroup:(JTSettingsGroup *)group;
- (void)addSettingsGroup:(JTSettingsGroup *)group at:(NSUInteger)index;
- (void)removeSettingsGroup:(JTSettingsGroup *)group;

- (JTSettingsGroup *) settingsGroupAtIndex:(NSUInteger) index;

- (void)setTitle:(NSString *)title forGroupAt:(NSUInteger)groupIndex;

- (void)setFooter:(NSString *)title forGroupAt:(NSUInteger)groupIndex;

- (void)reloadSettingForKey:(NSString *)key inGroupAt:(NSUInteger)groupIndex;

@end

@protocol JTSettingsViewControllerDelegate<NSObject>

@optional

- (void)settingsViewController:(JTSettingsViewController *)settingsViewController
    valueChangedForSettingWithKey:(NSString *)key
                          toValue:(id)value;

- (NSString *)descriptionForValue:(id)value forKey:(NSString *)key;

- (NSDictionary *)settingsViewController:(JTSettingsViewController *)settingsViewController
    dataForSettingEditorDataForSettingKey:(NSString *)key;
@end
