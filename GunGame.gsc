#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;

init() // entry point
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");

        flag_wait("initial_blackscreen_passed");

        if (getDvar("mapname") == "zm_transit") self thread startGamemode();
        else iprintln("^1Gun Game Not Supported On This Map");
    }
}


startGamemode() // TODO: Add code for being demoted, add code to check which map the player is in
{
    self iprintlnbold("^2Gun Game Created By Electro Games, Good Luck!");

    level.weaponList = [];
    level.weaponList[1] = "raygun_mark2_zm";
    level.weaponList[2] = "ray_gun_zm";
    level.weaponList[3] = "galil_zm";
    level.weaponList[4] = "hamr_zm";
    level.weaponList[5] = "rpd_zm";
    level.weaponList[6] = "usrpg_zm";
    level.weaponList[7] = "m32_zm"; // War Machine
    level.weaponList[8] = "python_zm";
    level.weaponList[9] = "judge_zm";
    level.weaponList[10] = "ak74u_zm";
    level.weaponList[11] = "tar21_zm";
    level.weaponList[12] = "m16_zm";
    level.weaponList[13] = "xm8_zm"; // M8a1
    level.weaponList[14] = "srm1216_zm"; // M1216
    level.weaponList[15] = "870mcs_zm"; // Remington Shotgun
    level.weaponList[16] = "dsr50_zm";
    level.weaponList[17] = "barretm82_zm";
    level.weaponList[18] = "type95_zm";
    level.weaponList[19] = "qcw05_zm"; // Chicom
    level.weaponList[20] = "saiga12_zm"; // S12
    level.weaponList[21] = "mp5k_zm";
    level.weaponList[22] = "fnfal_zm";
    level.weaponList[23] = "kard_zm"; // Kap 40
    level.weaponList[24] = "beretta93r_zm"; // 57 burst pistol
    level.weaponList[25] = "fivesevendw_zm";
    level.weaponList[26] = "fiveseven_zm";
    level.weaponList[27] = "rottweil72_zm"; // Olympia
    level.weaponList[28] = "saritch_zm";
    level.weaponList[29] = "m14_zm";
    level.weaponList[30] = "knife_ballistic_zm";
    level.weaponList[31] = "m1911_zm";
    
    self thread giveGun(31);

    gunsRemaining = 30;
    gunCost = 1000;
    nextGun = self.score + gunCost;
    previousScore = self.score;
    self.currentGun = "";
    gameEnded = false;

    self.nextGunText = createfontstring("Objective", 1.5);
    self.nextGunText setPoint("LEFT", "CENTER", -418, 10);

    self.gunsRemainingText = createfontstring("Objective", 1.5);
    self.gunsRemainingText setPoint("LEFT", "CENTER", -418, -10);
	
	self.nextGunText setPoint("LEFT", "CENTER", -2000, 10);
	self.gunsRemainingText setPoint("LEFT", "CENTER", -2000, -10);

    while (!gameEnded)
    {
        self endon("disconnect");
        if (self.score < previousScore) nextGun -= (previousScore-self.score);
        previousScore = self.score;

        if (gunsRemaining == 0 && !gameEnded && (nextGun - self.score) <= 0)
        {
            gameEnded = true;
            self iprintlnbold("^2Congratulations, You Have Completed Gun Game!");
            //level notify("end_game");
        }
        else if ((nextGun - self.score) <= 0)
        {
            self iprintlnbold("^2PROMOTED");
            self thread giveGun(gunsRemaining);
            gunsRemaining--;

            gunsRemainingLastNum = (gunsRemaining%10);
            if (gunsRemainingLastNum == 0 || gunsRemainingLastNum == 5) gunCost += 500;

            nextGun = self.score + gunCost;
        }

        currentweapon = self getcurrentweapon();
        if (currentweapon != self.currentGun &&
        currentWeapon != "zombie_perk_bottle_additionalprimaryweapon" &&
        currentWeapon != "zombie_perk_bottle_cherry" &&
        currentWeapon != "zombie_perk_bottle_deadshot" &&
        currentWeapon != "zombie_perk_bottle_doubletap" &&
        currentWeapon != "zombie_perk_bottle_jugg" &&
        currentWeapon != "zombie_perk_bottle_marathon" &&
        currentWeapon != "zombie_perk_bottle_nuke" &&
        currentWeapon != "zombie_perk_bottle_revive" &&
        currentWeapon != "zombie_perk_bottle_sleight" &&
        currentWeapon != "zombie_perk_bottle_tombstone" &&
        currentWeapon != "zombie_perk_bottle_vulture" &&
        currentWeapon != "zombie_perk_bottle_whoswho") self thread giveGun(gunsRemaining+1);
        self givemaxammo( currentWeapon );

        //self setWeaponAmmoClip("frag_grenade", 0);
        //self setWeaponAmmoStock("frag_grenade", 0);
        //self setWeaponAmmoClip("monkey_bomb", 0);
        //self setWeaponAmmoStock("monkey_bomb", 0);
        //self setWeaponAmmoClip("semtex_grenade", 0);
        //self setWeaponAmmoStock("semtex_grenade", 0);
        //self setWeaponAmmoClip("claymoremine_projectile", 0);
        //self setWeaponAmmoStock("claymoremine_projectile", 0);

        self.nextGunText.label = &"Next Gun: ^3";
        self.nextGunText setValue(nextGun - self.score);

        self.gunsRemainingText.label = &"Guns Left: ^3";
        self.gunsRemainingText setValue(gunsRemaining);
        wait 0.05;
    }
}

giveGun(gun)
{
    gunName = level.weaponList[gun];
    self takeallweapons();
    self giveWeapon(gunName);
    self switchToWeapon(gunName);
    self.currentGun = gunName;
}
