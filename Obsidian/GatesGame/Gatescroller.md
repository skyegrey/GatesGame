
#### Intro

You've probably seen these mobile game ads before, and maybe you were like me and even thought that they looked sorta fun. Were not talking game of the year material, but it looks like it could at least hold my attention while I was on the train or something.

So, perhaps you go to download the game and before you even can, your bombarded with ads and microtransactions. Wow 999 for only $10? But 999 is normally $11 dollars.

Even if you make it through all that and you do manage to download the game, turns out the its just... some random clash of clans city builder? Is the zombie bridge even real?


![[Pasted image 20250916215006.png]]

Uh No (kinda...) 

All this did have me thinking though, I'm a game developer, if they don't want me to play their game, maybe I could just...

#### Part 1 - Making the game -> this needs music or the joke doesn't land at all jfc

##### Overview
Okay, so to start off, this game has about 3 things going for it. 
1. The character, you can basically just move them back and fourth and they just kind of fire their weapon for you
	1. For our character, we can use this asset that I bought a while ago. It has a few animations for shooting & some special attacks.
	2. And as for why its a centaur, no particular reason.
![[Umamusume_Pretty_Derby_game_cover.jpg]]
2. The enemies. They seem to just sorta randomly run down the screen at you and sometimes a big one appears.
	1. For our normal enemies, I have this little goblin guy, and we can use this bigger one to be our boss at the end of the level. 
3. Finally, we have the gates. I've seen some games where there is a + or -, and sometimes you can even shoot the gates to make the number go up, so we'll throw all that in too.





And thats about it! Lets dive into the code.
##### Development
First things first, we need some code to let us move our player up and down, so I added in this script and now we can move around. 

Next up I added in some logic to spawn a bunch of enemies `clip of spawning breaking idk where that vod is though` which went a bit overboard, so with some tuning we're ready to go. 

Next we can move on to making the gates. We add in a hitbox, and some logic to spawn in new team members when you walk through the gate. 

Throw in some path for the character to run on, give us some clouds in the background, hit it all with some *paralax* and that's all set. 

Finally, we need the boss character. I'll use this as sort of an end-of-the-level dps check to see if you picked up enough characters. I even added some animations and different attacks to make it a bit more interactive, here you can see they charge up to attack, then jump back to `clip of goblin boss falling through the floor 6/13 vod I think` ah yeah turns out I haven't made the floor yet so they just kinda kept going, so I made the floor be made out of floor, and everything seems to be working.

And that's pretty much it! Now I can finally sit back, relax, and enjoy my mobile slop game. 

There is however just one small problem -- the uh, the game isn't very fun.

#### Part 2 - Making the game more fun

If I know anything about making games (I don't) its that if you want to make your game more fun, simply give the player some choose from 3 things gameplay. So before we can ship this, add microtransactions, loot boxes, in game purchases, an energy system, and rewarded and banner ads, we need to make some cards. 

I threw together some really simple boxes that you can click on, added a few icons for some powerups and added a few abilities. 

We have multishot, a spreading shot, faster gate spawning, gate shooting, and two alternate firing modes -- spring rain and this cool tornado thing. 

Since we the player are leveling up as we go, I added in some logic to make the game get slightly harder after each level too, so you have to glue together some sort of build to progress. 

And with that, the game is ready to go. 

#### Part 3 Outro













![[Pasted image 20250916214416.png]]

By Cygames, Inc. - Original publication: SteamImmediate source: https://store.steampowered.com/app/3224770/Umamusume_Pretty_Derby/, Fair use, https://en.wikipedia.org/w/index.php?curid=80777957