

#include <vsg/viewer/Window.h>
#include <vsg/viewer/Viewer.h>
#include <vsg/platform/ios/iOS_Window.h>
#import <UIKit/UIKit.h>

#include <vsg/all.h>
using namespace vsg;

//------------------------------------------------------------------------
// Application delegate
//------------------------------------------------------------------------
@interface vsgiOSAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) vsg_iOS_Window *window;
@end


#define LOG(x) std::cout << x << std::endl

const unsigned char frag_PushConstants_spv[] = {0x03,0x02,0x23,0x07,0x00,0x00,0x01,0x00,0x06,0x00,0x08,0x00,0x17,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x11,0x00,0x02,0x00,0x01,0x00,0x00,0x00,0x0b,0x00,0x06,0x00,0x01,0x00,0x00,0x00,0x47,0x4c,0x53,0x4c,0x2e,0x73,0x74,0x64,0x2e,0x34,0x35,0x30,0x00,0x00,0x00,0x00,0x0e,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x0f,0x00,0x08,0x00,0x04,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x6d,0x61,0x69,0x6e,0x00,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x11,0x00,0x00,0x00,0x16,0x00,0x00,0x00,0x10,0x00,0x03,0x00,0x04,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x03,0x00,0x03,0x00,0x02,0x00,0x00,0x00,0xc2,0x01,0x00,0x00,0x04,0x00,0x09,0x00,0x47,0x4c,0x5f,0x41,0x52,0x42,0x5f,0x73,0x65,0x70,0x61,0x72,0x61,0x74,0x65,0x5f,0x73,0x68,0x61,0x64,0x65,0x72,0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x73,0x00,0x00,0x05,0x00,0x04,0x00,0x04,0x00,0x00,0x00,0x6d,0x61,0x69,0x6e,0x00,0x00,0x00,0x00,0x05,0x00,0x05,0x00,0x09,0x00,0x00,0x00,0x6f,0x75,0x74,0x43,0x6f,0x6c,0x6f,0x72,0x00,0x00,0x00,0x00,0x05,0x00,0x05,0x00,0x0d,0x00,0x00,0x00,0x74,0x65,0x78,0x53,0x61,0x6d,0x70,0x6c,0x65,0x72,0x00,0x00,0x05,0x00,0x06,0x00,0x11,0x00,0x00,0x00,0x66,0x72,0x61,0x67,0x54,0x65,0x78,0x43,0x6f,0x6f,0x72,0x64,0x00,0x00,0x00,0x00,0x05,0x00,0x05,0x00,0x16,0x00,0x00,0x00,0x66,0x72,0x61,0x67,0x43,0x6f,0x6c,0x6f,0x72,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x09,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x0d,0x00,0x00,0x00,0x22,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x0d,0x00,0x00,0x00,0x21,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x11,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x16,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x13,0x00,0x02,0x00,0x02,0x00,0x00,0x00,0x21,0x00,0x03,0x00,0x03,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x16,0x00,0x03,0x00,0x06,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x07,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x08,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x08,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x19,0x00,0x09,0x00,0x0a,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1b,0x00,0x03,0x00,0x0b,0x00,0x00,0x00,0x0a,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x0c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0b,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x0c,0x00,0x00,0x00,0x0d,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x0f,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x10,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x0f,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x10,0x00,0x00,0x00,0x11,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x14,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x15,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x15,0x00,0x00,0x00,0x16,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x36,0x00,0x05,0x00,0x02,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0xf8,0x00,0x02,0x00,0x05,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x0b,0x00,0x00,0x00,0x0e,0x00,0x00,0x00,0x0d,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x0f,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x11,0x00,0x00,0x00,0x57,0x00,0x05,0x00,0x07,0x00,0x00,0x00,0x13,0x00,0x00,0x00,0x0e,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x3e,0x00,0x03,0x00,0x09,0x00,0x00,0x00,0x13,0x00,0x00,0x00,0xfd,0x00,0x01,0x00,0x38,0x00,0x01,0x00,};
const unsigned frag_PushConstants_spv_size = sizeof(frag_PushConstants_spv);
const unsigned char vert_PushConstants_spv[] = {0x03,0x02,0x23,0x07,0x00,0x00,0x01,0x00,0x07,0x00,0x08,0x00,0x2e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x11,0x00,0x02,0x00,0x01,0x00,0x00,0x00,0x0b,0x00,0x06,0x00,0x01,0x00,0x00,0x00,0x47,0x4c,0x53,0x4c,0x2e,0x73,0x74,0x64,0x2e,0x34,0x35,0x30,0x00,0x00,0x00,0x00,0x0e,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x0f,0x00,0x0b,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x6d,0x61,0x69,0x6e,0x00,0x00,0x00,0x00,0x0a,0x00,0x00,0x00,0x1a,0x00,0x00,0x00,0x25,0x00,0x00,0x00,0x26,0x00,0x00,0x00,0x2a,0x00,0x00,0x00,0x2c,0x00,0x00,0x00,0x03,0x00,0x03,0x00,0x02,0x00,0x00,0x00,0xc2,0x01,0x00,0x00,0x04,0x00,0x09,0x00,0x47,0x4c,0x5f,0x41,0x52,0x42,0x5f,0x73,0x65,0x70,0x61,0x72,0x61,0x74,0x65,0x5f,0x73,0x68,0x61,0x64,0x65,0x72,0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x73,0x00,0x00,0x05,0x00,0x04,0x00,0x04,0x00,0x00,0x00,0x6d,0x61,0x69,0x6e,0x00,0x00,0x00,0x00,0x05,0x00,0x06,0x00,0x08,0x00,0x00,0x00,0x67,0x6c,0x5f,0x50,0x65,0x72,0x56,0x65,0x72,0x74,0x65,0x78,0x00,0x00,0x00,0x00,0x06,0x00,0x06,0x00,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x67,0x6c,0x5f,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x00,0x05,0x00,0x03,0x00,0x0a,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x06,0x00,0x0e,0x00,0x00,0x00,0x50,0x75,0x73,0x68,0x43,0x6f,0x6e,0x73,0x74,0x61,0x6e,0x74,0x73,0x00,0x00,0x00,0x06,0x00,0x06,0x00,0x0e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x72,0x6f,0x6a,0x65,0x63,0x74,0x69,0x6f,0x6e,0x00,0x00,0x06,0x00,0x06,0x00,0x0e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x6d,0x6f,0x64,0x65,0x6c,0x76,0x69,0x65,0x77,0x00,0x00,0x00,0x05,0x00,0x03,0x00,0x10,0x00,0x00,0x00,0x70,0x63,0x00,0x00,0x05,0x00,0x05,0x00,0x1a,0x00,0x00,0x00,0x69,0x6e,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x00,0x00,0x05,0x00,0x05,0x00,0x25,0x00,0x00,0x00,0x66,0x72,0x61,0x67,0x43,0x6f,0x6c,0x6f,0x72,0x00,0x00,0x00,0x05,0x00,0x04,0x00,0x26,0x00,0x00,0x00,0x69,0x6e,0x43,0x6f,0x6c,0x6f,0x72,0x00,0x05,0x00,0x06,0x00,0x2a,0x00,0x00,0x00,0x66,0x72,0x61,0x67,0x54,0x65,0x78,0x43,0x6f,0x6f,0x72,0x64,0x00,0x00,0x00,0x00,0x05,0x00,0x05,0x00,0x2c,0x00,0x00,0x00,0x69,0x6e,0x54,0x65,0x78,0x43,0x6f,0x6f,0x72,0x64,0x00,0x00,0x48,0x00,0x05,0x00,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0b,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x03,0x00,0x08,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x48,0x00,0x04,0x00,0x0e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x48,0x00,0x05,0x00,0x0e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x23,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x48,0x00,0x05,0x00,0x0e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x48,0x00,0x04,0x00,0x0e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x48,0x00,0x05,0x00,0x0e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x23,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x48,0x00,0x05,0x00,0x0e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x47,0x00,0x03,0x00,0x0e,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x1a,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x25,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x26,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x2a,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x47,0x00,0x04,0x00,0x2c,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x13,0x00,0x02,0x00,0x02,0x00,0x00,0x00,0x21,0x00,0x03,0x00,0x03,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x16,0x00,0x03,0x00,0x06,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x07,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x1e,0x00,0x03,0x00,0x08,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x09,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x09,0x00,0x00,0x00,0x0a,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x15,0x00,0x04,0x00,0x0b,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x2b,0x00,0x04,0x00,0x0b,0x00,0x00,0x00,0x0c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x04,0x00,0x0d,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x1e,0x00,0x04,0x00,0x0e,0x00,0x00,0x00,0x0d,0x00,0x00,0x00,0x0d,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x0f,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x0e,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x0f,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x11,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x0d,0x00,0x00,0x00,0x2b,0x00,0x04,0x00,0x0b,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x18,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x19,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x18,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x19,0x00,0x00,0x00,0x1a,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x2b,0x00,0x04,0x00,0x06,0x00,0x00,0x00,0x1c,0x00,0x00,0x00,0x00,0x00,0x80,0x3f,0x20,0x00,0x04,0x00,0x22,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x24,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x18,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x24,0x00,0x00,0x00,0x25,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x19,0x00,0x00,0x00,0x26,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x17,0x00,0x04,0x00,0x28,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x29,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x28,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x29,0x00,0x00,0x00,0x2a,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x20,0x00,0x04,0x00,0x2b,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x28,0x00,0x00,0x00,0x3b,0x00,0x04,0x00,0x2b,0x00,0x00,0x00,0x2c,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x36,0x00,0x05,0x00,0x02,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0xf8,0x00,0x02,0x00,0x05,0x00,0x00,0x00,0x41,0x00,0x05,0x00,0x11,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x0c,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x0d,0x00,0x00,0x00,0x13,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x41,0x00,0x05,0x00,0x11,0x00,0x00,0x00,0x15,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x0d,0x00,0x00,0x00,0x16,0x00,0x00,0x00,0x15,0x00,0x00,0x00,0x92,0x00,0x05,0x00,0x0d,0x00,0x00,0x00,0x17,0x00,0x00,0x00,0x13,0x00,0x00,0x00,0x16,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x18,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x1a,0x00,0x00,0x00,0x51,0x00,0x05,0x00,0x06,0x00,0x00,0x00,0x1d,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x51,0x00,0x05,0x00,0x06,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x51,0x00,0x05,0x00,0x06,0x00,0x00,0x00,0x1f,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x50,0x00,0x07,0x00,0x07,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x1d,0x00,0x00,0x00,0x1e,0x00,0x00,0x00,0x1f,0x00,0x00,0x00,0x1c,0x00,0x00,0x00,0x91,0x00,0x05,0x00,0x07,0x00,0x00,0x00,0x21,0x00,0x00,0x00,0x17,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x41,0x00,0x05,0x00,0x22,0x00,0x00,0x00,0x23,0x00,0x00,0x00,0x0a,0x00,0x00,0x00,0x0c,0x00,0x00,0x00,0x3e,0x00,0x03,0x00,0x23,0x00,0x00,0x00,0x21,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x18,0x00,0x00,0x00,0x27,0x00,0x00,0x00,0x26,0x00,0x00,0x00,0x3e,0x00,0x03,0x00,0x25,0x00,0x00,0x00,0x27,0x00,0x00,0x00,0x3d,0x00,0x04,0x00,0x28,0x00,0x00,0x00,0x2d,0x00,0x00,0x00,0x2c,0x00,0x00,0x00,0x3e,0x00,0x03,0x00,0x2a,0x00,0x00,0x00,0x2d,0x00,0x00,0x00,0xfd,0x00,0x01,0x00,0x38,0x00,0x01,0x00,};
const unsigned vert_PushConstants_spv_size = sizeof(vert_PushConstants_spv);

