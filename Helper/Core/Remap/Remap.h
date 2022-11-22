//
// --------------------------------------------------------------------------
// Remap.h
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2020
// Licensed under the MMF License (https://github.com/noah-nuebling/mac-mouse-fix/blob/master/LICENSE)
// --------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#import "ButtonInputReceiver.h"
#import "WannabePrefixHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Remap : NSObject

@property (class, readonly) BOOL addModeIsEnabled;

+ (NSDictionary * _Nullable)modificationsWithModifiers:(NSDictionary *)modifiers MF_SWIFT_HIDDEN;
+ (id _Nullable)__SWIFT_UNBRIDGED_modificationsWithModifiers:(id)modifiers;

+ (void)reload;

+ (NSDictionary *)remaps MF_SWIFT_HIDDEN;
+ (id)__SWIFT_UNBRIDGED_remaps;

+ (void)enableAddMode;
+ (void)disableAddMode;
+ (void)concludeAddModeWithPayload:(NSDictionary *)payload MF_SWIFT_HIDDEN;
+ (void)__SWIFT_UNBRIDGED_concludeAddModeWithPayload:(id)payload;

@end

NS_ASSUME_NONNULL_END