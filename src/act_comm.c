/*
 * file: act.comm.c , Implementation of commands.         Part of DIKUMUD
 * Usage : Communication.
 * Copyright (C) 1990, 1991 - see 'license.doc' for complete information.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>

#include "global.h"
#include "bug.h"
#include "utils.h"
#include "comm.h"
#include "interpreter.h"
#include "handler.h"
#include "db.h"
#include "spells.h"
#include "constants.h"
#define _ACT_COMM_C
#include "act_comm.h"

void do_say(struct char_data *ch, char *argument, int cmd)
{
  register int i;
  char buf[MAX_INPUT_LENGTH + 40];

  if (DEBUG)
    dlog("do_say");
  for (i = 0; *(argument + i) == ' '; i++);

  if (!*(argument + i))
    send_to_char("usage: say <mesg>.\n\r", ch);
  else {
    switch(argument[strlen(argument)-1]) {
      case '!':
        sprintf(buf, "$n exclaims '%s'", argument + i);
        act(buf, FALSE, ch, 0, 0, TO_ROOM);
        if (IS_NPC(ch) || (IS_SET(ch->specials.act, PLR_ECHO))) {
          cprintf(ch, "You exclaim '%s'\n\r", argument + i);
        }
        break;
      case '?':
        sprintf(buf, "$n asks '%s'", argument + i);
        act(buf, FALSE, ch, 0, 0, TO_ROOM);
        if (IS_NPC(ch) || (IS_SET(ch->specials.act, PLR_ECHO))) {
          cprintf(ch, "You ask '%s'\n\r", argument + i);
        }
        break;
      default:
        sprintf(buf, "$n says '%s'", argument + i);
        act(buf, FALSE, ch, 0, 0, TO_ROOM);
        if (IS_NPC(ch) || (IS_SET(ch->specials.act, PLR_ECHO))) {
          cprintf(ch, "You say '%s'\n\r", argument + i);
        }
        break;
    }
  }
}

void do_shout(struct char_data *ch, char *argument, int cmd)
{
  char buf1[MAX_INPUT_LENGTH + 40];
  struct descriptor_data *i;
  struct room_data *rp, *mrp;
  struct room_direction_data *exitp;
  struct char_data *v;
  int x;

  if (DEBUG)
    dlog("do_shout");

  if (IS_SET(ch->specials.act, PLR_NOSHOUT)) {
    send_to_char("You can't shout!!\n\r", ch);
    return;
  }
  for (; *argument == ' '; argument++);

  if (ch->master && IS_AFFECTED(ch, AFF_CHARM)) {
    send_to_char("You pet is trying to shout....", ch->master);
    return;
  }
  if (!(*argument))
    send_to_char("usage: shout <mesg>.\n\r", ch);
  else {
    sprintf(buf1, "$n shouts '%s'", argument);

    if(IS_IMMORTAL(ch) || IS_NPC(ch)) {
      cprintf(ch, "You shout '%s'\n\r", argument);
      for (i = descriptor_list; i; i = i->next)
        if (i->character != ch && !i->connected &&
	    !IS_SET(i->character->specials.act, PLR_NOSHOUT) &&
	    !IS_SET(i->character->specials.act, PLR_DEAF))
	  act(buf1, 0, ch, 0, i->character, TO_VICT);
    } else {
#ifdef OLD_SHOUT
      if(GET_MOVE(ch) < (GET_MAX_MOVE(ch) / 10)) {
        cprintf(ch, "You are just too tired to shout anything.\n\r");
        return;
      }
      if(GET_MANA(ch) < (GET_MAX_MANA(ch) / 15)) {
        cprintf(ch, "You can't seem to summon the energy to shout.\n\r");
        return;
      }
      if(GET_COND(ch, THIRST) < 4) {
        cprintf(ch, "Your throat is too dry to shout anything!\n\r");
        return;
      }
      GET_MOVE(ch) -= (GET_MAX_MOVE(ch) / 10);
      GET_MANA(ch) -= (GET_MAX_MANA(ch) / 15);
      GET_COND(ch, THIRST) -= 4;
      if (IS_SET(ch->specials.act, PLR_ECHO))
        cprintf(ch, "You shout '%s'\n\r", argument);
      for (i = descriptor_list; i; i = i->next)
        if (i->character != ch && !i->connected &&
	    !IS_SET(i->character->specials.act, PLR_NOSHOUT) &&
	    !IS_SET(i->character->specials.act, PLR_DEAF) &&
            (rp= real_roomp(i->character->in_room)) &&
            (mrp= real_roomp(ch->in_room)))
	  act(buf1, 0, ch, 0, i->character, TO_VICT);
#endif
#ifdef ZONE_SHOUT
      if(GET_MOVE(ch) < (GET_MAX_MOVE(ch) / 10)) {
        cprintf(ch, "You are just too tired to shout anything.\n\r");
        return;
      }
      if(GET_MANA(ch) < (GET_MAX_MANA(ch) / 15)) {
        cprintf(ch, "You can't seem to summon the energy to shout.\n\r");
        return;
      }
      if(GET_COND(ch, THIRST) < 4) {
        cprintf(ch, "Your throat is too dry to shout anything!\n\r");
        return;
      }
      GET_MOVE(ch) -= (GET_MAX_MOVE(ch) / 10);
      GET_MANA(ch) -= (GET_MAX_MANA(ch) / 15);
      GET_COND(ch, THIRST) -= 4;
      if (IS_SET(ch->specials.act, PLR_ECHO))
        cprintf(ch, "You shout '%s'\n\r", argument);
      for (i = descriptor_list; i; i = i->next)
        if (i->character != ch && !i->connected &&
	    !IS_SET(i->character->specials.act, PLR_NOSHOUT) &&
	    !IS_SET(i->character->specials.act, PLR_DEAF) &&
            (rp= real_roomp(i->character->in_room)) &&
            (mrp= real_roomp(ch->in_room)) &&
            (rp->zone == mrp->zone))
	  act(buf1, 0, ch, 0, i->character, TO_VICT);
#endif
#ifdef RADIUS_SHOUT
/* This is a buggy... it corrupts memory someplace */
      if(!(mrp= real_roomp(ch->in_room))) {
        cprintf(ch, "You are not in reality... this is bad.\n\r");
        return;
      }
      for(v= mrp->people; v; v= v->next_in_room)
        if (v != ch && v->desc &&
	    !IS_SET(v->specials.act, PLR_NOSHOUT) &&
	    !IS_SET(v->specials.act, PLR_DEAF))
	  act(buf1, 0, ch, 0, v, TO_VICT);
      for(x= 0; x< MAX_NUM_EXITS; x++)
        if((exitp= EXIT(ch, x)) && exit_ok(exitp, mrp))
          if((rp= real_roomp(exitp->to_room)) && (rp != mrp)) {
            sprintf(buf1, "$n shouts %s '%s'", dir_from[rev_dir[x]], argument);
            for(v= rp->people; v; v= v->next_in_room)
              if (v != ch && v->desc &&
	          !IS_SET(v->specials.act, PLR_NOSHOUT) &&
	          !IS_SET(v->specials.act, PLR_DEAF))
	        act(buf1, 0, ch, 0, v, TO_VICT);
          }