vsg::ref_ptr<vsg::Node> createQuad(const vsg::vec3& origin, const vsg::vec3& horizontal,  const vsg::vec3& vertical, vsg::ref_ptr<vsg::Data> sourceData = {})
{

    // set up model transformation node
    auto transform = vsg::MatrixTransform::create(); // VK_SHADER_STAGE_VERTEX_BIT

    // set up vertex and index arrays
    auto vertices = vsg::vec3Array::create(
    {
        origin,
        origin + horizontal,
        origin + horizontal + vertical,
        origin + vertical
    }); // VK_FORMAT_R32G32B32_SFLOAT, VK_VERTEX_INPUT_RATE_INSTANCE, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, VK_SHARING_MODE_EXCLUSIVE

    auto colors = vsg::vec3Array::create(
    {
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f}
    }); // VK_FORMAT_R32G32B32_SFLOAT, VK_VERTEX_INPUT_RATE_VERTEX, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, VK_SHARING_MODE_EXCLUSIVE

    bool top_left = true; // in Vulkan the origin is by default top left.
    float left = 0.0f;
    float right = 1.0f;
    float top = top_left ? 0.0f : 1.0f;
    float bottom = top_left ? 1.0f : 0.0f;
    auto texcoords = vsg::vec2Array::create(
    {
        {left, bottom},
        {right, bottom},
        {right, top},
        {left, top}
    }); // VK_FORMAT_R32G32_SFLOAT, VK_VERTEX_INPUT_RATE_VERTEX, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, VK_SHARING_MODE_EXCLUSIVE

    auto indices = vsg::ushortArray::create(
    {
        0, 1, 2,
        2, 3, 0
    }); // VK_BUFFER_USAGE_INDEX_BUFFER_BIT, VK_SHARING_MODE_EXCLUSIVE

    // setup geometry
    auto drawCommands = vsg::Commands::create();
    drawCommands->addChild(vsg::BindVertexBuffers::create(0, vsg::DataList{vertices, colors, texcoords}));
    drawCommands->addChild(vsg::BindIndexBuffer::create(indices));
    drawCommands->addChild(vsg::DrawIndexed::create(6, 1, 0, 0, 0));

    // add drawCommands to transform
    transform->addChild(drawCommands);

    return transform;
}

