acim_fn_ai_disable = {
_unit = _this select 0;
_type = _this select 1;

_unit disableAi _type;
};

acim_fn_ai_enable = {
_unit = _this select 0;
_type = _this select 1;

_unit enableAi _type;
};