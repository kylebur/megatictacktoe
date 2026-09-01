import os
import uuid

def make_project():
    proj_dir = "MegaTicTacToe.xcodeproj"
    xcshared_dir = os.path.join(proj_dir, "xcshareddata", "xcschemes")
    os.makedirs(xcshared_dir, exist_ok=True)

    # IDs
    id_proj = "100000000000000000000001"
    id_main_group = "100000000000000000000002"
    id_products_group = "100000000000000000000003"
    id_app_group = "100000000000000000000004"
    id_ext_group = "100000000000000000000005"

    # App Target (Messages Application Wrapper)
    id_app_target = "200000000000000000000001"
    id_app_product = "200000000000000000000002"
    id_app_sources_phase = "200000000000000000000003"
    id_app_frameworks_phase = "200000000000000000000004"
    id_app_resources_phase = "200000000000000000000005"
    id_app_embed_ext_phase = "200000000000000000000006"
    id_app_build_config_list = "200000000000000000000007"
    id_app_debug_config = "200000000000000000000008"
    id_app_release_config = "200000000000000000000009"

    # Extension Target (Messages Extension with UI & Engine)
    id_ext_target = "300000000000000000000001"
    id_ext_product = "300000000000000000000002"
    id_ext_sources_phase = "300000000000000000000003"
    id_ext_frameworks_phase = "300000000000000000000004"
    id_ext_resources_phase = "300000000000000000000005"
    id_ext_embed_icons_phase = "300000000000000000000010"
    id_ext_build_config_list = "300000000000000000000007"
    id_ext_debug_config = "300000000000000000000008"
    id_ext_release_config = "300000000000000000000009"

    # Target Dependency & Container Item Proxy
    id_container_proxy = "400000000000000000000001"
    id_target_dependency = "400000000000000000000002"
    id_embed_ext_build_file = "400000000000000000000003"

    # Local Swift Package Reference
    id_pkg_ref = "500000000000000000000001"
    id_pkg_product_ext = "500000000000000000000003"
    id_pkg_build_file_ext = "500000000000000000000005"

    # Project Build Configs
    id_proj_build_config_list = "600000000000000000000001"
    id_proj_debug_config = "600000000000000000000002"
    id_proj_release_config = "600000000000000000000003"

    # Files
    id_file_app_plist = "700000000000000000000005"
    id_file_app_assets = "700000000000000000000006"
    id_build_app_assets = "700000000000000000000007"

    id_file_ext_messages_vc = "800000000000000000000001"
    id_build_ext_messages_vc = "800000000000000000000002"
    id_file_ext_plist = "800000000000000000000003"
    id_file_ext_assets = "800000000000000000000004"
    id_build_ext_assets = "800000000000000000000005"

    pbxproj = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
		{id_build_app_assets} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {id_file_app_assets} /* Assets.xcassets */; }};
		{id_build_ext_messages_vc} /* MessagesViewController.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {id_file_ext_messages_vc} /* MessagesViewController.swift */; }};
		{id_build_ext_assets} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {id_file_ext_assets} /* Assets.xcassets */; }};
		{id_pkg_build_file_ext} /* MegaTicTacToeCore in Frameworks */ = {{isa = PBXBuildFile; productRef = {id_pkg_product_ext} /* MegaTicTacToeCore */; }};
		{id_embed_ext_build_file} /* MegaTicTacToeMessagesExtension.appex in Embed App Extensions */ = {{isa = PBXBuildFile; fileRef = {id_ext_product} /* MegaTicTacToeMessagesExtension.appex */; settings = {{ATTRIBUTES = (RemoveHeadersOnCopy, ); }}; }};
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		{id_container_proxy} /* PBXContainerItemProxy */ = {{
			isa = PBXContainerItemProxy;
			containerPortal = {id_proj} /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = {id_ext_target};
			remoteInfo = MegaTicTacToeMessagesExtension;
		}};
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
		{id_app_embed_ext_phase} /* Embed App Extensions */ = {{
			isa = PBXCopyFilesBuildPhase;
			buildActionMask = 2147483647;
			dstPath = "";
			dstSubfolderSpec = 13;
			files = (
				{id_embed_ext_build_file} /* MegaTicTacToeMessagesExtension.appex in Embed App Extensions */,
			);
			name = "Embed App Extensions";
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
		{id_app_product} /* MegaTicTacToe.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = MegaTicTacToe.app; sourceTree = BUILT_PRODUCTS_DIR; }};
		{id_ext_product} /* MegaTicTacToeMessagesExtension.appex */ = {{isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = MegaTicTacToeMessagesExtension.appex; sourceTree = BUILT_PRODUCTS_DIR; }};
		{id_file_app_plist} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
		{id_file_app_assets} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};
		{id_file_ext_messages_vc} /* MessagesViewController.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/MessagesViewController.swift; sourceTree = "<group>"; }};
		{id_file_ext_plist} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
		{id_file_ext_assets} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};
/* End PBXFileReference section */

/* Begin PBXFileSystemSynchronizedRootGroup section */
		{id_pkg_ref} /* MegaTicTacToeCore */ = {{
			isa = XCLocalSwiftPackageReference;
			relativePath = ".";
		}};
/* End PBXFileSystemSynchronizedRootGroup section */

/* Begin PBXFrameworksBuildPhase section */
		{id_app_frameworks_phase} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{id_ext_frameworks_phase} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{id_pkg_build_file_ext} /* MegaTicTacToeCore in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{id_main_group} = {{
			isa = PBXGroup;
			children = (
				{id_app_group} /* MegaTicTacToe */,
				{id_ext_group} /* MegaTicTacToeMessagesExtension */,
				{id_products_group} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{id_products_group} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{id_app_product} /* MegaTicTacToe.app */,
				{id_ext_product} /* MegaTicTacToeMessagesExtension.appex */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
		{id_app_group} /* MegaTicTacToe */ = {{
			isa = PBXGroup;
			children = (
				{id_file_app_plist} /* Info.plist */,
				{id_file_app_assets} /* Assets.xcassets */,
			);
			path = MegaTicTacToe;
			sourceTree = "<group>";
		}};
		{id_ext_group} /* MegaTicTacToeMessagesExtension */ = {{
			isa = PBXGroup;
			children = (
				{id_file_ext_messages_vc} /* MessagesViewController.swift */,
				{id_file_ext_plist} /* Info.plist */,
				{id_file_ext_assets} /* Assets.xcassets */,
			);
			path = MegaTicTacToeMessagesExtension;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{id_app_target} /* MegaTicTacToe */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {id_app_build_config_list} /* Build configuration list for PBXNativeTarget "MegaTicTacToe" */;
			buildPhases = (
				{id_app_sources_phase} /* Sources */,
				{id_app_frameworks_phase} /* Frameworks */,
				{id_app_resources_phase} /* Resources */,
				{id_app_embed_ext_phase} /* Embed App Extensions */,
			);
			buildRules = (
			);
			dependencies = (
				{id_target_dependency} /* PBXTargetDependency */,
			);
			name = MegaTicTacToe;
			productName = MegaTicTacToe;
			productReference = {id_app_product} /* MegaTicTacToe.app */;
			productType = "com.apple.product-type.application.messages";
		}};
		{id_ext_target} /* MegaTicTacToeMessagesExtension */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {id_ext_build_config_list} /* Build configuration list for PBXNativeTarget "MegaTicTacToeMessagesExtension" */;
			buildPhases = (
				{id_ext_sources_phase} /* Sources */,
				{id_ext_frameworks_phase} /* Frameworks */,
				{id_ext_resources_phase} /* Resources */,
				{id_ext_embed_icons_phase} /* Embed iMessage Store Icons */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = MegaTicTacToeMessagesExtension;
			packageProductDependencies = (
				{id_pkg_product_ext} /* MegaTicTacToeCore */,
			);
			productName = MegaTicTacToeMessagesExtension;
			productReference = {id_ext_product} /* MegaTicTacToeMessagesExtension.appex */;
			productType = "com.apple.product-type.app-extension.messages";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{id_proj} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {{
					{id_app_target} = {{
						CreatedOnToolsVersion = 15.0;
					}};
					{id_ext_target} = {{
						CreatedOnToolsVersion = 15.0;
					}};
				}};
			}};
			buildConfigurationList = {id_proj_build_config_list} /* Build configuration list for PBXProject "MegaTicTacToe" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {id_main_group};
			packageReferences = (
				{id_pkg_ref} /* MegaTicTacToeCore */,
			);
			productRefGroup = {id_products_group} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{id_app_target} /* MegaTicTacToe */,
				{id_ext_target} /* MegaTicTacToeMessagesExtension */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{id_app_resources_phase} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{id_build_app_assets} /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{id_ext_resources_phase} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{id_build_ext_assets} /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXShellScriptBuildPhase section */
		{id_ext_embed_icons_phase} /* Embed iMessage Store Icons */ = {{
			isa = PBXShellScriptBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			inputFileListPaths = (
			);
			inputPaths = (
			);
			name = "Embed iMessage Store Icons";
			outputFileListPaths = (
			);
			outputPaths = (
			);
			runOnlyForDeploymentPostprocessing = 0;
			shellPath = /bin/sh;
			shellScript = "SRC=\\"${{PROJECT_DIR}}/MegaTicTacToeMessagesExtension/Assets.xcassets/iMessage App Icon.stickersiconset\\"\nDST=\\"${{TARGET_BUILD_DIR}}/${{UNLOCALIZED_RESOURCES_FOLDER_PATH}}\\"\nmkdir -p \\"${{DST}}\\"\nfor f in \\"${{SRC}}\\"/*.png; do\n  b=$(basename \\"${{f}}\\")\n  cp \\"${{f}}\\" \\"${{DST}}/${{b}}\\"\n  s=${{b#icon_}}\n  cp \\"${{f}}\\" \\"${{DST}}/iMessage App Icon${{s}}\\"\n  cp \\"${{f}}\\" \\"${{DST}}/iMessage App Icon-${{s}}\\"\ndone\ncp \\"${{SRC}}/icon_1024x768.png\\" \\"${{DST}}/iMessage App Icon.png\\"\ncp \\"${{SRC}}/icon_1024x768.png\\" \\"${{DST}}/iMessage App Icon1024x768.png\\"\ncp \\"${{SRC}}/icon_1024x768.png\\" \\"${{DST}}/iMessage App Icon-1024x768.png\\"\n";
		}};
