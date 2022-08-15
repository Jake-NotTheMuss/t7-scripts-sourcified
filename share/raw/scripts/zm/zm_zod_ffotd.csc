#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_utility;

function main_start()
{
	level.custom_umbra_hotfix = &zod_custom_umbra_hotfix;
}

function zod_custom_umbra_hotfix( localclientnum )
{
	return false;
}

function main_end()
{

}
