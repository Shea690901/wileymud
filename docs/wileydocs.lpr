Feb  3 00:49 1995  dbdocsII Page 1


:: A brief discussion of what has been done to the database, a full
:: builders doc will follow at a later time....

:: I will start by listing all of the definition words known to the
:: database..

::	::		A comment in your file that will not print out when
::			 the file is being parsed.
::	;;		A comment in your file that will print out when
::			 the file is being parsed.
::	@		Inherit symbol, followed by an integer.
::	#		Start of a room, followed by an integer.
::	end		End of a room, exdescription,exit...and what not.
::	name		to define the name, a string ending with '~'
::	desc		to define the main desc, followed by '~'
::	sect		Sector type, followed by a definition word, see LISTS
::	zone		The zone this file belongs to, followed by an integer.
:: 	flags		Flag types, followed by definition word[s], see LISTS
::	exit		Start of an exit, use end to encapsulate it. c LISTS
::	key		Key used for an exit, followed by an integer.
::	goto		Room exit should goto, followed by an integer.
::	sound1		This is the in room sound players will hear.
::	sound2		This is the out of room sound players hear when
::			 in a room connected to this room.
::	tele_time	The time before a teleport takes action.
::	tele_targ	where the room teleports to.
::	tele_look	Should the description print when the player shows
::			 up. see lists.
::	ex_desc		An extra description, followed by key words used when
::			 a player used 'look at '. use end to encapsulate it.

:: LISTS
::  There are various lists used throughout, most are for checking keywords
::  used with other definitions.

::  SECTOR LIST
::	inside
::	city
::	field
::	forest
::	hills
::	mountain
::	swim		- a player CAN swim in this room ****
::	no_swim		- a player needs a floatation device for this room ***
::	air		- a player must be flying by some means to enter.
::	underwater	- a player needs a way to breath to enter. ****

:: **** These sector types must be followed by the currents direction and
Feb  3 00:49 1995  dbdocsII Page 2


::      speed. IE.  sect swim north 1.
::      This room will flow north with a flow speed of 1.

::  DIRECTION LIST - used for exits and water flow direction.
::	north or N or n
::	east or E or e
::	south or S or s
::	west or W or w
::	up or U or u
::	down or D or d

::  FLAGS LIST
::	dark
::	no_mob
::	indoors
::	no_flight
::	no_steal
::	no_summon
::	no_magic
::	private

:: REPLY LIST
::	YES or yes
::	NO or no
::	ON or on
::	OFF or off

:: EXIT LIST - 
::      isdoor
::	closed
::	locked
::	pickproof

:: DEFAULTS for room if you do not define them.
::	zone		0
::	sect		city
::	riverdir	-1	
::	riverspeed	0
::	teletime	-1
::	teletarg	-1
::	telelook	YES
::	flags		none
::	
:: DEFAULTS for an exit if you do not define them.
::	keyword		none
::	description	none
::	flags		none
::	key		-1
Feb  3 00:49 1995  dbdocsII Page 3


::	goto		0 ( void ) cackle
:: AN EXAMPLE

#1000				
name A test room.~
flags indoors no_mob~
desc
A description of this room, well, none actually.
~					
sect city			
zone 1			
ex_desc rug~
This is the extra description for the rug.~
  exit north	
    desc This is the description of an exit.~
    goto 1001
  end	
  exit south
    key 1111
    flags isdoor~
    desc A small wooden door set into the south wall.~
  end 
end
Feb  3 00:49 1995  wileydb.doc Page 1


                              -= WileyMUD Docs =-
  			    Modified for WileyMUDII

-= These documents accurate for:

wiley_file.wld
wiley_file.mob
wiley_file.obj
wiley_file.zon
wiely_file.shp

-= World File field description:

Basic template of a room:

<#virtual_number>
<name>~
<description>
~
<zone room_flags sector_type>
<exit>
<exit_description>
~
<exit_keywords>~
<exit_type key_number room>
<E>
<keywords>~
<extra_description>
~
S

Explanations:

<virtual number>:
  A number for the given room. No two rooms may have the same number.
  The <virtual number> must always increase when browsing down the 
  world file (but increments can be larger than one).
  ie.
     #3001
     #3002
     #3010

<name>~:
  This name is the "title" of the room.  It is very important to have a 
  title to your room as that is the only part of a room that will print
  when 'brief' has been set on a player.  A tilda must follow the name
  of your room.

Feb  3 00:49 1995  wileydb.doc Page 2


<description>:
  This is what will print to a character who walks into a room, this should
  include what the room looks like, what the people see and why they see
  it.  There must be a tilda on a line by itself below the last line of
  the description.

<zone nr>:
  This is the zone in which the room will reside for purposes of a reset.
  Your room must have a zone or it will have no place in the world to 
  which you build it for.

<room_flags>:
  A bitvector consisting of the room conditions.  The ones that are desired
  are added together and that number is used for the final bit.

  DARK           1  Light must be used to see anything.
  DEATH          2  Do not use.
  NO_MOB         4  No monsters may walk into this room. 
  INDOORS        8  The room is indoors.  (cave/house/tent/etc) 
  PEACEFUL      16  No fighting can be attempted.
  NO_STEAL      32  No stealing can be attempted. 
  NO_SUM        64  Nothing can be summoned from this room.
  NO_MAGIC     128  No magic can be cast.
  PRIVATE      512  This room cannot be accesed by a teleport spell.
  SOUND       1024  The room eminates sounds.

  SOUND requires addition of two fields below <zone room_flags sector_flags>.

  <zone room_flags sector_flags>
  <sound one>
  ~
  <sound two>
  ~
  <exit>

<sector_type>:
  This determines how many movement points are used when moving through
  the room.  This is a bit table, not the amount of movement it actually
  takes to move through this room.

  SECT_TELE           -1  Telepprts things within.
  SECT_INSIDE          0  Indoors.
  SECT_CITY            1  City.
  SECT_FIELD           2  Field.
  SECT_FOREST          3  Forest.
  SECT_HILLS           4  Hills.
  SECT_MOUNTAIN        5  Mountains.
  SECT_WATER_SWIM      6  Swimming.