/* End PBXShellScriptBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{id_app_sources_phase} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{id_ext_sources_phase} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{id_build_ext_messages_vc} /* MessagesViewController.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		{id_target_dependency} /* PBXTargetDependency */ = {{
			isa = PBXTargetDependency;
			target = {id_ext_target} /* MegaTicTacToeMessagesExtension */;
			targetProxy = {id_container_proxy} /* PBXContainerItemProxy */;
		}};
/* End PBXTargetDependency section */

/* Begin XCSwiftPackageProductDependency section */
		{id_pkg_product_ext} /* MegaTicTacToeCore */ = {{
			isa = XCSwiftPackageProductDependency;
			productName = MegaTicTacToeCore;
		}};
/* End XCSwiftPackageProductDependency section */

/* Begin XCBuildConfiguration section */
		{id_proj_debug_config} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			}};
			name = Debug;
		}};
		{id_proj_release_config} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{id_app_debug_config} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon";
				ASSETCATALOG_COMPILER_STICKER_PACK_APPICON_NAME = "iMessage App Icon";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = 7DRN9GQWJ3;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = MegaTicTacToe/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.megatictactoe.MegaTicTacToe;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{id_app_release_config} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon";
				ASSETCATALOG_COMPILER_STICKER_PACK_APPICON_NAME = "iMessage App Icon";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = 7DRN9GQWJ3;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = MegaTicTacToe/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.megatictactoe.MegaTicTacToe;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
		{id_ext_debug_config} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon";
				ASSETCATALOG_COMPILER_STICKER_PACK_APPICON_NAME = "iMessage App Icon";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = 7DRN9GQWJ3;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = MegaTicTacToeMessagesExtension/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.megatictactoe.MegaTicTacToe.MessagesExtension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{id_ext_release_config} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon";
				ASSETCATALOG_COMPILER_STICKER_PACK_APPICON_NAME = "iMessage App Icon";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = 7DRN9GQWJ3;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = MegaTicTacToeMessagesExtension/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.megatictactoe.MegaTicTacToe.MessagesExtension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{id_proj_build_config_list} /* Build configuration list for PBXProject "MegaTicTacToe" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{id_proj_debug_config} /* Debug */,
				{id_proj_release_config} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{id_app_build_config_list} /* Build configuration list for PBXNativeTarget "MegaTicTacToe" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{id_app_debug_config} /* Debug */,
				{id_app_release_config} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{id_ext_build_config_list} /* Build configuration list for PBXNativeTarget "MegaTicTacToeMessagesExtension" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{id_ext_debug_config} /* Debug */,
				{id_ext_release_config} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */

	}};
	rootObject = {id_proj} /* Project object */;
}}
"""

    with open(os.path.join(proj_dir, "project.pbxproj"), "w") as f:
        f.write(pbxproj)

    # Generate Shared Schemes
    app_scheme = f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{id_app_target}"
               BuildableName = "MegaTicTacToe.app"
               BlueprintName = "MegaTicTacToe"
               ReferencedContainer = "container:MegaTicTacToe.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{id_app_target}"
            BuildableName = "MegaTicTacToe.app"
            BlueprintName = "MegaTicTacToe"
            ReferencedContainer = "container:MegaTicTacToe.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
</Scheme>
"""
    with open(os.path.join(xcshared_dir, "MegaTicTacToe.xcscheme"), "w") as f:
        f.write(app_scheme)

    ext_scheme = f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{id_ext_target}"
               BuildableName = "MegaTicTacToeMessagesExtension.appex"
               BlueprintName = "MegaTicTacToeMessagesExtension"
               ReferencedContainer = "container:MegaTicTacToe.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = ""
      selectedLauncherIdentifier = "Xcode.IDEFoundation.Launcher.PosixSpawn"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{id_ext_target}"
            BuildableName = "MegaTicTacToeMessagesExtension.appex"
            BlueprintName = "MegaTicTacToeMessagesExtension"
            ReferencedContainer = "container:MegaTicTacToe.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
</Scheme>
"""
    with open(os.path.join(xcshared_dir, "MegaTicTacToeMessagesExtension.xcscheme"), "w") as f:
        f.write(ext_scheme)

    print("Successfully generated MegaTicTacToe.xcodeproj and schemes!")

if __name__ == "__main__":
    make_project()
