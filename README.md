# ebuild-overlay

Contains various ebuilds I have created to install packages in Gentoo

# dev-libs/sfgui
Installs the SFML GUI library from http://sfgui.sfml-dev.de

# dev-libs/stp
Installs the STP SFML TMX file parser from https://edoren.github.io/STP

# dev-util/entityx
Installs the fast, type-safe c++ entity component system from https://github.com/alecthomas/entityx

# sci-physics/box2d
Installs the Box2d physics library from https://github.com/erincatto/Box2D

# games-engines/unity3d
Installs the Unity3d game development platform (forked from maxik-overlay)

After installation some of the file permissions are not set correctly.
Once I have found them all I will add them to the ebuild.

For now run:

chmod 4755 /opt/Unity/Editor/chrome-sandbox

chmod +x /opt/Unity/Editor/Data/Mono/bin/mono

chmod +x /opt/Unity/Editor/Data/Tools/FSBTool

chmod +x /opt/Unity/MonoDevelop/bin/monodevelop

# dev-dotnet/xsp
Fixes for xsp to compile with mcs rather than gmcs and find libraries (now under /usr/libXX/mono/X.X-api/)

dev-dotnet/monodevelop has a similar problem but can be installed using

MCS=/usr/bin/mcs emerge monodevelop

# dev-dotnet/mono-addins
Fixes for mono-addins-0.6.2 to compile with mcs rather than gmcs and find references (hardcoded to /usr/lib/mono/4.0-api/)
The Gentoo testing package 1.0-r1 compiles successfully without this patch but blocks on dev-dotnet/XXXX-sharp. Once these are resolved then my patch will no longer be required.
