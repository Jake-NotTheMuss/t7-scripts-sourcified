#using scripts\codescripts\struct;

#using scripts\shared\music_shared;

#insert scripts\shared\shared.gsh;

function main()
{
	thread startZmbSpawnerSoundLoops();
}

function startZmbSpawnerSoundLoops()
{
	loopers = struct::get_array( "exterior_goal", "targetname" );
	
	if( isdefined( loopers ) && loopers.size > 0 )
	{
		delay = 0;
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : Initialising zombie spawner loop sounds - " + loopers.size + " emitters." );
		}	
#/			
		for( i = 0; i < loopers.size; i++ )
		{
			loopers[i] thread soundLoopThink();
			delay += 1;

			if( delay % 20 == 0 ) //don't send more than 20 a frame
			{
				WAIT_CLIENT_FRAME;
			}
		}		
	}
	else
	{
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : No zombie spawner loop sounds." );
		}	
#/			
	}
}

//self is looper struct
function soundLoopThink()
{
	if( !isdefined( self.origin ) )
	{
		return;
	}

	if ( !isdefined( self.script_sound ) )
	{
		self.script_sound = "zmb_spawn_walla";
	}

	
	notifyName = "";
	assert( isdefined( notifyName ) );
	
	if( isdefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	assert( isdefined( notifyName ) );
	
	started = true;
	
	if( isdefined( self.script_int ) )
	{
		started = self.script_int != 0;
	}
	
	if( started )
	{
		soundloopemitter( self.script_sound, self.origin );
	}
	
	if( notifyName != "" )
	{
		for(;;)
		{
			level waittill( notifyName );

			if( started )
			{
				soundstoploopemitter( self.script_sound, self.origin );
			}
			else
			{
				soundloopemitter( self.script_sound, self.origin );
			}
			started = !started;
		}
	}
}
