#include <UIKit/UIKit.h>

#ifndef CUBE_CONTROLLER
#include <vsg/viewer/WindowTraits.h>
#include <vsg/viewer/Window.h>
#endif

#pragma mark -
#pragma mark vsg_iOS_View
@interface vsg_iOS_View : UIView
@end


#pragma mark -
#pragma mark vsg_iOS_ViewController
@interface vsg_iOS_ViewController : UIViewController
#ifndef CUBE_CONTROLLER
@property vsg::ref_ptr<vsg::Window> vsgWindow;
- (instancetype)initWithTraits:(vsg::ref_ptr<vsg::WindowTraits>)traits andVsgViewer:(vsg::ref_ptr<vsg::Viewer>) vsgViewer;
#endif
@end

