# Yosemite (10.10.x) Disk Arbitration Agent

This is a modifed codebase for DiskArbitrationAgent that prevents OS X from displaying an "unreadable disk" dialog screen for SATA drives.

![unreadble disk dialog](https://raw.github.com/jrnewell/disk-arbitration-agent/images/dialog.png)

This annoyance occurs if you are running a dual-boot system where your Windows disks are running on a RAID setup (e.g. Intel ICH9R).  OS X will display two more of these dialogs on every bootup because it cannot read the RAID disks properly.

The code is modifed from Apple's Open Source repository for version 10.10.3.

[http://opensource.apple.com/source/DiskArbitration/DiskArbitration-268/](http://opensource.apple.com/source/DiskArbitration/DiskArbitration-268/)

## Installation

Download the latest DiskArbitrationAgent binary from the Releases link in GitHub.  

1. Backup your original ``/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support/DiskArbitrationAgent`` binary to someplace safe.
2. Copy the modified binary to this path.
3. Sign the new binary ``codesign -fs - DiskArbitrationAgent`` so it will run
4. Back your original ``/System/Library/LaunchAgents/com.apple.DiskArbitrationAgent.plist`` launchd plist file to someplace safe.
5. Copy the modified plist to this path (it just passes the ``-s`` option to DiskArbitrationAgent)

## Compilation

Compilation is a bit tricky because Apple does not include all of the private headers that code base uses in the OS X SDK.

I included the private headers I found online in folder PrivateHeaders.  You need to copy them to your XCode's SDK path ``Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk``.

Using XCode 6, ``Build Archive`` the DiskArbitrationAgent project and export the build using the XCode organizer.  The modified binary should be in the path ``DiskArbitrationAgent/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support``

## Usage

When the plist is setup correctly, ``DiskArbitrationAgent`` should run automatically at start up.  To disable just remove the ``-s`` option in the plist.

Note that this does not disable the "unreadable disk" dialog for USB drives.

## License

[APSL License](http://www.opensource.apple.com/license/apsl/)