Feb  3 00:49 1995  wileydb.doc Page 3


  SECT_WATER_NOSWIM    7  Requires use of a boat.
  SECT_AIR             8  Requires use of flight.
  SECT_UNDERWATER      9  Requires water breathing.

 SECT_TELE:
  The below parameters must be placed behind the <sector_type>.

 <teleport_time> <to_room> <do_look> <real_sector_type>

  <teleport_time>:
     A multiple of 10, the higher the number, the longer the wait before 
     the teleports activates.  (10 is a combat round) 
  <to_room>:
     The room to which you are teleported to.
  <do_look>:
     If this value is a non-zero you will automatically look when entering
     the new room.
  <real_sector_type>:
     What this sector costs for movement.  (refer to sector_type chart)

 SECT_WATER_NOSWIM:
  The below parameters must be place behind the <sector type>.

 <river_speed> <flow_direction>

  <river_speed>:
    The time it takes before you drift through a exit.
  <river_direction>:
    The exit through which you will drift.  The exit must exist or no 
    drift will occur.

<exit>:
  This combination of a 'D' and exit number.  This field states that a 
  exit will be leaving the room in one of the cardinal directions.

  0 = North
  1 = East
  2 = South
  3 = West
  4 = Up
  5 = Down

<exit description>:
  What a player will see if he in the direction of this exit.  There must
  be a tilda on a line by itself after this field.

<exit keywords>:
  A keyword is what the exit is called if you have to open it.  This is also
Feb  3 00:49 1995  wileydb.doc Page 4


  used if you want the <exit description> printed out if they look at a
  keyword.  If the exit is a door, you must have a keyword, without one the
  door cannot be opened or used in any way.

<exit_type>:
  This field determines what type of portal the exit is.  If it is anything
  other than '0' there must be a keyword for it to be acted upon.  A door is
  considred opened by the game unless it is closed in the zone file.

    0  A open passage.
    1  Door which can be opened/closed/locked/unlocked/picked
    2  Door which can be opened/closed/locked/unlocked
    3  Secret door which can be opened/closed/locked/unlocked/picked
    4  Secret door which can be opened/closed/locked/unlocked

<key_number>:
  The number of the object which can unlock/lock the door.  A value of -1
  means there is no key for this door.

<to_room>:
  The virtual number of the room to which the exit leads. If this number is
  -1, the exit doesn't lead anywhere, this is used when you need a exit 
  description but don't need it to go anywhere.

  You must have a door between both rooms that the door seperates.

-= Exit aliasing:

  This allows you to have a alternate name to a exit.  The northern exit
  could be called a cave instead of north.  This is accomplished by adding
  4 to the exit type that you desire.  ie. 1 + 4 = 5 to include a alias.
  Please note that the alias for the exit must be included in the <keywords>
  for that exit.

-= Extra descriptions:
   
  Extra descriptions are used for things within the room that you would like
  the player to be able to look at.  This is signified by placing a 'E' on
  a line by itself after all exits have been completed.  Below the 'E' you 
  must add these fields.

 <keyword list>~:
  A list of the keywords that will allow the extra description to be
  displayed. The keywords must must be seperated by blanks.  This must 
  be followed by a tilda.

 <description>:
  The description that is show when a player types 'look at <keyword>'
Feb  3 00:49 1995  wileydb.doc Page 5


  and keyword matches one of the above.  There must be a tilda on a line
  by itself following the description.

Example room:

#3001
The Griffons Tail~
  Warm candlelight burns about you as you glance into this small bar and
inn.  About you people talk amungst themselves around small oaken tables,
most moving uncomfortably upon their small stools.  Near the far wall a
tall bench serves as the bar for this inn, behind which stands a large man
cleaning a wooden mug.
  A door lies to the west while archways lead east and south from here.
~
3 12 0
D1
The archway seems to lead into another chamber, most likely where people
to when they feel they need to rest.
~
~
0 -1 3008
D2
You can see a large bulletin board not for into this chamber.
~
~
0 -1 3048
D3
The door is made of solid oak, the brass handle shines in the warm light.
~
door~
1 3010 3000
E
bar~
  The bar holds many drinks upon it from those that mill about, the barkeep
fills them from time to time, spilling a bit as he looses his attention.
~
S
#3002
...

-= Facts about this room is:
    Room number: 3001
    Room name: The Griffons Tail
    Zone number: 3 
      Room Flags: 12 (8+4=12) "INDOORS and NO_MOB"
      Sector Type: 0 "Inside"
    Exits:
      A eastern exit which has:
Feb  3 00:49 1995  wileydb.doc Page 6


        A description when someone looks east.
        No key-words for the exit.
        A open passageway.
        No key.
        Leads to another room, 3008.
      A southern exit which has:
        A description when somone looks south.
        No key-words for the exit.
        A open passageway.
        No key.
        Leads to another room 3048. 
      A western exit which has:
        A description when someone loods west, or at 'door'.
        A keyword of door.
        A pickable door.
        A key with object number 3010.
        Leads to another room 3000.
    Extra Description: bar
 
=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-= Monster fields description:

Basic template of a mobile:

<#virtual_number>
<name_list>~ 
<short_description>~
<long_description>
~
<description>
~
<action_flags affects_flags alignment type>
<level thac0 AC hit_points damage>
<-1 gold experience race_type>
<position def_postion sex resistances immunites suscebilities>
<room_sound>
~
<distant_sound>
~

-= Explanations:

<#virtual_number>:
  The monsters virtual number.  These work best if in numerical order.
  ie.
   #102
   #201
Feb  3 00:49 1995  wileydb.doc Page 7



<name_list>~:
  This are the names by which the mob can be accesed for player actions such
  as 'look at buck'.  In there 'buck' must be one of the names in the 
  <name_list> for the mob to be looked at.

<short_description>~:
  This string will be displayed when the monster takes action.  This is when
  the mob does anything, ie.  A small boy leaves south, A small boy misses you
  with his hit.

<long_description>:
  This string is displayed when the current position of the mob matches that
  of the default position.  If those two do not match the string will simply
  read, A small boy is sitting here.  There must be a tilda on a line by 
  itself following this description.

<description>:
  This string will be displayed when a player looks at the monster.  There
  must be a tilda on a line by itself following this description.

