//
// --------------------------------------------------------------------------
// PointerSpeed2.m
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2021
// Licensed under MIT
// --------------------------------------------------------------------------
//

/// The original PointerSpeed.m was getting a little long and confusing, so we created this


#import "PointerSpeed.h"
#import <IOKit/hidsystem/IOHIDEventSystemClient.h>
#import <IOKit/hidsystem/IOHIDServiceClient.h>
#import "WannabePrefixHeader.h"
#import "IOUtility.h"


@implementation PointerSpeed

#pragma mark - External declarations

/*!
 * @typedef HIDEventSystemClientType
 *
 * @abstract
 * Enumerator of HIDEventSystemClient types.
 *
 * @field HIDEventSystemClientTypeAdmin
 * Admin client will receive blanket access to all HIDEventSystemClient API,
 * and will receive events before monitor/rate controlled clients. This client
 * type requires entitlement 'com.apple.private.hid.client.admin', and in
 * general should not be used.
 *
 * @field HIDEventSystemClientTypeMonitor
 * Client type used for receiving HID events from the HID event system. Requires
 * entitlement 'com.apple.private.hid.client.event-monitor'.
 *
 * @field HIDEventSystemClientTypePassive
 * Client type that does not require any entitlements, but may not receive HID
 * events. Passive clients can be used for querying/setting properties on
 * HID services.
 *
 * @field HIDEventSystemClientTypeRateControlled
 * Client type used for receiving HID events from the HID event system. This is
 * similar to the monitor client, except rate controlled clients have the
 * ability to set the report and batch interval for the services they are
 * monitoring. Requires entitlement 'com.apple.private.hid.client.event-monitor'.
 *
 * @field HIDEventSystemClientTypeSimple
 * Public client type used by third parties. Simple clients do not have the
 * ability to monitor events, and have a restricted set of properties on which
 * they can query/set on a HID service.
 */
typedef NS_ENUM(NSInteger, HIDEventSystemClientType) {
    /// src: ~/Documents/Projekte/Programmieren/Xcode/Xcode Projekte/Mac Mouse Fix/Other/IOKit source code (19.06.2021)/IOHIDFamily-1633.100.36/HID/HIDEventSystemClient.h
    HIDEventSystemClientTypeAdmin,
    HIDEventSystemClientTypeMonitor,
    HIDEventSystemClientTypePassive,
    HIDEventSystemClientTypeRateControlled,
    HIDEventSystemClientTypeSimple
};

/// src: Saw this being used around the IOHIDFamily source code
extern IOHIDEventSystemClientRef IOHIDEventSystemClientCreateWithType(CFAllocatorRef allocator,
                                                                      HIDEventSystemClientType clientType,
                                                                      CFDictionaryRef _Nullable attributes);
/// src: I forgot
extern IOHIDServiceClientRef IOHIDEventSystemClientCopyServiceForRegistryID(IOHIDEventSystemClientRef client, uint64_t entryID);

#pragma mark - Set sensitivity

static void printServiceClientInfo(IOHIDServiceClientRef serviceClient) {
    
    uint64_t serviceClientRegistryID = ((__bridge NSNumber *)IOHIDServiceClientGetRegistryID(serviceClient)).longLongValue;
    CFMutableDictionaryRef serviceClientMatchingDict = IORegistryEntryIDMatching(serviceClientRegistryID);
    io_service_t serviceClientService = IOServiceGetMatchingService(kIOMasterPortDefault, serviceClientMatchingDict);
    
    /// Get IORegistry path
    
    char serviceClientPath[1000];
    IORegistryEntryGetPath(serviceClientService, kIOServicePlane, serviceClientPath);
    /// ^ This makes the program crash after the function returns for some reason. Seems to be a stack overflow
    /// After enabling Address Sanitizer it presents itself as EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
    /// After enabling NSZombies there's a stack-buffer-overflow when printing serviceClientPath with DDLogDebug. Doesn't matter if we cast to NSString and use %@ or print using %s.
    /// If we comment out DDLogDebug, we get the old error after the function returns.
    /// When allocating 1000 characters for the serviceClientPath array, the crash disappears!
    /// But then why was is also crashing when we used got serviceClientProperties? ... Now it doesn't do that anymore.
    
    /// Get properties
    
    CFMutableDictionaryRef serviceClientProperties = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    IORegistryEntryCreateCFProperties(serviceClientService, &serviceClientProperties, kCFAllocatorDefault, 0);
    
    DDLogDebug(@"ServiceClientInfo: \n%@", (__bridge NSDictionary *)serviceClientProperties);
    
    CFRelease(serviceClientProperties);
}

