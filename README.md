# Yosemite (10.10.x) Disk Arbitration Agent

This is a modifed codebase for DiskArbitrationAgent that prevents OS X from displaying an "unreadable disk" dialog screen for SATA drives.

![unreadble disk dialog](https://raw.githubusercontent.com/jrnewell/disk-arbitration-agent/master/images/dialog.png)

This annoyance occurs if you are running a dual-boot system where your Windows disks are running on a RAID setup (e.g. Intel ICH9R).  OS X will display two more of these dialogs on every bootup because it cannot read the RAID disks properly.  ``/etc/fstat`` does not seem to be effective in ignoring the disks because OS X will not assign a UUID for these disk since they are unreadable.  To overcome this limitation, I added an option to DiskArbitrationAgent to not display a dialog message if the disk is unreadble and is a SATA drive.  Otherwise, it behaves the same as Apple's version.

The code is modifed from Apple's Open Source repository for version 10.10.x.

[http://opensource.apple.com/source/DiskArbitration/DiskArbitration-268/](http://opensource.apple.com/source/DiskArbitration/DiskArbitration-268/)

## Installation

Download the latest DiskArbitrationAgent binary from the [Releases](https://github.com/jrnewell/disk-arbitration-agent/releases/latest) link in GitHub.

I am also including a Mavericks and El Capitan build.  The El Capitan build uses the Yosemite source built against the OSX 11 SDK since the source code has not been released yet.

**Note that System Integrity Protection must be turned off in 10.11+ to use the modified DiskArbitrationAgent. Turn off SIP at your own risk**

### Automatically

Run the ``./install.sh`` script (requires root privileges).  This will create a backup folder ``DiskArbitrationAgent_Backup`` in the same directory.  Run ``./uninstall.sh <backup-dir-path>`` to uninstall.

### Manually

1. Backup your original ``/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support/DiskArbitrationAgent`` binary to some place safe.
2. Copy the modified binary to this path.
3. Sign the new binary ``codesign -fs - DiskArbitrationAgent`` so it will run
4. Back your original ``/System/Library/LaunchAgents/com.apple.DiskArbitrationAgent.plist`` launchd plist file to some place safe.
5. Copy the modified plist to this path (it just passes the ``-s`` option to DiskArbitrationAgent)

## Compilation

Compilation is a bit tricky because Apple does not include all of the private headers that code base uses in the OS X SDK.

I included the private headers I found online in the folder PrivateHeaders.  You need modify the project's ``Header Search Paths`` to include the PrivateHeaders directory.  Alternatively, you can copy the header files to your XCode's SDK path ``/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk`` using the file ``PrivateHeaders XCode SDK.txt`` as a guide.

Note that you might have a compilation issue with the file ``NSUserNotification.h`` because it exists in the public SDK but is missing the following method signature:
```
+ (id)_centerForIdentifier:(id)arg1 type:(unsigned long long)arg2;
```
You may need to manually add this method signature to your public SDK version of ``NSUserNotification.h`` if your XCode is not picking up the modified ``NSUserNotification.h`` included in the repo.

Using XCode 6, ``Build Archive`` the DiskArbitrationAgent project and export the build using the XCode organizer.  The modified binary should be in the path ``DiskArbitrationAgent/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support``

## Usage

When the plist is setup correctly, ``DiskArbitrationAgent`` should run automatically at start up.  To disable just remove the ``-s`` option in the plist.

Note that this does not disable the "unreadable disk" dialog for USB drives.

## License

[APSL License](http://www.opensource.apple.com/license/apsl/)