<action_flags>:
  This bitvector define how the monster behave.  The desired bits are to be
  added together and that final bit is to be used as <action_flags>.

  ACT_SPEC          1  This bit should not be set.
  ACT_SENTINEL      2  The mob will not move out of its loading room.
  ACT_SCAVENGER     4  The mob will pick things up.
  ACT_ISNPC         8  Do not use.
  ACT_NICE_THIEF   16  The mob will not attack if a missed steal happens.
  ACT_AGGRESSIVE   32  The mob will attack only things it can see.
  ACT_STAY_ZONE    64  The mob will not move out of its loading zone.
  ACT_WIMPY       128  Mob will flee if injured.  If this bit is combined with
                       ACT_AGGRESSIVE the mob attacks sleeping pc's only.
  ACT_HATED       256  The mob will be attacked by other mobs.
  ACT_ASSASIN     512  Do not use.
  ACT_SCARED_PC  1024  Do not use.
  ACT_IMMORTAL   2048  Mob can not be attacked.
  ACT_HUNTING    4096  Do not use.
  ACT_DEADLY     8192  Do not use. 
  ACT_POLYSELF  16384  Do not use.
  ACT_POLYOTHER 32768  Do not use.
  ACT_GUARDIAN  65536  Do not use.
  ACT_USE_ITEM 131072  The mob will use items that it picks up.
  ACT_FR_MOVES 262144  The mob will use fighter skills.
  ACT_FD_PROV  524288  The mob has a chance to provide food when killed.
  ACT_PROT    1048576  Do not use.
  ACT_MOUNT   2097152  The mob can be ridden.
Feb  3 00:49 1995  wileydb.doc Page 8



<affection_flags>:
  This is a bitvector that indicates what the monster is affected by.  The
  bits desired for a mob are added and the final number is that which is 
  used for <affection_flags>.

  AFF_INVISIBLE        2  The mob is invisible.
  AFF_DETECT_INVISIBLE 8  The mob can see_invisible.
  AFF_SENSE_LIFE      32  The mob can sense hidden pc's.
  AFF_SANCTUARY      128  The mob takes half damage.
  AFF_FLYING        2048  The mob can move into FLY sectors.
  AFF_INFRAVISION  32768  The mob can see in the dark.
  AFF_GILLS        65536  The mob can see underwater.
  AFF_SNEAK       524288  The mob will not be seen leaving/entering.
  AFF_HIDE       1048576  The mob will be hidden, even in combat.
  AFF_CHARM      4194304  The mob will act as charmed if a 'follow' command
                          is given to it.

<alignment>:
  This is the monsters alignment read as:
   1000 <> 350   (good alignment)
    349 <>-349   (neutral alignment)
   -350 <>-1000  (evil alignment)


<type>:
  There are four different types of a mobile.  The type defines what the
  mob will do in other respects besides those covered in <affect, action>.

  'D'  - Do not use.
  'S'  - Mob will not have multiple attacks or make sounds.
  'M'  - Mob can have more than one attack.  You must place a number after the
         M to designate how many attacks the mob shall have.  ie.  M 2
  'W'  - Mob can have multiple attacks and make sounds.  Attacks apply to the
         same rule as M mobs.  Sound is handled at the end of the template.

<level>:
  This is the level of the monster, and is used for the 'consider' command
  in game.

<thac0>:
  The amount the mob needs to hit armor class 0.  The lower the number the
  better the chance the mob will hit.  This number should be <level> + 2, with
  a max of 20.

<AC>:
  The mobs armor class.  The lower the number the harder it is to hit the 
  mob.  Figure in dexterity bonuses as dex 18=AC 6, 17=7, 16=8, 15=9, 14+=10.
Feb  3 00:49 1995  wileydb.doc Page 9



<hit_points>:
  This defines the number of hitpoints a given monster has.  The format is:
  <level>d8+25.  Figure in constitution bonuses as con 18=+4 per <level>, 
  17=+3/level, 16=+2/level, 15=+1/level.  Constitution bonuses are added to
  the base 25.

<damage>:
  This is the bare_hand damage a mob will give.  The format is: 1d4+0 for any
  normal mobile.  The dice and additional strength damage can be increased
  if the mobile is deserving.

<-1>:
  This is stating that the mob will have a race, which will be place after the
  <experience>.  You do not have to have a race, therefore the -1 is not 
  needed in that case.

<gold>:
  This is how much gold the mob has on its body.  This amount can be stolen
  and is the amount a player will get from the corpse of the mob.

<experience>:
  This is how much exp a player will get for killing the mob.  A general rule
  for experience is 100*<level> + whatever amount you feel neccesary.  Do
  not give out a exuberant amount of exp, but enough to make the fight worth
  a players while.

<race>:
  This is activated by having a -1 in front of the <gold> portion of the mob
  template.  This number will be the race that the mob is seen as when a 
  player looks at it.  Mobs of the same race will help each other out in a 
  fight, keep that in mind.

  Races available:
   Player/Mobile races :
   RACE_HALFBREED 0
   RACE_HUMAN     1
   RACE_ELVEN     2
   RACE_DWARF     3
   RACE_HALFLING  4
   RACE_GNOME     5
   Mobile races :
   RACE_REPTILE  6
   RACE_SPECIAL  7
   RACE_LYCANTH  8
   RACE_DRAGON   9
   RACE_UNDEAD   10
   RACE_ORC      11 
Feb  3 00:49 1995  wileydb.doc Page 10


   RACE_INSECT   12 
   RACE_ARACHNID 13
   RACE_DINOSAUR 14
   RACE_FISH     15
   RACE_BIRD     16
   RACE_GIANT    17
   RACE_PREDATOR 18 
   RACE_PARASITE 19 
   RACE_SLIME    20 
   RACE_DEMON    21 
   RACE_SNAKE    22 
   RACE_HERBIV   23 
   RACE_TREE     24 
   RACE_VEGGIE   25 
   RACE_ELEMENT  26 
   RACE_PLANAR   27 
   RACE_DEVIL    28 
   RACE_GHOST    29 
   RACE_GOBLIN   30 
   RACE_TROLL    31 
   RACE_VEGMAN   32 
   RACE_MFLAYER  33 
   RACE_PRIMATE  34 
   RACE_ANIMAL   35
   RACE_FAERY    36
   RACE_PLANT    37