#endif
    }
  }
}

void do_commune(struct char_data *ch, char *argument, int cmd)
{
  static char buf1[MAX_INPUT_LENGTH];
  struct descriptor_data *i;

  if (DEBUG)
    dlog("do_commune");

  for (; *argument == ' '; argument++);

  if (!(*argument))
    send_to_char("Communing among the gods is fine, but WHAT?\n\r", ch);
  else {
    if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO)) {
      sprintf(buf1, "You wiz : '%s'\n\r", argument);	/*part of wiznet */
      send_to_char(buf1, ch);
    }
    sprintf(buf1, "$n : '%s'", argument);	/* this is part of wiz */

    for (i = descriptor_list; i; i = i->next)
      if (i->character != ch && !i->connected &&
	  !IS_SET(i->character->specials.act, PLR_NOSHOUT) &&
	  (GetMaxLevel(i->character) >= LOW_IMMORTAL))
	act(buf1, 0, ch, 0, i->character, TO_VICT);
  }
}

void do_tell(struct char_data *ch, char *argument, int cmd)
{
  struct char_data *vict;
  char name[100], message[MAX_INPUT_LENGTH + 20];

  if (DEBUG)
    dlog("do_tell");
  half_chop(argument, name, message);

  if (!*name || !*message) {
    send_to_char("usage: tell <who> <mesg>.\n\r", ch);
    return;
  }
  if (!(vict = get_char_vis(ch, name))) {
    send_to_char("No-one by that name here..\n\r", ch);
    return;
  }
  if (ch == vict) {
    send_to_char("You try to tell yourself something.\n\r", ch);
    return;
  }
  if (GET_POS(vict) == POSITION_SLEEPING) {
    act("$E is asleep, shhh.", FALSE, ch, 0, vict, TO_CHAR);
    return;
  }
  if (IS_NPC(vict) && !(vict->desc)) {
    send_to_char("No-one by that name here..\n\r", ch);
    return;
  }
  if (!vict->desc) {
    send_to_char("They can't hear you, link dead.\n\r", ch);
    return;
  }
  if (IS_SET(vict->specials.new_act, NEW_PLR_NOTELL) && IS_MORTAL(ch)) {
    send_to_char("They are not recieving tells at the moment.\n\r", ch);
    return;
  }
  switch(message[strlen(message)-1]) {
    case '!':
      cprintf(vict, "%s exclaims to you '%s'\n\r", NAME(ch), message);
      if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO))
        cprintf(ch, "You exclaim to %s '%s'\n\r", NAME(vict), message);
      break;
    case '?':
      cprintf(vict, "%s asks you '%s'\n\r", NAME(ch), message);
      if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO))
        cprintf(ch, "You ask %s '%s'\n\r", NAME(vict), message);
      break;
    default:
      cprintf(vict, "%s tells you '%s'\n\r", NAME(ch), message);
      if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO))
        cprintf(ch, "You tell %s '%s'\n\r", NAME(vict), message);
      break;
  }
}