struct TouchTrackball : public vsg::Inherit<vsg::Visitor, TouchTrackball>
{
  public:
    struct Viewpoint
    {
        vsg::ref_ptr<vsg::LookAt> lookAt;
        double duration = 0.0;
    };
    /// container that maps key symbol bindings with the Viewpoint that should move the LookAt to when pressed.
    std::map<vsg::KeySymbol, Viewpoint> keyViewpoitMap;

    /// Button mask value used to enable panning of the view, defaults to left mouse button
    vsg::ButtonMask rotateButtonMask = vsg::BUTTON_MASK_1;

    /// Button mask value used to enable panning of the view, defaults to middle mouse button
    vsg::ButtonMask panButtonMask = vsg::BUTTON_MASK_2;

    /// Button mask value used to enable zooming of the view, defaults to right mouse button
    vsg::ButtonMask zoomButtonMask = vsg::BUTTON_MASK_3;

    /// Scale for control how rapidly the view zooms in/out. Positive value zooms in when mouse moved downwards
    double zoomScale = 1.0;

    /// Toggle on/off whether the view should continue moving when the mouse buttons are released while the mouse is in motion.
    bool supportsThrow = true;

    TouchTrackball(vsg::ref_ptr<vsg::Camera> camera, vsg::ref_ptr<vsg::EllipsoidModel> ellipsoidModel = {}) :
        _camera(camera),
        _ellipsoidModel(ellipsoidModel)
    {
        LOG("TouchTrackball ctor");
        _lookAt = dynamic_cast<vsg::LookAt*>(_camera->viewMatrix.get());

        if (!_lookAt)
        {
            // TODO: need to work out how to map the original ViewMatrix to a LookAt and back, for now just fallback to assigning our own LookAt
            _lookAt = new vsg::LookAt;
        }

        clampToGlobe();

        addKeyViewpoint(vsg::KEY_Space, vsg::LookAt::create(*_lookAt), 1.0);
    }