<position>:
  This defines the monster's position when loaded into the game.
  A position is one of:

   Position_Sleeping   4  The mob is sleeping.
   Position_Resting    5  The mob is resting.
   Position_Sitting    6  The mob is sitting.
   Position_Standing   8  The mob is standing.

<def_position>:
  This is the position into which the monster will return after a fight.
  This must be the same as the <positon> or the <long_description> will not
  print out.

<sex>:
  This is the monsters sex.  If the mob is going to have <immunities, ect>,
  you must add 3 to the sex, and then you may include those fields.  

   Neutral   0
   Male      1 
   Female    2 
Feb  3 00:49 1995  wileydb.doc Page 11



<resistance> <immunity> <susceptibility>:
  This combination of numbers will make the mob resistant to those types of
  attacks and damages.  Each field uses the numbers below to result in the
  resistances, immunities, and suscebilities.  This field is only active if
  a 3 has been added to the sex of the mob.

  Imm_Fire    1
  Imm_Cold    2
  Imm_Elec    4
  Imm_Energy  8
  Imm_Blunt  16
  Imm_Pierce 32
  Imm_Slash  64

<sound_one>:
  This is the sound that will be heard if you are in the same room as the W
  type mob.  Only the 'W' type mobs are allowed to have this field.

<sound_two>:
  This is the sound you will hear if you are standing one room away from the
  mob that emits the sound.  Only 'W' type mobs are allows to have this field.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-= Object field description:

Basic object template:

<#virtual_number>
<name_list>~
<short_description>~
<long_description>~
<action_description>~
<type_flag> <extra_flag> <wear_flag>
<value0> <value1> <value2> <value3>
<wieght> <value> <cost/day>
<A>
<location> <modifier>
<E>
<keyword_list>~
<extra_description>
~

<#virtual_number>:
  This is the virtual number of the object.  Object numbers must increase
  in number with each additional object.  
  #234
Feb  3 00:49 1995  wileydb.doc Page 12


  #235
  #391

<namelist>~:
  These are the various names that the obj can be accessed with.  They must
  be obvious enough so that a player can manipulate the obj.

<short_description>~:
  This string will be displayed when the object is used.  This field is
  the name of the obj as it will appear in a players inventory or when the
  obj is manipulated.

<long_description>~:
  This description is displayed when the object is lying on the ground.

<action_description>~:
  This field is not used for all objects other than the audio object for which
  it is used as the sound that the object will make.

<type_flag>:
  This defines what kind of obj you are making.  A obj can ony be one of
  the listed below.

   ITEM_LIGHT      1  Obj gives off light.
   ITEM_SCROLL     2  Obj can be a read spell.
   ITEM_WAND       3  Obj can use a spell.
   ITEM_STAFF      4  Obj can use a spell.
   ITEM_WEAPON     5  Obj is a weapon.
   ITEM_FIREWEAPON 6  Do not use.
   ITEM_MISSILE    7  Do not use.
   ITEM_TREASURE   8  Obj is jewelry worth coin.
   ITEM_ARMOR      9  Obj is armor.
   ITEM_POTION    10  Obj can be quaffed.
   ITEM_WORN      11  Obj can be worn.
   ITEM_OTHER     12  Obj is misc.
   ITEM_TRASH     13  Obj is junk.
   ITEM_TRAP      14  Obj is a trap.
   ITEM_CONTAINER 15  Obj is a container.
   ITEM_NOTE      16  Obj is a note, can be written upon.
   ITEM_DRINKCON  17  Obj is a drink container.
   ITEM_KEY       18  Obj is a key.
   ITEM_FOOD      19  Obj is food.
   ITEM_MONEY     20  Obj is a amount of coins.
   ITEM_PEN       21  Obj is a pen, can write on a note.
   ITEM_BOAT      22  Obj allows a player to move into SECT_NOSWIM.
   ITEM_AUDIO	  23  Obj will make a sound.
   ITEM_BOARD	  24  Obj can be a bulletin board.

Feb  3 00:49 1995  wileydb.doc Page 13


<extra_flag>:
  This bitvector defines the affects and restrictions of the obj.  The
  desired bits below are added together and the final number is used as
  the <extra_flag> bit.

   ITEM_GLOW             1  Obj glows.
   ITEM_HUM              2  Obj hums.
   ITEM_INVISIBLE       32  Obj is invisible.
   ITEM_MAGIC           64  Obj will have a blue hue if detect magic is cast.
   ITEM_NODROP         128  Obj cannot be dropped.
   ITEM_BLESS          256  Obj is blessed.
   ITEM_ANTI_GOOD      512  Obj cannot be held by a good alignment.
   ITEM_ANTI_EVIL     1024  Obj cannot be held by a evilalignment.
   ITEM_ANTI_NEUTRAL  2048  Obj cannot be held by a neutral alignment.
   ITEM_ANTI_CLERIC   4096  Obj cannot be used by a cleric.
   ITEM_ANTI_MAGE     8192  Obj cannot be used by a mage.
   ITEM_ANTI_THIEF   16384  Obj cannot be used by a thief.
   ITEM_ANTI_FIGHTER 32768  Obj cannot be used by a warrior.
   ITEM_ANTI_RANGER  65536  Obj cannot be used by a ranger.
   ITEM_PARISH	    131072  Obj ITEM_FOOD will decay.