+ (void)setSensitivityTo:(int)sensitivity onDevice:(IOHIDDeviceRef)dev {
    /// More info on what we're doing here in [PointerSpeed + setSensitivityTo:onDevice:]
    /// And in the header comment of [PointerSpeed + newSetSensitivityViaIORegTo:device:]
    
    /// Testing stuff
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        /// Get event system client
        
        DDLogDebug(@"BEGIN SERVICE LOGGING");
        
        IOHIDEventSystemClientRef eventSystemClient = IOHIDEventSystemClientCreateWithType(kCFAllocatorDefault, HIDEventSystemClientTypePassive, NULL);
        
        if (YES) {
            /// Test 3:
            /// Refined version of Test 2. See Test 2 for explanation
            
            io_service_t IOHIDDeviceService = IOHIDDeviceGetService(dev);
            io_service_t interfaceService = [IOUtility getChildOfRegistryEntry:IOHIDDeviceService withName:@"IOHIDInterface"];
            io_service_t driverService = [IOUtility getChildOfRegistryEntry:interfaceService withName:@"AppleUserHIDEventDriver"];
            
            /// Get ID
            uint64_t driverServiceID;
            IORegistryEntryGetRegistryEntryID(driverService, &driverServiceID);
            IOHIDServiceClientRef serviceClient = IOHIDEventSystemClientCopyServiceForRegistryID(eventSystemClient, driverServiceID);
            
            /// Print info
            printServiceClientInfo(serviceClient); /// It seems to work! this logs the right thing!
            
        }
        
        if ((NO)) {
            /// Test 2
            /// Get the serviceClient for my mouse directly from the IOHIDDeviceRef
            /// This approach almost works, but doesn't, because the paths obtained by IOHIDDeviceGetService() and IOHIDEventSystemClientCopyServices() don't match. See below.
            
            /// Get registryEntryID for IOHIDDeviceRef
            /// Get service
            io_service_t IOHIDDeviceService = IOHIDDeviceGetService(dev);
            /// Print info on IOHIDDeviceService
            char IOHIDDeviceServicePath[100];
            IORegistryEntryGetPath(IOHIDDeviceService, kIOServicePlane, IOHIDDeviceServicePath);
            DDLogDebug(@"IOHIDDeviceServicePath: %s", IOHIDDeviceServicePath);
            
            /// Get ID
            uint64_t IOHIDDeviceServiceID;
            IORegistryEntryGetRegistryEntryID(IOHIDDeviceService, &IOHIDDeviceServiceID);
            /// Get serviceClient
            /// This doesn't work. It seems the IOService returned by IOHIDDeviceGetService() is not the one which corresponds to a serviceClient
            /// Edit: Yes that theory was correct.
            /// Path obtained via IOHIDEventSystemClientCopyServices()
            ///     IOService:/IOResources/IOHIDResource/IOHIDResourceDeviceUserClient/IOHIDUserDevice/IOHIDInterface/AppleUserHIDEventDriver
            /// Path obtained via IOHIDDeviceGetService()
            ///     IOService:/IOResources/IOHIDResource/IOHIDResourceDeviceUserClient/IOHIDUserDevice
            IOHIDServiceClientRef serviceClient = IOHIDEventSystemClientCopyServiceForRegistryID(eventSystemClient, IOHIDDeviceServiceID);
            
//            printServiceClientInfo(serviceClient);
        }
        
        
        if (NO) {
            /// Test 1
            /// Copy all services of the eventSystemClient to get an overview
            /// Conclusion:
            /// - There is only one serviceClient provided by the eventSystemClient that relates to my mouse. (Logitech M720 attached via Bluetooth)
            /// - The registryPath of the IOService derived from that serviceClient is
            ///  IOService:/IOResources/IOHIDResource/IOHIDResourceDeviceUserClient/IOHIDUserDevice/IOHIDInterface/AppleUserHIDEventDriver

            CFArrayRef serviceClients = IOHIDEventSystemClientCopyServices(eventSystemClient);
            for (id serviceClientUntyped in (__bridge NSArray *)serviceClients) {
                
                IOHIDServiceClientRef serviceClient = (__bridge IOHIDServiceClientRef)serviceClientUntyped;
                
                printServiceClientInfo(serviceClient);
            }
        }
        
        DDLogDebug(@"END SERVICE LOGGING");
    });

}

@end