    void clampToGlobe()
    {
        //    std::cout<<"Trackball::clampToGlobe()"<<std::endl;

        if (!_ellipsoidModel) return;

        // get the location of the current lookAt center
        auto location_center = _ellipsoidModel->convertECEFToLatLongAltitude(_lookAt->center);
        auto location_eye = _ellipsoidModel->convertECEFToLatLongAltitude(_lookAt->eye);

        double ratio = location_eye.z / (location_eye.z - location_center.z);
        auto location = _ellipsoidModel->convertECEFToLatLongAltitude(_lookAt->center * ratio + _lookAt->eye * (1.0 - ratio));

        // clamp to the globe
        location.z = 0.0;

        // compute clamped position back in ECEF
        auto ecef = _ellipsoidModel->convertLatLongAltitudeToECEF(location);

        // apply the new clamped position to the LookAt.
        _lookAt->center = ecef;

        double minimum_altitude = 1.0;
        if (location_eye.z < minimum_altitude)
        {
            location_eye.z = minimum_altitude;
            _lookAt->eye = _ellipsoidModel->convertLatLongAltitudeToECEF(location_eye);
            _thrown = false;
        }
    }

    bool withinRenderArea(int32_t x, int32_t y) const
    {
        auto renderArea = _camera->getRenderArea();

        return (x >= renderArea.offset.x && x < static_cast<int32_t>(renderArea.offset.x + renderArea.extent.width)) &&
               (y >= renderArea.offset.y && y < static_cast<int32_t>(renderArea.offset.y + renderArea.extent.height));
    }

    /// compute non dimensional window coordinate (-1,1) from event coords
    vsg::dvec2 ndc(vsg::PointerEvent& event)
    {
        auto renderArea = _camera->getRenderArea();

        double aspectRatio = static_cast<double>(renderArea.extent.width) / static_cast<double>(renderArea.extent.height);
        vsg::dvec2 v(
            (renderArea.extent.width > 0) ? (static_cast<double>(event.x - renderArea.offset.x) / static_cast<double>(renderArea.extent.width) * 2.0 - 1.0) * aspectRatio : 0.0,
            (renderArea.extent.height > 0) ? static_cast<double>(event.y - renderArea.offset.y) / static_cast<double>(renderArea.extent.height) * 2.0 - 1.0 : 0.0);
        return v;
    }

    /// compute trackball coordinate from event coords
    vsg::dvec3 tbc(vsg::PointerEvent& event)
    {
        vsg::dvec2 v = ndc(event);

        double l = length(v);
        if (l < 1.0f)
        {
            double h = 0.5 + cos(l * vsg::PI) * 0.5;
            return vsg::dvec3(v.x, -v.y, h);
        }
        else
        {
            return vsg::dvec3(v.x, -v.y, 0.0);
        }
    }

    void apply(vsg::TouchDownEvent& touchDown)
    {
        LOG("TouchDown");
        vsg::ButtonPressEvent evt;
        evt.mask = vsg::BUTTON_MASK_1;
        evt.handled = false;
        evt.x = touchDown.x;
        evt.y = touchDown.y;
        apply(evt);
    }

    void apply(vsg::TouchUpEvent& touchUp)
    {
        LOG("TouchUp");
        vsg::ButtonReleaseEvent evt;
        evt.mask = vsg::BUTTON_MASK_1;
        evt.handled = false;
        evt.x = touchUp.x;
        evt.y = touchUp.y;
        apply(evt);
    }

    void apply(vsg::TouchMoveEvent& touchMove)
    {
        LOG("TouchMove");
        vsg::MoveEvent evt;
        evt.mask = vsg::BUTTON_MASK_1;
        evt.x = touchMove.x;
        evt.y = touchMove.y;
        evt.handled = false;
        apply(evt);
    }

    void apply(vsg::KeyPressEvent& keyPress)
    {
        if (keyPress.handled || !_lastPointerEventWithinRenderArea) return;

        if (auto itr = keyViewpoitMap.find(keyPress.keyBase); itr != keyViewpoitMap.end())
        {
            _previousTime = keyPress.time;

            setViewpoint(itr->second.lookAt, itr->second.duration);

            keyPress.handled = true;
        }
    }

    void apply(vsg::ButtonPressEvent& buttonPress)
    {
        LOG("ButtonPressedEvt");
        if (buttonPress.handled) return;

        _hasFocus = withinRenderArea(buttonPress.x, buttonPress.y);
        _lastPointerEventWithinRenderArea = _hasFocus;

        if (buttonPress.mask & vsg::BUTTON_MASK_1)
            _updateMode = ROTATE;
        else if (buttonPress.mask & vsg::BUTTON_MASK_2)
            _updateMode = PAN;
        else if (buttonPress.mask & vsg::BUTTON_MASK_3)
            _updateMode = ZOOM;
        else
            _updateMode = INACTIVE;

        if (_hasFocus) buttonPress.handled = true;

        _zoomPreviousRatio = 0.0;
        _pan.set(0.0, 0.0);
        _rotateAngle = 0.0;

        _previousPointerEvent = &buttonPress;
    }

    void apply(vsg::ButtonReleaseEvent& buttonRelease)
    {
        LOG("ButtonReleasedEvt");
        if (supportsThrow) _thrown = _previousPointerEvent && (buttonRelease.time == _previousPointerEvent->time);

        _lastPointerEventWithinRenderArea = withinRenderArea(buttonRelease.x, buttonRelease.y);
        _hasFocus = false;

        _previousPointerEvent = &buttonRelease;
    }