<wear_flag>:
  This bit defines how and where the obj is manipulated within the game.  The
  desired bits are added together and used for <wear_flag> bit.  Please note
  that ITEM_TAKE should be set, or the object can never be picked up to be
  used.

   ITEM_TAKE            1  Obj can be picked up.
   ITEM_WEAR_FINGER     2  Obj can be worn on finger.
   ITEM_WEAR_NECK       4  Obj can be worn around neck.
   ITEM_WEAR_BODY       8  Obj can be worn on body.
   ITEM_WEAR_HEAD      16  Obj can be worn on head.
   ITEM_WEAR_LEGS      32  Obj can be worn on legs.
   ITEM_WEAR_FEET      64  Obj can be worn on feet.
   ITEM_WEAR_HANDS    128  Obj can be worn on hands.
   ITEM_WEAR_ARMS     256  Obj can be worn on arms.
   ITEM_WEAR_SHIELD   512  Obj can be used as a shield.
   ITEM_WEAR_ABOUT   1024  Obj is worn about body.
   ITEM_WEAR_WAISTE  2048  Obj can be worn around the waiste.
   ITEM_WEAR_WRIST   4096  Obj can be worn on wrist.
   ITEM_WIELD        8192  Obj can be wielded one-handed.
   ITEM_HOLD        16384  Obj can be held in a hand.
   ITEM_WIELD_TWOH  32768  Obj can he wielded two-handed.

<value 0> <value 1> <value 2> <value 3>:
  These values are very central. They define the ability of items based on
  the items <item_type>. These values are defined in below as each obj has
  different values.
Feb  3 00:49 1995  wileydb.doc Page 14



Values are:
  (Items with no values listed must have a 0 assinged to all values)

ITEM_LIGHT (1)
Value[0]: 0
Value[1]: 0
Value[2]: Number of hours the light can be used for. Zero hours means that
          the light has gone out. A negative number will create an eternal
          light source.
Value[3]: 0

ITEM_SCROLL (2)
Value[0]: Level of the spell on the scroll.
Value[1]: Spell one.
Value[2]: Spell two.
Value[3]: Spell three.
  The values(1-3) are three (or less) different spells scribed on the scroll.
  Unused spells should be set to -1.

ITEM_WAND (3)
Value[0]: Level of spell in wand.
Value[1]: Max charges.
Value[2]: Charges left.
Value[3]: Spell in wand.

ITEM_STAFF (4)
Value[0]: Level of spell in staff.
Value[1]: Max charges.
Value[2]: Charges left.
Value[3]: Spell in staff.

ITEM_WEAPON (5)
Value[0]: 0
Value[1]: Number of die for damage.
Value[2]: Size of die for damage
Value[3]: The weapon type. Type is one of:

         NUMBER  CATEGORY   Message type
	    0  : Bludgeon      "smite/smites"
	    1  : Pierce        "stab/stabs"
            2  : Slash         "whip/whips"
            3  : Slash         "slash/slashes"
	    4  : Bludgeon      "smash/smashes"
	    5  : Slash         "cleave/cleaves"
            6  : Bludgeon      "crush/crushes"
            7  : Bludgeon      "pound/pounds"
	    8  : Mob           "claw/claws"
Feb  3 00:49 1995  wileydb.doc Page 15


	    9  : Mob           "bite/bites"
           10  : Mob           "sting/stings"
           11  : Pierce        "pierce/pierces"

ITEM_FIREWEAPON (6)

ITEM_MISSILE    (7)

ITEM_TREASURE   (8)

ITEM_ARMOR      (9)
Value[0]: Effective AC of armor.
Value[1]: Original AC of armor (before damage).
Value[2]: 0
Value[3]: 0

ITEM_POTION    (10)
Value[0]: Level of the spell in the potion.
Value[1]: Spell one.
Value[2]: Spell two.
Value[3]: Spell three.
  The values(1-3) are three (or less) different spells, mixed in the potion.
  Unused spells should be set to -1.

ITEM_WORN      (11)

ITEM_OTHER     (12)

ITEM_TRASH     (13)

ITEM_TRAP      (14)
value[0]: The effect of the trap.

  TRAP_EFF_MOVE     1  Movement trigger, must be used with TRAP_EFF_(dir).
  TRAP_EFF_OBJECT   2  Trigger on a get or put of this obj, or in its chest.
  TRAP_EFF_ROOM     4  Triggers affect all in the room.
  TRAP_EFF_NORTH    8  Used with TRAP_EFF_MOVE.
  TRAP_EFF_EAST    16  Used with TRAP_EFF_MOVE.
  TRAP_EFF_SOUTH   32  Used with TRAP_EFF_MOVE.
  TRAP_EFF_WEST    64  Used with TRAP_EFF_MOVE.
  TRAP_EFF_UP     128  Used with TRAP_EFF_MOVE.
  TRAP_EFF_DOWN   256  Used with TRAP_EFF_MOVE.

value[1]: What type of damage the trap does.

  TRAP_DAM_SLEEP    -3  Makes player sleep for 12 hours.  Save vs spell.
  TRAP_DAM_TELEPORT -2  Player is teleported.  Save vs petrification.
  TRAP_DAM_ENERGY   10  Energy damage.
Feb  3 00:49 1995  wileydb.doc Page 16


  TRAP_DAM_FIRE     26  Fire damage.
  TRAP_DAM_COLD    203  Cold damage.
  TRAP_DAM_ACID    206  Acid damage.
  TRAP_DAM_BLUNT   207  Blunt damage.
  TRAP_DAM_PIERCE  208  Piercing damage.
  TRAP_DAM_SLASH   209  Slashing damage.

value[2]: Level of the trap.  The higher the level, the larger the chance of 
          the trap being sprung.
value[3]: Charges on trap.

ITEM_CONTAINER (15)
Value[0]: Maximum weight the container can contain.
Value[1]: Container flags:

   CLOSEABLE 1
   PICKPROOF 2
   CLOSED    4
   LOCKED    8

Value[2]: The item-number of the object which can open the object. -1 means
          no lockability.
Value[3]: 0

ITEM_NOTE      (16)

ITEM_DRINKCON  (17)
Value[0]: Max drinks.
Value[1]: Number of drinks left.
Value[2]: The type of liquid in the drink-container, one of:

              Type           #      Drunkness   Fullness   Thirst
              LIQ_WATER      0      0           1           10
              LIQ_BEER       1      3           2           5
              LIQ_WINE       2      5           2           5
              LIQ_ALE        3      2           2           5
              LIQ_DARKALE    4      1           2           5
              LIQ_WHISKY     5      6           1           4
              LIQ_LEMONADE   6      0           1           8
              LIQ_FIREBRT    7      10          0           0
              LIQ_LOCALSPC   8      3           3           3
              LIQ_SLIME      9      0           4           -8
              LIQ_MILK       10     0           3           6
              LIQ_TEA        11     0           1           6
              LIQ_COFFE      12     0           1           6
              LIQ_BLOOD      13     0           2           -1
              LIQ_SALTWATER  14     0           1           -2
              LIQ_COKE       15     0           1           5
