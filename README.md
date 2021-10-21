# Waypoint Connector

## Overview

A short addition to the pezbot source to create (nearly) all connections between waypoints with a single click.
The result can be used in other bot mods too, tested with pezbots, rotu and kill the king.

## Installation

Get the latest pezbot source (i used 011p) and place it in your mods folder.
Download the autolink.gsc from this repro and save it in 'mods/pezbotsource/svr/'

Open the PeZBOT.gsc which is located in 'mods/pezbotsource/svr/'.
Jump to the function 'GetButtonPressed()' and add a new if statement:

```
else if(self secondaryoffhandbuttonpressed())
{
	while(self secondaryoffhandbuttonpressed())
		wait .05;

	if(getdvar("svr_pezbots_mode2") == "check")
		return "CheckWaypointConnections";
	
	return "AutoLinkAllWaypoins"; //"ChangeWaypointType";
}
```

Then jump to the function 'StartDev()' and find 'switch(level.players[0] GetButtonPressed())'.
Add this two new case statements before the 'default' statement:

```
case "AutoLinkAllWaypoins":
{
	svr\autolink::AutoLinkAllWaypoins();
	break;
}

case "CheckWaypointConnections":
{
	level.players[0] svr\autolink::getMissingLinks();
	break;
}
```

## Configuration

The mod comes with a single server config only - the pezbot default values are fine enough.
Start the mod and map locally with 'developer' and 'developer_script' set to 1.

## Note

This script does not generate connections for mantle or ladder waypoints.
Please add them manually.

## Support
For bug reports and issues, please visit the "Issues" tab at the top.
First look through the issues, maybe your problem has already been reported.
If not, feel free to open a new issue.

**Keep in mind that we only support the current state of the repository - older versions are not supported anymore!**

However, for any kind of question, feel free to visit our discord server at https://discord.gg/wDV8Eeu!