    void apply(vsg::MoveEvent& moveEvent)
    {
        _lastPointerEventWithinRenderArea = withinRenderArea(moveEvent.x, moveEvent.y);

        if (moveEvent.handled || !_hasFocus) return;
        LOG("MoveEvent");

        vsg::dvec2 new_ndc = ndc(moveEvent);
        vsg::dvec3 new_tbc = tbc(moveEvent);

        if (!_previousPointerEvent) _previousPointerEvent = &moveEvent;

        vsg::dvec2 prev_ndc = ndc(*_previousPointerEvent);
        vsg::dvec3 prev_tbc = tbc(*_previousPointerEvent);

    #if 1
        vsg::dvec2 control_ndc = new_ndc;
        vsg::dvec3 control_tbc = new_tbc;
    #else
        vsg::dvec2 control_ndc = (new_ndc + prev_ndc) * 0.5;
        vsg::dvec3 control_tbc = (new_tbc + prev_tbc) * 0.5;
    #endif

        double dt = std::chrono::duration<double, std::chrono::seconds::period>(moveEvent.time - _previousPointerEvent->time).count();
        _previousDelta = dt;

        double scale = 1.0;
        //if (_previousTime > _previousPointerEvent->time) scale = std::chrono::duration<double, std::chrono::seconds::period>(moveEvent.time - _previousTime).count() / dt;
        //    scale *= 2.0;

        _previousTime = moveEvent.time;

        if (moveEvent.mask & rotateButtonMask)
        {
            LOG("rotate");
            _updateMode = ROTATE;

            moveEvent.handled = true;

            vsg::dvec3 xp = cross(normalize(control_tbc), normalize(prev_tbc));
            double xp_len = length(xp);
            if (xp_len > 0.0)
            {
                _rotateAngle = asin(xp_len);
                _rotateAxis = xp / xp_len;

                rotate(_rotateAngle * scale, _rotateAxis);
            }
            else
            {
                _rotateAngle = 0.0;
            }
        }
        else if (moveEvent.mask & panButtonMask)
        {
            _updateMode = PAN;

            moveEvent.handled = true;

            vsg::dvec2 delta = control_ndc - prev_ndc;

            _pan = delta;

            LOG("pan");
            pan(delta * scale);
        }
        else if (moveEvent.mask & zoomButtonMask)
        {
            _updateMode = ZOOM;

            moveEvent.handled = true;

            vsg::dvec2 delta = control_ndc - prev_ndc;

            if (delta.y != 0.0)
            {
                _zoomPreviousRatio = zoomScale * 2.0 * delta.y;
                LOG("zoom");
                zoom(_zoomPreviousRatio * scale);
            }
        }
        else
        {
            LOG("Move doing NOTHING");
        }

        _thrown = false;

        _previousPointerEvent = &moveEvent;
    }

    void apply(vsg::ScrollWheelEvent& scrollWheel)
    {
        if (scrollWheel.handled) return;

        scrollWheel.handled = true;

        zoom(scrollWheel.delta.y * 0.1);
    }

