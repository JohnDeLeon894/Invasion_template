/**
creates a task and assigns it to given unit.
[owner, taskID, description, destination, state, priority, showNotification, type, visibleIn3D] call BIS_fnc_taskCreate

from https://community.bistudio.com/wiki/BIS_fnc_taskCreate

owner: Task owner(s)
	Boolean - true to set task of all playable units
	Object - set task of a specific object
	Group - set tasks of all objects in the group
	Side - set tasks of all objects of the given side
	Array - collection of above types

taskID:
	String - Task ID
	Array - In the format of [task ID, parent task ID]

description:
	Array - Task description in the format ["description", "title", "marker"]
	String - CfgTaskDescriptions class name, if empty string is used then CfgTaskDescriptions is searched for a class matching the tasks TaskID

destination (Optional): Task destination
	Object - Use objNull to set no position		
	Array - Either position in format [x,y,z], or [object,precision] as used by setSimpleTaskTarget command

state (Optional): Task state
	String - can be one of following:
		"CREATED"
		"ASSIGNED"
		"AUTOASSIGNED" ("ASSIGNED" when no task is assigned yet, otherwise "CREATED")
		"SUCCEEDED"
		"FAILED"
		"CANCELED"
	Boolean - true to set the task as current

priority (Optional): Number - priority. When the current task is completed, the system selects the one with the largest priority >= 0. To avoid auto assignment of that task, give it a priority of -1.

showNotification (Optional): Boolean - true to show notification (default), false to disable it

type (Optional): String - task type from CfgTaskTypes, if not defined, type "" is being used

visibleIn3D (Optional): Boolean - true to make task always visible in 3D (default: false)
*/

Private _variableList = [_owner, _taskID, _description, _destination, _state, _priority, _showNotification, _type, _visibleIn3D];
private _paramCount = 0;
{
	if (!isNil _this select _paramCount) then {
		_x = _this select _paramCount
	};
	_paramCount = _paramCount +1;

} forEach _variableList;

_variableList call BIS_fnc_taskCreate;