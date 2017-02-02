#import <UIKit/UIKit.h>
#include <dlfcn.h>

int main(int argc, char * argv[]) {
	@autoreleasepool {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *frameworkPath = [bundle privateFrameworksPath];
		BOOL roolback = NO;
		NSString *previousVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFrameworkAsPreviousVersion.framework"];
		NSString *currentVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFramework.framework"];

		if (roolback) {
			[[NSBundle bundleWithPath:previousVersionPath] load];
		}
		else {
			[[NSBundle bundleWithPath:currentVersionPath] load];
		}

	    return UIApplicationMain(argc, argv, nil, @"AppDelegate");
	}
}