    void apply(vsg::FrameEvent& frame)
    {
        if (_endLookAt)
        {
            double timeSinceOfAnimation = std::chrono::duration<double, std::chrono::seconds::period>(frame.time - _startTime).count();
            if (timeSinceOfAnimation < _animationDuration)
            {
                double r = vsg::smoothstep(0.0, 1.0, timeSinceOfAnimation / _animationDuration);

                if (_ellipsoidModel)
                {
                    auto interpolate = [](const vsg::dvec3& start, const vsg::dvec3& end, double ratio) -> vsg::dvec3 {
                        if (ratio >= 1.0) return end;

                        double length_start = length(start);
                        double length_end = length(end);
                        double acos_ratio = dot(start, end) / (length_start * length_end);
                        double angle = acos_ratio >= 1.0 ? 0.0 : (acos_ratio <= -1.0 ? vsg::PI : acos(acos_ratio));
                        auto cross_start_end = cross(start, end);
                        auto length_cross = length(cross_start_end);
                        if (angle != 0.0 && length_cross != 0.0)
                        {
                            cross_start_end /= length_cross;
                            auto rotation = vsg::rotate(angle * ratio, cross_start_end);
                            vsg::dvec3 new_dir = normalize(rotation * start);
                            return new_dir * vsg::mix(length_start, length_end, ratio);
                        }
                        else
                        {
                            return mix(start, end, ratio);
                        }
                    };

                    auto interpolate_arc = [](const vsg::dvec3& start, const vsg::dvec3& end, double ratio, double arc_height = 0.0) -> vsg::dvec3 {
                        if (ratio >= 1.0) return end;

                        double length_start = length(start);
                        double length_end = length(end);
                        double acos_ratio = dot(start, end) / (length_start * length_end);
                        double angle = acos_ratio >= 1.0 ? 0.0 : (acos_ratio <= -1.0 ? vsg::PI : acos(acos_ratio));
                        auto cross_start_end = cross(start, end);
                        auto length_cross = length(cross_start_end);
                        if (angle != 0.0 && length_cross != 0.0)
                        {
                            cross_start_end /= length_cross;
                            auto rotation = vsg::rotate(angle * ratio, cross_start_end);
                            vsg::dvec3 new_dir = normalize(rotation * start);
                            double target_length = vsg::mix(length_start, length_end, ratio) + (ratio - ratio * ratio) * arc_height * 4.0;
                            return new_dir * target_length;
                        }
                        else
                        {
                            return mix(start, end, ratio);
                        }
                    };

                    double length_center_start = length(_startLookAt->center);
                    double length_center_end = length(_endLookAt->center);
                    double length_center_mid = (length_center_start + length_center_end) * 0.5;
                    double distance_between = length(_startLookAt->center - _endLookAt->center);

                    double transition_length = length_center_mid + distance_between;

                    double length_eye_start = length(_startLookAt->eye);
                    double length_eye_end = length(_endLookAt->eye);
                    double length_eye_mid = (length_eye_start + length_eye_end) * 0.5;

                    double arc_height = (transition_length > length_eye_mid) ? (transition_length - length_eye_mid) : 0.0;

                    _lookAt->eye = interpolate_arc(_startLookAt->eye, _endLookAt->eye, r, arc_height);
                    _lookAt->center = interpolate(_startLookAt->center, _endLookAt->center, r);
                    _lookAt->up = interpolate(_startLookAt->up, _endLookAt->up, r);
                }
                else
                {
                    _lookAt->eye = mix(_startLookAt->eye, _endLookAt->eye, r);
                    _lookAt->center = mix(_startLookAt->center, _endLookAt->center, r);

                    double angle = acos(dot(_startLookAt->up, _endLookAt->up) / (length(_startLookAt->up) * length(_endLookAt->up)));
                    if (angle != 0.0)
                    {
                        auto rotation = vsg::rotate(angle * r, normalize(cross(_startLookAt->up, _endLookAt->up)));
                        _lookAt->up = rotation * _startLookAt->up;
                    }
                    else
                    {
                        _lookAt->up = _endLookAt->up;
                    }
                }
            }
            else
            {
                _lookAt->eye = _endLookAt->eye;
                _lookAt->center = _endLookAt->center;
                _lookAt->up = _endLookAt->up;

                _endLookAt = nullptr;
                _animationDuration = 0.0;
            }
        }
        else if (_thrown)
        {
            double scale = _previousDelta > 0.0 ? std::chrono::duration<double, std::chrono::seconds::period>(frame.time - _previousTime).count() / _previousDelta : 0.0;
            switch (_updateMode)
            {
            case (ROTATE):
                rotate(_rotateAngle * scale, _rotateAxis);
                break;
            case (PAN):
                pan(_pan * scale);
                break;
            case (ZOOM):
                zoom(_zoomPreviousRatio * scale);
                break;
            default:
                break;
            }
        }

        _previousTime = frame.time;
    }

    void rotate(double angle, const vsg::dvec3& axis)
    {
        vsg::dmat4 rotation = vsg::rotate(angle, axis);
        vsg::dmat4 lv = lookAt(_lookAt->eye, _lookAt->center, _lookAt->up);
        vsg::dvec3 centerEyeSpace = (lv * _lookAt->center);

        vsg::dmat4 matrix = inverse(lv) * translate(centerEyeSpace) * rotation * translate(-centerEyeSpace) * lv;

        _lookAt->up = normalize(matrix * (_lookAt->eye + _lookAt->up) - matrix * _lookAt->eye);
        _lookAt->center = matrix * _lookAt->center;
        _lookAt->eye = matrix * _lookAt->eye;

        clampToGlobe();
    }

    void zoom(double ratio)
    {
        vsg::dvec3 lookVector = _lookAt->center - _lookAt->eye;
        _lookAt->eye = _lookAt->eye + lookVector * ratio;

        clampToGlobe();
    }

    void pan(const vsg::dvec2& delta)
    {
        vsg::dvec3 lookVector = _lookAt->center - _lookAt->eye;
        vsg::dvec3 lookNormal = normalize(lookVector);
        vsg::dvec3 upNormal = _lookAt->up;
        vsg::dvec3 sideNormal = cross(lookNormal, upNormal);

        double distance = length(lookVector);
        distance *= 0.25; // TODO use Camera project matrix to guide how much to scale

        if (_ellipsoidModel)
        {
            double scale = distance;
            double angle = (length(delta) * scale) / _ellipsoidModel->radiusEquator();

            if (angle != 0.0)
            {
                vsg::dvec3 globeNormal = normalize(_lookAt->center);
                vsg::dvec3 m = upNormal * (-delta.y) + sideNormal * (delta.x); // compute the position relative to the center in the eye plane
                vsg::dvec3 v = m + lookNormal * dot(m, globeNormal);           // componsate for any tile relative to the globenormal
                vsg::dvec3 axis = normalize(cross(globeNormal, v));            // compute the axis of ratation to map the mouse pan

                vsg::dmat4 matrix = vsg::rotate(-angle, axis);

                _lookAt->up = normalize(matrix * (_lookAt->eye + _lookAt->up) - matrix * _lookAt->eye);
                _lookAt->center = matrix * _lookAt->center;
                _lookAt->eye = matrix * _lookAt->eye;

                clampToGlobe();
            }
        }
        else
        {
            vsg::dvec3 translation = sideNormal * (-delta.x * distance) + upNormal * (delta.y * distance);

            _lookAt->eye = _lookAt->eye + translation;
            _lookAt->center = _lookAt->center + translation;
        }
    }

    void addKeyViewpoint(vsg::KeySymbol key, vsg::ref_ptr<vsg::LookAt> lookAt, double duration)
    {
        keyViewpoitMap[key].lookAt = lookAt;
        keyViewpoitMap[key].duration = duration;
    }