void do_whisper(struct char_data *ch, char *argument, int cmd)
{
  struct char_data *vict;
  char name[100], message[MAX_INPUT_LENGTH], buf[MAX_INPUT_LENGTH];

  if (DEBUG)
    dlog("do_whisper");
  half_chop(argument, name, message);

  if (!*name || !*message)
    send_to_char("Who do you want to whisper to.. and what??\n\r", ch);
  else if (!(vict = get_char_room_vis(ch, name)))
    send_to_char("No-one by that name here..\n\r", ch);
  else if (vict == ch) {
    act("$n whispers quietly to $mself.", FALSE, ch, 0, 0, TO_ROOM);
    send_to_char
      ("You can't seem to get your mouth close enough to your ear...\n\r", ch);
  } else {
    sprintf(buf, "$n whispers to you, '%s'", message);
    act(buf, FALSE, ch, 0, vict, TO_VICT);
    if (IS_NPC(ch) || (IS_SET(ch->specials.act, PLR_ECHO))) {
      sprintf(buf, "You whisper to %s, '%s'\n\r",
      (IS_NPC(vict) ? vict->player.name : GET_NAME(vict)), message);
      send_to_char(buf, ch);
    }
    act("$n whispers something to $N.", FALSE, ch, 0, vict, TO_NOTVICT);
  }
}

void do_ask(struct char_data *ch, char *argument, int cmd)
{
  struct char_data *vict;
  char name[100], message[MAX_INPUT_LENGTH], buf[MAX_INPUT_LENGTH];

  if (DEBUG)
    dlog("do_ask");
  half_chop(argument, name, message);

  if (!*name || !*message)
    send_to_char("Who do you want to ask something.. and what??\n\r", ch);
  else if (!(vict = get_char_room_vis(ch, name)))
    send_to_char("No-one by that name here..\n\r", ch);
  else if (vict == ch) {
    act("$n quietly asks $mself a question.", FALSE, ch, 0, 0, TO_ROOM);
    send_to_char("You think about it for a while...\n\r", ch);
  } else {
    sprintf(buf, "$n asks you '%s'", message);
    act(buf, FALSE, ch, 0, vict, TO_VICT);

    if (IS_NPC(ch) || (IS_SET(ch->specials.act, PLR_ECHO))) {
      sprintf(buf, "You ask %s, '%s'\n\r",
      (IS_NPC(vict) ? vict->player.name : GET_NAME(vict)), message);
      send_to_char(buf, ch);
    }
    act("$n asks $N a question.", FALSE, ch, 0, vict, TO_NOTVICT);
  }
}