Feb  3 00:49 1995  wileydb.doc Page 17



Value[3]: If non-zero, the drink is poisoned.

ITEM_KEY       (18)
Value[0]: The key-type. This value must match the lock-type of the door.
Value[1]: 0 
Value[2]: 0
Value[3]: 0

ITEM_FOOD      (19)
Value[0]: The number of hours, that this food will fill the stomach.
Value[1]: 0
Value[2]: 0
Value[3]: If this value is non-zero, the food is poisoned.

ITEM_MONEY     (20)
Value[0]: The number of gold coins.
Value[1]: 0
Value[2]: 0
Value[3]: 0

ITEM_PEN       (21)

ITEM_BOAT      (22)

Spells for items:
  (The Y/N are stating whether that spell can be in that item.  The MIN_LEV
   is the minimum level for that item spell level in the item)

                                   POTION  SCROLL  WAND  STAFF   MIN_LEV
TYPE_UNDEFINED               -1      Y       Y      Y      Y        -
SPELL_RESERVED_DBC            0      N       N      N      N        -
SPELL_ARMOR                   1      Y       Y      Y      N        >0
SPELL_TELEPORT                2      Y       Y      Y      Y        >0
SPELL_BLESS                   3      Y       Y      Y      N        ...
SPELL_BLINDNESS               4      Y       Y      Y      Y
SPELL_BURNING_HANDS           5      N       N      N      N        == 5
SPELL_CALL_LIGHTNING          6      Y       Y      N      Y        >=12
SPELL_CHARM_PERSON            7      N       Y      N      Y
SPELL_CHILL_TOUCH             8      N       N      N      N        == 3
SPELL_CLONE                   9      Y       Y      Y      N
SPELL_COLOUR_SPRAY           10      N       Y      Y      N        ==11
SPELL_CONTROL_WEATHER        11      N       N      N      N
SPELL_CREATE_FOOD            12      N       Y      N      N
SPELL_CREATE_WATER           13      N       N      N      N
SPELL_CURE_BLIND             14      Y       N      N      Y
SPELL_CURE_CRITIC            15      Y       N      N      Y
SPELL_CURE_LIGHT             16      Y       N      N      Y
Feb  3 00:49 1995  wileydb.doc Page 18


SPELL_CURSE                  17      Y       Y      N      Y
SPELL_DETECT_EVIL            18      Y       N      N      Y
SPELL_DETECT_INVISIBLE       19      Y       N      N      Y
SPELL_DETECT_MAGIC           20      Y       N      N      Y
SPELL_DETECT_POISON          21      Y       Y      N      N
SPELL_DISPEL_EVIL            22      Y       Y      Y      Y       == 10
SPELL_EARTHQUAKE             23      N       Y      N      Y       == 7
SPELL_ENCHANT_WEAPON         24      N       Y      N      N
SPELL_ENERGY_DRAIN           25      Y       Y      Y      Y       == 13
SPELL_FIREBALL               26      N       Y      Y      N       == 15
SPELL_HARM                   27      Y       N      N      Y       == 15
SPELL_HEAL                   28      Y       N      N      Y
SPELL_INVISIBLE              29      Y       Y      Y      Y
SPELL_LIGHTNING_BOLT         30      N       Y      Y      N       == 9
SPELL_LOCATE_OBJECT          31      N       N      N      N
SPELL_MAGIC_MISSILE          32      N       Y      Y      N       == 1
SPELL_POISON                 33      Y       N      N      Y
SPELL_PROTECT_FROM_EVIL      34      Y       Y      Y      Y
SPELL_REMOVE_CURSE           35      Y       Y      N      Y
SPELL_SANCTUARY              36      Y       Y      N      Y
SPELL_SHOCKING_GRASP         37      N       N      N      N       == 7
SPELL_SLEEP                  38      Y       Y      Y      Y
SPELL_STRENGTH               39      Y       Y      N      Y
SPELL_SUMMON                 40      N       N      N      N
SPELL_VENTRILOQUATE          41      N       N      N      N
SPELL_WORD_OF_RECALL         42      Y       Y      Y      Y
SPELL_REMOVE_POISON          43      Y       N      N      Y
SPELL_SENCE_LIFE             44      Y       N      N      Y
SPELL_IDENTIFY               53     N       Y      N      N

<weight>:
  The weight of the item in pounds.

<value>:
  The value of the item if sold.

<cost/day>:
  The cost to store the item in the reception overnight.

<A>:
  This option is stating that the object has magical properties if it is
  held, worn or used by the player.  There can a maximum of two properties 
  to a object.

<location>:
  This is the area of the player that the obj will affect.

   APPLY_NONE           0  Do not use.
