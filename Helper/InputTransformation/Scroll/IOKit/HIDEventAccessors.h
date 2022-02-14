//
//  HIDEventAccessors.h
//

//
// DO NOT EDIT THIS FILE. IT IS AUTO-GENERATED
//

#ifndef HIDEventAccessors_h
#define HIDEventAccessors_h

#import <Foundation/Foundation.h>
#import "HIDEvent.h" /* <HID/HIDEvent.h> */

typedef uint32_t IOHIDGenericGestureType;
typedef uint8_t IOHIDEventColorSpace;

NS_ASSUME_NONNULL_BEGIN

@interface HIDEvent (HIDVendorDefinedEvent)

+ (instancetype)vendorDefinedEvent:(uint64_t)timestamp usagePage:(uint16_t)usagePage usage:(uint16_t)usage version:(uint32_t)version data:(uint8_t *)data length:(uint32_t)length options:(uint32_t)options;

@end

@interface HIDEvent (HIDTemperatureEvent)

+ (instancetype)temperatureEvent:(uint64_t)timestamp level:(double)level options:(uint32_t)options;

@end

@interface HIDEvent (HIDAccelerometerEvent)

+ (instancetype)accelerometerEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

@end

@interface HIDEvent (HIDGenericGestureEvent)

+ (instancetype)genericGestureEvent:(uint64_t)timestamp gestureType:(IOHIDGenericGestureType)gestureType options:(uint32_t)options;

@end

@interface HIDEvent (HIDAmbientLightSensorEvent)

+ (instancetype)ambientLightSensorEvent:(uint64_t)timestamp level:(uint32_t)level options:(uint32_t)options;

@end

@interface HIDEvent (HIDPowerEvent)

@end

@interface HIDEvent (HIDForceEvent)

+ (instancetype)forceEvent:(uint64_t)timestamp behavior:(uint32_t)behavior progress:(double)progress stage:(uint32_t)stage stageProgress:(double)stageProgress options:(uint32_t)options;

@end

@interface HIDEvent (HIDMotionGestureEvent)

+ (instancetype)motionGestureEvent:(uint64_t)timestamp gestureType:(uint32_t)gestureType progress:(double)progress options:(uint32_t)options;

@end

@interface HIDEvent (HIDGameControllerEvent)

+ (instancetype)gameControllerEvent:(uint64_t)timestamp controllerType:(uint32_t)controllerType options:(uint32_t)options;

@end

@interface HIDEvent (HIDDigitizerEvent)

+ (instancetype)digitizerEvent:(uint64_t)timestamp transducerType:(uint32_t)transducerType x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

+ (instancetype)tiltDigitizerEvent:(uint64_t)timestamp x:(double)x y:(double)y options:(uint32_t)options;

+ (instancetype)polarDigitizerEvent:(uint64_t)timestamp altitude:(double)altitude azimuth:(double)azimuth quality:(double)quality density:(double)density majorRadius:(double)majorRadius minorRadius:(double)minorRadius options:(uint32_t)options;

+ (instancetype)qualityDigitizerEvent:(uint64_t)timestamp quality:(double)quality density:(double)density irregularity:(double)irregularity majorRadius:(double)majorRadius minorRadius:(double)minorRadius accuracy:(double)accuracy options:(uint32_t)options;

@end

@interface HIDEvent (HIDCompassEvent)

+ (instancetype)compassEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

@end

@interface HIDEvent (HIDMotionActivityEvent)

+ (instancetype)motionActivityEvent:(uint64_t)timestamp activityType:(uint32_t)activityType confidence:(double)confidence options:(uint32_t)options;

@end

@interface HIDEvent (HIDBrightnessEvent)

+ (instancetype)brightnessEvent:(uint64_t)timestamp currentBrightness:(double)currentBrightness targetBrightness:(double)targetBrightness transitionTime:(uint64_t)transitionTime options:(uint32_t)options;

@end

@interface HIDEvent (HIDGyroEvent)

+ (instancetype)gyroEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

@end

@interface HIDEvent (HIDButtonEvent)

+ (instancetype)buttonEvent:(uint64_t)timestamp buttonMask:(uint32_t)buttonMask options:(uint32_t)options;

@end

@interface HIDEvent (HIDAtmosphericPressureEvent)

+ (instancetype)atmosphericPressureEvent:(uint64_t)timestamp level:(double)level sequence:(uint32_t)sequence options:(uint32_t)options;

@end

@interface HIDEvent (HIDHumidityEvent)

@end

@interface HIDEvent (HIDScrollEvent)

+ (instancetype)scrollEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

@end

@interface HIDEvent (HIDBiometricEvent)

+ (instancetype)biometricEvent:(uint64_t)timestamp eventType:(uint32_t)eventType level:(double)level options:(uint32_t)options;

@end

@interface HIDEvent (HIDLEDEvent)

+ (instancetype)ledEvent:(uint64_t)timestamp ledMask:(uint32_t)ledMask number:(uint8_t)number state:(uint32_t)state options:(uint32_t)options;

@end

@interface HIDEvent (HIDOrientationEvent)

+ (instancetype)polarOrientationEvent:(uint64_t)timestamp radius:(double)radius azimuth:(double)azimuth altitude:(double)altitude options:(uint32_t)options;

+ (instancetype)quaternionOrientationEvent:(uint64_t)timestamp w:(double)w x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

+ (instancetype)tiltOrientationEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z options:(uint32_t)options;

@end

@interface HIDEvent (HIDProximityEvent)

+ (instancetype)proximityEvent:(uint64_t)timestamp detectionMask:(uint32_t)detectionMask options:(uint32_t)options;

@end

@interface HIDEvent (HIDKeyboardEvent)

+ (instancetype)keyboardEvent:(uint64_t)timestamp usagePage:(uint16_t)usagePage usage:(uint16_t)usage down:(uint32_t)down options:(uint32_t)options;

@end

@interface HIDEvent (HIDPointerEvent)

+ (instancetype)pointerEvent:(uint64_t)timestamp x:(double)x y:(double)y z:(double)z buttonMask:(uint32_t)buttonMask options:(uint32_t)options;

@end

NS_ASSUME_NONNULL_END

#endif /* HIDEventAccessors_h */