void do_write(struct char_data *ch, char *argument, int cmd)
{
  struct obj_data *paper = 0, *pen = 0;
  char papername[MAX_INPUT_LENGTH], penname[MAX_INPUT_LENGTH],
       buf[MAX_STRING_LENGTH];

  if (DEBUG)
    dlog("do_write");
  argument_interpreter(argument, papername, penname);

  if (!ch->desc)
    return;

  if (!*papername) {		       /* nothing was delivered */
    send_to_char("write (on) papername (with) penname.\n\r", ch);
    return;
  }
  if (!*penname) {
    send_to_char("write (on) papername (with) penname.\n\r", ch);
    return;
  }
  if (!(paper = get_obj_in_list_vis(ch, papername, ch->carrying))) {
    sprintf(buf, "You have no %s.\n\r", papername);
    send_to_char(buf, ch);
    return;
  }
  if (!(pen = get_obj_in_list_vis(ch, penname, ch->carrying))) {
    sprintf(buf, "You have no %s.\n\r", penname);
    send_to_char(buf, ch);
    return;
  }
  /* ok.. now let's see what kind of stuff we've found */
  if (pen->obj_flags.type_flag != ITEM_PEN) {
    act("$p is no good for writing with.", FALSE, ch, pen, 0, TO_CHAR);
  } else if (paper->obj_flags.type_flag != ITEM_NOTE) {
    act("You can't write on $p.", FALSE, ch, paper, 0, TO_CHAR);
  } else if (paper->action_description) {
    send_to_char("There's something written on it already.\n\r", ch);
    return;
  } else {
    /* we can write - hooray! */
    send_to_char
      ("Ok.. go ahead and write.. end the note with a @.\n\r", ch);
    act("$n begins to jot down a note.", TRUE, ch, 0, 0, TO_ROOM);
    ch->desc->str = &paper->action_description;
    ch->desc->max_str = MAX_NOTE_LENGTH;
  }
}

void do_group_tell(struct char_data *ch, char *arguement, int cmd)
{
  struct char_data *k, *vict;
  struct follow_type *f;

  char name[100], message[MAX_INPUT_LENGTH + 20], buf[MAX_INPUT_LENGTH + 20];

  if (DEBUG)
    dlog("do_group_tell");
  if (!*arguement) {
    send_to_char("usage: gtell <mesg>.\n\r", ch);
    return;
  }
  if (!IS_AFFECTED(ch, AFF_GROUP)) {
    send_to_char("But you are a member of no group?!\n\r", ch);
    return;
  }
  if (GET_POS(ch) == POSITION_SLEEPING) {
    send_to_char("You are to tired to do this....\n\r", ch);
    return;
  }
  if (!ch->master)
    k = ch;
  else {
    /* tell the leader of the group */

    k = ch->master;
    if (IS_AFFECTED(k, AFF_GROUP)) {
      if ((GET_POS(k) != POSITION_SLEEPING) && (k->desc) && (k != ch)) {
	sprintf(buf, "%s tells the group '%s'\n\r",
		(IS_NPC(ch) ? ch->player.short_descr : GET_NAME(ch)), arguement);
	send_to_char(buf, k);
      }
    }
  }

  /* tell the followers of the group and exclude ourselfs */

  for (f = k->followers; f; f = f->next) {
    vict = f->follower;
    if (IS_AFFECTED(vict, AFF_GROUP)) {
      if ((GET_POS(vict) != POSITION_SLEEPING) &&
	  (vict->desc) &&
	  (vict != ch)) {
	sprintf(buf, "%s tells the group '%s'\n\r",
		(IS_NPC(ch) ? ch->player.short_descr : GET_NAME(ch)), arguement);
	send_to_char(buf, vict);
      }
    }
  }

  if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO)) {
    sprintf(buf, "You tell the group '%s'\n\r", arguement);
    send_to_char(buf, ch);
  }
}