Feb  3 00:49 1995  wileydb.doc Page 19


   APPLY_STR            1  Positive aids while negative hinders strength.
   APPLY_DEX            2  Positive aids while negative hinders dexterity.
   APPLY_INT            3  Positive aids while negative hinders inteligence.
   APPLY_WIS            4  Positive aids while negative hinders wisdom.
   APPLY_CON            5  Positive aids while negative hinders constitution.
   APPLY_SEX	        6  Do not use.
   APPLY_CLASS	        7  Do not use.
   APPLY_LEVEL 	        8  Do not use.
   APPLY_AGE            9  Positive will age while negative makes young.
   APPLY_CHAR_WEIGHT   10  Positive adds wieght while negative takes away.
   APPLY_CHAR_HEIGHT   11  Positive adds hieght while negative takes away.
   APPLY_MANA	       12  Positive adds mana while negative takes away.
   APPLY_HIT           13  Positive adds HP while negative declines HP.
   APPLY_MOVE	       14  Positive adds move while negative declines move.
   APPLY_GOLD          15  Positive adds gold while negative declines gold.
   APPLY_EXP	       16  Do not use.
   APPLY_ARMOR         17  Negative numbers make a lower AC.
   APPLY_HITROLL       18  Bonus/penalty to hit the opponent.
   APPLY_DAMROLL       19  Bouns/penalty to damage the opponent.
   APPLY_SAVING_PARA   20  Positive number helps make saving throw.
   APPLY_SAVING_ROD    21  Positive number helps make saving throw.
   APPLY_SAVING_PETRI  22  Positive number helps make saving throw.
   APPLY_SAVING_BREATH 23  Positive number helps make saving throw.
   APPLY_SAVING_SPELL  24  Positive number helps make saving throw.
   APPLY_SAVE_ALL      25  Adjustment to all 5 saving throws
   APPLY_IMMUNE        26  Resistance to spell or weapon/spell type.
                            Imm_Fire    1
                            Imm_Cold    2
                    	    Imm_Elec    4
  			    Imm_Energy  8
  			    Imm_Blunt  16
  			    Imm_Pierce 32
  			    Imm_Slash  64
   APPLY_SUSC          27  Susceptable to a above weapon/spell type.
   APPLY_M_IMMUNE      28  Make totally immune to a above weapon/spell type.
   APPLY_SPELL_AFFECT  29  Makes a item use a spell. (above list)
   APPLY_WEAPON_SPELL  30  A weapon uses a spell upon each hit. (above list)
   APPLY_EAT_SPELL     31  Food contains a spell cast when eaten.
   APPLY_BACKSTAB      32  Positive aids skill while negative is a detriment.
   APPLY_KICK          33  Positive aids skill while negative is a detriment.
   APPLY_SNEAK         34  Positive aids skill while negative is a detriment.
   APPLY_HIDE          35  Positive aids skill while negative is a detriment.
   APPLY_BASH          36  Positive aids skill while negative is a detriment.
   APPLY_PICK          37  Positive aids skill while negative is a detriment.
   APPLY_STEAL         38  Positive aids skill while negative is a detriment.
   APPLY_TRACK         39  Positive aids skill while negative is a detriment.
   APPLY_HITNDAM       40  Bonus/penalty for both to_hit and damage.

Feb  3 00:49 1995  wileydb.doc Page 20


<modifier>:
  This is a negative or positive number following the <location>.

     A
     1 2

<E>:
  This option means that there will be a extra description.

<keyword_list>~:
  The words that are used to activate the extra descriptions buffer.

<extra_description>:
  The buffer that will print out if a player looks at one of the keywords.
  There must be a tilda on a line by itself following the description.

Example of a mobile:

#3001
punice baker~
Punice the baker~
The baker, Punice, looks at you calmly, wiping his hands on an apron.
~
  A fat, nice looking baker. But you can see that he has many scars on his
body.
~
2 0 900 W 2
15 2 2 15d8+170 1d4+4
-1 200 3000 1
8 8 1
Punice says, 'What can I get for you?".
~
~

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-= The zone file description:

Basic template of a zone file:

<#zone_number>
<zone_name>~
<top_room> <reset_time> <reset_mode>
<command> <if_flag> <parm1/command> <max_existing/state> <parm2/room>
S

What this mess means:

Feb  3 00:49 1995  wileydb.doc Page 21


<#zone_number>:
  This is the virtual_number of the zone.  The rooms that are part of this
  zone must match the <#zone_number>.  This number relates to objects and
  mobs as well.  The zone will work fastest if all the files that are being
  used inside a zone start with the zone number for their <#virtual_numbers>.

<zone_name>~:
  This is the name of the zone as it would appear in a table of all zones.
  There must be a tilda following the <zone_name>.

<top_room>:
  This is the largest <#virtual_number> of the rooms that are being loaded
  into this zone.

<reset_time>:
  This is the amount of time a zone will remain before it resets all the
  commands within its file.  This value is a number of minutes, usually
  between 30 minutes and a hour.  Zones that never reset have no need for
  a reset time, therefore this value can be placed at 0.

<reset_mode>:
  This field is a command: 0, 1, 2.  Any of those three numbers will tell 
  the zone file how the zone will reset.  They mean:

  0: Don't reset the zone at all. In this case, the age of the zone is never
     updated, and it will never be queued for reset. Thus, the value of the
     <reset_time> is effectively ignored.

  1: Reset the zone as soon as it is deserted, ie as soon as there are no
     players located within the zone.

  2: Reset the zone no matter who or what is in it.

<command> <if_flag> <parm1/command> <max_existing/state> <parm2/room>:
  These are a series of comands that tell the zone file what to do when it
  resets.  Each command has different parts so each will be handled 
  seperately.  The commands are:

  M: This command loads a mobile into a room.
       Format: M <if_flag> <mob_number> <max_existing> <room>

  <if_flag>:
    This is either 0, which means load the mobile no matter what.  Or 1, which
    means load the mobile only if the command before it was executed.  This
    stands true for all the commands in the zone file.  0 means load the
    command, 1 means load this command only if the previous was executed.

  <mob_number>:
Feb  3 00:49 1995  wileydb.doc Page 22


    This is the virtual number of the mobile to be loaded.

  <max_existing>:
    This field is the maximum number of mobs that the game will load in. Note
    that if you want more than one mobile in a room you must load each 
    individualy, with the <max_existing> equal to the total number of that
    which will be in the game.  This stands true for all the commands in
    the zone file.  This field must be the total amount that you want to be
    loaded into the game.
    
  <room>:
    This is the virtual number of the room to which the mob is loaded into.
 
  O: This command loads a object into a room.
       Format: O <if_flag> <obj_number> <max_existing> <room>

  <obj_number>:
    This is the virtual number of the object to be loaded.

  <room>:
    This is the room that the obj is to be loaded into.

  G: Give a obj to a mob.  This must be preceeded with the load of a mob.
       Format: G <if_flag> <obj_number> <max_existing>

  <obj_number>:
    This is the virtual number of the obj to be given.

  E: Equips a mob with a object.
       Format: E <if_flag> <obj_number> <max_existing> <equip_position>

  <obj_number>:
    The virtual number of the obj to be equipped.

  <equip_position>:
    This is the position to which the mob will be equiped with the item.  Make
    sure that the obj is able to be equiped in that position, or you will
    have boots loading in as worn on head.  Positions are:

      WEAR_LIGHT    0
      WEAR_FINGER_R 1
      WEAR_FINGER_L 2
      WEAR_NECK_1   3
      WEAR_NECK_2   4
      WEAR_BODY     5
      WEAR_HEAD     6
      WEAR_LEGS     7
      WEAR_FEET     8
