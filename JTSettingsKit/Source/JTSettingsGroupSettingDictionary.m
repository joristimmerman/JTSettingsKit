//
//  SettingsGroupSettingDictionary.h
//  JTSettingsEditor
//
//  Created by Joris Timmerman on 20/02/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "JTSettingsGroupSettingDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent) {
  NSString *objectString;
  if ([object isKindOfClass:[NSString class]]) {
    objectString = (NSString *)object;
  } else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
    objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
  } else if ([object respondsToSelector:@selector(descriptionWithLocale:)]) {
    objectString = [(NSSet *)object descriptionWithLocale:locale];
  } else {
    objectString = [object description];
  }
  return objectString;
}

@implementation JTSettingsGroupSettingDictionary

- (id)init {
  return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity {
  self = [super init];
  if (self != nil) {
    dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    array = [[NSMutableArray alloc] initWithCapacity:capacity];
  }
  return self;
}

- (id)copy {
  return [self mutableCopy];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
  if (![dictionary objectForKey:aKey]) {
    [array addObject:aKey];
  }
  [dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
  [dictionary removeObjectForKey:aKey];
  [array removeObject:aKey];
}

- (NSUInteger)count {
  return [dictionary count];
}

- (id)objectForKey:(id)aKey {
  return [dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
  return [array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator {
  return [array reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
  if ([dictionary objectForKey:aKey]) {
    [self removeObjectForKey:aKey];
  }
  [array insertObject:aKey atIndex:anIndex];
  [dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex {
  return [array objectAtIndex:anIndex];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
  NSMutableString *indentString = [NSMutableString string];
  NSUInteger i, count = level;
  for (i = 0; i < count; i++) {
    [indentString appendFormat:@"    "];
  }

  NSMutableString *description = [NSMutableString string];
  [description appendFormat:@"%@{\n", indentString];
  for (NSObject *key in self) {
    [description appendFormat:@"%@    %@ = %@;\n", indentString,
                              DescriptionForObject(key, locale, level),
                              DescriptionForObject([self objectForKey:key], locale, level)];
  }
  [description appendFormat:@"%@}\n", indentString];
  return description;
}

@end