    void addKeyViewpoint(vsg::KeySymbol key, double latitude, double longitude, double altitude, double duration)
    {
        if (!_ellipsoidModel) return;

        auto lookAt = vsg::LookAt::create();
        lookAt->eye = _ellipsoidModel->convertLatLongAltitudeToECEF(vsg::dvec3(latitude, longitude, altitude));
        lookAt->center = _ellipsoidModel->convertLatLongAltitudeToECEF(vsg::dvec3(latitude, longitude, 0.0));
        lookAt->up = normalize(cross(lookAt->center, vsg::dvec3(-lookAt->center.y, lookAt->center.x, 0.0)));

        keyViewpoitMap[key].lookAt = lookAt;
        keyViewpoitMap[key].duration = duration;
    }

    void setViewpoint(vsg::ref_ptr<vsg::LookAt> lookAt, double duration)
    {
        if (!lookAt) return;

        _thrown = false;

        if (duration == 0.0)
        {
            _lookAt->eye = lookAt->eye;
            _lookAt->center = lookAt->center;
            _lookAt->up = lookAt->up;

            _startLookAt = nullptr;
            _endLookAt = nullptr;
            _animationDuration = 0.0;

            clampToGlobe();
        }
        else
        {
            _startTime = _previousTime;
            _startLookAt = vsg::LookAt::create(*_lookAt);
            _endLookAt = lookAt;
            _animationDuration = duration;
        }
    }
protected:
    vsg::ref_ptr<vsg::Camera> _camera;
    vsg::ref_ptr<vsg::LookAt> _lookAt;
    vsg::ref_ptr<vsg::EllipsoidModel> _ellipsoidModel;

    bool _hasFocus = false;
    bool _lastPointerEventWithinRenderArea = false;

    enum UpdateMode
    {
        INACTIVE = 0,
        ROTATE,
        PAN,
        ZOOM
    };
    UpdateMode _updateMode = INACTIVE;
    double _zoomPreviousRatio = 0.0;
    vsg::dvec2 _pan;
    double _rotateAngle = 0.0;
    vsg::dvec3 _rotateAxis;

    vsg::time_point _previousTime;
    vsg::ref_ptr<vsg::PointerEvent> _previousPointerEvent;
    double _previousDelta = 0.0;
    bool _thrown = false;

    vsg::time_point _startTime;
    vsg::ref_ptr<vsg::LookAt> _startLookAt;
    vsg::ref_ptr<vsg::LookAt> _endLookAt;
    double _animationDuration = 0.0;
};

@implementation vsgiOSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    auto mainScreen =[UIScreen mainScreen];
    auto bounds = [mainScreen bounds];
    
#if defined CUBE_CONTROLLER
    { // good code
        self.window = [[UIWindow alloc] initWithFrame:bounds];
        vsg_iOS_ViewController* vc = [[vsg_iOS_ViewController alloc] init];
        self.window.rootViewController = vc;
        self.window.makeKeyAndVisible;
    }
