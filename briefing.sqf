// player createDiaryRecord ["Diary", "Information gathered.<br /><img image='wellDone_ca.paa' />"]

private _briefingText = format['Gear up soldier! I know technically you are just an Electrical Engineer. However, we are shorthanded and you are the highest ranking we have. So, you''re the newest squad leader. You know those guys that were mortaring us all summer? Well, we are attacking them head on. We are outnumbered and surrounded so bringing the fight to them is our only hope. <br /> The plan is to blaze a trail all the way to their base. Problem is, we don''t know where exactly that base is. We have an idea, but its your job to go out their and confirm our suspicions. When you find them, don''t try to hit them by yourself. Call it in the best assets for the job. Artillery, close air support, or boots on the ground, call it in and we''ll get''m there. Assets are limited so don''t over do it. Alright soldier, move out.'];

private _supportSystem = format['
The Combat Support System<br />
Purpose: Designed as a simple interface for requesting support from artillery and transport providers. <br />
Usage: Place a marker on the map where you want support to be centered on. The text in the marker will determine the type of support that will be provided. <br />
Available support requests are as follows;<br /> 
1.	Infil. Used to request chopper transport to an area. When requested, the chopper that’s taken up the request will wait for you to board and then will transport you to the marker position.<br />
2.	Exfil. Request exfiltration rendezvous at marker position. <br />
3.	Reinforce. Request your numbers to be reinforced. Substitutes for any incapacitated units will be flown in by chopper to marker position. <br />
4.	Arty. Request artillery mission at marker position. Syntax for an artillery strike is as follows; arty_10_guided. Mission type(arty), number of rounds(10), and ammunition type(guided). The ammunition type is 155mm mortar shells by default. Other ammunitions types are guided for precise targeting, cluster for airburst munitions, lg for laser guided(laser designator required), and smoke for smoke shells.  
'];

// player createDiarySubject['Briefing', 'Briefing'];

player createDiaryRecord ['Diary',['Situation', _briefingText]];