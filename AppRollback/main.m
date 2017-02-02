#import <UIKit/UIKit.h>
#include <dlfcn.h>

int main(int argc, char * argv[]) {
	@autoreleasepool {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *frameworkPath = [bundle privateFrameworksPath];
		NSLog(@"frameworkPath:%@", frameworkPath);

		BOOL roolback = NO;
		NSString *previousVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFrameworkAsPreviousVersion.framework"];
		NSString *currentVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFramework.framework"];

		if (roolback) {
			BOOL load = [[NSBundle bundleWithPath:previousVersionPath] load];
			NSLog(@"load:%d", load);
		}
		else {
			BOOL load = [[NSBundle bundleWithPath:currentVersionPath] load];
			NSLog(@"load:%d", load);
		}

	    return UIApplicationMain(argc, argv, nil, @"AppDelegate");
	}
}