void do_group_report(struct char_data *ch, char *arguement, int cmd)
{
  struct char_data *k, *vict;
  struct follow_type *f;

  char name[100], message[MAX_INPUT_LENGTH + 20], buf[MAX_INPUT_LENGTH + 20];

  if (DEBUG)
    dlog("do_group_report");

  if (!IS_AFFECTED(ch, AFF_GROUP)) {
    send_to_char("But you are a member of no group?!\n\r", ch);
    return;
  }
  if (GET_POS(ch) == POSITION_SLEEPING) {
    send_to_char("You are to tired to do this....\n\r", ch);
    return;
  }
  sprintf(message,
	  "\n\rGroup Report from:Name:%s Hits:%d(%d) Mana:%d(%d) Move:%d(%d)",
	  GET_NAME(ch),
	  GET_HIT(ch),
	  GET_MAX_HIT(ch),
	  GET_MANA(ch),
	  GET_MAX_MANA(ch),
	  GET_MOVE(ch),
	  GET_MAX_MOVE(ch));

  if (!ch->master)
    k = ch;
  else {
    /* tell the leader of the group */

    k = ch->master;
    if (IS_AFFECTED(k, AFF_GROUP)) {
      if ((GET_POS(k) != POSITION_SLEEPING) && (k->desc) && (k != ch)) {
	send_to_char(message, k);
      }
    }
  }

  /* tell the followers of the group and exclude ourselfs */

  for (f = k->followers; f; f = f->next) {
    vict = f->follower;
    if (IS_AFFECTED(vict, AFF_GROUP)) {
      if ((GET_POS(vict) != POSITION_SLEEPING) &&
	  (vict->desc) &&
	  (vict != ch)) {
	send_to_char(message, vict);
      }
    }
  }

  if (IS_NPC(ch) || IS_SET(ch->specials.act, PLR_ECHO)) {
    sprintf(buf, "You tell the group your stats.\n\r", arguement);
    send_to_char(buf, ch);
  }
}

void do_split(struct char_data *ch, char *arguement, int cmd)
{
  struct char_data *k, *vict;
  struct follow_type *f;
  char blah[256];
  int amount, count, i, share;
  char buf[512];

  if (DEBUG)
    dlog("do_split");
  if (!IS_AFFECTED(ch, AFF_GROUP)) {
    send_to_char("You are a member of no group!\n\r", ch);
    return;
  }
  if (ch->master) {
    send_to_char("You must be the leader of the group to use this.\n\r", ch);
    return;
  }
  one_argument(arguement, blah);

  if (!is_number(blah)) {
    send_to_char("You must supply an integer amount.\n\r", ch);
    return;
  }
  amount = atoi(blah);
  if (amount > GET_GOLD(ch)) {
    send_to_char("You do not have that much gold.\n\r", ch);
    return;
  }
  GET_GOLD(ch) -= amount;
  count = 1;

  for (f = ch->followers; f; f = f->next) {
    vict = f->follower;
    if (IS_AFFECTED(vict, AFF_GROUP)) {
      if ((vict->desc) && (vict != ch))
	count++;
    }
  }

  share = amount / count;
  GET_GOLD(ch) += share;

  sprintf(buf, "You split the gold into shares of %d coin(s)\n\r", share);
  send_to_char(buf, ch);

  for (f = ch->followers; f; f = f->next) {
    vict = f->follower;
    if (IS_AFFECTED(vict, AFF_GROUP)) {
      if ((vict->desc) && (vict != ch)) {
	sprintf(buf, "%s gives you %d coins.\n\r",
	(IS_NPC(ch) ? ch->player.short_descr : GET_NAME(ch)), share);
	send_to_char(buf, vict);
	GET_GOLD(vict) += share;
      }
    }
  }
}

void do_land(struct char_data *ch, char *arg, int cmd)
{
  if (DEBUG)
    dlog("do_land");
  if (IS_NOT_SET(ch->specials.affected_by, AFF_FLYING)) {
    send_to_char("But you are not flying?\n\r", ch);
    return;
  }
  act("$n slowly lands on the ground.", FALSE, ch, 0, 0, TO_ROOM);

  if (affected_by_spell(ch, SPELL_FLY))
    affect_from_char(ch, SPELL_FLY);
  if (IS_SET(ch->specials.affected_by, AFF_FLYING))
    REMOVE_BIT(ch->specials.affected_by, AFF_FLYING);

  send_to_char("You feel the extreme pull of gravity...\n\r", ch);
}

void do_invis_off(struct char_data *ch, char *arg, int cmd)
{
  if (DEBUG)
    dlog("do_invis_off");
  if (!IS_SET(ch->specials.affected_by, AFF_INVISIBLE)) {
    send_to_char("But you are not invisible?\n\r", ch);
    return;
  }
  act("$n slowly fades into existence.", FALSE, ch, 0, 0, TO_ROOM);
  act("You feel exposed.", FALSE, ch,0,0,TO_CHAR);

  if (affected_by_spell(ch, SPELL_INVISIBLE))
    affect_from_char(ch, SPELL_INVISIBLE);

  if (IS_SET(ch->specials.affected_by, AFF_INVISIBLE))
    REMOVE_BIT(ch->specials.affected_by, AFF_INVISIBLE);
}
