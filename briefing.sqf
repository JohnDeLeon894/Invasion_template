// player createDiaryRecord ["Diary", "Information gathered.<br /><img image='wellDone_ca.paa' />"]

private _diaryEntry = format["
I don't know where to start. The battle for Havananiemi airbase was nothing like what we expected. We were briefed about 15 to 20 hostiles, but it was a fucking massacre out there. They swarmed us from all sides, like a goddamn hornet's nest that we kicked by accident.<br /><br />

We cut through the fence with those wire cutters like it was routine, but the moment we stepped inside, all hell broke loose. They were waiting for us, well-prepared and well-armed. AKs, RPGs—the works. And they knew how to use them, too. Better trained than we thought, like they'd been doing this shit their whole lives.<br /><br />

I lost count of the bodies. We lost good men out there—friends. It's hard to process. One moment they were cracking jokes, the next they're gone in a spray of bullets.<br /><br />

Fucking intel screwed us over. Should've known better than to trust those numbers. There must've been at least fifty of those bastards, maybe more. We were outnumbered and outgunned from the start, fighting tooth and nail for every inch of ground.<br /><br />

I don't know how we held on. It was chaos—screaming, gunfire, explosions. The airbase turned into a warzone, and we were in the middle of it, fighting for our lives. We fought like hell, but victory came at a high cost. Too high.<br /><br />

I can still hear the echoes of gunfire ringing in my ears. The faces of the fallen haunt me. We'll mourn tonight, but tomorrow we'll keep moving. There's more to do, more battles to fight.
<br /><br />
God, I hope we make it through this.<br /><br />

- %1", name player];

private _briefingText = format["Soldiers, our mission has transitioned to Operation Northern Vigilance. We're tasked with rooting out enemy cells scattered across the rural landscapes of Klamila, Lansikyla, and Jarvenkyla, alongside patrolling the surrounding countryside and fishing villages. This phase requires patience, vigilance, and precise execution.<br /><br />

Our intelligence reports indicate that enemy forces have dispersed into smaller groups, using the cover of rural terrain to evade detection. They may call for reinforcements if engaged, so we must act swiftly and quietly.<br /><br />

Your squad will conduct targeted assaults on known enemy positions within the larger villages, disrupting their operations and gathering valuable intelligence. Meanwhile, patrols will sweep through the farms and fishing communities, ensuring no enemy presence goes unnoticed.<br /><br />

Expect varied terrain—from dense forests to open fields—and be prepared for encounters in both populated and isolated areas. Utilize the local geography to your advantage, leveraging natural cover and maintaining constant communication to coordinate movements effectively.<br /><br />

This operation will test your endurance and adaptability. Remember, every village cleared and every enemy cell neutralized brings us closer to securing this region. Stay focused, stay disciplined. The safety of our allies and the success of this mission depend on each one of you.<br /><br />

Prepare your gear and await further instructions. Operation Northern Vigilance begins now"];

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

player createDiaryRecord ['Diary',['Surviving the Battle for Havananiemi Airbase', _diaryEntry]];
player createDiaryRecord ['Diary',['Situation', _briefingText]];