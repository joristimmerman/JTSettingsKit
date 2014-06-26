//
//  JTSettingsContainerViewController.m
//  JTSettingsKit
//
//  Created by Joris Timmerman on 25/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//

#import "JTSettingsViewController.h"
#import "JTSettingsTableViewController.h"
#import "JTSettingsCell.h"

@interface JTSettingsViewController () <JTSettingsVisualizerDelegate, JTSettingsEditorDelegate>{
	NSMutableArray *_settingGroups;
    UIViewController<JTSettingsVisualizing> *settingsController;
}

@end

@implementation JTSettingsViewController

-(id) initWithSettingsVisualizerClass:(Class) settingsViewControllerClass {
    self = [super init];
    if(self){
        if(settingsController != nil){
            
            if (![settingsViewControllerClass conformsToProtocol:@protocol(JTSettingsVisualizing)] ||
                ![settingsViewControllerClass isSubclassOfClass:[UIViewController class]]) {
                [NSException
                 raise:@"Invalid class."
                 format:@"Invalid class passed to init function, given class %@ is not a %@ and/or does not implement the protocol %@",
                 NSStringFromClass(settingsViewControllerClass),
                 NSStringFromClass([UIViewController class]),
                 NSStringFromProtocol(@protocol(JTSettingsVisualizing))];
            }
            
            settingsController = (UIViewController<JTSettingsVisualizing> *)[[settingsViewControllerClass alloc] init];
        }else{
            settingsController = [[JTSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        }
        settingsController.delegate = self;
        _autoStoreValuesInUserDefaults = NO;
        [self addChildViewController:settingsController];

    }
    return self;
}

- (id)init
{
    self = [self initWithSettingsVisualizerClass:nil];
    return self;
}

- (void)setTitle:(NSString *)title forGroupAt:(NSUInteger)index {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
	if (group) {
		group.title = title;
	}
}

- (void)setFooter:(NSString *)footer forGroupAt:(NSUInteger)index {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
	if (group) {
		group.footer = footer;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)addSettingsGroup:(JTSettingsGroup *)group {
	[self addSettingsGroup:group at:_settingGroups.count];
}

- (void)addSettingsGroup:(JTSettingsGroup *)group at:(NSUInteger)index {
	if (!_settingGroups) {
		_settingGroups = [NSMutableArray array];
	}
    
	[_settingGroups insertObject:group atIndex:index];
	[settingsController reload];
}

- (void)addSettingWithType:(JTSettingType)settingType
                   toGroup:(JTSettingsGroup *)group
                 withLabel:(NSString *)label
                    forKey:(NSString *)key
                 withValue:(id)value
                   options:(NSDictionary *)optionsOrNil {
	
    [group addSettingWithType:settingType
                        label:label
           forUserDefaultsKey:key
                    withValue:value
                      options:optionsOrNil];
    
    
	[settingsController reload];
}

#pragma mark - table delegate 

-(NSUInteger) numberOfGroups {
    return _settingGroups.count;
}

-(NSUInteger) numberOfSettingsInGroupAt:(NSUInteger) index {
    JTSettingsGroup *grp = [_settingGroups objectAtIndex:index];
    if(grp){
        return [grp count];
    }
    return 0;
}

-(NSString *) titleForGroupAt:(NSUInteger) index {
    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
    
	if (group) {
		return [group title];
	}
    return nil;
}

-(NSString *) footerForGroupAt:(NSUInteger) index {
    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
    
	if (group) {
		return [group footer];
	}
    
    return nil;
}

-(NSString *) settingKeyForSettingAt:(NSUInteger) index inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [self groupAtIndex:groupIndex];
    if(group){
        return [group keyOfSettingAt:index];
    }
    return nil;
}

-(BOOL) shouldSelectSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex{
    JTSettingsGroup *group = [self groupAtIndex:groupIndex];
    if(group){
        return [group hasEditorForSettingWithKey:key];
    }
    return NO;
}

-(UIViewController<JTSettingsEditing>*) editorForSettingWithKey:(NSString *)key inGroupAt:(NSUInteger)groupIndex {

    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:groupIndex];
    
	if (group) {
		UIViewController<JTSettingsEditing> *editor = [group editorForSettingWithKey:key];
        
        if(editor){
            editor.settingsGroup = group;
            editor.settingsKey = key;
            
            NSDictionary *editorData= nil;
            if([self.settingDelegate respondsToSelector:@selector(settingsViewController:dataForSettingEditorDataForSettingKey:)]){
                editorData = [self.settingDelegate settingsViewController:self dataForSettingEditorDataForSettingKey:key];
            }
            editor.data = editorData;
            editor.selectedValue = [group settingValueForSettingWithKey:key];
            
            editor.delegate = self;
            
            return editor;
        }
	}
    
    return nil;
}

-(NSString *) settingLabelForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingLabelForSettingWithKey:key];
    }
    return nil;
}

-(JTSettingType) settingTypeForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingTypeForSettingWithKey:key];
    }
    return JTSettingTypeCustom;
}

-(id) selectedDataForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex{
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingValueForSettingWithKey:key];
    }
    return nil;
}

-(NSString *) selectedDataDescriptionForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        id value = [group settingValueForSettingWithKey:key];
        if ([self.settingDelegate respondsToSelector:@selector(descriptionForValue:forKey:)]) {
            return [self.settingDelegate descriptionForValue:value forKey:key];
        }
    }
    return nil;
}

- (JTSettingsGroup *)groupAtIndex:(NSUInteger)groupIndex {
	return (JTSettingsGroup *)[_settingGroups objectAtIndex:groupIndex];
}

-(void)cellValueChangedForSettingWithKey:(NSString *)key toValue:(id)value inGroupAt:(NSUInteger)groupIndex {
    JTSettingsGroup *group = [self groupAtIndex:groupIndex];
    [self updateSettingWithKey:key inGroup:group toValue:value];
}

#pragma mark - SettingsOptionsViewControllerDelegate
- (void)settingsEditorViewController:(UIViewController<JTSettingsEditing> *) viewController selectedValueChangedToValue:(id)value {

    [self updateSettingWithKey:viewController.settingsKey
                       inGroup:viewController.settingsGroup
                       toValue:value];
    
}

- (void)updateSettingWithKey:(NSString *)key inGroup:(JTSettingsGroup*)group toValue:(id)value {
    [group updateSettingValue:value forSettingWithKey:key];
    
    if (self.autoStoreValuesInUserDefaults) {
		JTSettingType settingType = [group settingTypeForSettingWithKey:key];
		switch (settingType) {
			case JTSettingTypeSwitch:
				[[NSUserDefaults standardUserDefaults] setBool:[(NSNumber *)value boolValue] forKey:key];
				break;
                
			default:
				[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
				break;
		}
        
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

    NSUInteger cellIndex = [group indexForKey:key];
    NSUInteger groupIndex = [_settingGroups indexOfObject:group];
    if(cellIndex != NSNotFound && groupIndex != NSNotFound){
        [settingsController reloadItemAt:cellIndex inGroupAt:groupIndex];
    }
}


@end
