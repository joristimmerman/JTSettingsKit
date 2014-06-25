JTSettingsKit
=============

Settings kit to easily build custom settings views in an iOS app.

Currently available settings types:
 - Switch
 - Option list

 (More in development)

Usage example:
--------------
This example will create 2 sections with 1 setting each.

```objc
-(void) setup {
    JTSettingsViewController *settingsController = [[JTSettingsViewController alloc] init];
    settingsController.delegate = self;
    settingsController.title = @"Settings";
    
    // create a group (one is required)
    JTSettingsGroup *generalGroup = [[JTSettingsGroup alloc] initWithTitle:@"General Settings"];
    
    //add a setting to the generalGroup
    [generalGroup addOptionForType:JTSettingsOptionTypeSwitch
                             label:@"On/Off Switch"
                forUserDefaultsKey:@"OnOff"
                         withValue:[NSNumber numberWithBool:YES]
                           options:nil];
    
    // create a new section: Camera
    JTSettingsGroup *cameraGroup = [[JTSettingsGroup alloc] initWithTitle:@"Camera"];
    
    // Add a select setting (selection of 1 item in a list)
    [cameraGroup addOptionForType:JTSettingsOptionTypeMultiValue
                            label:@"Video resolutions"
               forUserDefaultsKey:@"VideoResolutions"
                        withValue:@"high"
                          options:nil];
    
    [settingsController addSettingsGroup:generalGroup];
    
    [self presentViewController:settingsController animated:YES completion:nil];
}

- (NSArray *)settingsViewController: (JTSettingsViewController *)settingsViewController 
           optionsForSettingWithKey:(NSString *)key {
    
    if([key isEqualToString:@"VideoResolutions"]){
        return @[@"high", @"medium", @"low"];
    }
    
	return nil;
}

- (void)settingsViewController:(JTSettingsViewController *)settingsViewController 
 valueChangedForSettingWithKey:(NSString *)key toValue:(id)value{
    NSLog(@"Setting with key %@ changed to %@", key, value);
    // update your model
}

- (NSString *)descriptionForValue:(id)value forKey:(NSString *)key{
	// return human readable text for an option
    return [NSString stringWithFormat:@"Setting %@", value];
}
```