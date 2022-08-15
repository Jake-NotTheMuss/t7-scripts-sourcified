#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\zm_stalingrad;

//-------------------------------------------------------------------------------
//	Create the zone information for zombie spawning
//-------------------------------------------------------------------------------
function init()
{
	level flag::init( "always_on" );
	level flag::set( "always_on" );
	level flag::init( "department_store_upper_open" );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// INIT ZONES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// LIBRARY
	zm_zonemgr::zone_init( "library_A_zone" );
	zm_zonemgr::zone_init( "library_B_zone" );

	// FACTORY
	zm_zonemgr::zone_init( "factory_A_zone" );
	zm_zonemgr::zone_init( "factory_B_zone" );
	zm_zonemgr::zone_init( "factory_C_zone" );
	zm_zonemgr::zone_init( "factory_arm_zone" );

	// POWERED BRIDGE
	zm_zonemgr::zone_init( "powered_bridge_zone" );
	zm_zonemgr::zone_init( "powered_bridge_A_zone" );
	zm_zonemgr::zone_init( "powered_bridge_B_zone" );

	// LIBRARY STREET
	zm_zonemgr::zone_init( "library_street_A_zone" );
	zm_zonemgr::zone_init( "library_street_B_zone" );
	zm_zonemgr::zone_init( "library_street_C_zone" );

	// FACTORY STREET
	zm_zonemgr::zone_init( "factory_street_A_zone" );
	zm_zonemgr::zone_init( "factory_street_B_zone" );

	// JUDICIAL
	zm_zonemgr::zone_init( "judicial_street_zone" );
	zm_zonemgr::zone_init( "judicial_B_zone" );
	zm_zonemgr::zone_init( "judicial_A_zone" );

	// ALEEY
	zm_zonemgr::zone_init( "alley_B_zone" );
	zm_zonemgr::zone_init( "alley_A_zone" );

	// BUNKER
	zm_zonemgr::zone_init( "bunker_zone" );

	// YELLOW (ARMORY)
	zm_zonemgr::zone_init( "yellow_A_zone" );
	zm_zonemgr::zone_init( "yellow_B_zone" );
	zm_zonemgr::zone_init( "yellow_C_zone" );
	zm_zonemgr::zone_init( "yellow_D_zone" );

	// RED BRICK (INFIRMARY)
	zm_zonemgr::zone_init( "red_brick_A_zone" );
	zm_zonemgr::zone_init( "red_brick_B_zone" );
	zm_zonemgr::zone_init( "red_brick_C_zone" );

	// DEPARTMENT STORE
	zm_zonemgr::zone_init( "department_store_zone" );
	zm_zonemgr::zone_init( "department_store_floor2_A_zone" );
	zm_zonemgr::zone_init( "department_store_floor2_B_zone" );
	zm_zonemgr::zone_init( "department_store_floor3_A_zone" );
	zm_zonemgr::zone_init( "department_store_floor3_B_zone" );
	zm_zonemgr::zone_init( "department_store_floor3_C_zone" );

	// START ZONE
	zm_zonemgr::zone_init( "start_A_zone" );
	zm_zonemgr::zone_init( "start_B_zone" );
	zm_zonemgr::zone_init( "start_C_zone" );

	// PAVLOVS (PAP)
	zm_zonemgr::zone_init( "pavlovs_A_zone" );
	zm_zonemgr::zone_init( "pavlovs_B_zone" );
	zm_zonemgr::zone_init( "pavlovs_C_zone" );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ZONE ADJACENCIES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//	START ZONE

	//	start_A_zone
	zm_zonemgr::add_adjacent_zone( "start_A_zone",			"start_B_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_A_zone",			"start_C_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_A_zone",			"department_store_zone",			"department_store_open",	true );

	//	start_B_zone
	zm_zonemgr::add_adjacent_zone( "start_B_zone",			"start_A_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_B_zone",			"start_C_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_B_zone",			"department_store_zone",			"department_store_open",	true );
	zm_zonemgr::add_adjacent_zone( "start_B_zone",			"department_store_floor2_A_zone",	"department_store_open",	true );

	//	start_C_zone
	zm_zonemgr::add_adjacent_zone( "start_C_zone",			"start_A_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_C_zone",			"start_B_zone",						"always_on",				true );
	zm_zonemgr::add_adjacent_zone( "start_C_zone",			"department_store_zone",			"department_store_open",	true );
	zm_zonemgr::add_adjacent_zone( "start_C_zone",			"department_store_floor2_A_zone",	"department_store_open",	true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DEPARTMENT STORE

	// department_store_zone
	zm_zonemgr::add_adjacent_zone( "department_store_zone",					"department_store_floor2_A_zone",		"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_zone",					"department_store_floor2_B_zone",		"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_zone",					"start_A_zone",							"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_zone",					"start_B_zone",							"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_zone",					"start_C_zone",							"department_store_open",				true );

	//	department_store_floor2_A_zone
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"department_store_zone",				"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"department_store_floor2_B_zone",		"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"start_A_zone",							"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"department_store_floor3_A_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"department_store_floor3_B_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_A_zone",		"alley_B_zone",							"alley_to_department_store_open",		true );

	//	department_store_floor2_B_zone
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_B_zone",		"department_store_zone",				"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_B_zone",		"department_store_floor2_A_zone",		"department_store_open",				true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_B_zone",		"department_store_floor3_A_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_B_zone",		"department_store_floor3_B_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor2_B_zone",		"alley_B_zone",							"alley_to_department_store_open",		true );

	//	department_store_floor3_A_zone
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_A_zone",		"department_store_floor3_B_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_A_zone",		"department_store_floor3_C_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_A_zone",		"red_brick_C_zone",						"department_floor3_to_red_brick_open",	true );

	//	department_store_floor3_B_zone
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_B_zone",		"department_store_floor3_A_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_B_zone",		"department_store_floor3_C_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_B_zone",		"department_store_floor2_A_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_B_zone",		"red_brick_C_zone",						"department_floor3_to_red_brick_open",	true );

	//	department_store_floor3_C_zone
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_C_zone",		"department_store_floor3_A_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_C_zone",		"department_store_floor3_B_zone",		"department_store_upper_open",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_C_zone",		"department_store_floor2_A_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_C_zone",		"department_store_floor2_B_zone",		"department_store_2f_to_3f",			true );
	zm_zonemgr::add_adjacent_zone( "department_store_floor3_C_zone",		"yellow_C_zone",						"dept_to_yellow",						true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	RED BRICK

	//	red_brick_A_zone
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"red_brick_B_zone",					"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"red_brick_C_zone",					"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"powered_bridge_A_zone",			"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"bunker_zone",						"red_brick_to_bunker_open",				true );
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"factory_street_B_zone",			"red_brick_to_factory_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "red_brick_A_zone",		"judicial_street_zone",				"red_brick_to_judicial_street_open",	true );

	//	red_brick_B_zone
	zm_zonemgr::add_adjacent_zone( "red_brick_B_zone",		"red_brick_A_zone",					"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_B_zone",		"red_brick_C_zone",					"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_B_zone",		"powered_bridge_A_zone",			"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_B_zone",		"factory_arm_zone",					"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "red_brick_B_zone",		"factory_B_zone",					"factory_open",							true );

	//	red_brick_C_zone
	zm_zonemgr::add_adjacent_zone( "red_brick_C_zone",		"red_brick_B_zone",					"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_C_zone",		"powered_bridge_A_zone",			"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "red_brick_C_zone",		"department_store_floor3_A_zone",	"department_floor3_to_red_brick_open",	true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	YELLOW

	//	yellow_A_zone
	zm_zonemgr::add_adjacent_zone( "yellow_A_zone",			"yellow_B_zone",					"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_A_zone",			"library_street_A_zone",			"library_street_to_yellow_open",		true );
	zm_zonemgr::add_adjacent_zone( "yellow_A_zone",			"library_street_B_zone",			"library_street_to_yellow_open",		true );

	//	yellow_B_zone
	zm_zonemgr::add_adjacent_zone( "yellow_B_zone",			"yellow_A_zone",					"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_B_zone",			"yellow_C_zone",					"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_B_zone",			"library_street_A_zone",			"library_street_to_yellow_open",		true );
	zm_zonemgr::add_adjacent_zone( "yellow_B_zone",			"judicial_street_B_zone",			"yellow_to_judicial_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "yellow_B_zone",			"bunker_zone",						"yellow_to_bunker_open",				true );

	//	yellow_C_zone
	zm_zonemgr::add_adjacent_zone( "yellow_C_zone",			"yellow_B_zone",					"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_C_zone",			"yellow_D_zone",					"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_C_zone",			"department_store_floor3_C_zone",	"dept_to_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_C_zone",			"library_street_C_zone",			"power_on",								true );

	//	yellow_D_zone
	zm_zonemgr::add_adjacent_zone( "yellow_D_zone",			"powered_bridge_B_zone",			"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "yellow_D_zone",			"yellow_C_zone",					"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "yellow_D_zone",			"library_street_C_zone",			"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "yellow_D_zone",			"library_B_zone",					"library_open",							true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	JUDICIAL

	//	judicial_A_zone
	zm_zonemgr::add_adjacent_zone( "judicial_A_zone",			"judicial_B_zone",				"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_A_zone",			"judicial_street_zone",			"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_A_zone",			"judicial_street_B_zone",		"activate_judicial",					true );

	//	judicial_B_zone
	zm_zonemgr::add_adjacent_zone( "judicial_B_zone",			"judicial_A_zone",				"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_B_zone",			"judicial_street_zone",			"activate_judicial",					true );

	//	judicial_street_zone
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"judicial_A_zone",				"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"judicial_B_zone",				"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"judicial_street_B_zone",		"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"red_brick_A_zone",				"red_brick_to_judicial_street_open",	true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"red_brick_B_zone",				"red_brick_to_judicial_street_open",	true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_zone",		"yellow_B_zone",				"yellow_to_judicial_street_open",		true );

	//	judicial_street_B_zone
	zm_zonemgr::add_adjacent_zone( "judicial_street_B_zone",	"judicial_A_zone",				"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_B_zone",	"judicial_street_zone",			"activate_judicial",					true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_B_zone",	"red_brick_A_zone",				"red_brick_to_judicial_street_open",	true );
	zm_zonemgr::add_adjacent_zone( "judicial_street_B_zone",	"yellow_B_zone",				"yellow_to_judicial_street_open",		true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	ALLEY / BUNKER

	//	alley_A_zone
	zm_zonemgr::add_adjacent_zone( "alley_A_zone",			"alley_B_zone",						"activate_bunker",						true );
	zm_zonemgr::add_adjacent_zone( "alley_A_zone",			"bunker_zone",						"activate_bunker",						true );
	zm_zonemgr::add_adjacent_zone( "alley_A_zone",			"department_store_floor2_B_zone",	"alley_to_department_store_open",		true );

	//	alley_B_zone
	zm_zonemgr::add_adjacent_zone( "alley_B_zone",			"alley_A_zone",						"activate_bunker",						true );
	zm_zonemgr::add_adjacent_zone( "alley_B_zone",			"bunker_zone",						"activate_bunker",						true );
	zm_zonemgr::add_adjacent_zone( "alley_B_zone",			"department_store_floor2_A_zone",	"alley_to_department_store_open",		true );
	zm_zonemgr::add_adjacent_zone( "alley_B_zone",			"department_store_floor2_B_zone",	"alley_to_department_store_open",		true );

	//	bunker_zone
	zm_zonemgr::add_adjacent_zone( "bunker_zone",			"alley_A_zone",						"activate_bunker",						true );
	zm_zonemgr::add_adjacent_zone( "bunker_zone",			"red_brick_A_zone",					"red_brick_to_bunker_open",				true );
	zm_zonemgr::add_adjacent_zone( "bunker_zone",			"yellow_B_zone",					"yellow_to_bunker_open",				true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	POWERED BRIDGE

	//	powered_bridge_A_zone
	zm_zonemgr::add_adjacent_zone( "powered_bridge_A_zone",		"red_brick_A_zone",				"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_A_zone",		"red_brick_B_zone",				"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_A_zone",		"red_brick_C_zone",				"activate_red_brick",					true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_A_zone",		"powered_bridge_B_zone",		"activate_bridge",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_A_zone",		"powered_bridge_zone",			"activate_bridge",						true );

	//	powered_bridge_B_zone
	zm_zonemgr::add_adjacent_zone( "powered_bridge_B_zone",		"powered_bridge_A_zone",		"activate_bridge",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_B_zone",		"yellow_D_zone",				"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_B_zone",		"yellow_C_zone",				"activate_yellow",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_B_zone",		"library_street_C_zone",		"power_on",								true );

	//	powered_bridge_zone
	zm_zonemgr::add_adjacent_zone( "powered_bridge_zone",		"powered_bridge_A_zone",		"activate_bridge",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_zone",		"powered_bridge_B_zone",		"activate_bridge",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_zone",		"yellow_D_zone",				"activate_bridge",						true );
	zm_zonemgr::add_adjacent_zone( "powered_bridge_zone",		"red_brick_C_zone",				"activate_bridge",						true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	LIBRARY

	//	library_street_A_zone
	zm_zonemgr::add_adjacent_zone( "library_street_A_zone",		"library_street_B_zone",		"activate_library_street",				true );
	zm_zonemgr::add_adjacent_zone( "library_street_A_zone",		"yellow_A_zone",				"activate_library_street",				true );
	zm_zonemgr::add_adjacent_zone( "library_street_A_zone",		"library_street_C_zone",		"library_street_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "library_street_A_zone",		"library_A_zone",				"library_open",							true );

	//	library_street_B_zone
	zm_zonemgr::add_adjacent_zone( "library_street_B_zone",		"library_street_A_zone",		"activate_library_street",				true );
	zm_zonemgr::add_adjacent_zone( "library_street_B_zone",		"yellow_A_zone",				"library_street_to_yellow_open",		true );
	zm_zonemgr::add_adjacent_zone( "library_street_B_zone",		"library_street_C_zone",		"library_street_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "library_street_B_zone",		"library_A_zone",				"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_street_B_zone",		"library_B_zone",				"library_open",							true );

	//	library_street_C_zone
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"yellow_C_zone",				"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"yellow_D_zone",				"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"powered_bridge_B_zone",		"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"library_street_A_zone",		"library_street_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"library_street_B_zone",		"library_street_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "library_street_C_zone",		"library_B_zone",				"library_open",							true );

	//	library_A_zone
	zm_zonemgr::add_adjacent_zone( "library_A_zone",			"library_B_zone",				"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_A_zone",			"library_street_A_zone",		"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_A_zone",			"library_street_B_zone",		"library_open",							true );

	//	library_B_zone
	zm_zonemgr::add_adjacent_zone( "library_B_zone",			"library_A_zone",				"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_B_zone",			"library_street_B_zone",		"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_B_zone",			"library_street_C_zone",		"library_open",							true );
	zm_zonemgr::add_adjacent_zone( "library_B_zone",			"yellow_D_zone",				"library_open",							true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	FACTORY

	//	factory_A_zone
	zm_zonemgr::add_adjacent_zone( "factory_A_zone",			"factory_street_A_zone",		"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_A_zone",			"factory_street_B_zone",		"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_A_zone",			"factory_B_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_A_zone",			"factory_C_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_A_zone",			"factory_arm_zone",				"factory_open",							true );

	//	factory_B_zone
	zm_zonemgr::add_adjacent_zone( "factory_B_zone",			"factory_A_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_B_zone",			"factory_C_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_B_zone",			"factory_arm_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_B_zone",			"factory_street_A_zone",		"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_B_zone",			"red_brick_B_zone",				"factory_open",							true );

	//	factory_C_zone
	zm_zonemgr::add_adjacent_zone( "factory_C_zone",			"factory_A_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_C_zone",			"factory_B_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_C_zone",			"factory_arm_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_C_zone",			"factory_street_A_zone",		"factory_open",							true );

	//	factory_arm_zone
	zm_zonemgr::add_adjacent_zone( "factory_arm_zone",			"factory_A_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_arm_zone",			"factory_B_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_arm_zone",			"factory_C_zone",				"factory_open",							true );
	zm_zonemgr::add_adjacent_zone( "factory_arm_zone",			"red_brick_B_zone",				"power_on",								true );
	zm_zonemgr::add_adjacent_zone( "factory_arm_zone",			"factory_street_B_zone",		"factory_bridge_dropdown_open",			true );

	//	factory_street_A_zone
	zm_zonemgr::add_adjacent_zone( "factory_street_A_zone",		"factory_street_B_zone",		"red_brick_to_factory_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "factory_street_A_zone",		"red_brick_A_zone",				"red_brick_to_factory_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "factory_street_A_zone",		"factory_arm_zone",				"factory_bridge_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "factory_street_A_zone",		"factory_A_zone",				"factory_open",							true );

	//	factory_street_B_zone
	zm_zonemgr::add_adjacent_zone( "factory_street_B_zone",		"factory_street_A_zone",		"red_brick_to_factory_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "factory_street_B_zone",		"red_brick_A_zone",				"red_brick_to_factory_street_open",		true );
	zm_zonemgr::add_adjacent_zone( "factory_street_B_zone",		"factory_arm_zone",				"factory_bridge_dropdown_open",			true );
	zm_zonemgr::add_adjacent_zone( "factory_street_B_zone",		"factory_A_zone",				"factory_open",							true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	PAVLOVS (PAP)

	//	pavlovs_A_zone
	zm_zonemgr::add_adjacent_zone( "pavlovs_A_zone",			"pavlovs_B_zone",				"dragonride_crafted",					true );

	//	pavlovs_C_zone
	zm_zonemgr::add_adjacent_zone( "pavlovs_C_zone",			"pavlovs_B_zone",				"dragonride_crafted",					true );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	BOSS FIGHT ARENA
	zm_zonemgr::zone_init( "boss_arena_zone" );


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Connecting zone activation	(NOTE: Put after zone adjacencies so the connection flags are initialized)
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Department store - connect 3rd floor to 2nd floor
	zm_zonemgr::add_zone_flags( "department_store_2f_to_3f",				"department_store_upper_open" );
	zm_zonemgr::add_zone_flags( "dept_to_yellow",							"department_store_upper_open" );
	zm_zonemgr::add_zone_flags( "department_floor3_to_red_brick_open",		"department_store_upper_open" );

	// Yellow
	zm_zonemgr::add_zone_flags( "yellow_to_judicial_street_open",			"activate_yellow" );
	zm_zonemgr::add_zone_flags( "red_brick_to_judicial_street_open",		"activate_yellow" );
	zm_zonemgr::add_zone_flags( "dept_to_yellow",							"activate_yellow" );
	zm_zonemgr::add_zone_flags( "yellow_to_bunker_open",					"activate_yellow" );
	zm_zonemgr::add_zone_flags( "activate_bridge",							"activate_yellow" );

	// Red Brick
	zm_zonemgr::add_zone_flags( "department_floor3_to_red_brick_open",		"activate_red_brick" );
	zm_zonemgr::add_zone_flags( "red_brick_to_judicial_street_open",		"activate_red_brick" );
	zm_zonemgr::add_zone_flags( "yellow_to_judicial_street_open",			"activate_red_brick" );
	zm_zonemgr::add_zone_flags( "red_brick_to_bunker_open",					"activate_red_brick" );
	zm_zonemgr::add_zone_flags( "activate_bridge",							"activate_red_brick" );

	// Judicial
	zm_zonemgr::add_zone_flags( "red_brick_to_judicial_street_open",		"activate_judicial" );
	zm_zonemgr::add_zone_flags( "yellow_to_judicial_street_open",			"activate_judicial" );

	// Library
	zm_zonemgr::add_zone_flags( "library_street_to_yellow_open",			"activate_library_street" );

	// Bunker
	zm_zonemgr::add_zone_flags( "alley_to_department_store_open",			"activate_bunker" );
	zm_zonemgr::add_zone_flags( "red_brick_to_bunker_open",					"activate_bunker" );
	zm_zonemgr::add_zone_flags( "yellow_to_bunker_open",					"activate_bunker" );
}