Feb  3 00:49 1995  wileydb.doc Page 23


      WEAR_HANDS    9
      WEAR_ARMS    10
      WEAR_SHIELD  11
      WEAR_ABOUT   12
      WEAR_WAISTE  13
      WEAR_WRIST_R 14
      WEAR_WRIST_L 15
      WIELD        16
      HOLD         17
      WIELD_TWOH   18

  P: Loads one obj and puts it into another obj.
       Format: P <if_flag> <obj_number1> <max_existing> <obj_number2>

  <obj_number1>:
    This is the obj that will be put into <obj_number2>.

  <obj_number2>:
    This is the obj that will have <obj_number1> put into it.

  D: Sets the state of a door.
       Format: D <if_flag> <room> <exit_number> <state>

  <room>:
    This is the room that holds the door to be manipulated.

  <exit_number>:
    This is the exit number of the exit. (1-5)

  <state>:
    This field puts the door in one of the below states.

	0: Open.
	1: Closed.
	2: Closed and locked.

  R: Removes a obj from a room.
       Format: R <if_flag> <room> <obj_number>

  <room>:
    The room from which the obj is to be removed.

  <obj_number>:
    The virtual number of the obj to be removed.

  L: Led by, makes a mob the leader of others.

       This still needs a bit more work.
Feb  3 00:49 1995  wileydb.doc Page 24



  H/F: The hate/fear flags.  These will make a mob hate/fear something else.

       This still needs a bit more work.

Example of part of a zone:

#30
Shylar~
3099 15 2
M 0 3000 1 3001     * buck, the barkeep w/drinks
G 1 3000 1
G 1 3001 1
G 1 3002 1
G 1 3003 6
G 1 3004 1
M 0 3001 1 3010     * punice, the baker w/food
G 1 3010 7
G 1 3011 3
G 1 3012 3
M 0 3004 1 3012     * sass, the leatherworker w/leathers
G 1 3025 100
G 1 3026 100
G 1 3027 100
G 1 3028 100
G 1 3051 100
G 1 3052 100
G 1 3053 100
M 0 3005 1 3008     * butler
M 0 3018 5 3016     * small boys
M 0 3018 5 3002
M 0 3018 5 3002
M 0 3018 5 3015
M 0 3018 5 3005
S

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-= The design of shops.

Basic template of a shop:

<#virtual_number>~
<obj1_sold>
<obj2_sold>
<obj3_sold>
<obj4_sold>
<obj5_sold>
Feb  3 00:49 1995  wileydb.doc Page 25


<selling_profit>
<buying_profit>
<obj1_traded>
<obj2_traded>
<obj3_traded>
<obj4_traded>
<obj5_traded>
<keeper_message1>~
<keeper_message2>~
<keeper_message3>~
<keeper_message4>~
<keeper_message5>~
<keeper_message6>~
<keeper_message7>~
<temper1>
<temper2>
<keeper_mob_number>
0
<room>
<open1>
<close1>
<open2>
<close2>

What this means:

<#virtual_number>~:
  This is the number of the shop.  This must be followed by a tilda.

<obj1_sold> <obj2_sold> <obj3_sold> <obj4_sold> <obj5_sold>:
  These are objs that the shop will sell and never run out of.  You must give
  the shop keeper the obj in the zone file when loading.  These fields refer
  to the virtual numbers of the objs.  There can only be five items that
  the shop will sell and never run out of.  Other objs can be given to the
  shopkeeper and he will sell just one of them.

<selling_prof>:
  The object value is multiplied by this value when sold. This is a
  floating point value. Must be >= 1.0

<buying_prof>:
  The object value is multiplied by this value when bought. This is a
  floating point value. Must be <= 1.0

<obj1_traded> <obj2_traded> <obj3_traded> <obj4_traded> <obj5_traded>:
  These are the ITEM_TYPE's that the shop will buy.  There can only be five
  different types.

Feb  3 00:49 1995  wileydb.doc Page 26


<keeper_message1>~:
  Message when item to buy is non existing.  A %s must be at the beginning
  of this field to signify the shopkeeper will be talking.  The %s applies
  for message fields 1 - 7.  %d symbolizes the coin for the item.

<keeper_message2>~:
  Message when item trying to sell is non existing.

<keeper_message3>~:
  Message when wrong item-type sold.

<keeper_message4>~:
  Message when shop can't afford item.

<keeper_message5>~:
  Message when player can't afford item.

<keeper_message6>~:
  Message when buying an item.  The price is %d.

<keeper_message7>~:
  Message when selling an item.  The price is %d.

<temper1>:
  When player can't afford an item.
    0: The shopkeeper spits player in the face.
    1: The shopkeeper smokes his joint.

<temper2>:
  When player is attempting a to kill a shopkeeper.
    0: Shopkeeper tells player "Don't ever try that again!" and gets the
       first hit!
    1: Shopkeeper tells player "I'm to powerfull for you - midget!" and 
       killing is impossible.

<keeper_mob_number>:
  Virtual number of the shopkeeper.

<room>:
  The virtual number of the room the mobile must be in for the shop to be
  effective.

<open1>:
  The time which the shop opens.  Use a 0 for this field.

<close1>:
  The time which the shop closes.  If you use 28 for this field, the shop is
  open all the time, never closes.
Feb  3 00:49 1995  wileydb.doc Page 27



<open2>:
  Use a 0 for this field.

<close2>:
  Use a 0 for this field.

Example of a shop:

#0~
3000
3001
3002
3003
3004
1.5
0.5
0
0
0
0
0
%s Don't mix that here pup.~
%s You don't even have that pup.~
%s This is a bar pup, only drinks here.~
%s A might to expensive for me pup.~
%s This is a little out of your league pup.~
%s Thanks for the %d coins pup.~
%s I think %d coins is just a bit much, but i'll do it pup.~
2
0
3000
0
3001
0
28
0
0

