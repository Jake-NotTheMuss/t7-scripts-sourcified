#using scripts\codescripts\struct;

#insert scripts\shared\shared.gsh;

function main()
{
	level._zombie_gameModePrecache =&onPrecacheGameType;
	level._zombie_gamemodeMain =&onStartGameType;
	
	/# println(" ************ ZCLASSIC MAIN"); #/
}

function onPrecacheGameType()
{
	/# println(" ************ ZCLASSIC PRECACHE"); #/	
}

function onStartGameType()
{
		/# println(" ************ ZCLASSIC MAIN MAIN"); #/
}