#else
    {
        vsg::ref_ptr<vsg::Viewer> vsgViewer = vsg::Viewer::create();
        vsg::ref_ptr<vsg::WindowTraits> traits = vsg::WindowTraits::create();
        traits->x = bounds.origin.x;
        traits->y = bounds.origin.y;
        traits->width = bounds.size.width;
        traits->height = bounds.size.height;
        self.window = [[vsg_iOS_Window alloc] initWithTraits: traits andVsgViewer: vsgViewer];
        self.window.makeKeyAndVisible;
        vsg::ref_ptr<vsg::Window> vsgWindow = self.window.vsgWindow;
        {
            
            // BEGIN code that should be in the View
            
            VkExtent2D  sz ;
            sz.width = bounds.size.width;
            sz.height = bounds.size.height;
                auto viewport = vsg::ViewportState::create(sz);

                auto perspective = vsg::Perspective::create(60.0, static_cast<double>(sz.width) / static_cast<double>(sz.height), 0.1, 10.0);
                auto eye = vsg::dvec3(0.0, 0.0, 5.0);
                auto center =  vsg::dvec3(0.0, 0.0, 0.0);
                auto up = vsg::dvec3(0.0, 1.0, 0.0);
                auto lookAt = vsg::LookAt::create(eye, center, up);
                vsg::ref_ptr<vsg::Camera> camera = vsg::Camera::create(perspective, lookAt, viewport);
            

            LOG("Ttrackball supposedly with touch is created");
            vsgViewer->addEventHandler(TouchTrackball::create(camera));

            // load shaders from embedded resources :-)
            vsg::ShaderModule::SPIRV spirv;
            spirv.resize(vert_PushConstants_spv_size/sizeof(uint32_t));
            auto spirv_data = reinterpret_cast<unsigned char*>(spirv.data());
            memcpy(spirv_data, vert_PushConstants_spv, vert_PushConstants_spv_size);
            vsg::ref_ptr<vsg::ShaderStage> vertexShader = vsg::ShaderStage::create(VK_SHADER_STAGE_VERTEX_BIT, "main", spirv);

            spirv.resize(frag_PushConstants_spv_size/sizeof(uint32_t));
            spirv_data = reinterpret_cast<unsigned char*>(spirv.data());
            memcpy(spirv_data, frag_PushConstants_spv, frag_PushConstants_spv_size);
            vsg::ref_ptr<vsg::ShaderStage> fragmentShader = vsg::ShaderStage::create(VK_SHADER_STAGE_FRAGMENT_BIT, "main", spirv);
            LOG("SPIRV shaders created");

            if (!vertexShader || !fragmentShader)
            {
                vsg::Exception ex;
                ex.message = "Could not create shaders.";
                LOG( "Could not create shaders.");
                throw ex;
            }




            // set up graphics pipeline
            vsg::DescriptorSetLayoutBindings descriptorBindings
            {
                {0, VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, 1, VK_SHADER_STAGE_FRAGMENT_BIT, nullptr} // { binding, descriptorTpe, descriptorCount, stageFlags, pImmutableSamplers}
            };

            auto descriptorSetLayout = vsg::DescriptorSetLayout::create(descriptorBindings);

            vsg::PushConstantRanges pushConstantRanges
            {
                {VK_SHADER_STAGE_VERTEX_BIT, 0, 128} // projection view, and model matrices, actual push constant calls autoaatically provided by the VSG's DispatchTraversal
            };

            vsg::VertexInputState::Bindings vertexBindingsDescriptions
            {
                VkVertexInputBindingDescription{0, sizeof(vsg::vec3), VK_VERTEX_INPUT_RATE_VERTEX}, // vertex data
                VkVertexInputBindingDescription{1, sizeof(vsg::vec3), VK_VERTEX_INPUT_RATE_VERTEX}, // colour data
                VkVertexInputBindingDescription{2, sizeof(vsg::vec2), VK_VERTEX_INPUT_RATE_VERTEX}  // tex coord data
            };

            vsg::VertexInputState::Attributes vertexAttributeDescriptions
            {
                VkVertexInputAttributeDescription{0, 0, VK_FORMAT_R32G32B32_SFLOAT, 0}, // vertex data
                VkVertexInputAttributeDescription{1, 1, VK_FORMAT_R32G32B32_SFLOAT, 0}, // colour data
                VkVertexInputAttributeDescription{2, 2, VK_FORMAT_R32G32_SFLOAT, 0},    // tex coord data
            };

            vsg::GraphicsPipelineStates pipelineStates
            {
                vsg::VertexInputState::create( vertexBindingsDescriptions, vertexAttributeDescriptions ),
                        vsg::InputAssemblyState::create(),
                        vsg::RasterizationState::create(),
                        vsg::MultisampleState::create(),
                        vsg::ColorBlendState::create(),
                        vsg::DepthStencilState::create()
            };

            auto pipelineLayout = vsg::PipelineLayout::create(vsg::DescriptorSetLayouts{descriptorSetLayout}, pushConstantRanges);
            auto graphicsPipeline = vsg::GraphicsPipeline::create(pipelineLayout, vsg::ShaderStages{vertexShader, fragmentShader}, pipelineStates);
            auto bindGraphicsPipeline = vsg::BindGraphicsPipeline::create(graphicsPipeline);

            // BEGIN code that I believe should be in the widget
            auto textureData = vsg::vec4Array2D::create(1, 1, vsg::Data::Layout{VK_FORMAT_R32G32B32A32_SFLOAT});
            textureData->set(0, 0, vsg::vec4(1.0f, 1.0f, 0.5f, 1.0f));

            // create texture image and associated DescriptorSets and binding

            auto texture = vsg::DescriptorImage::create(vsg::Sampler::create(), textureData, 0, 0, VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER);

            auto descriptorSet = vsg::DescriptorSet::create(descriptorSetLayout, vsg::Descriptors{texture});
            auto bindDescriptorSets = vsg::BindDescriptorSets::create(VK_PIPELINE_BIND_POINT_GRAPHICS, pipelineLayout, 0, vsg::DescriptorSets{descriptorSet});

            auto rootNode = vsg::StateGroup::create();



            { // DO NOT DELETE THIS BECAUSE IN AN EXTREME CASE THIS WILL SHOW SOMETHING (just comment it out when you don't need it)
                auto origin = vsg::vec3(0.0, 0.0, 2.0);
                auto horizontal = vsg::vec3(1, 0.0, 0.0);
                auto vertical = vsg::vec3(0.0, 1.0, 0.0);
                rootNode->addChild(createQuad( origin, horizontal, vertical));

            }
    //        {
    //            auto widget = new Widget;
    //            widget->setGeometry(Rectangle2dF(Point2dF({0,0}), Point2dF({1,1})));
    //            _rootWidget = widget;
    //        }
            vsg::ref_ptr<vsg::CommandGraph> commandGraph;
            try
            {
                commandGraph = vsg::createCommandGraphForView(vsgWindow, camera, rootNode);
                LOG("vulkan command graph is created");
            }
            catch (vsg::Exception& vsgEx)
            {
                (void)vsgEx;
        #if __OS__LINUX__
                if (vsgEx.result == VK_ERROR_INVALID_EXTERNAL_HANDLE)
                {
                    LOG("Failed initializing vulkan device. Since you are in Linux, perhaps you'll need to run 'apt install mesa-vulkan-drivers' or similar..");
                    return 1;
                }
                throw;
        #endif
            }
            vsgViewer->assignRecordAndSubmitTaskAndPresentation({commandGraph});


    //        // assign a CloseHandler to the Viewer to respond to pressing Escape or press the window close button
    //        viewer->addEventHandlers({CloseHandler::create(this)});

            // flag this as dirty so compile gets called
//            update();


        }
    }
#endif
 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
          return UIApplicationMain(argc, argv, nil, @"vsgiOSAppDelegate");
    }
}
	
