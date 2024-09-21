	private _copyStatements = triggerStatements sectorTrigger;
	private _copyActivation = _copyStatements select 1;
	private _copyDeactivation = _copyStatements select 2;

	player createDiaryRecord ['triggerPicker', ['the trigger statements before', format['%1', _copyStatements]]];

	sectorTrigger setTriggerStatements ['false', _copyActivation, _copyDeactivation];
	player createDiaryRecord ['triggerPicker', ['the trigger statements after', format['%1', (triggerStatements sectorTrigger)]]];