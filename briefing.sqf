// player createDiaryRecord ["Diary", "Information gathered.<br /><img image='wellDone_ca.paa' />"]

private _briefingText = format["<br />
Our mission in Virohlati has escalated. Mercenaries of unknown origin have seized control of the municipality, driving out local authorities and threatening civilian safety. Our objective is clear: bring disruption to their operations and reclaim control of the region, starting with the old airbase in the southwestern part of Virohlati.<br />

Intelligence indicates a moderate enemy presence, estimated at 15 to 20 hostiles. Despite limited resources and the presence of outdated Soviet-era BMP-2s, we anticipate minimal resistance. Our force of 60 personnel will secure the airbase swiftly and decisively.<br />

We'll conduct our insertion just south of the target, near beachfront residences—a tactical advantage in this operation. Prepare your teams and gear for immediate deployment. Our success here will pave the way for further operations against these hostile forces.<br />

Stay sharp, stay vigilant. Our actions today will determine the future of Virohlati."];

private _missionText = format["Infiltrate and occupy the strategic airport located on the peninsula of Harvananiemi in Virohlati, Finland. Our objective is clear: establish a foothold in enemy territory to disrupt their logistics and reinforce our own supply lines. The airport is heavily guarded and enclosed by a formidable perimeter fence. Equip yourself with wire cutters to breach the barrier and gain entry.<br />

Be vigilant; expect resistance from enemy patrols and automated defenses. Stealth and precision are paramount as we cannot afford to alert the entire garrison. Once inside, secure key locations and disable communications to prevent reinforcements. The success of this operation hinges on our ability to seize control swiftly and maintain it until reinforcements arrive.<br />

Move out, soldiers."];

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

player createDiaryRecord ['Diary',['Mission Iron Clad: Seize and Secure', _missionText]];
player createDiaryRecord ['Diary',['Situation', _briefingText]];