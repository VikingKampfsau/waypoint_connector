AutoLinkAllWaypoins()
{
	iPrintLnBold("Creating waypoint connections!");

	//Loop through all waypoints
	for(i=0;i<level.waypointCount;i++)
	{
		if(i == int(i/100))
			wait .05;
	
		//Check if it's linkable with any other waypoint
		for(j=0;j<level.waypointCount;j++)
		{
			linkWaypoints = true;
	
			if(j == int(j/100))
				wait .05;
		
			if(j != i)
			{		
				//check if i is already linked to j
				linkExists = false;
				if(level.waypoints[i].childCount > 0)
				{
					for(c=0;c<level.waypoints[i].childCount;c++)
					{
						if(level.waypoints[i].children[c] == j)
						{
							linkExists = true;
							break;
						}
					}
				}
				
				//skip on existing links
				if(!linkExists)
				{
					start = level.waypoints[i].origin + (0,0,5);
					target = level.waypoints[j].origin + (0,0,5);
					
					//check if the path to j is free
					if(PlayerPhysicsTrace(start, target) != target)
						linkWaypoints = false;
					else
					{
						//check if the way to j is passable
						passablePath = true;
							
						lastOffset = 0;
						tempLastOffset = undefined;						
						for(t=1;t<floor(Distance2d(start, target)/5);t++)
						{					
							pos = start + AnglesToForward(VectorToAngles(target - start))*5*t;
							trace = BulletTrace(pos, pos - (0,0,10000), false, undefined);
							
							if(!isDefined(trace["position"]))
							{
								passablePath = false;
								break;
							}
							
							offset = abs(abs(pos[2]) - abs(trace["position"][2]));
							tempLastOffset = abs(offset - lastOffset);
								
							if(!isDefined(tempLastOffset) || tempLastOffset > 10)
							{
								passablePath = false;
								break;
							}
								
							lastOffset = tempLastOffset;
							tempLastOffset = undefined;
						}
					
						//skip when the way to j is unpassable
						if(!passablePath)
							linkWaypoints = false;
							
						//check the distance
						if(Distance(start, target) > 1000)
							linkWaypoints = false;
					}

					//link the waypoint i and j
					if(linkWaypoints)
					{
						level.waypoints[i].children[level.waypoints[i].childcount] = j;
						level.waypoints[i].childcount++;
				  
						level.waypoints[j].children[level.waypoints[j].childcount] = i;
						level.waypoints[j].childcount++;
					}
				}
			}
		}
	}
	
	iPrintLnBold(level.waypointCount + " Waypoints processed.");
	iPrintLnBold("Please check the created connections!");
	iPrintLnBold("Mantles/Ladders have to be added manually!");
}

getMissingLinks()
{
	if(isDefined(level.missingLinks) && level.missingLinks.size > 0)
	{
		self thread jumpToUnlinkedWaypoints();
		return;
	}

	iPrintLnBold("Checking waypoint connections!");

	level.missingLinks = [];

	//Loop through all waypoints
	for(i=0;i<level.waypointCount;i++)
	{
		if(!isDefined(level.waypoints[i].childCount) || level.waypoints[i].childCount <= 1)
		{
			iPrintLnBold("Waypoint: " + i + " has no children!");
			level.missingLinks[level.missingLinks.size] = level.waypoints[i];
		}
	}
	
	iPrintLnBold(level.waypointCount + " Waypoints processed.");
}

jumpToUnlinkedWaypoints()
{
	if(!isDefined(level.missingLinks) || !level.missingLinks.size)
		return;
	
	self setOrigin(level.missingLinks[self.currentCheck].origin);
	self.currentCheck++;
			
	if(self.currentCheck >= level.missingLinks.size)
		self.currentCheck = 0;
}