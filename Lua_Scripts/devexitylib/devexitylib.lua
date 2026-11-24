--[[
#Script Name:   <devexitylib.lua>
# Description:  <Unified RS3 helper library: utilities, waits, state, interfaces, entities, walking, dialog, sessions, GUI, prayers, necromancy, lodestones, bank, herblore, vendored Spectre libs and data tables>
# Autor:        <Devexity>
# Version:      <1.2.0>
# Datum:        <2026.11.23>

CREDITS — code in this file from other authors (see each SECTION header):

  * DX.Bank        - "Bank Toolbox" v1.2.0 by Spectre011 (+ local bugfixes)
  * DX.Quest       - quest.lua v1.1.0 by Spectre011
  * DX.Spectre     - spectre.lua v1.0 by Spectre011
  * DX.Slib        - slib.lua v1.0.17 by Spectre011
                     github.com/spectre011-code/Public-ME-Scripts (MIT license)
                     Discord: not_spectre011
  * DX.PlayerManager - player_manager.lua v1.2.4 by Sonson
                     github.com/sonsonmagro/Sonsons-Player-Manager
                     (re-adds status dispatch upstream removed; see section header)

Everything else in this file is original Devexity work. Vendored sections are
kept as close to upstream as possible; our modifications are noted at each
section header so fixes stay easy to re-apply on upstream updates.
--]]

local API = require("api")
local DX = {}

DX.VERSION = "1.2.0"
DX.API = API

math.randomseed(os.time())

DX.Data = {}

DX.Data.Ores = {
    COPPER = 436,
    TIN = 438,
    IRON = 440,
    SILVER = 442,
    GOLD = 444,
    MITHRIL = 447,
    ADAMANTITE = 449,
    RUNITE = 451,
    COAL = 453,
    BANITE = 21778,
    LUMINITE = 44820,
    ORICHALCITE = 44822,
    DRAKOLITH = 44824,
    NECRITE = 44826,
    PHASMATITE = 44828,
    LIGHT_ANIMICA = 44830,
    DARK_ANIMICA = 44832
}

DX.Data.Runes = {
    AIR = { ID = 556, INV_VB = 5886 },
    MIND = { ID = 558, INV_VB = 5902 },
    WATER = { ID = 555, INV_VB = 5887 },
    EARTH = { ID = 557, INV_VB = 5889 },
    FIRE = { ID = 554, INV_VB = 5888 },
    BODY = { ID = 559, INV_VB = 5896 },
    COSMIC = { ID = 564, INV_VB = 5897 },
    NATURE = { ID = 561, INV_VB = 5899 },
    CHAOS = { ID = 562, INV_VB = 5898 },
    LAW = { ID = 563, INV_VB = 5900 },
    DEATH = { ID = 560, INV_VB = 5901 },
    ASTRAL = { ID = 9075, INV_VB = 5903 },
    BLOOD = { ID = 565, INV_VB = 5904 },
    SOUL = { ID = 566, INV_VB = 5905 },
}

DX.Data.Food = {
    42267, 42269, 42271,
    42258, 42260, 42262,
    385, 379, 373, 329, 333,
    391, 7946, 15272,
}

DX.Data.Potions = {
    SuperRestore = { 3024, 3026, 3028, 3030 },
    Adrenaline = { 39212, 39214, 39216, 39218 },
    HolyOverload = { 33246, 33244, 33242, 33240, 33238, 33236 },
    Overload = {
        15335, 15334, 15333, 15332,
        23536, 23535, 23534, 23533, 23532, 23531,
        33236, 33238, 33240, 33242, 33244, 33246,
        33248, 33250, 33252, 33254, 33256, 33258,
        48229, 48231, 48233, 48235, 48237, 48239,
        50867, 50869, 50871, 50873, 50875, 50877,
        33188, 33190, 33192, 33194, 33196, 33198,
        33200, 33202, 33204, 33206, 33208, 33210,
        33212, 33214, 33216, 33218, 33220, 33222,
        49029, 49031, 49033, 49035, 49037, 49039,
        49042, 49044, 49046, 49048, 49050, 49052,
    },
    SuperAntiFire = { 15304, 15305, 15306, 15307 },
}

DX.Data.Locations = {
    WarRetreat = { x1 = 3270, x2 = 3325, y1 = 10113, y2 = 10163 },
    DeathOffice = { x1 = 400, x2 = 430, y1 = 670, y2 = 680 },
    AnachroniaLodestone = { x1 = 5400, x2 = 5500, y1 = 2250, y2 = 2400 },
}

DX.Data.Objects = {
    WarAltar = 114748,
    WarRetreatBank = 114750,
}

DX.Data.AbilityIds = {
    Necro = {
        ConjureUndeadArmy = 32988,
        SoulSap = 30080,
        TouchOfDeath = 30076,
        Necromancy = 30015,
        SoulStrike = 30082,
        Volley = 30088,
        FingerDeath = 30077,
        SpectralScythe = 30084,
        Bloat = 30016,
        DeathSkulls = 30074,
        LivingDeath = 30078,
        Darkness = 30700,
        InvokeDeath = 30702,
        ThreadsOfFate = 30734,
    },
    Defensives = {
        Freedom = 14220,
        Anticipation = 14219,
        Preparation = 14223,
        Devotion = 21665,
        Debilitate = 14226,
        Reflect = 14225,
        Revenge = 14227,
        Resonance = 14222,
        Immortality = 14230,
        NatureInstinct = 16549,
        Cease = 15036,
        Provoke = 14221,
    },
    HP = {
        EatFood = 1601,
        SpecialAtk = 26105,
    },
    Support = {
        HolyOverload = 33244,
        SuperRestore = 3024,
        SuperAdrenaline = 39212,
    },
    Agility = {
        Surge = 14233,
        Escape = 14245,
        Dive = 23714,
        Barge = 14208,
    },
    Curses = {
        Sorrow = 30771,
        DeflectMagic = 26041,
        DeflectRanged = 26044,
        DeflectMelee = 26040,
        SoulSplit = 26033,
        ProtectMagic = 25959,
    },
    Teleports = {
        WarRetreatTeleport = 35042,
    }
}

DX.Data.BuffIds = {
    DeflectRanged = 26044,
    DeflectMagic = 26041,
    DeflectMelee = 26040,
    SoulSplit = 26033,
    Resonance = 14222,
    Darkness = 30122,
    LivingDeath = 30078,
    Necrosis = 30101,
    ResidualSouls = 30123,
    SkeletonWarrior = 30102,
    Antifire = 30093,
    Devotion = 21665,
    Overload = 26093,
    OverloadIcons = { 26093, 33210, 49039 },
    Sorrow = 30771,
}

DX.Data.DebuffIds = {
    Excalibur = 14632,
    ElvenShard = 43358,
    NecroSpecCooldown = 55524,
    SpecCooldown = 55480,
}

DX.Data.Abilities = {
    DEFENSIVE = {
        Anticipation = { name = "Anticipation", id = 14219 },
        Freedom = { name = "Freedom", id = 14220 },
        Provoke = { name = "Provoke", id = 14221 },
        Resonance = { name = "Resonance", id = 14222 },
        Preparation = { name = "Preparation", id = 14223 },
        Bash = { name = "Bash", id = 14224 },
        Reflect = { name = "Reflect", id = 14225 },
        Debilitate = { name = "Debilitate", id = 14226 },
        Revenge = { name = "Revenge", id = 14227 },
        Barricade = { name = "Barricade", id = 14228 },
        Rejuvenate = { name = "Rejuvenate", id = 14229 },
        Immortality = { name = "Immortality", id = 14230 },
        NaturalInstinct = { name = "Natural Instinct", id = 16549 },
        Devotion = { name = "Devotion", id = 21665 },
        Unsullied = { name = "Unsullied", id = 1525 },
        Aggression = { name = "Aggression", id = 1516 },
        Divert = { name = "Divert", id = 15035 },
        Cease = { name = "Cease", id = 15036 },
    },
    HP = {
        EssenceOfFinality = { name = "Essence of Finality", id = 10231 },
        Regenerate = { name = "Regenerate", id = 14267 },
        Incite = { name = "Incite", id = 14268 },
        BalancedStance = { name = "Balanced Stance", id = 16854 },
        DefensiveStance = { name = "Defensive Stance", id = 16853 },
        AggressiveStance = { name = "Aggressive Stance", id = 16852 },
        GuthixSBlessing = { name = "Guthix's Blessing", id = 16558 },
        Sacrifice = { name = "Sacrifice", id = 21666 },
        Transfigure = { name = "Transfigure", id = 26106 },
        CombatMonolith = { name = "Combat Monolith", id = 21663 },
        ShoutTofu = { name = "Shout - Tofu", id = 16864 },
        ShoutCrackers = { name = "Shout - Crackers", id = 16865 },
        ShoutWorms = { name = "Shout - Worms", id = 16866 },
        ShoutRedEgg = { name = "Shout - Red Egg", id = 16861 },
        ShoutGreenEgg = { name = "Shout - Green Egg", id = 16862 },
        ShoutBlueEgg = { name = "Shout - Blue Egg", id = 16863 },
        ShoutPoisonedWorms = { name = "Shout - Poisoned Worms", id = 16859 },
        ShoutPoisonedTofu = { name = "Shout - Poisoned Tofu", id = 16858 },
        ShoutPoisonedMeat = { name = "Shout - Poisoned Meat", id = 16860 },
        ShoutBalancedStance = { name = "Shout - Balanced Stance", id = 16857 },
        ShoutAggressiveStance = { name = "Shout - Aggressive Stance", id = 16855 },
        ShoutDefensiveStance = { name = "Shout - Defensive Stance", id = 16856 },
        Revolution = { name = "Revolution", id = 26108 },
        IceAsylum = { name = "Ice Asylum", id = 17503 },
        Siphon = { name = "Siphon", id = 18764 },
        WeaponSpecialAttack = { name = "Weapon Special Attack", id = 26105 },
        TuskaSWrath = { name = "Tuska's Wrath", id = 8861 },
        StormShards = { name = "Storm Shards", id = 19227 },
        Shatter = { name = "Shatter", id = 19228 },
        Onslaught = { name = "Onslaught", id = 19289 },
        Reprisal = { name = "Reprisal", id = 799 },
        IngenuityOfTheHumans = { name = "Ingenuity of the Humans", id = 1521 },
        DemonSlayer = { name = "Demon Slayer", id = 1517 },
        DragonSlayer = { name = "Dragon Slayer", id = 1518 },
        UndeadSlayer = { name = "Undead Slayer", id = 1524 },
        Limitless = { name = "Limitless", id = 1522 },
        SlayerSInsight = { name = "Slayer's Insight", id = 1523 },
        KuradalSFavour = { name = "Kuradal's Favour", id = 1519 },
        EatFood = { name = "Eat Food", id = 36566 },
        PhantomStrike = { name = "Phantom Strike.", id = 49552 },
        DeepBurn = { name = "Deep Burn", id = 49553 },
        SoulfireDamageOverTime = { name = "Soulfire - Damage over time", id = 30372 },
        VampyreSlayer = { name = "Vampyre Slayer", id = 36568 },
        VitalDrain = { name = "Vital Drain", id = 36569 },
    },
    INCANTATION = {
        LifeTransfer = { name = "Life Transfer", id = 30704 },
        ThreadsOfFate = { name = "Threads of Fate", id = 30734 },
        InvokeDeath = { name = "Invoke Death", id = 30702 },
        SplitSoul = { name = "Split Soul", id = 30706 },
        CityOfUmTeleport = { name = "City of Um Teleport", id = 30715 },
        UngaelTeleport = { name = "Ungael Teleport", id = 33716 },
        Darkness = { name = "Darkness", id = 30700 },
        LesserBoneShield = { name = "Lesser Bone Shield", id = 30697 },
        GreaterBoneShield = { name = "Greater Bone Shield", id = 30628 },
        InvokeLordOfBones = { name = "Invoke Lord of Bones", id = 33147 },
        InvokeArisenFlesh = { name = "Invoke Arisen Flesh", id = 36582 },
    },
    MAGIC = {
        RunicCharge = { name = "Runic Charge", id = 23725 },
        Impact = { name = "Impact", id = 14234 },
        Chain = { name = "Chain", id = 15037 },
        Combust = { name = "Combust", id = 23401 },
        DragonBreath = { name = "Dragon Breath", id = 14236 },
        Asphyxiate = { name = "Asphyxiate", id = 14237 },
        Detonate = { name = "Detonate", id = 14238 },
        WildMagic = { name = "Wild Magic", id = 14239 },
        Metamorphosis = { name = "Metamorphosis", id = 14241 },
        Tsunami = { name = "Tsunami", id = 14240 },
        Omnipower = { name = "Omnipower", id = 14242 },
        Sunshine = { name = "Sunshine", id = 20183 },
        SonicWave = { name = "Sonic Wave", id = 27430 },
        ConcentratedBlast = { name = "Concentrated Blast", id = 13309 },
        SmokeTendrils = { name = "Smoke Tendrils", id = 17501 },
        DeepImpact = { name = "Deep Impact", id = 22755 },
        MagmaTempest = { name = "Magma Tempest", id = 4378 },
        MagmaTempestAreaOfEffectDamage = { name = "Magma Tempest - Area of effect damage", id = 4378 },
        CorruptionBlast = { name = "Corruption Blast", id = 19226 },
        Shock = { name = "Shock", id = 33083 },
        Horror = { name = "Horror", id = 33084 },
        SanguineCharge = { name = "Sanguine Charge", id = 13308 },
        GreaterChain = { name = "Greater Chain", id = 15038 },
        GreaterConcentratedBlast = { name = "Greater Concentrated Blast", id = 13310 },
        MagmaTempestTargeted = { name = "Magma Tempest (Targeted)", id = 15033 },
        GreaterSunshine = { name = "Greater Sunshine", id = 20184 },
        TempestOfArmadyl = { name = "Tempest of Armadyl", id = 47055 },
        GreaterSonicWave = { name = "Greater Sonic Wave", id = 27432 },
        SanguineOffering = { name = "Sanguine offering", id = 36573 },
    },
    MELEE = {
        BladedDive = { name = "Bladed Dive", id = 30331 },
        GreaterFlurry = { name = "Greater Flurry", id = 841 },
        Slice = { name = "Slice", id = 14207 },
        Barge = { name = "Barge", id = 14208 },
        AdaptiveStrike = { name = "Adaptive Strike", id = 21237 },
        Smash = { name = "Smash", id = 14211 },
        Backhand = { name = "Backhand", id = 14212 },
        Slaughter = { name = "Slaughter", id = 21362 },
        Flurry = { name = "Flurry", id = 14214 },
        Hurricane = { name = "Hurricane", id = 14215 },
        Overpower = { name = "Overpower", id = 14216 },
        Massacre = { name = "Massacre", id = 21296 },
        MeteorStrike = { name = "Meteor Strike", id = 21363 },
        Punish = { name = "Punish", id = 14257 },
        Fury = { name = "Fury", id = 14258 },
        Decimate = { name = "Decimate", id = 14259 },
        Cleave = { name = "Cleave", id = 14260 },
        Assault = { name = "Assault", id = 14261 },
        Quake = { name = "Quake", id = 14262 },
        Destroy = { name = "Destroy", id = 14263 },
        Berserk = { name = "Berserk", id = 14264 },
        Frenzy = { name = "Frenzy", id = 14265 },
        Pulverise = { name = "Pulverise", id = 14266 },
        BalancedStrike = { name = "Balanced Strike", id = 16548 },
        BloodTendrils = { name = "Blood Tendrils", id = 17500 },
        GreaterBarge = { name = "Greater Barge", id = 840 },
        GreaterFury = { name = "Greater Fury", id = 842 },
        Havoc = { name = "Havoc", id = 14210 },
        Dismember = { name = "Dismember", id = 21239 },
        ChaosRoar = { name = "Chaos Roar", id = 21238 },
        BasicNbspAttack = { name = "Basic<nbsp>Attack", id = 23399 },
        Rend = { name = "Rend", id = 14211 },
    },
    MISC = {
        Escape = { name = "Escape", id = 14245 },
        Surge = { name = "Surge", id = 14233 },
        QuiverAmmoSlot1 = { name = "Quiver ammo slot 1", id = 15031 },
        QuiverAmmoSlot2 = { name = "Quiver ammo slot 2", id = 15032 },
        Dive = { name = "Dive", id = 23714 },
    },
    NECRO = {
        ConjurePhantomGuardian = { name = "Conjure Phantom Guardian", id = 34175 },
        CommandPhantomGuardian = { name = "Command Phantom Guardian", id = 34168 },
        ConjureUndeadArmy = { name = "Conjure Undead Army", id = 32988 },
        BasicNbspAttack = { name = "Basic<nbsp>Attack", id = 30015 },
        TouchOfDeath = { name = "Touch of Death", id = 30076 },
        FingerOfDeath = { name = "Finger of Death", id = 30077 },
        SoulSap = { name = "Soul Sap", id = 30080 },
        SoulStrike = { name = "Soul Strike", id = 30082 },
        VolleyOfSouls = { name = "Volley of Souls", id = 30088 },
        ConjureSkeletonWarrior = { name = "Conjure Skeleton Warrior", id = 34169 },
        CommandSkeletonWarrior = { name = "Command Skeleton Warrior", id = 34165 },
        ConjurePutridZombie = { name = "Conjure Putrid Zombie", id = 34173 },
        CommandPutridZombie = { name = "Command Putrid Zombie", id = 34167 },
        ConjureVengefulGhost = { name = "Conjure Vengeful Ghost", id = 34171 },
        CommandVengefulGhost = { name = "Command Vengeful Ghost", id = 34166 },
        Bloat = { name = "Bloat", id = 30016 },
        BloodSiphon = { name = "Blood Siphon", id = 30017 },
        SpectralScythe = { name = "Spectral Scythe", id = 30087 },
        DeathSkulls = { name = "Death Skulls", id = 30074 },
        LivingDeath = { name = "Living Death", id = 30078 },
    },
    RANGE = {
        GreaterDazingShot = { name = "Greater Dazing Shot", id = 30332 },
        SaltTheWound = { name = "Salt the Wound", id = 30334 },
        PiercingShot = { name = "Piercing Shot", id = 23727 },
        BindingShot = { name = "Binding Shot", id = 14244 },
        Snipe = { name = "Snipe", id = 23729 },
        FragmentationShot = { name = "Fragmentation Shot", id = 14247 },
        Ricochet = { name = "Ricochet", id = 23868 },
        SnapShot = { name = "Snap Shot", id = 23728 },
        RapidFire = { name = "Rapid Fire", id = 14250 },
        Bombardment = { name = "Bombardment", id = 14251 },
        IncendiaryShot = { name = "Incendiary Shot", id = 14252 },
        Unload = { name = "Unload", id = 14253 },
        Deadshot = { name = "Deadshot", id = 23730 },
        DeathSSwiftness = { name = "Death's Swiftness", id = 20185 },
        DazingShot = { name = "Dazing Shot", id = 9316 },
        ShadowTendrils = { name = "Shadow Tendrils", id = 20914 },
        CorruptionShot = { name = "Corruption Shot", id = 17255 },
        Demoralise = { name = "Demoralise", id = 33085 },
        Rout = { name = "Rout", id = 33086 },
        GreaterRicochet = { name = "Greater Ricochet", id = 15039 },
        GreaterDeathSSwiftness = { name = "Greater Death's Swiftness", id = 20186 },
        BasicNbspAttack = { name = "Basic<nbsp>Attack", id = 23726 },
        ImbueShadows = { name = "Imbue: Shadows", id = 23761 },
        Galeshot = { name = "Galeshot", id = 23731 },
    },
    TELEPORT = {
        BurthorpeLodestone = { name = "Burthorpe Lodestone", id = 31864 },
        MaxGuildTeleport = { name = "Max guild Teleport", id = 36145 },
        SkeletalHorrorTeleport = { name = "Skeletal horror Teleport", id = 36142 },
        KandarinMonasteryTeleport = { name = "Kandarin monastery Teleport", id = 36143 },
        ManorFarmTeleport = { name = "Manor farm Teleport", id = 36144 },
        WarSRetreatTeleport = { name = "War's Retreat Teleport", id = 35042 },
        AlKharidLodestone = { name = "Al Kharid Lodestone", id = 31871 },
        TaverleyTeleport = { name = "Taverley Teleport", id = 35031 },
        ArdougneLodestone = { name = "Ardougne Lodestone", id = 31862 },
        SouthFeldipHillsTeleport = { name = "South Feldip Hills Teleport", id = 36136 },
        VarrockTeleport = { name = "Varrock Teleport", id = 36137 },
        LumbridgeTeleport = { name = "Lumbridge Teleport", id = 36135 },
        FaladorTeleport = { name = "Falador Teleport", id = 36132 },
        HouseTeleport = { name = "House Teleport", id = 36134 },
        CamelotTeleport = { name = "Camelot Teleport", id = 36130 },
        ArdougneTeleport = { name = "Ardougne Teleport", id = 35028 },
        WatchtowerTeleport = { name = "Watchtower Teleport", id = 35033 },
        TrollheimTeleport = { name = "Trollheim Teleport", id = 35032 },
        ApeAtollTeleport = { name = "Ape Atoll Teleport", id = 35027 },
        TeleOtherLumbridge = { name = "Tele-other Lumbridge", id = 36140 },
        TeleOtherFalador = { name = "Tele-other Falador", id = 36139 },
        TeleOtherCamelot = { name = "Tele-other Camelot", id = 36138 },
        PaddewwaTeleport = { name = "Paddewwa Teleport", id = 36128 },
        SenntistenTeleport = { name = "Senntisten Teleport", id = 36129 },
        KharyrllTeleport = { name = "Kharyrll Teleport", id = 36126 },
        LassarTeleport = { name = "Lassar Teleport", id = 36127 },
        DareeyakTeleport = { name = "Dareeyak Teleport", id = 36124 },
        CarrallangarTeleport = { name = "Carrallangar Teleport", id = 36123 },
        AnnakarlTeleport = { name = "Annakarl Teleport", id = 36122 },
        GhorrockTeleport = { name = "Ghorrock Teleport", id = 36125 },
        MoonclanTeleport = { name = "Moonclan Teleport", id = 14403 },
        TeleGroupMoonclan = { name = "Tele-group Moonclan", id = 14428 },
        OuraniaTeleport = { name = "Ourania Teleport", id = 14442 },
        SouthFaladorTeleport = { name = "South Falador Teleport", id = 14444 },
        WaterbirthTeleport = { name = "Waterbirth Teleport", id = 14404 },
        TeleGroupWaterbirth = { name = "Tele-group Waterbirth", id = 14429 },
        BarbarianTeleport = { name = "Barbarian Teleport", id = 14406 },
        NorthArdougneTeleport = { name = "North Ardougne Teleport", id = 14446 },
        TeleGroupBarbarian = { name = "Tele-group Barbarian", id = 14430 },
        KhazardTeleport = { name = "Khazard Teleport", id = 14408 },
        TeleGroupKhazard = { name = "Tele-group Khazard", id = 14431 },
        FishingGuildTeleport = { name = "Fishing Guild Teleport", id = 14414 },
        TeleGroupFishingGuild = { name = "Tele-group Fishing Guild", id = 14432 },
        CatherbyTeleport = { name = "Catherby Teleport", id = 14415 },
        TeleGroupCatherby = { name = "Tele-group Catherby", id = 14433 },
        IcePlateauTeleport = { name = "Ice Plateau Teleport", id = 14416 },
        TeleGroupIcePlateau = { name = "Tele-group Ice Plateau", id = 14434 },
        TrollheimFarmTeleport = { name = "Trollheim Farm Teleport", id = 14453 },
        TeleGroupTrollheimFarm = { name = "Tele-group Trollheim Farm", id = 14454 },
        HomeTeleport = { name = "Home Teleport", id = 36131 },
        DungeonHomeTeleport = { name = "Dungeon Home Teleport", id = 31524 },
        CreateGatestone = { name = "Create Gatestone", id = 14507 },
        GatestoneTeleport = { name = "Gatestone Teleport", id = 14508 },
        GroupGatestoneTeleport = { name = "Group Gatestone Teleport", id = 14509 },
        CatherbyLodestone = { name = "Catherby Lodestone", id = 31865 },
        CreateGatestone2 = { name = "Create Gatestone 2", id = 20614 },
        Gatestone2Teleport = { name = "Gatestone 2 Teleport", id = 20615 },
        DraynorLodestone = { name = "Draynor Lodestone", id = 31868 },
        EdgevilleLodestone = { name = "Edgeville Lodestone", id = 31870 },
        FaladorLodestone = { name = "Falador Lodestone", id = 31861 },
        LumbridgeLodestone = { name = "Lumbridge Lodestone", id = 31859 },
        PortSarimLodestone = { name = "Port Sarim Lodestone", id = 31867 },
        SeersVillageLodestone = { name = "Seers' Village Lodestone", id = 31866 },
        TaverleyLodestone = { name = "Taverley Lodestone", id = 31863 },
        VarrockLodestone = { name = "Varrock Lodestone", id = 31860 },
        YanilleLodestone = { name = "Yanille Lodestone", id = 31869 },
        LunarIsleLodestone = { name = "Lunar Isle Lodestone", id = 31873 },
        BanditCampLodestone = { name = "Bandit Camp Lodestone", id = 31872 },
        CanifisLodestone = { name = "Canifis Lodestone", id = 31874 },
        EaglesPeakLodestone = { name = "Eagles' Peak Lodestone", id = 31875 },
        FremennikLodestone = { name = "Fremennik Lodestone", id = 31877 },
        KaramjaLodestone = { name = "Karamja Lodestone", id = 31878 },
        OoGlogLodestone = { name = "Oo'glog Lodestone", id = 31876 },
        TirannwnLodestone = { name = "Tirannwn Lodestone", id = 31879 },
        WildernessLodestone = { name = "Wilderness Lodestone", id = 31880 },
        AshdaleLodestone = { name = "Ashdale Lodestone", id = 31881 },
        PrifddinasLodestone = { name = "Prifddinas Lodestone", id = 31882 },
        MenaphosLodestone = { name = "Menaphos Lodestone", id = 31885 },
        AnachroniaLodestone = { name = "Anachronia Lodestone", id = 31886 },
        GodWarsDungeonTeleport = { name = "God Wars Dungeon Teleport", id = 35029 },
        AnachroniaTeleport = { name = "Anachronia Teleport", id = 10371 },
        TheHeartTeleport = { name = "The Heart Teleport", id = 35029 },
        MazcabTeleport = { name = "Mazcab Teleport", id = 35030 },
        FortForinthryLodestone = { name = "Fort Forinthry Lodestone", id = 12692 },
        CityOfUmLodestone = { name = "City of Um Lodestone", id = 30939 },
        ChristmasVillageTeleport = { name = "Christmas Village Teleport", id = 31180 },
        BloomingBurrowTeleport = { name = "Blooming Burrow Teleport", id = 33606 },
        HarvestHollowTeleport = { name = "Harvest Hollow Teleport", id = 34363 },
        WesternKharaziJungleTeleport = { name = "Western Kharazi Jungle Teleport", id = 1779 },
        MountainCampTeleport = { name = "Mountain Camp Teleport", id = 1780 },
        NorthWesternAnachroniaTeleport = { name = "North-western Anachronia Teleport", id = 10370 },
        EasternAnachroniaTeleport = { name = "Eastern Anachronia Teleport", id = 10369 },
        NorthernLostGroveTeleport = { name = "Northern Lost Grove Teleport", id = 11316 },
        WendlewickLodestone = { name = "Wendlewick Lodestone", id = 35667 },
        WendlewickTeleport = { name = "Wendlewick Teleport", id = 35665 },
        SunlightSandsTeleport = { name = "Sunlight Sands Teleport", id = 36102 },
    },
}

DX.Data.Buffs = {
    ABIL = {
        DealsDamageToSurroundingNPCsDamage = { name = "Deals damage to surrounding NPCs. Damage is increased with multiple stacks.", id = 30363 },
        Revenge = { name = "Revenge", id = 14227 },
        SplitSoul = { name = "Split Soul", id = 30126 },
        GreaterFlurry = { name = "Greater Flurry", id = 841 },
        Snipe = { name = "Snipe", id = 23729 },
        RapidFire = { name = "Rapid Fire", id = 14250 },
        Unload = { name = "Unload", id = 14253 },
        Flurry = { name = "Flurry", id = 14214 },
        Regenerate = { name = "Regenerate", id = 14267 },
        Incite = { name = "Incite", id = 14268 },
        BalancedStance = { name = "Balanced Stance", id = 16854 },
        DefensiveStance = { name = "Defensive Stance", id = 16853 },
        AggressiveStance = { name = "Aggressive Stance", id = 16852 },
        Assault = { name = "Assault", id = 14261 },
        Destroy = { name = "Destroy", id = 14263 },
        Berserk = { name = "Berserk", id = 14264 },
        Frenzy = { name = "Frenzy", id = 14265 },
        Anticipation = { name = "Anticipation", id = 14219 },
        Freedom = { name = "Freedom", id = 14220 },
        Resonance = { name = "Resonance", id = 14222 },
        Preparation = { name = "Preparation", id = 14223 },
        Reflect = { name = "Reflect", id = 14225 },
        Debilitate = { name = "Debilitate", id = 14226 },
        Barricade = { name = "Barricade", id = 14228 },
        Rejuvenate = { name = "Rejuvenate", id = 14229 },
        Immortality = { name = "Immortality", id = 14230 },
        Asphyxiate = { name = "Asphyxiate", id = 14237 },
        Metamorphosis = { name = "Metamorphosis", id = 14241 },
        DisruptionShield = { name = "Disruption Shield", id = 14450 },
        DeathSSwiftness = { name = "Death's Swiftness", id = 20185 },
        NaturalInstinct = { name = "Natural Instinct", id = 16549 },
        GuthixSBlessing = { name = "Guthix's Blessing", id = 16558 },
        Sunshine = { name = "Sunshine", id = 20183 },
        ConcentratedBlast = { name = "Concentrated Blast", id = 13309 },
        Transfigure = { name = "Transfigure", id = 26106 },
        CombatMonolith = { name = "Combat Monolith", id = 21663 },
        Devotion = { name = "Devotion", id = 21665 },
        IceAsylum = { name = "Ice Asylum", id = 17503 },
        SmokeTendrils = { name = "Smoke Tendrils", id = 17501 },
        PerfectEquilibrium = { name = "Perfect Equilibrium", id = 20228 },
        StormShards = { name = "Storm Shards", id = 19227 },
        Onslaught = { name = "Onslaught", id = 19289 },
        EmeraldAurora = { name = "Emerald Aurora", id = 25933 },
        RubyAurora = { name = "Ruby Aurora", id = 25936 },
        ShieldDome = { name = "Shield Dome", id = 25931 },
        PhantomGuardian = { name = "Phantom Guardian", id = 34180 },
        Reprisal = { name = "Reprisal", id = 799 },
        Blackhole = { name = "Blackhole", id = 37640 },
        Intercept = { name = "Intercept - You will receive redirected damage.", id = 27742 },
        GravitateActive = { name = "Gravitate Active", id = 39049 },
        LocateActive = { name = "Locate Active.", id = 39053 },
        Intercepted = { name = "Intercepted - You will receive no damage.", id = 27741 },
        DetonateIsChargingUponHitting100 = { name = "Detonate is charging; upon hitting 100%, detonate it for maximum damage.", id = 14238 },
        Unsullied = { name = "Unsullied", id = 1525 },
        Aggression = { name = "Aggression", id = 1516 },
        TheNextTimeYouReceiveDamage = { name = "The next time you receive damage, <col=ffffff>75%</col> of the damage received is also dealt to the attacker.", id = 14423 },
        SpectralScythe = { name = "Spectral Scythe", id = 30084 },
        InnerChaos = { name = "Inner Chaos", id = 20228 },
        SwordOfEdicts = { name = "Sword of Edicts", id = 20229 },
        CleansingAura = { name = "Cleansing Aura", id = 20229 },
        IcyChillAt10StacksNon = { name = "Icy Chill: At 10 stacks non-basic abilities convert this into Icy Precision for 9s.", id = 19116 },
        IcyPrecisionBlocksConsumptionOfIcy = { name = "Icy Precision: Blocks consumption of Icy Chill and gives threshold, ultimate and special abilities +30% base damage and +30% hit chance.", id = 19117 },
        AnimateDead = { name = "Animate Dead", id = 14764 },
        GlacialEmbrace = { name = "Glacial Embrace", id = 14766 },
        BloodTithe = { name = "Blood Tithe", id = 14765 },
        Divert = { name = "Divert", id = 15035 },
        Cease = { name = "Cease", id = 15036 },
        Instability = { name = "Instability", id = 51772 },
        TimeRift = { name = "Time rift", id = 15146 },
        GreaterConcentratedBlast = { name = "Greater Concentrated Blast", id = 13310 },
        FeastingSpores = { name = "Feasting Spores", id = 52303 },
        ChannelledMight = { name = "Channelled Might", id = 17606 },
        SheerCold = { name = "Sheer Cold", id = 15922 },
        SplinteringArrows = { name = "Splintering Arrows", id = 30332 },
        GladiatorSRage = { name = "Gladiator's Rage", id = 52494 },
        GreaterSunshine = { name = "Greater Sunshine", id = 20184 },
        GreaterDeathSSwiftness = { name = "Greater Death's Swiftness", id = 20186 },
        ChaosRoar = { name = "Chaos Roar", id = 21238 },
        Flow = { name = "Flow", id = 27430 },
        GreaterFlow = { name = "Greater Flow", id = 27432 },
        TempestOfArmadyl = { name = "Tempest of Armadyl", id = 21777 },
        GreaterSonicWave = { name = "Greater Sonic Wave", id = 27432 },
        BloodSiphon = { name = "Blood Siphon", id = 30017 },
        Necrosis = { name = "Necrosis", id = 30101 },
        ResidualSoul = { name = "Residual Soul", id = 30123 },
        SkeletonWarrior = { name = "Skeleton Warrior", id = 34177 },
        PutridZombie = { name = "Putrid Zombie", id = 34179 },
        VengefulGhost = { name = "Vengeful Ghost", id = 34178 },
        BoneShield = { name = "Bone Shield", id = 30099 },
        ThreadsOfFate = { name = "Threads of Fate", id = 30129 },
        DeathInvocation = { name = "Death Invocation", id = 30100 },
        Darkness = { name = "Darkness", id = 30122 },
        DeathSpark = { name = "Death Spark", id = 30128 },
        DeathEssence = { name = "Death Essence", id = 55480 },
        DracolichInfusion = { name = "Dracolich infusion", id = 31271 },
        LordOfBonesInvocation = { name = "Lord of Bones invocation", id = 33145 },
        DarkBurn = { name = "Dark Burn", id = 34158 },
        PrimordialIce = { name = "Primordial Ice", id = 15190 },
        Frostblades = { name = "Frostblades", id = 15184 },
        DevourerSCorruption = { name = "Devourer's Corruption", id = 57126 },
        Conflagrate = { name = "Conflagrate", id = 30373 },
        EssenceCorruption = { name = "Essence Corruption", id = 33967 },
        TemporalAnomaly = { name = "Temporal Anomaly", id = 1368 },
        SurgingStorm = { name = "Surging Storm", id = 34997 },
        FlameboundRival = { name = "Flamebound Rival", id = 34998 },
        SoulReave = { name = "Soul Reave", id = 35069 },
        SoulCrush = { name = "Soul Crush", id = 59354 },
        PowerOfTheElderGods = { name = "Power of the Elder Gods", id = 59639 },
        AnimaCharged = { name = "Anima Charged", id = 23725 },
        BlastInfused = { name = "Blast Infused", id = 14239 },
        Bloodlust = { name = "Bloodlust", id = 23876 },
        Dismember = { name = "Dismember", id = 21239 },
        SearingWinds = { name = "Searing Winds", id = 23877 },
        ShadowImbued = { name = "Shadow Imbued", id = 31925 },
        Vampyrism = { name = "Vampyrism", id = 35768 },
        Penance = { name = "Penance", id = 35769 },
        ArisenFleshInvocation = { name = "Arisen Flesh invocation", id = 36581 },
        CrimsonSalvo = { name = "Crimson Salvo", id = 36575 },
    },
    COMBATBOOST = {
        AttackStatBoosted = { name = "Attack Stat Boosted", id = 25824 },
        StrengthStatBoosted = { name = "Strength Stat Boosted", id = 25825 },
        DefenceStatBoosted = { name = "Defence Stat Boosted", id = 25826 },
        RangedStatBoosted = { name = "Ranged Stat Boosted", id = 25827 },
        PrayerPointsBoosted = { name = "Prayer Points Boosted", id = 25828 },
        MagicStatBoosted = { name = "Magic Stat Boosted", id = 25829 },
        LifePointsBoosted = { name = "Life Points Boosted", id = 25830 },
        NecromancyStatBoosted = { name = "Necromancy Stat Boosted", id = 30125 },
        CloseFormation = { name = "Close Formation", id = 25826 },
    },
    MISC = {
        SpiritDragonCharmEffect = { name = "Spirit dragon charm effect", id = 37731 },
        ReanimatingDisease = { name = "Reanimating Disease", id = 38983 },
        YouAreImmuneToAllStuns = { name = "You are immune to all stuns for 15 seconds.", id = 26104 },
        FuryOfTheSmall = { name = "Fury of the Small - All basic abilities generate 1% more adrenaline", id = 10495 },
        ConservationOfEnergy = { name = "Conservation of Energy - After using an ultimate ability, you will regain 10% adrenaline", id = 10493 },
        BerserkerSFury = { name = "Berserker's Fury - For all combat styles, deal up to 5.5% more damage the lower your current life points are below max health", id = 10492 },
        DeathWard = { name = "Death Ward - 5% damage reduction when your life points are below 50%; 10% damage reduction when they are below 25%", id = 10494 },
        ClanCupSessionActive = { name = "Clan Cup Session Active", id = 20709 },
        YouCurrentlyFeelEnergisedAndHastened = { name = "You currently feel energised and hastened.", id = 18818 },
        CastingGreaterBargeWillMakeYour = { name = "Casting greater barge will make your next melee channelled ability instant and deal damage over time instead.", id = 840 },
        EndlessAssault = { name = "Endless Assault - Your next melee channelled ability will be instant cast and deal damage over time to your opponent instead.", id = 14221 },
        ReduceAllIncomingMeleeDamageBy = { name = "Reduce all incoming melee damage by 50%", id = 15486 },
        ReducesAllIncomingDamageBy25 = { name = "Reduces all incoming damage by 25% and 25% of incoming damage is reflected back to the attacker.", id = 34155 },
        PyroclasticShock = { name = "Pyroclastic Shock - You have been rapidly defrosted, gaining a huge adrenaline rush!", id = 389 },
        Overcharged = { name = "Overcharged - Lightning runs through your veins, you will deal additional magic damage on each of your attacks and your surge ability has a drastically reduced cooldown.", id = 9880 },
        InnerPower = { name = "Inner power - Harnessing the shadow anima will increase damage dealt to Raksha. Damage is increased by 10% per stack.", id = 12171 },
        WarpTimeTakesASnapshotOf = { name = "Warp Time: Takes a snapshot of your life points, ability cooldowns, adrenaline, prayer points and location. 10 seconds later, you'll be restored to that point in time, exactly as you were.", id = 15142 },
        LightOfSaradomin = { name = "Light of Saradomin - Incoming damage is reduced by 50%", id = 15144 },
        SwiftnessOfTheAviansie = { name = "Swiftness of the Aviansie - Damage output is increased by 10%", id = 15143 },
        IgneousEnergy = { name = "Igneous energy - The energy flows through your body.", id = 16462 },
        SmoulderingHide = { name = "Smouldering Hide", id = 26421 },
        YourNextBargeAbilityIsEmpowered = { name = "Your next Barge ability is empowered.", id = 14208 },
        Rampage = { name = "Rampage", id = 1377 },
        DraconicPrecision = { name = "Draconic Precision", id = 4587 },
        SoulSiphon = { name = "Soul Siphon", id = 26450 },
        MagicCriticalStrikesGenerateAnAdditional = { name = "Magic critical strikes generate an additional 8% adrenaline.", id = 33962 },
        RangedCriticalStrikesGenerateAnAdditional = { name = "Ranged critical strikes generate an additional 8% adrenaline.", id = 33962 },
        YourNextMeleeAttackIsGuaranteed = { name = "Your next Melee attack is guaranteed to Critically Strike.", id = 842 },
        DivineProtection = { name = "Divine Protection", id = 33974 },
        RecentlyResurrected = { name = "Recently Resurrected", id = 33973 },
        BlessingOfApmeken = { name = "Blessing of Apmeken", id = 35063 },
        BlessingOfCrondis = { name = "Blessing of Crondis", id = 35064 },
        BlessingOfHet = { name = "Blessing of Het", id = 35065 },
        BlessingOfScabaras = { name = "Blessing of Scabaras", id = 35066 },
        Enlightened = { name = "Enlightened", id = 35067 },
        Ascension = { name = "Ascension", id = 35244 },
        MeleeBasicAbilitiesGenerate15x = { name = "Melee basic abilities generate 1.5x adrenaline<br>Regenerate 4.5% adrenaline every 0.6s.", id = 21363 },
        StrongestPoisonVerditeMoth = { name = "Strongest poison - Verdite moth", id = 60749 },
        StrongestPoisonLazuriteMoth = { name = "Strongest poison - Lazurite moth", id = 60750 },
        StrongestPoisonPurpuriteMoth = { name = "Strongest poison - Purpurite moth", id = 60751 },
        StrongestPoisonGreenSpikes = { name = "Strongest poison - Green spikes", id = 60752 },
        StrongestPoisonBlueSpikes = { name = "Strongest poison - Blue spikes", id = 60753 },
        StrongestPoisonPurpleSpikes = { name = "Strongest poison - Purple spikes", id = 60754 },
        SugiliteMoth = { name = "Sugilite moth", id = 60700 },
        CalciteMoth = { name = "Calcite moth", id = 60702 },
        AzuriteMoth = { name = "Azurite moth", id = 60704 },
        SanguineInfluence = { name = "Sanguine Influence", id = 36598 },
    },
    POTS = {
        Overloaded = { name = "Overloaded", id = 26093 },
        AdrenalineRenewal = { name = "Adrenaline renewal", id = 49079 },
        AntiPoisonActive = { name = "Anti-poison Active", id = 30094 },
        Poisonous = { name = "Poisonous", id = 30095 },
        AntiFireActive = { name = "Anti-Fire Active", id = 30093 },
        SuperAntiFireActive = { name = "Super Anti-Fire Active", id = 30093 },
        PrayerRenewActive = { name = "Prayer Renew Active", id = 14695 },
        JujuMiningPotionActive = { name = "Juju Mining Potion Active", id = 20004 },
        JujuWoodcuttingPotionActive = { name = "Juju Woodcutting Potion Active", id = 20016 },
        JujuFishingPotionActive = { name = "Juju Fishing Potion Active", id = 20020 },
        ScentlessPotionActive = { name = "Scentless Potion Active", id = 20028 },
        JujuFarmingPotionActive = { name = "Juju Farming Potion Active", id = 20012 },
        SaradominSBlessingPotionActive = { name = "Saradomin's Blessing Potion Active", id = 20032 },
        GuthixSGiftPotionActive = { name = "Guthix's Gift Potion Active", id = 20036 },
        ZamorakSFavourPotionActive = { name = "Zamorak's Favour Potion Active", id = 20040 },
        JujuHunterPotionActive = { name = "Juju Hunter Potion Active", id = 20024 },
        WyrmfirePotionActive = { name = "Wyrmfire Potion Active", id = 30093 },
        SuperPrayerRenewalPotionActive = { name = "Super Prayer Renewal Potion Active:", id = 14695 },
        SupremeOverloadPotionActive = { name = "Supreme Overload Potion Active", id = 33210 },
        PerfectPlusPotionActive = { name = "Perfect Plus Potion Active", id = 33234 },
        PerfectJujuMiningPotionActive = { name = "Perfect Juju Mining Potion Active", id = 32773 },
        PerfectJujuWoodcuttingPotionActive = { name = "Perfect Juju Woodcutting Potion Active", id = 32757 },
        PerfectJujuSmithingPotionActive = { name = "Perfect Juju Smithing Potion Active", id = 32781 },
        PerfectJujuAgilityPotionActive = { name = "Perfect Juju Agility Potion Active", id = 32789 },
        PerfectJujuFarmingPotionActive = { name = "Perfect Juju Farming Potion Active", id = 32765 },
        PerfectJujuPrayerPotionActive = { name = "Perfect Juju Prayer Potion Active", id = 32797 },
        PerfectJujuHerblorePotionActive = { name = "Perfect Juju Herblore Potion Active", id = 32805 },
        PerfectJujuDungeoneeringPotionActive = { name = "Perfect Juju Dungeoneering Potion Active", id = 32813 },
        PerfectJujuFishingPotionActive = { name = "Perfect Juju Fishing Potion Active", id = 35739 },
        CamouflagePotionActive = { name = "Camouflage potion active", id = 37957 },
        LuckPotionActive = { name = "Luck potion active", id = 37963 },
        AggressionPotionActive = { name = "Aggression potion active", id = 37969 },
        EnhancedLuckPotionActive = { name = "Enhanced Luck potion active", id = 39820 },
        ExtremeCookingPotionActive = { name = "Extreme Cooking Potion Active - increases your Cooking level temporarily.", id = 49010 },
        HarvestPotionActive = { name = "Harvest Potion Active - allows you to discover special produce from your allotments patches.", id = 48968 },
        CharmingPotionActive = { name = "Charming potion active - gives an extra charm per charm drop.", id = 48986 },
        ElderOverloadActive = { name = "Elder Overload Active", id = 49039 },
        PowerburstOfAcceleration = { name = "Powerburst of acceleration", id = 49055 },
        PowerburstOfSorcery = { name = "Powerburst of sorcery", id = 49063 },
        PowerburstOfFeats = { name = "Powerburst of feats", id = 49071 },
        PowerburstOfMasterstroke = { name = "Powerburst of masterstroke", id = 49087 },
        PowerburstOfLifeforce = { name = "Powerburst of lifeforce", id = 49095 },
        ExtremeDivinationPotionActive = { name = "Extreme Divination Potion Active - increases your Divination level temporarily.", id = 44103 },
        ExtremeRunecraftingPotionActive = { name = "Extreme Runecrafting Potion Active - increases your Runecrafting level temporarily.", id = 44111 },
        ExtremeInventionPotionActive = { name = "Extreme Invention Potion Active - increases your Invention level temporarily.", id = 44119 },
        ExtremeHunterPotionActive = { name = "Extreme Hunter Potion Active - increases your Hunter level temporarily.", id = 44127 },
        BoostsTheMaximumAmountOfItems = { name = "Boosts the maximum amount of items you can make while fletching by 15 for 10 minutes.", id = 208 },
        GivesYouA10ChanceTo = { name = "Gives you a 10% chance to save resources while fletching for 10 minutes.", id = 208 },
        TriplesTheEffectivenessOfLuminiteInjectors = { name = "Triples the effectiveness of luminite injectors on you for 10 minutes.", id = 210 },
        DoublesAllYourRespectGainWithin = { name = "Doubles all your respect gain within the artisans workshop for 10 minutes.", id = 210 },
        DoublesTheActivationChanceOfPerks = { name = "Doubles the activation chance of perks on your tool while fishing for 10 minutes.", id = 211 },
        IncreasesTheItemExperienceYouGain = { name = "Increases the item experience you gain while fishing by 50% for 10 minutes.", id = 211 },
        DoublesTheAmountOfTokensMedals = { name = "Doubles the amount of tokens & medals you receive from Fish flingers for 15 minutes.", id = 211 },
        IncreasesYourChanceToObtainGeodes = { name = "Increases your chance to obtain geodes while mining by 10% for 10 minutes.", id = 209 },
        IncreasesYourChanceToCriticallyStrike = { name = "Increases your chance to critically strike a mining rock by 10% for 10 minutes.", id = 209 },
        SummoningRenewActive = { name = "Summoning Renew Active", id = 50843 },
        SpiritAttractionActive = { name = "Spirit Attraction Active", id = 50859 },
        PowerburstOfOpportunity = { name = "Powerburst of opportunity", id = 50880 },
        Col0x00ffff5ColSlayerXP = { name = "<col=0x00ffff>+5%</col> Slayer XP.<br><col=0x00ffff>+25%</col> chance not to decrease <col=0x00ffff>Slayer count</col> on target kill.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55991 },
        Col0x00ffff25ColChanceTo = { name = "<col=0x00ffff>+25%</col> chance to save <col=0x00ffff>bones and ashes</col> offered on an <col=0x00ffff>altar</col>.<br><col=0x00ffff>-33%</col> delay between offering on an <col=0x00ffff>altar</col>.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55992 },
        Col0x00ffff50ColBaseArchaeology = { name = "<col=0x00ffff>+50%</col> base Archaeology <col=0x00ffff>precision</col>.<br><col=0x00ffff>+100%</col> XP from <col=0x00ffff>sprite focus</col> buff.<br><col=0x00ffff>+1</col> material at <col=0x00ffff>100% sprite focus</col>.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55993 },
        Col0x00ffff100ColChanceTo = { name = "<col=0x00ffff>+100%</col> chance to spawn <col=0x00ffff>fire spirits</col> whilst <col=0x00ffff>Firemaking</col>.<br>When <col=0x00ffff>claiming</col> a fire spirit, gain <col=0x00ffff>100%</col> base <col=0x00ffff>Firemaking XP</col> of the log burnt to spawn it.<br><col=0x00ffff>Automatically claims</col> fire spirits when they spawn.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55994 },
        GrantsCol0x00ffffTier4Luck = { name = "Grants <col=0x00ffff>tier 4 luck</col> whilst active. This bonus is capped at <col=0x00ffff>tier 1</col> in <col=0x00ffff>free to play worlds</col>.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55995 },
        Col0x00ffff25ColCriticalChance = { name = "<col=0x00ffff>+25%</col> critical chance for <col=0x00ffff>Divination</col>.<br><col=0x00ffff>+100%</col> base <col=0x00ffff>energy</col> when harvesting from a <col=0x00ffff>Divination spring</col>.<br><col=0x00ffff>+50% energy</col> when converting memories to energy.<br>Lasts <col=0x00ffff>10</col> minutes.", id = 55996 },
        AutomaticallyCol0x00ffffSmashPumpkinsCol = { name = "Automatically <col=0x00ffff>smash pumpkins</col> when they spawn.<br>Consumes <col=0x00ffff>1</col> stack per use.<br>Grants <col=0x00ffff>5</col> stacks.", id = 55997 },
        AgilityPotionActive = { name = "Agility Potion Active - increases your Agility level temporarily.", id = 3034 },
        CraftingPotionActive = { name = "Crafting Potion Active - increases your Crafting level temporarily.", id = 14840 },
        SuperMiningPotionActive = { name = "Super Mining Potion Active - increases your Mining level temporarily.", id = 52452 },
        AntisanguineActive = { name = "Antisanguine Active", id = 60424 },
    },
    PRAYERS = {
        ThickSkin = { name = "Thick Skin", id = 25947 },
        RockSkin = { name = "Rock Skin", id = 25950 },
        SteelSkin = { name = "Steel Skin", id = 25956 },
        BurstOfStrength = { name = "Burst of Strength", id = 25948 },
        SuperhumanStrength = { name = "Superhuman Strength", id = 25951 },
        UltimateStrength = { name = "Ultimate Strength", id = 25957 },
        ClarityOfThought = { name = "Clarity of Thought", id = 25949 },
        ImprovedReflexes = { name = "Improved Reflexes", id = 25952 },
        IncredibleReflexes = { name = "Incredible Reflexes", id = 25958 },
        SharpEye = { name = "Sharp Eye", id = 25965 },
        HawkEye = { name = "Hawk Eye", id = 25967 },
        EagleEye = { name = "Eagle Eye", id = 25969 },
        UnstoppableForce = { name = "Unstoppable Force", id = 25979 },
        UnrelentingForce = { name = "Unrelenting Force", id = 25980 },
        OverpoweringForce = { name = "Overpowering Force", id = 25981 },
        MysticWill = { name = "Mystic Will", id = 25966 },
        MysticLore = { name = "Mystic Lore", id = 25968 },
        MysticMight = { name = "Mystic Might", id = 25970 },
        Charge = { name = "Charge", id = 25976 },
        SuperCharge = { name = "Super Charge", id = 25977 },
        Overcharge = { name = "Overcharge", id = 25978 },
        Chivalry = { name = "Chivalry", id = 25972 },
        Piety = { name = "Piety", id = 25973 },
        Augury = { name = "Augury", id = 25974 },
        Rigour = { name = "Rigour", id = 25982 },
        RapidRestore = { name = "Rapid Restore", id = 25953 },
        RapidHeal = { name = "Rapid Heal", id = 25954 },
        RapidRenewal = { name = "Rapid Renewal", id = 25975 },
        ProtectItem = { name = "Protect Item", id = 26046 },
        ProtectFromMagic = { name = "Protect from Magic", id = 25959 },
        ProtectFromRanged = { name = "Protect from Ranged", id = 25960 },
        ProtectFromMelee = { name = "Protect from Melee", id = 25961 },
        ProtectFromSummoning = { name = "Protect from Summoning", id = 25971 },
        Retribution = { name = "Retribution", id = 25963 },
        Redemption = { name = "Redemption", id = 25962 },
        Smite = { name = "Smite", id = 25964 },
        SapMeleeAttack = { name = "Sap Melee Attack", id = 26023 },
        SapRangedAttack = { name = "Sap Ranged Attack", id = 26024 },
        SapRangedStrength = { name = "Sap Ranged Strength", id = 26034 },
        SapMagicAttack = { name = "Sap Magic Attack", id = 26026 },
        SapMagicStrength = { name = "Sap Magic Strength", id = 26039 },
        SapAdrenaline = { name = "Sap Adrenaline", id = 26025 },
        SapDefence = { name = "Sap Defence", id = 26031 },
        SapMeleeStrength = { name = "Sap Melee Strength", id = 26032 },
        Berserker = { name = "Berserker", id = 26042 },
        DeflectSummoning = { name = "Deflect Summoning", id = 26045 },
        DeflectMagic = { name = "Deflect Magic", id = 26041 },
        DeflectRanged = { name = "Deflect Ranged", id = 26044 },
        DeflectMelee = { name = "Deflect Melee", id = 26040 },
        LeechMeleeAttack = { name = "Leech Melee Attack", id = 26027 },
        LeechRangedAttack = { name = "Leech Ranged Attack", id = 26028 },
        LeechRangedStrength = { name = "Leech Ranged Strength", id = 26038 },
        LeechMagicAttack = { name = "Leech Magic Attack", id = 26030 },
        LeechMagicStrength = { name = "Leech Magic Strength", id = 26043 },
        LeechDefence = { name = "Leech Defence", id = 26035 },
        LeechMeleeStrength = { name = "Leech Melee Strength", id = 26036 },
        LeechRunEnergy = { name = "Leech Run Energy", id = 26037 },
        LeechAdrenaline = { name = "Leech Adrenaline", id = 26029 },
        Wrath = { name = "Wrath", id = 26022 },
        SoulSplit = { name = "Soul Split", id = 26033 },
        Turmoil = { name = "Turmoil", id = 26019 },
        Torment = { name = "Torment", id = 26021 },
        Anguish = { name = "Anguish", id = 26020 },
        ChronicleAttraction = { name = "Chronicle Attraction", id = 26053 },
        Fortitude = { name = "Fortitude", id = 26047 },
        LightForm = { name = "Light Form", id = 26048 },
        DarkForm = { name = "Dark Form", id = 26049 },
        SoulLink = { name = "Soul Link", id = 26050 },
        TeamworkProtection = { name = "Teamwork Protection", id = 26051 },
        SuperheatForm = { name = "Superheat Form", id = 26055 },
        Malevolence = { name = "Malevolence", id = 29262 },
        Desolation = { name = "Desolation", id = 29263 },
        Affliction = { name = "Affliction", id = 29264 },
        HandOfJudgement = { name = "Hand of Judgement", id = 30851 },
        HandOfFate = { name = "Hand of Fate", id = 30863 },
        HandOfDoom = { name = "Hand of Doom", id = 30904 },
        Decay = { name = "Decay", id = 30906 },
        HastenedDecay = { name = "Hastened Decay", id = 30908 },
        AcceleratedDecay = { name = "Accelerated Decay", id = 30910 },
        Sanctity = { name = "Sanctity", id = 30925 },
        ProtectFromNecromancy = { name = "Protect from Necromancy", id = 30831 },
        SapNecromancyAttack = { name = "Sap Necromancy Attack", id = 30791 },
        SapNecromancyStrength = { name = "Sap Necromancy Strength", id = 30811 },
        DeflectNecromancy = { name = "Deflect Necromancy", id = 30745 },
        LeechNecromancyAttack = { name = "Leech Necromancy Attack", id = 30747 },
        LeechNecromancyStrength = { name = "Leech Necromancy Strength", id = 30758 },
        Sorrow = { name = "Sorrow", id = 30771 },
        Ruination = { name = "Ruination", id = 30769 },
        DivineRage = { name = "Divine Rage", id = 33970 },
        EclipsedSoul = { name = "Eclipsed Soul", id = 34199 },
    },
    SKILLING = {
        AdrenalineUrn = { name = "Adrenaline urn - prevents your adrenaline draining while out of combat.", id = 44210 },
        YourSignOfThePorterIs = { name = "Your sign of the porter is active, banking specific items, using a charge each time.", id = 51490 },
        SliverOfEdicts = { name = "Sliver of Edicts", id = 63597 },
        PortableTraderSummoningStoneActive = { name = "Portable Trader summoning stone active", id = 47804 },
        QuiverAmmo = { name = "Quiver ammo", id = 33719 },
        GuamIncense = { name = "Guam Incense:", id = 47699 },
        TarrominIncense = { name = "Tarromin Incense:", id = 47700 },
        MarrentillIncense = { name = "Marrentill Incense:", id = 47701 },
        HarralanderIncense = { name = "Harralander Incense:", id = 47702 },
        RanarrIncense = { name = "Ranarr Incense:", id = 47703 },
        ToadflaxIncense = { name = "Toadflax Incense:", id = 47704 },
        SpiritWeedIncense = { name = "Spirit weed Incense:", id = 47705 },
        IritIncense = { name = "Irit Incense:", id = 47706 },
        WergaliIncense = { name = "Wergali Incense:", id = 47707 },
        AvantoeIncense = { name = "Avantoe Incense:", id = 47708 },
        KwuarmIncense = { name = "Kwuarm Incense:", id = 47709 },
        BloodweedIncense = { name = "Bloodweed Incense:", id = 47710 },
        SnapdragonIncense = { name = "Snapdragon Incense:", id = 47711 },
        CadantineIncense = { name = "Cadantine Incense:", id = 47712 },
        LantadymeIncense = { name = "Lantadyme Incense:", id = 47713 },
        DwarfWeedIncense = { name = "Dwarf weed Incense:", id = 47714 },
        TorstolIncense = { name = "Torstol Incense:", id = 47715 },
        FellstalkIncense = { name = "Fellstalk Incense:", id = 47716 },
        ReaperNecklace = { name = "Reaper Necklace - provides a 0.1% accuracy boost per stack", id = 26099 },
        Deathmark = { name = "Deathmark - gain an additional 1% adrenaline from basic abilities.", id = 26100 },
        ScrimshawActive = { name = "Scrimshaw Active", id = 26097 },
        HealerSChocolateBrYouAre = { name = "Healer's chocolate<br>You are currently regenerating health.", id = 24532 },
        KnightSChocolateBrYouAre = { name = "Knight's chocolate<br>You are currently shielded from some damage.", id = 24537 },
        BerserkerSChocolateBrYourAttacks = { name = "Berserker's chocolate<br>Your attacks of all types currently do extra damage.", id = 24535 },
        PorterSChocolateBrYouWill = { name = "Porter's chocolate<br>You will send some items you gather to the bank automatically.", id = 24536 },
        _2XPLovePotionActive = { name = "+2% XP Love Potion Active", id = 34010 },
        _1XPLovePotionActive = { name = "+1% XP Love Potion Active", id = 34010 },
        PulseCore = { name = "Pulse Core - 2% XP Boost", id = 34918 },
        BeachCocktail = { name = "Beach Cocktail", id = 35051 },
        BaronSharkBoostActive = { name = "Baron Shark Boost Active", id = 19948 },
        CinderCore = { name = "Cinder Core - 2% Bonus XP Burn Boost", id = 48544 },
        YourChallengerPorterIsActiveAnd = { name = "Your challenger porter is active and has a 50% chance to bank specific items.", id = 53755 },
        DreadnipActive = { name = "Dreadnip active - A ferocious pest is attacking your target.", id = 22370 },
        DamageInPvPIsReducedBy = { name = "Damage in PvP is reduced by 15%.", id = 22446 },
        BrassicaPrimer = { name = "Brassica Primer - gives a 10% XP boost when checking the health of Farming patches", id = 48950 },
        KuradalSFavour = { name = "Kuradal's Favour", id = 1519 },
        GoldenTouch = { name = "Golden Touch - All alchable items (under your loot beam value) that drop for the next 60 seconds will be automatically high-alched", id = 1520 },
        Limitless = { name = "Limitless - You are no longer required to reach 50% adrenaline to use threshold abilities", id = 1522 },
        IngenuityOfTheHumans = { name = "Ingenuity of the Humans - The next strike from an ability you use is guaranteed to hit.", id = 1521 },
        UndeadSlayer = { name = "Undead slayer - Boosts your damage against the undead by 15%.", id = 1524 },
        YourFurySharkHasBeenConsumed = { name = "Your fury shark has been consumed and will protect an item for one minute.", id = 20429 },
        YourBookOfCharIsActive = { name = "Your Book of Char is active, burning any logs you walk over.", id = 23027 },
        GlovesOfPassage = { name = "Gloves of Passage - Your next melee attack within 6 seconds deals 10% increased damage.", id = 40322 },
        DominionMine1Placed = { name = "Dominion Mine 1 Placed", id = 22371 },
        DominionMine2Placed = { name = "Dominion Mine 2 Placed", id = 22371 },
        FurnaceCore = { name = "Furnace Core", id = 50806 },
        ArtificerSMeasure = { name = "Artificer's Measure", id = 50805 },
        FungalShieldActive = { name = "Fungal Shield Active", id = 52272 },
        PinkFizzBeachCocktail = { name = "Pink fizz (beach cocktail)", id = 35051 },
        PurpleLumbridgeBeachCocktail = { name = "Purple Lumbridge (beach cocktail)", id = 35052 },
        PineappletiniBeachCocktail = { name = "Pineappletini (beach cocktail)", id = 35053 },
        LemonSourBeachCocktail = { name = "Lemon sour (beach cocktail)", id = 35054 },
        YourAbilityToDelveIntoThe = { name = "Your ability to delve into the 'Dungeoneering Hole' activity is improved.<br>XP gain is increased by +10%.<br>You can now complete '60 floors' before having to break.<br>Doing the activity won't increase your temperature gauge.<br>This effect lasts 15 mins.", id = 51729 },
        YourProwessAtTheHookA = { name = "Your prowess at the 'Hook a Duck' activity is improved.<br>XP gain is increased by +10%.<br>This effect lasts 15 mins.", id = 51730 },
        YourSkillAtPickingCoconutsFrom = { name = "Your skill at picking coconuts from the 'Palm Tree Farming' activity is improved.<br>XP gain is increased by +10%.<br>Picking from trees no longer depletes fruit from the tree.<br>This effect lasts 15 mins.", id = 51731 },
        YourAbilityToFishWithinThe = { name = "Your ability to fish within the 'Rock Pools' is improved.<br>XP gain is increased by +10%.<br>This effect lasts 15 mins.", id = 51732 },
        YourSkillAtTheSandcastleBuilding = { name = "Your skill at the 'Sandcastle Building' activity is improved.<br>XP gain is increased by +10%.<br>You can shovel sand up to 60 times before you need a rest.<br>This effect lasts 15 mins.", id = 51733 },
        Havoc = { name = "Havoc", id = 53378 },
        EssenceCorruptionAdrenaline = { name = "Essence Corruption: Adrenaline", id = 33963 },
        VampyreSlayer = { name = "Vampyre slayer - Boosts your damage against vampyric creatures by 15%.", id = 36578 },
        VitalDrain = { name = "Vital drain - Steals health from enemies hit.", id = 36569 },
    },
    SUMMON = {
        FamiliarSummoned = { name = "Familiar Summoned", id = 26095 },
        LegendaryPetAbilityBeastOfBurden = { name = "Legendary Pet Ability: Beast of Burden", id = 25403 },
        EnlightenmentBrBetterRewardsOnThe = { name = "Enlightenment<br>- Better rewards on the Hefin Agility Course<br>- Increases the instant memory conversion chance to 50%<br>- Gives a 10% chance of getting double blue tears in Tears of Guthix", id = 18781 },
        KalGerionRoar = { name = "Kal'gerion roar - +5% Critical Strike Chance.", id = 49416 },
    },
}

DX.Data.Debuffs = {
    ABIL = {
        Punctured = { name = "Punctured", id = 30335 },
        AbyssalParasite = { name = "Abyssal Parasite", id = 52931 },
        Debilitated = { name = "Debilitated", id = 14226 },
        FragmentationShot = { name = "Fragmentation Shot", id = 14247 },
        IncendiaryShot = { name = "Incendiary Shot", id = 14252 },
        Deadshot = { name = "Deadshot", id = 23730 },
        AdaptiveStrike = { name = "Adaptive Strike", id = 21237 },
        Slaughter = { name = "Slaughter", id = 21362 },
        Massacre = { name = "Massacre", id = 21296 },
        Pulverise = { name = "Pulverise", id = 14266 },
        Provoke = { name = "Provoke", id = 14221 },
        Combust = { name = "Combust", id = 23401 },
        Confuse = { name = "Confuse", id = 14389 },
        Weaken = { name = "Weaken", id = 14390 },
        Curse = { name = "Curse", id = 14391 },
        Vulnerability = { name = "Vulnerability", id = 14395 },
        Enfeeble = { name = "Enfeeble", id = 14371 },
        Stagger = { name = "Stagger", id = 14377 },
        PenanceAttack = { name = "Penance Attack - Inflicts 50 (500 if insignia was charged) damage every 3 seconds for 12 seconds", id = 16852 },
        BloodTendrils = { name = "Blood Tendrils", id = 17500 },
        CorruptionBlast = { name = "Corruption Blast", id = 19226 },
        CorruptionShot = { name = "Corruption Shot", id = 17255 },
        Devour = { name = "Devour", id = 39057 },
        YourMazcabDefensiveResetEffectWill = { name = "Your Mazcab defensive reset effect will not activate for at least 60 seconds.", id = 35248 },
        YourVengeanceAbilityIsOnCooldown = { name = "Your Vengeance ability is on cooldown.", id = 14423 },
        FuryOfLeng = { name = "Fury of Leng - Each stack increases damage output by 1% and breaks through protection prayers by 0.25%", id = 842 },
        EvolvingToxinIncreasesPoisonDamageTaken = { name = "Evolving Toxin: Increases poison damage taken by percentage displayed. After 30 seconds without an ability using a Bik arrow hitting the target, all stacks are removed.", id = 19118 },
        FrostSurge = { name = "Frost Surge - Currently on cooldown.", id = 14766 },
        SmokeCloud = { name = "Smoke Cloud", id = 14771 },
        CroesusDeathspores = { name = "Croesus Deathspores", id = 52260 },
        KerapacSFuryEachStackIncreases = { name = "Kerapac's Fury: Each stack increases damage output by 1% and breaks through protection prayers by 0.25%", id = 15145 },
        Grounded = { name = "Grounded - Each stack increases this creature's Attack and Strength by 1%.", id = 19434 },
        CorruptedWounds = { name = "Corrupted Wounds", id = 40320 },
        GuardianSTriumph = { name = "Guardian's Triumph", id = 20225 },
        SpiritTrauma = { name = "Spirit trauma - Healing effects have been reduced by 40%.", id = 39057 },
        TheEmpoweredEffectOfTuskaS = { name = "The empowered effect of Tuska's Wrath is on cooldown.", id = 8861 },
        ExtremeVulnerability = { name = "Extreme Vulnerability", id = 30092 },
        DeathGrasp = { name = "Death Grasp", id = 55524 },
        CrystalRain = { name = "Crystal Rain", id = 37632 },
        PowerOfDarkness = { name = "Power of Darkness", id = 34155 },
        IcyTempest = { name = "Icy Tempest", id = 52053 },
        VineCall = { name = "Vine Call", id = 21371 },
        PhantomStrike = { name = "Phantom Strike.", id = 13879 },
        DevourerSContagion = { name = "Devourer's Contagion", id = 57126 },
        Soulfire = { name = "Soulfire", id = 57162 },
        IgneousShowdown = { name = "Igneous Showdown", id = 52511 },
        SunfallSlam = { name = "Sunfall Slam", id = 59350 },
        Specialist = { name = "Specialist", id = 35242 },
        Resurrection = { name = "Resurrection", id = 35240 },
        Fishstabber = { name = "Fishstabber", id = 60101 },
        Combusted = { name = "Combusted", id = 23401 },
        Rend = { name = "Rend", id = 14211 },
        SanguineVolley = { name = "Sanguine Volley", id = 64191 },
    },
    MISC = {
        Stunned = { name = "Stunned", id = 26103 },
        Bound = { name = "Bound", id = 14392 },
        Poisoned = { name = "Poisoned", id = 30097 },
        Corrupted = { name = "Corrupted - Damage dealt and damage taken is increased by 1% per stack", id = 30722 },
        SoulDrained = { name = "Soul drained - Each stack reduces your maximum health by <col=ffffff>100</col> lifepoints", id = 30721 },
        Enervated = { name = "Enervated", id = 33964 },
        Frozen = { name = "Frozen", id = 14415 },
        CamelSandstorm = { name = "Camel Sandstorm - 5% reduced chance to hit", id = 36019 },
        Toxic = { name = "Toxic - a deadly venom flows through your veins dealing rapid damage.", id = 30722 },
        CavernChill = { name = "Cavern Chill", id = 8437 },
        Bleeding = { name = "Bleeding", id = 21239 },
        ArmourBreak = { name = "Armour Break - Armour effectiveness is reduced by 1% per stack.", id = 9228 },
        YourPortentOfRestorationHasRecently = { name = "Your Portent of Restoration has recently activated, it'll activate again when off cooldown.", id = 29257 },
        YouAreUnableToUseOverhead = { name = "You are unable to use overhead protection prayers and deflection curses.", id = 26343 },
        TeleportBlock = { name = "Teleport Block - Prevents teleporting using any spells or items.", id = 14344 },
        DownToEarth = { name = "Down to Earth - Each stack lowers magic damage by 1%.", id = 41628 },
        DeepSeaFishing = { name = "Deep Sea Fishing - Electrified stacks can be removed by catching regular jellyfish. If you continue to fish from electrifying jellyfish with 10 stacks, the jellyfish will stun you and you will not be able to remove this debuff for a period of time.", id = 33045 },
        HoaryChill = { name = "Hoary Chill", id = 9881 },
        ShadowsOfTheEmpire = { name = "Shadows of the Empire", id = 51656 },
        Corrosion = { name = "Corrosion", id = 9882 },
        Frostbite = { name = "Frostbite - You have been frozen to the core, reducing attack speed and movement speed.", id = 9881 },
        SearingPain = { name = "Searing Pain - The suffering is reducing your maximum life points.", id = 30721 },
        HeatingUp = { name = "Heating Up - You're hot enough to be able to damage TzKal-Zuk's spire!", id = 30721 },
        SavageWounds = { name = "Savage Wounds", id = 21239 },
        YourLacerationBootsEmpoweringEffectIs = { name = "Your laceration boots' empowering effect is on cooldown.", id = 14208 },
        Haunted = { name = "Haunted", id = 30212 },
        DeathMark = { name = "Death Mark", id = 30100 },
        ZemouregalSEmpowerment = { name = "Zemouregal's Empowerment", id = 34478 },
        ShatteringBones = { name = "Shattering bones", id = 33146 },
        ResurrectionSickness = { name = "Resurrection Sickness", id = 33976 },
        Corruption = { name = "Corruption", id = 30722 },
        LesserPulverised = { name = "Lesser Pulverised", id = 14266 },
        Pulverised = { name = "Pulverised", id = 14266 },
        Severed = { name = "Severed", id = 14209 },
        ApmekenSBurden = { name = "Apmeken's Burden", id = 35063 },
        Interceptor = { name = "Interceptor", id = 35067 },
        AfflictedWound = { name = "Afflicted Wound", id = 36579 },
        SanguineStrike = { name = "Sanguine Strike", id = 36601 },
        Haemorrhage = { name = "Haemorrhage", id = 36579 },
        Exsanguinated = { name = "Exsanguinated", id = 36576 },
        CrimsonLament = { name = "Crimson Lament", id = 36599 },
        BloodChallenge = { name = "Blood Challenge", id = 36600 },
    },
    POTS = {
        PowerburstPotionIsOnCooldown = { name = "Powerburst potion is on cooldown.", id = 48960 },
        AdrenalinePotionPrevention = { name = "Adrenaline potion prevention", id = 26094 },
    },
    PRAYERS = {
        YouHaveAPrayerActiveDraining = { name = "You have a prayer active, draining your prayer points.", id = 18857 },
    },
    REDUCED = {
        AttackStatReduced = { name = "Attack Stat Reduced", id = 25831 },
        StrengthStatReduced = { name = "Strength Stat Reduced", id = 25832 },
        DefenceStatReduced = { name = "Defence Stat Reduced", id = 25833 },
        RangedStatReduced = { name = "Ranged Stat Reduced", id = 25834 },
        PrayerPointsReduced = { name = "Prayer Points Reduced", id = 18857 },
        MagicStatReduced = { name = "Magic Stat Reduced", id = 25836 },
        LifePointsReduced = { name = "Life Points Reduced", id = 25837 },
        WoodcuttingStatReduced = { name = "Woodcutting Stat Reduced", id = 16197 },
        MiningStatReduced = { name = "Mining Stat Reduced", id = 16056 },
        FishingStatReduced = { name = "Fishing Stat Reduced", id = 16050 },
        HunterStatReduced = { name = "Hunter Stat Reduced", id = 16053 },
        NecromancyStatReduced = { name = "Necromancy Stat Reduced", id = 30213 },
    },
    SKILLING = {
        ThePorterFunctionalityOfYourGrace = { name = "The porter functionality of your Grace of the Elves is disabled.", id = 44550 },
        SweetToothBrYouHaveRecently = { name = "Sweet tooth<br>You have recently eaten a chocolate and can't have another one.", id = 24538 },
        DeployedACalorieBomb = { name = "Deployed a Calorie bomb", id = 9155 },
        EnhancedExcalibur = { name = "Enhanced Excalibur - Currently on cooldown.", id = 14632 },
        Bloodthirsty = { name = "Bloodthirsty - Your body requires at least 60 seconds recovery time between Blood Essence activations.", id = 37230 },
        YouWillNotBenefitFromAnother = { name = "You will not benefit from another Sign/Portent of Life for one hour; this also applies to the Defence skillcape.", id = 29290 },
        YourGorajianMushroomEffectIsOn = { name = "Your Gorajian mushroom effect is on cooldown.", id = 22446 },
        YourCannonIsActiveOnceThe = { name = "Your cannon is active. Once the timer runs out, it will jam!", id = 2 },
        YourTeaFlaskIsCurrentlyReheating = { name = "Your tea flask is currently reheating.", id = 41987 },
        AncientElvenRitualShard = { name = "Ancient elven ritual shard - Currently on cooldown.", id = 43358 },
        StalledMasterworkDamage = { name = "Stalled masterwork damage", id = 46038 },
        YourFungalShieldEffectIsOn = { name = "Your Fungal Shield effect is on cooldown.", id = 52272 },
        RingOfDeath = { name = "Ring of Death", id = 31869 },
        Wicked = { name = "Wicked - Blocks any XP boosts from the savvy runecrafting levelling benefit.", id = 22332 },
    },
    SUMMON = {
        LegendaryPetAbilityBanking = { name = "Legendary Pet Ability: Banking", id = 25418 },
        LegendaryPetAbilityLifeSaver = { name = "Legendary Pet Ability: Life Saver", id = 25409 },
        LegendaryPetAbilityItemRepair = { name = "Legendary Pet Ability: Item Repair", id = 25412 },
        LegendaryPetAbilityHighLevelAlchemy = { name = "Legendary Pet Ability: High Level Alchemy", id = 25400 },
        LegendaryPetAbilityFertiliser = { name = "Legendary Pet Ability: Fertiliser", id = 25406 },
    },
}

DX.Util = {}

---@param s string|nil
---@return boolean
function DX.Util.isEmpty(s)
    return s == nil or s == ''
end

---@param tbl table
---@param v any
---@return boolean
function DX.Util.tableIncludes(tbl, v)
    for i = 1, #tbl do
        if tbl[i] == v then
            return true
        end
    end
    return false
end

---@param ... table[]
---@return table
function DX.Util.concat(...)
    local result = {}
    for _, tbl in ipairs({ ... }) do
        for _, value in ipairs(tbl) do
            table.insert(result, value)
        end
    end
    return result
end

---@param tbl table
---@return table
function DX.Util.distinct(tbl)
    local distinctValues = {}
    local seenValues = {}
    for _, value in ipairs(tbl) do
        if not seenValues[value] then
            table.insert(distinctValues, value)
            seenValues[value] = true
        end
    end
    return distinctValues
end

---@param tbl table
---@param prop string
---@return table
function DX.Util.distinctBy(tbl, prop)
    local distinctValues = {}
    local seenValues = {}
    for _, value in ipairs(tbl) do
        local p = value[prop]
        if not seenValues[p] then
            table.insert(distinctValues, value)
            seenValues[p] = true
        end
    end
    return distinctValues
end

---@param value any
---@param tbl table
---@return any|nil
function DX.Util.labelOf(value, tbl)
    for label, record in pairs(tbl) do
        if record == value then
            return label
        end
    end
    return nil
end

---@param ud userdata
---@return table
function DX.Util.userdataToTable(ud)
    local vector = {}
    for i = 1, #ud do
        vector[i] = ud[i]
    end
    return vector
end

---@param ud userdata
---@return string
function DX.Util.userdataToString(ud)
    local vector = {}
    for i = 1, #ud do
        vector[i] = ud[i]
    end
    return table.concat(vector, "")
end

---@param tbl table
---@return string
function DX.Util.tableToString(tbl)
    local strTable = {}
    for _, innerTbl in ipairs(tbl) do
        local strInnerTable = {}
        for _, value in ipairs(innerTbl) do
            table.insert(strInnerTable, tostring(value))
        end
        table.insert(strTable, "{" .. table.concat(strInnerTable, ", ") .. "}")
    end
    return table.concat(strTable, ", ")
end


---@param s number seconds
---@return string "HH:MM:SS"
function DX.Util.fmtTime(s)
    s = math.max(0, math.floor(s or 0))
    return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor((s % 3600) / 60), s % 60)
end

---@param n number
---@return string compact number ("1.2M", "45.3K")
function DX.Util.fmtNum(n)
    n = n or 0
    if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(math.floor(n))
end

---@param n number amount gained
---@param secs number elapsed seconds
---@return number amount per hour
function DX.Util.perHour(n, secs)
    secs = math.max(1, secs or 1)
    return math.floor((n / secs) * 3600)
end

DX.Game = {}

local stateFailCount = 0
local lastAfkTime = os.time()
local afkThreshold = nil

---@return boolean
function DX.Game.isLoggedIn()
    return API.GetGameState2() == 3
end

---@return boolean
function DX.Game.isRunning()
    return API.Read_LoopyLoop() and DX.Game.isLoggedIn()
end

---@return boolean
function DX.Game.stateChecks()
    if API.GetGameState2() ~= 3 and stateFailCount > 5 then
        print('not logged in after 100 checks')
        API.Write_LoopyLoop(false)
        return false
    elseif API.GetGameState2() ~= 3 then
        DX.Wait.forCondition(function() return API.GetGameState2() == 3 end, 5, 'state change to 3', { stateChecks = false })
        print('not logged in ' .. tostring(stateFailCount))
        stateFailCount = stateFailCount + 1
    end
    if not API.Read_LoopyLoop() then
        print('LoopyLoop is false')
        return false
    end
    return true
end

---@param maxIdleMinutes number|nil
---@return boolean
function DX.Game.antiIdle(maxIdleMinutes)
    maxIdleMinutes = maxIdleMinutes or 5
    if afkThreshold == nil then
        afkThreshold = math.random((maxIdleMinutes * 60) * 0.6, (maxIdleMinutes * 60) * 0.9)
    end
    local timeDiff = os.difftime(os.time(), lastAfkTime)
    if timeDiff > afkThreshold then
        API.PIdle2()
        lastAfkTime = os.time()
        afkThreshold = math.random((maxIdleMinutes * 60) * 0.6, (maxIdleMinutes * 60) * 0.9)
        return true
    end
    return false
end

---@return boolean
function DX.Game.handleRandomEvents()
    local F_obj = API.GetAllObjArrayInteract({ 19884, 26022, 27228, 27297, 28411, 30599, 15451 }, 20, { 1 })
    if F_obj ~= nil and #F_obj > 0 then
        print("Random event object detected: trying to click")
        DX.Wait.randomSleep(1000)
        if API.DoAction_NPC__Direct(0x29, API.OFF_ACT_InteractNPC_route, F_obj[1]) then
            DX.Wait.randomSleep(1000)
            return true
        end
    end
    return false
end

---@return boolean
function DX.Game.canUseLodestone()
    local vb = API.VB_FindPSett(7994)
    return vb.state == -1 or vb.stateAlt == -1
end

DX.Wait = {}

---@param ms number
---@param jitterMin number|nil
---@param jitterMax number|nil
function DX.Wait.sleep(ms, jitterMin, jitterMax)
    jitterMin = jitterMin or 0
    jitterMax = jitterMax or 0
    local randomDelay = math.random(jitterMin, jitterMax)
    local totalDelay = ms + randomDelay
    local start = os.clock()
    local target = start + (totalDelay / 1000)
    while os.clock() < target do
        API.RandomSleep2(50, 0, 0)
    end
end

---@param ms number
function DX.Wait.randomSleep(ms)
    DX.Wait.sleep(ms, 1, 200)
end

---@param cond function
---@param timeoutSec number
---@param label string
---@param opts table|nil {randomEvents=true, stateChecks=true, checkLoopy=true, quiet=false}
---@return boolean
function DX.Wait.forCondition(cond, timeoutSec, label, opts)
    opts = opts or {}
    local randomEvents = opts.randomEvents ~= false
    local stateChecks = opts.stateChecks ~= false
    local checkLoopy = opts.checkLoopy ~= false
    local quiet = opts.quiet == true
    label = label or "condition"
    local startTime = os.time()
    while not cond() do
        if randomEvents then
            API.DoRandomEvents()
        end
        if os.difftime(os.time(), startTime) >= timeoutSec then
            if not quiet then
                print("Stopped waiting for " .. label .. " after " .. timeoutSec .. " seconds.")
            end
            break
        end
        if checkLoopy and not API.Read_LoopyLoop() then
            if not quiet then
                print("Script exited - breaking sleep.")
            end
            break
        end
        if stateChecks and not DX.Game.stateChecks() then
            if not quiet then
                print("State checks failed - breaking sleep.")
            end
            break
        end
        API.RandomSleep2(50, 0, 0)
    end
    if cond() then
        if not quiet then
            print("Sleep condition met for " .. label)
        end
        return true
    end
    return false
end

---@param n number
---@return number ticks elapsed, or 0 if the script stopped running
function DX.Wait.ticks(n)
    local currentTick = API.Get_tick()
    local target = currentTick + n
    while target >= currentTick do
        currentTick = API.Get_tick()
        DX.Wait.sleep(10, 0, 0)
        if not DX.Game.isRunning() then
            return 0
        end
    end
    return n
end

---@param animId number
---@param timeoutSec number|nil
---@return boolean
function DX.Wait.forAnimation(animId, timeoutSec)
    animId = animId or 0
    timeoutSec = timeoutSec or 5
    local start = os.time()
    while os.time() - start < timeoutSec do
        if not (API.Read_LoopyLoop() and API.PlayerLoggedIn()) then
            return false
        end
        if API.ReadPlayerAnim() == animId then
            return true
        end
        DX.Wait.sleep(50, 50, 50)
    end
    return false
end

---@param coord FFPOINT
---@param threshold number|nil
---@param timeoutSec number|nil
---@return boolean
function DX.Wait.forCoords(coord, threshold, timeoutSec)
    threshold = threshold or 0
    timeoutSec = timeoutSec or 5
    local start = os.time()
    while os.time() - start < timeoutSec do
        if not (API.Read_LoopyLoop() and API.PlayerLoggedIn()) then
            return false
        end
        if API.PInAreaF2(coord, threshold) then
            return true
        end
        DX.Wait.sleep(50, 50, 50)
    end
    return false
end

------------------------------------------------------------------
-- DX.State - reliable activity/state detection.
-- Player.Animation / InteractingNpc go stale on this server during
-- channeling (wisps, gathering) and some actions, so activity is
-- derived from observables that DO update: position, inventory
-- quantities, XP, and object presence via GetAllObjArrayInteract.
------------------------------------------------------------------
DX.State = {}

---Convert a sol.std::vector userdata (0- or 1-indexed) or plain table to a
---Lua array. Returns the input unchanged if already a table.
local function stateToTable(x)
    if type(x) == "table" then return x end
    if type(x) ~= "userdata" then return nil end
    local ok, t = pcall(DX.Util.userdataToTable, x)
    if ok and type(t) == "table" and #t > 0 then return t end
    local okn, n = pcall(function() return #x end)
    if not okn or type(n) ~= "number" or n <= 0 then return {} end
    local t2 = {}
    for i = 0, n - 1 do
        local okv, v = pcall(function() return x[i] end)
        if okv and v ~= nil then t2[#t2 + 1] = v end
    end
    return t2
end

---@return table|nil { id -> qty } for all inventory items, or nil on read failure
local function stateInvMap()
    local ok, items = pcall(function() return Inventory:GetItems() end)
    if not ok or items == nil then return nil end
    items = stateToTable(items)
    if type(items) ~= "table" then return nil end
    local map = {}
    for _, it in pairs(items) do
        if type(it) == "table" then
            local id = it.id or it.item_id or it.itemid1
            local qty = it.amount or it.item_stack or it.itemid1_size or 1
            if id and id > 0 then map[id] = (map[id] or 0) + qty end
        end
    end
    return map
end

---@param ids number|table item id or list of ids
---@return number total quantity held across all stacks, -1 on read failure
function DX.State.itemCount(ids)
    if type(ids) == "number" then ids = { ids } end
    local map = stateInvMap()
    if map == nil then return -1 end
    local total = 0
    for _, id in ipairs(ids) do total = total + (map[id] or 0) end
    return total
end

---@param ids table object/npc ids
---@param maxdist number|nil search radius, default 25
---@param types table|nil object types, default {0,1,12}
---@return boolean true if any listed entity is within range
function DX.State.objectsPresent(ids, maxdist, types)
    local ok, arr = pcall(API.GetAllObjArrayInteract, ids, maxdist or 25, types or { 0, 1, 12 })
    if not ok or arr == nil then return false end
    arr = stateToTable(arr)
    return type(arr) == "table" and next(arr) ~= nil
end

local StateTracker = {}
StateTracker.__index = StateTracker

---Create an activity tracker. Call :sample() once per main-loop iteration.
---@param opts table|nil { xpSkills = {"DIVINATION", ...} }
---@return table tracker
function DX.State.newTracker(opts)
    opts = opts or {}
    return setmetatable({
        xpSkills = opts.xpSkills or {},
        snap = nil,
        lastChange = os.clock(),
    }, StateTracker)
end

function StateTracker:_snapshot()
    local s = { t = os.clock() }
    local ok, coord = pcall(API.PlayerCoordfloat)
    if ok and coord then
        s.x, s.y, s.z = coord.x, coord.y, coord.z
    end
    local okm, mv = pcall(API.ReadPlayerMovin2)
    if okm then s.moving = mv and true or false end
    s.inv = stateInvMap()
    if #self.xpSkills > 0 then
        s.xp = {}
        for _, sk in ipairs(self.xpSkills) do
            local okx, xp = pcall(API.GetSkillXP, sk)
            if okx and type(xp) == "number" then s.xp[sk] = xp end
        end
    end
    return s
end

local function invChanged(a, b)
    if a == nil or b == nil then return a ~= b end
    for id, q in pairs(a) do if b[id] ~= q then return true end end
    for id in pairs(b) do if a[id] == nil then return true end end
    return false
end

---Take a sample. Returns the snapshot and a table of what changed
---({pos=bool, moving=bool, inv=bool, xp=bool, any=bool}).
---@return table snapshot, table changed
function StateTracker:sample()
    local s = self:_snapshot()
    local prev = self.snap
    local ch = { pos = false, moving = false, inv = false, xp = false, any = false }
    if prev == nil then
        ch.pos, ch.moving, ch.inv, ch.xp, ch.any = true, true, true, true, true
    else
        ch.pos = (s.x ~= prev.x) or (s.y ~= prev.y) or (s.z ~= prev.z)
        ch.moving = s.moving ~= prev.moving
        ch.inv = invChanged(s.inv, prev.inv)
        if s.xp and prev.xp then
            for k, v in pairs(s.xp) do if prev.xp[k] ~= v then ch.xp = true break end end
        elseif s.xp ~= prev.xp then
            ch.xp = true
        end
        ch.any = ch.pos or ch.moving or ch.inv or ch.xp
    end
    if ch.any then self.lastChange = s.t end
    self.snap = s
    return s, ch
end

---Seconds since the last observable change (call sample() first).
---@return number
function StateTracker:idleSec()
    return os.clock() - self.lastChange
end

---True if any observable changed within the last windowSec.
---@param windowSec number
---@return boolean
function StateTracker:isActive(windowSec)
    return self:idleSec() <= (windowSec or 5)
end

---True while gaining inv items/xp but not moving - the channeling
---signature that Animation/InteractingNpc fail to report.
---@param windowSec number|nil default 8
---@return boolean
function StateTracker:isChanneling(windowSec)
    local s = self.snap
    if s == nil then self:sample() s = self.snap end
    if s == nil then return false end
    if s.moving then return false end
    return self:idleSec() <= (windowSec or 8)
end

---Block until any observable change occurs or timeout.
---@param timeoutSec number
---@return boolean true if progress was observed
function StateTracker:waitForProgress(timeoutSec)
    local baseline = self.snap or select(1, self:sample())
    local t0 = os.clock()
    while os.clock() - t0 < (timeoutSec or 10) do
        if not API.Read_LoopyLoop() then return false end
        API.RandomSleep2(150, 50, 100)
        local s = self:sample()
        local prev = baseline
        if (s.x ~= prev.x) or (s.y ~= prev.y) or invChanged(s.inv, prev.inv) then
            return true
        end
        if s.xp and prev.xp then
            for k, v in pairs(s.xp) do if prev.xp[k] ~= v then return true end end
        end
    end
    return false
end

DX.Interface = {}

---@return boolean
function DX.Interface.isWorldSelectionOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 61
end

---@return boolean
function DX.Interface.isCraftingOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 1310738
end

---@return boolean
function DX.Interface.isChooseOptionOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 12
end

---@return boolean
function DX.Interface.isCookingOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 18
end

---@return boolean
function DX.Interface.isSmeltingOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 85
end

---@return boolean
function DX.Interface.isTeleportSeedOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 13
end

---@return boolean
function DX.Interface.isNoneOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 0
end

function DX.Interface.openInventory()
    if not API.InventoryInterfaceCheckvarbit() then
        API.KeyboardPress2(0x42, 50, 150)
    end
end

function DX.Interface.openLootWindow()
    if not API.LootWindowOpen_2() then
        API.KeyboardPress("\\", 0, 50)
        API.RandomSleep2(600, 100, 200)
    end
end

function DX.Interface.lootAll()
    DX.Interface.openLootWindow()
    if API.LootWindowOpen_2() and (API.LootWindow_GetData()[1].itemid1 > 0) then
        API.DoAction_LootAll_Button()
    end
end

---@param n number
---@return boolean result of the interface action, false for invalid bar numbers
function DX.Interface.loadActionBar(n)
    print("Loading action bar: " .. n)
    local selected = { id = nil, number = nil, offset = nil }
    if n >= 1 and n <= 10 then
        selected.number = 255
    elseif n >= 11 and n <= 15 then
        selected.number = 254
    elseif n >= 16 and n <= 18 then
        selected.number = 253
    else
        print("Invalid bar number passed: " .. tostring(n))
        return false
    end
    if n >= 1 and n <= 5 then
        selected.offset = API.OFF_ACT_GeneralInterface_route
    elseif n >= 6 and n <= 18 then
        selected.offset = API.OFF_ACT_GeneralInterface_route2
    end
    if n == 10 or n == 15 then
        selected.id = 10
    elseif n >= 1 and n <= 9 then
        selected.id = n
    elseif n >= 11 and n <= 14 then
        selected.id = n - 5
    elseif n >= 16 and n <= 18 then
        selected.id = n - 10
    end
    return API.DoAction_Interface(0xffffffff, 0xffffffff, selected.id, 1430, selected.number, -1, selected.offset)
end

DX.Player = {}

---@param coord FFPOINT
---@param area table {x1, y1, x2, y2} rectangle or array of points with .x/.y
---@return boolean
function DX.Player.coordInArea(coord, area)
    if coord.z ~= API.PlayerCoord().z then
        return false
    end
    local poly
    if #area == 4 and type(area[1]) == "number" then
        local x1, y1, x2, y2 = area[1], area[2], area[3], area[4]
        poly = {
            { x = x1, y = y1 },
            { x = x2, y = y1 },
            { x = x2, y = y2 },
            { x = x1, y = y2 }
        }
    elseif type(area[1]) ~= "number" then
        poly = {}
        for i, point in ipairs(area) do
            poly[i] = { x = point.x, y = point.y }
        end
    else
        poly = area
    end
    local count = 0
    local n = #poly
    for i = 1, n do
        local j = (i % n) + 1
        local vertex1 = poly[i]
        local vertex2 = poly[j]
        if ((vertex1.y > coord.y) ~= (vertex2.y > coord.y)) and
            (coord.x < (vertex2.x - vertex1.x) * (coord.y - vertex1.y) / (vertex2.y - vertex1.y) + vertex1.x) then
            count = count + 1
        end
    end
    return (count % 2) == 1
end

---@param area table
---@return boolean
function DX.Player.inArea(area)
    return DX.Player.coordInArea(API.PlayerCoord(), area)
end

---@param rect table {x1, x2, y1, y2}
---@return boolean
function DX.Player.inRect(rect)
    return API.PInArea21(rect.x1, rect.x2, rect.y1, rect.y2)
end

---@return boolean
function DX.Player.hasTarget()
    return API.Local_PlayerInterActingWith_Id() ~= 0
end

---@return number
function DX.Player.targetId()
    return API.Local_PlayerInterActingWith_Id()
end

---@param name string
---@return boolean
function DX.Player.isTargeting(name)
    if DX.Player.hasTarget() then
        return API.ReadLpInteracting().Name == name
    end
    return false
end

---@param id number
---@return boolean
function DX.Player.isTargetingId(id)
    return API.Local_PlayerInterActingWith_Id() == id
end

---@param loops number
---@return number interacting id, or 0
function DX.Player.waitForTarget(loops)
    for _ = loops, 0, -1 do
        local interact = API.Local_PlayerInterActingWith_Id()
        if interact ~= 0 then
            return interact
        end
    end
    return 0
end

---@param id number
---@param loops number
---@return boolean
function DX.Player.waitForTargetId(id, loops)
    for _ = loops, 0, -1 do
        local interact = API.Local_PlayerInterActingWith_Id()
        if interact == id then
            return true
        end
        if API.VB_FindPSettinOrder(11625, 0).state == -1 then
            return true
        end
    end
    local boss = API.GetAllObjArray1({ id }, 50, { 1 })[1]
    if boss ~= nil and boss.Life == 0 then
        return true
    end
    return false
end

---@param tile WPOINT
---@param npcId number
function DX.Player.moveAndAttack(tile, npcId)
    API.DoAction_Tile(tile)
    API.RandomSleep2(600, 0, 50)
    API.WaitUntilMovingEnds(2, 2)
    API.DoAction_NPC(0x2a, API.OFF_ACT_AttackNPC_route, { npcId }, 50)
end

---@return boolean
function DX.Player.isAuraActive()
    return API.VB_FindPSett(7702).state > 0
end

DX.Ability = {}

local function resolveAbility(x)
    if type(x) == "number" then
        return API.GetABs_id(x)
    end
    if type(x) == "string" then
        return API.GetABs_name(x, false)
    end
    if (type(x) == "table" or type(x) == "userdata") and x.name ~= nil then
        return API.GetABs_name(x.name, false)
    end
    return nil
end

local function abilityReady(ab)
    return ab ~= nil and ab.id ~= 0 and ab.enabled and ab.cooldown_timer == 0
end

---@param x number|string|table
---@return Abilitybar|nil
function DX.Ability.get(x)
    return resolveAbility(x)
end

---@param x number|string|table
---@return boolean
function DX.Ability.isReady(x)
    return abilityReady(resolveAbility(x))
end

---@param x number|string|table
---@return boolean
function DX.Ability.use(x)
    local ab = resolveAbility(x)
    if abilityReady(ab) then
        API.DoAction_Ability_Direct(ab, 1, API.OFF_ACT_GeneralInterface_route)
        return true
    end
    return false
end

---@param x number|string|table
---@return boolean
function DX.Ability.useSpecial(x)
    local ab = resolveAbility(x)
    if abilityReady(ab) then
        API.DoAction_Ability_Direct(ab, 0, API.OFF_ACT_Bladed_interface_route)
        return true
    end
    return false
end

---@param name string
---@return boolean
function DX.Ability.canUse(name)
    local skillFound = API.GetABs_name1(name)
    if skillFound.id == 0 then
        return false
    end
    if not skillFound.enabled then
        return false
    end
    return true
end

local function findBarWithQueuedSkill()
    local queuedBar = API.VB_FindPSettinOrder(5861, 0).state
    if queuedBar == 0 then return nil end
    if queuedBar == 1003 then return 0 end
    if queuedBar == 1032 then return 1 end
    if queuedBar == 1033 then return 2 end
    if queuedBar == 1034 then return 3 end
    if queuedBar == 1035 then return 4 end
    return nil
end

---@return boolean
function DX.Ability.anyQueued()
    return API.VB_FindPSettinOrder(5861, 0).state ~= 0
end

---@param name string
---@return boolean
function DX.Ability.isQueued(name)
    if not DX.Ability.anyQueued() then return false end
    local barNumber = findBarWithQueuedSkill()
    if barNumber == nil then return false end
    local skillbar = API.GetAB_name(barNumber, name)
    local slot = API.VB_FindPSettinOrder(4164, 0).state
    if slot == 0 then return false end
    if skillbar.slot == slot then return true end
    return false
end

---@param name string
---@return boolean
function DX.Ability.canQueue(name)
    if DX.Ability.isQueued(name) then return false end
    if DX.Ability.canUse(name) then
        local skillFound = API.GetABs_name1(name)
        if skillFound.cooldown_timer < 6 then return true end
    end
    return false
end

---@return boolean
function DX.Ability.surge()
    if DX.Ability.canUse("Surge") then
        local surgeAB = API.GetABs_name1("Surge")
        return API.DoAction_Ability_Direct(surgeAB, 1, API.OFF_ACT_GeneralInterface_route)
    end
    return false
end

---@param tile FFPOINT
---@return boolean
function DX.Ability.dive(tile)
    if DX.Ability.canUse("Dive") then
        return API.DoAction_Dive_Tile(tile)
    end
    return false
end

DX.Prayer = {}

---@return boolean
function DX.Prayer.isTabOpen()
    return API.VB_FindPSettinOrder(3172, 1).state == 1
end

---@return boolean
function DX.Prayer.toggleTab()
    return API.DoAction_Interface(0xc2, 0xffffffff, 1, 1432, 5, 5, API.OFF_ACT_GeneralInterface_route)
end

---@return boolean
function DX.Prayer.usingNormal()
    return API.VB_FindPSettinOrder(3277, 0).state & 1 == 0
end

---@return boolean
function DX.Prayer.usingCurses()
    return API.VB_FindPSettinOrder(3277, 0).state & 1 == 1
end

---@param buffId number
---@return boolean
function DX.Prayer.isActive(buffId)
    return API.Buffbar_GetIDstatus(buffId, false).found
end

---@return boolean
function DX.Prayer.isSoulSplit()
    return DX.Prayer.isActive(DX.Data.BuffIds.SoulSplit)
end

---@return boolean
function DX.Prayer.isDeflectMelee()
    return DX.Prayer.isActive(DX.Data.BuffIds.DeflectMelee)
end

---@return boolean
function DX.Prayer.isDeflectMagic()
    return DX.Prayer.isActive(DX.Data.BuffIds.DeflectMagic)
end

---@return boolean
function DX.Prayer.isDeflectRanged()
    return DX.Prayer.isActive(DX.Data.BuffIds.DeflectRanged)
end

---@return boolean
function DX.Prayer.isDeflectNecro()
    return API.VB_FindPSettinOrder(5859, 0).state >> 16 & 0xffff == 2
end

---@param abilityId number
---@param buffId number
function DX.Prayer.activate(abilityId, buffId)
    if API.Buffbar_GetIDstatus(buffId, false).found then
        return
    end
    DX.Ability.use(abilityId)
end

---@param abilityId number
---@param buffId number
function DX.Prayer.deactivate(abilityId, buffId)
    if not API.Buffbar_GetIDstatus(buffId, false).found then
        return
    end
    DX.Ability.use(abilityId)
end

local prayerFlickChecks = {
    [26040] = function() return DX.Prayer.isDeflectMelee() end,
    [26041] = function() return DX.Prayer.isDeflectMagic() end,
    [26044] = function() return DX.Prayer.isDeflectRanged() end,
    [26033] = function() return DX.Prayer.isSoulSplit() end,
}

---@param abilityId number
function DX.Prayer.flick(abilityId)
    local check = prayerFlickChecks[abilityId]
    if check == nil then
        return
    end
    if not check() then
        return DX.Ability.use(abilityId)
    end
end

local lastRestoreSip = 0

---@param thresholdPercent number|nil
---@return boolean true if it drank a restore or used a shard
function DX.Prayer.restore(thresholdPercent)
    thresholdPercent = thresholdPercent or 50
    local pray = API.GetPrayPrecent()
    if pray >= thresholdPercent or os.time() - lastRestoreSip < 2 then
        return false
    end
    lastRestoreSip = os.time()
    local elvenCD = API.DeBuffbar_GetIDstatus(DX.Data.DebuffIds.ElvenShard, false)
    local elvenFound = Inventory:InvItemcount(DX.Data.DebuffIds.ElvenShard)
    if not elvenCD.found and elvenFound > 0 then
        print(string.format("[DX] prayer %d%% - using elven shard", pray))
        API.DoAction_Inventory1(DX.Data.DebuffIds.ElvenShard, 43358, 1, API.OFF_ACT_GeneralInterface_route)
        return true
    end
    local restores = 0
    for _, id in ipairs(DX.Data.Potions.SuperRestore) do
        restores = restores + (Inventory:InvItemcount(id) or 0)
    end
    if restores > 0 then
        print(string.format("[DX] prayer %d%% - drinking super restore (%d doses left)", pray, restores))
        API.DoAction_Inventory2(DX.Data.Potions.SuperRestore, 0, 1, API.OFF_ACT_GeneralInterface_route)
        return true
    end
    print("[DX] prayer low but NO super restores in inventory")
    return false
end

---@return boolean
function DX.Prayer.isChronicleAttractionActive()
    return API.VB_FindPSettinOrder(6890, 0).state >> 16 & 0xffff == 4
end

---@return boolean
function DX.Prayer.hasChronicleAttraction()
    if not DX.Prayer.usingCurses() then
        print('not on curses')
        return false
    end
    local open = DX.Prayer.isTabOpen()
    if not open then
        DX.Prayer.toggleTab()
        DX.Wait.randomSleep(50)
    end
    local chronicleInterface = { { 1458, 4, -1, -1, 0 }, { 1458, 6, -1, 4, 0 }, { 1458, 8, -1, 6, 0 }, { 1458, 40, -1, 8, 0 }, { 1458, 40, 30, 40, 0 } }
    local inter = API.ScanForInterfaceTest2Get2(false, chronicleInterface)
    local hasPrayer = false
    if (#inter > 0) then
        hasPrayer = inter[1].xs > 0
    end
    if not open then
        DX.Prayer.toggleTab()
    end
    return hasPrayer
end


---Toggle a prayer on if it is not already active (port of ClueUtils.PrayerFlicking).
---@param abilityId number action-bar ability id
---@param buffId number buff-bar id for the active check
---@return boolean true when the prayer is active after the call
function DX.Prayer.flick(abilityId, buffId)
    if DX.Prayer.isActive(buffId) then return true end
    return DX.Prayer.activate(abilityId, buffId)
end

DX.Magic = {}

---@return boolean
function DX.Magic.isNormal()
    return API.VB_FindPSettinOrder(4, 0).state == 1280
end

---@return boolean
function DX.Magic.isAncient()
    return API.VB_FindPSettinOrder(4, 0).state == 1281
end

---@return boolean
function DX.Magic.isLunar()
    return API.VB_FindPSettinOrder(4, 0).state == 1282
end

---@param items number[]
---@return boolean
function DX.Magic.highAlch(items)
    for _, item in pairs(items) do
        if Inventory:InvItemcount(item) > 0 then
            if DX.Ability.useSpecial("High Level Alchemy") then
                if API.DoAction_Inventory2({ item }, 0, 0, API.OFF_ACT_GeneralInterface_route1) then
                    return true
                end
            end
        end
    end
    return false
end

---@param items number[]
---@return boolean
function DX.Magic.disassemble(items)
    for _, item in pairs(items) do
        if Inventory:InvItemcount(item) > 0 then
            if DX.Ability.useSpecial("Disassemble") then
                if API.DoAction_Inventory2({ item }, 0, 0, API.OFF_ACT_GeneralInterface_route1) then
                    return true
                end
            end
        end
    end
    return false
end

DX.Consumables = {}

local lastEatWarn, lastEatAttempt = 0, 0

---@param foodIds number[]|nil
---@param thresholdPercent number|nil
---@return boolean
function DX.Consumables.eat(foodIds, thresholdPercent)
    thresholdPercent = thresholdPercent or 60
    local hp = API.GetHPrecent()
    if hp >= thresholdPercent or API.Get_tick() - lastEatAttempt < 4 then
        return false
    end
    local ab = API.GetABs_name("Eat Food")
    if ab ~= nil and ab.id > 0 then
        print(string.format("[DX] hp %d%% - eating", hp))
        if ab.hotkey ~= nil and ab.hotkey ~= 0 then
            API.KeyboardPress32(ab.hotkey, 0)
        else
            API.DoAction_Ability_Direct(ab, 1, API.OFF_ACT_GeneralInterface_route)
        end
        lastEatAttempt = API.Get_tick()
        return true
    end
    local slot = API.GetAB_id(foodIds or DX.Data.Food)
    if slot ~= nil and slot.id > 0 then
        print(string.format("[DX] hp %d%% - eating (item slot %s)", hp, tostring(slot.id)))
        if slot.hotkey ~= nil and slot.hotkey ~= 0 then
            API.KeyboardPress32(slot.hotkey, 0)
        else
            API.DoAction_Ability_Direct(slot, 1, API.OFF_ACT_GeneralInterface_route)
        end
        lastEatAttempt = API.Get_tick()
        return true
    end
    if os.time() - lastEatWarn >= 15 then
        lastEatWarn = os.time()
        print("[DX] hp low - 'Eat Food' ability/food item not found on the action bar")
    end
    return false
end

---@return boolean
function DX.Consumables.isOverloaded()
    for _, id in ipairs(DX.Data.BuffIds.OverloadIcons) do
        local buff = API.Buffbar_GetIDstatus(id, false)
        if buff ~= nil and buff.found then
            return true
        end
    end
    for _, id in ipairs(DX.Data.Potions.Overload) do
        local buff = API.Buffbar_GetIDstatus(id, false)
        if buff ~= nil and buff.found then
            return true
        end
    end
    return false
end

local lastOvlCheck, lastOvlWarn = 0, 0

---@return boolean
function DX.Consumables.drinkOverload()
    if os.time() - lastOvlCheck < 10 then
        return true
    end
    lastOvlCheck = os.time()
    if DX.Consumables.isOverloaded() then
        return true
    end
    for _, id in ipairs(DX.Data.Potions.Overload) do
        if (Inventory:InvItemcount(id) or 0) > 0 then
            print(string.format("[DX] overload expired - drinking dose (id %d)", id))
            return API.DoAction_Inventory2(DX.Data.Potions.Overload, 0, 1, API.OFF_ACT_GeneralInterface_route)
        end
    end
    if os.time() - lastOvlWarn >= 30 then
        lastOvlWarn = os.time()
        print("[DX] overload expired - no overload potion in inventory")
    end
    return false
end

---@param potionIds number[]
---@param buffId number
function DX.Consumables.drink(potionIds, buffId)
    local buff = API.Buffbar_GetIDstatus(buffId, false)
    if buff.found then
        return
    end
    return API.DoAction_Inventory2(potionIds, 0, 1, API.OFF_ACT_GeneralInterface_route)
end

---@param requirements table[] {{items={...}, count=n}, ...}
---@return boolean
function DX.Consumables.hasItems(requirements)
    for _, obj in pairs(requirements) do
        local count = obj.count
        for _, item in pairs(obj.items) do
            local c = Inventory:InvItemcount(item)
            count = count - c
        end
        if count > 0 then
            return false
        end
    end
    return true
end

DX.Necro = {}

---@return number
function DX.Necro.necrosisStacks()
    local buff = API.Buffbar_GetIDstatus(DX.Data.BuffIds.Necrosis, false)
    if buff ~= nil then
        return tonumber(buff.conv_text) or 0
    end
    return 0
end

---@return number
function DX.Necro.soulStacks()
    local buff = API.Buffbar_GetIDstatus(DX.Data.BuffIds.ResidualSouls, false)
    if buff ~= nil then
        return tonumber(buff.conv_text) or 0
    end
    return 0
end

---@return boolean
function DX.Necro.conjuresAlive()
    local buff = API.Buffbar_GetIDstatus(DX.Data.BuffIds.SkeletonWarrior, false)
    return buff.found
end

---@return boolean
function DX.Necro.inLivingDeath()
    local buff = API.Buffbar_GetIDstatus(DX.Data.BuffIds.LivingDeath, false)
    return buff.found
end

---@return boolean
function DX.Necro.canUseSpec()
    local debuffs = API.DeBuffbar_GetAllIDs()
    local specCooldown = false
    for _, a in pairs(debuffs) do
        if a.id == DX.Data.DebuffIds.SpecCooldown or a.id == DX.Data.DebuffIds.NecroSpecCooldown then
            specCooldown = true
        end
    end
    return not specCooldown
end

function DX.Necro.livingDeathRotation()
    if DX.Ability.use(DX.Data.AbilityIds.Necro.DeathSkulls) then
        return
    end
    if DX.Necro.necrosisStacks() >= 6 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.FingerDeath) then
            return
        end
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.TouchOfDeath) then
        return
    end
    DX.Ability.use(DX.Data.AbilityIds.Necro.Necromancy)
end

function DX.Necro.bestAbility()
    if DX.Ability.anyQueued() then
        return
    end
    if DX.Necro.inLivingDeath() and DX.Player.hasTarget() then
        return DX.Necro.livingDeathRotation()
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.LivingDeath) then
        return
    end
    if not DX.Necro.conjuresAlive() then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.ConjureUndeadArmy) then
            return
        end
    end
    if DX.Necro.soulStacks() >= 3 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.Volley) then
            return
        end
    end
    if DX.Ability.use("Command Vengeful Ghost") then
        return
    end
    if DX.Ability.use("Command Skeleton Warrior") then
        return
    end
    if DX.Necro.necrosisStacks() >= 12 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.FingerDeath) then
            return
        end
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.TouchOfDeath) then
        return
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.SoulSap) then
        return
    end
    DX.Ability.use(DX.Data.AbilityIds.Necro.Necromancy)
end

function DX.Necro.bestAbilityNoUltimates()
    if DX.Ability.anyQueued() then
        return
    end
    if not DX.Necro.conjuresAlive() then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.ConjureUndeadArmy) then
            return
        end
    end
    if DX.Necro.soulStacks() >= 3 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.Volley) then
            return
        end
    end
    if DX.Ability.use("Command Vengeful Ghost") then
        return
    end
    if DX.Ability.use("Command Skeleton Warrior") then
        return
    end
    if DX.Necro.necrosisStacks() >= 12 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.FingerDeath) then
            return
        end
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.TouchOfDeath) then
        return
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.SoulSap) then
        return
    end
    DX.Ability.use(DX.Data.AbilityIds.Necro.Necromancy)
end

function DX.Necro.revoSupport()
    if DX.Ability.anyQueued() then
        return
    end
    if DX.Necro.soulStacks() >= 3 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.Volley) then
            return
        end
    end
    if DX.Necro.necrosisStacks() >= 6 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.FingerDeath) then
            return
        end
    end
end

function DX.Necro.aoe()
    if DX.Ability.anyQueued() then
        return
    end
    if API.GetAddreline_() >= 90 then
        if DX.Ability.use(DX.Data.AbilityIds.Necro.Bloat) then
            return
        end
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.ThreadsOfFate) then
        return
    end
    if DX.Necro.canUseSpec() then
        if DX.Ability.use(DX.Data.AbilityIds.HP.SpecialAtk) then
            return
        end
    end
    if DX.Ability.use(DX.Data.AbilityIds.Necro.SoulSap) then
        return
    end
end

DX.Summoning = {}

---@return number minutes left on the familiar
function DX.Summoning.familiarMinutesLeft()
    local value = API.VB_FindPSettinOrder(1786, 0).state
    if value == 0 then return 0 end
    return (math.floor(value / 2.1333333)) / 60
end

---@param pouchId number
---@return boolean
function DX.Summoning.renewAtWarRetreat(pouchId)
    if not DX.Player.inRect(DX.Data.Locations.WarRetreat) then
        DX.WarRetreat.teleport()
        API.RandomSleep2(1200, 600, 1200)
        API.WaitUntilMovingEnds()
    end
    if API.GetSummoningPoints_() < 300 then
        API.DoAction_Object1(0x3d, API.OFF_ACT_GeneralObject_route0, { DX.Data.Objects.WarAltar }, 50)
        API.RandomSleep2(600, 0, 0)
        API.WaitUntilMovingandAnimEnds()
        API.RandomSleep2(1200, 0, 0)
    end
    if not API.BankOpen2() then
        API.DoAction_Object1(0x2e, API.OFF_ACT_GeneralObject_route1, { DX.Data.Objects.WarRetreatBank }, 50)
        API.RandomSleep2(600, 0, 0)
        API.WaitUntilMovingEnds()
    end
    if API.BankOpen2() then
        API.KeyboardPress2(0x33, 0, 50)
        API.RandomSleep2(1000, 500, 1000)
        API.DoAction_Bank(pouchId, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 500, 1000)
        API.KeyboardPress2(0x1B, 50, 150)
        API.RandomSleep2(1000, 500, 1000)
    end
    if Inventory:InvStackSize(pouchId) < 1 then
        return false
    end
    API.DoAction_Inventory2({ pouchId }, 0, 1, API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(600, 100, 300)
    API.WaitUntilMovingEnds()
    DX.Interface.openInventory()
    return true
end

DX.WarRetreat = {}

---@return boolean
function DX.WarRetreat.isAt()
    return DX.Player.inRect(DX.Data.Locations.WarRetreat)
end

---@return boolean
function DX.WarRetreat.teleport()
    return DX.Ability.use(DX.Data.AbilityIds.Teleports.WarRetreatTeleport)
end

---@param requirements table[]
---@param renewFamiliar boolean
---@param pouchId number|nil
---@return boolean
function DX.WarRetreat.prepare(requirements, renewFamiliar, pouchId)
    if not DX.WarRetreat.isAt() then
        if not DX.WarRetreat.teleport() then
            return false
        end
        API.RandomSleep2(4000, 100, 400)
        API.WaitUntilMovingandAnimEnds()
    end
    if renewFamiliar and DX.Summoning.familiarMinutesLeft() < 5 then
        if not DX.Summoning.renewAtWarRetreat(pouchId) then
            return false
        end
    end
    API.DoAction_Object_string1(0x33, API.OFF_ACT_GeneralObject_route3, { "Bank chest" }, 50, true)
    API.RandomSleep2(1200, 0, 200)
    API.WaitUntilMovingEnds()
    if not DX.Consumables.hasItems(requirements) then
        return false
    end
    if API.GetHPrecent() < 90 then
        DX.Wait.forCondition(function() return API.GetHPrecent() > 90 end, 10, "wait for hp full")
    end
    if API.GetPrayPrecent() < 90 then
        API.DoAction_Object1(0x3d, API.OFF_ACT_GeneralObject_route0, { DX.Data.Objects.WarAltar }, 50)
        API.RandomSleep2(600, 0, 0)
        DX.Wait.forCondition(function() return API.GetPrayPrecent() > 90 end, 5, "Wait for prayer")
    end
    return true
end

DX.Skilling = {}

local ORE_BOX_VARBITS = {
    [436] = 8309,
    [438] = 8310,
    [440] = 8311,
    [442] = 8313,
    [444] = 8317,
    [447] = 8314,
    [449] = 8315,
    [451] = 8318,
    [453] = 8312,
    [21778] = 8323,
    [44820] = 8316,
    [44822] = 8319,
    [44824] = 8320,
    [44826] = 8321,
    [44828] = 8322,
    [44830] = 8324,
    [44832] = 8325,
}

---@param oreId number
---@return number ore count, -1 if the ore is unknown
function DX.Skilling.oreBoxCount(oreId)
    local vb = ORE_BOX_VARBITS[oreId]
    if vb == nil then
        return -1
    end
    return API.VB_FindPSett(vb).state >> 0 & 0x3fff
end

---@param rune table {ID=n, INV_VB=n}
---@return number
function DX.Skilling.runeCount(rune)
    return API.VB_FindPSettinOrder(rune.INV_VB, 1).state
end

---@param itemId number
---@return boolean
function DX.Skilling.noteItem(itemId)
    local inventory = API.ReadInvArrays33()
    local notepaper = {}
    local itemToNote = {}
    local foundNotepaper = false
    local foundItem = false
    for i = 1, #inventory do
        if inventory[i].item_id == 43045 or inventory[i].item_id == 30372 then
            notepaper = inventory[i]
            foundNotepaper = true
        end
        if inventory[i].item_id == itemId then
            itemToNote = inventory[i]
            foundItem = true
        end
    end
    if not foundNotepaper then
        API.logError("Couldn't find notepaper")
        print("Couldn't find notepaper")
        return false
    end
    if not foundItem then
        API.logError("Couldn't find item with id:" .. tostring(itemId))
        print("Couldn't find item with id:", itemId)
        return false
    end
    API.DoAction_Interface(0x24, notepaper.item_id, 0, notepaper.item_interface.x,
        notepaper.item_interface.y, notepaper.item_interface.z,
        API.OFF_ACT_Bladed_interface_route)
    API.DoAction_DontResetSelection()
    API.RandomSleep2(50, 100, 200)
    API.DoAction_Interface(0x24, itemToNote.item_id, 0, itemToNote.item_interface.x,
        itemToNote.item_interface.y, itemToNote.item_interface.z,
        API.OFF_ACT_GeneralInterface_route1)
    return true
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Act — menu-option (action, route) pairs observed across our scripts
-- The client encodes each right-click option as an (action, route) pair — the route picks the
-- object class/menu slot, the action is the packet opcode. These are the pairs verified in
-- live use; scripts may still pass explicit pairs for options not listed here.
----------------------------------------------------------------------------------------------------
DX.Act = {
    -- objects (DX.Objects.interact / interactNear / direct)
    OBJ_OP1       = { 0x29, API.OFF_ACT_GeneralObject_route0 }, -- generic option 1 (craft/mine/check/enter)
    OBJ_OP2       = { 0x2e, API.OFF_ACT_GeneralObject_route1 }, -- e.g. War's Retreat bank chest "Bank"
    OBJ_OP4       = { 0x33, API.OFF_ACT_GeneralObject_route3 }, -- bank chest alt option
    OBJ_ALTAR     = { 0x3d, API.OFF_ACT_GeneralObject_route0 }, -- Altar of War
    OBJ_USE       = { 0x39, API.OFF_ACT_GeneralObject_route0 }, -- dung door/portal "use"
    OBJ_EX        = { 0xae, API.OFF_ACT_GeneralObject_route0 }, -- fort-builder objects
    -- npcs (DX.NPC.interact / talk / attack / direct)
    NPC_TALK      = { 0x29, API.OFF_ACT_InteractNPC_route },
    NPC_OP2       = { 0x29, API.OFF_ACT_InteractNPC_route2 },   -- e.g. pickpocket
    NPC_OP3       = { 0x2c, API.OFF_ACT_InteractNPC_route },    -- e.g. charm sprite catch
    NPC_A7        = { 0xa7, API.OFF_ACT_InteractNPC_route },    -- e.g. Croesus guards
    NPC_ATTACK    = { 0x2a, API.OFF_ACT_AttackNPC_route },
    -- ground items (DX.Ground.take* / direct)
    TAKE          = { 0x2d, API.OFF_ACT_Pickup_route },         -- DoAction_G_Items_Direct
    TAKE_IDX      = { 0x2a, API.OFF_ACT_Pickup_route },         -- DoAction_G_Items1 / _r2
    BOX_TRAP      = { 0x2a, API.OFF_ACT_Boxtrap_route },        -- hunter traps
}

local function actPair(op, action, route)
    if type(op) == "table" then return op[1], op[2] end
    return action, route
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Vars — varbit/varp reads
----------------------------------------------------------------------------------------------------
DX.Vars = {}

-- Varbits used by DX internals and commonly needed by scripts.
DX.Vars.ID = {
    INTERFACE_STATE = 2874, -- (2874,1,0): 0 none, 61 world select, 12 dialog, 1310738 crafting,
                            -- 18 cooking, 85 smelting, 13 teleport seed
    QUEUED_ABILITY  = 5861, -- inOrder 0: non-zero when an ability is queued
    ABILITY_SLOT    = 4164, -- inOrder 0: queued action-bar slot
    AURA_ACTIVE     = 7702, -- state > 0 when an aura is running
    ADRENALINE      = 679,  -- state = adrenaline percent (used by DX.PlayerManager)
    SPELLBOOK       = 4,    -- inOrder 0: 1280 normal book
}

---@param id number
---@param ... any extra VB_FindPSett args (e.g. 1, 0)
---@return VB|nil
function DX.Vars.get(id, ...)
    local ok, vb = pcall(API.VB_FindPSett, id, ...)
    if ok and type(vb) == "table" and vb.found ~= false then return vb end
    return nil
end

---@param id number
---@param ... any extra VB_FindPSett args
---@return number|nil
function DX.Vars.state(id, ...)
    local vb = DX.Vars.get(id, ...)
    return vb and vb.state or nil
end

---@param id number
---@param ix number|nil index for VB_FindPSettinOrder (default 0)
---@return number|nil
function DX.Vars.stateInOrder(id, ix)
    local ok, vb = pcall(API.VB_FindPSettinOrder, id, ix or 0)
    if ok and type(vb) == "table" and vb.found ~= false then return vb.state end
    return nil
end

---@param id number
---@param mask number bits that must all be set
---@return boolean
function DX.Vars.isSet(id, mask)
    local s = DX.Vars.state(id)
    return s ~= nil and (s & mask) == mask
end

---@param id number
---@param ix number
---@param mask number
---@return boolean
function DX.Vars.isSetInOrder(id, ix, mask)
    local s = DX.Vars.stateInOrder(id, ix)
    return s ~= nil and (s & mask) == mask
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Objects — scenery/object find + interact
----------------------------------------------------------------------------------------------------
DX.Objects = {}
DX.Objects.TYPES = { 0, 12 } -- scenery + decor

local function idList(ids)
    return type(ids) == "table" and ids or { ids }
end

---@param ids number|number[]
---@param maxdist number|nil search radius from player (default 25)
---@param types number[]|nil AllObject.Type filter (default DX.Objects.TYPES)
---@return AllObject[] nearest-first
function DX.Objects.find(ids, maxdist, types)
    local ok, arr = pcall(API.GetAllObjArrayInteract, idList(ids), maxdist or 25, types or DX.Objects.TYPES)
    if not ok then return {} end
    return stateToTable(arr) or {}
end

---@param ids number|number[]
---@param maxdist number|nil
---@param types number[]|nil
---@return AllObject|nil nearest match
function DX.Objects.first(ids, maxdist, types)
    local arr = DX.Objects.find(ids, maxdist, types)
    return arr[1]
end

---@param ids number|number[]
---@param maxdist number|nil
---@param types number[]|nil
---@return boolean
function DX.Objects.present(ids, maxdist, types)
    return DX.Objects.first(ids, maxdist, types) ~= nil
end

---@param ids number|number[]
---@param tile FFPOINT center tile for the search
---@param maxdist number|nil
---@param types number[]|nil
---@return AllObject|nil
function DX.Objects.firstNear(ids, tile, maxdist, types)
    local ok, arr = pcall(API.GetAllObjArray2, idList(ids), maxdist or 25, types or DX.Objects.TYPES, tile)
    if not ok then return nil end
    arr = stateToTable(arr)
    return arr and arr[1] or nil
end

---Interact with an object by id list.
---@param ids number|number[]
---@param opts table|nil { op={action,route}|action, route, maxdist=50, tile, isreachable }
---@return boolean
function DX.Objects.interact(ids, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x29, opts.route or API.OFF_ACT_GeneralObject_route0)
    local dist = opts.maxdist or 50
    if opts.tile then
        return API.DoAction_Object2(action, route, idList(ids), dist, opts.tile, opts.isreachable)
    end
    return API.DoAction_Object1(action, route, idList(ids), dist, opts.isreachable)
end

---Interact with an object near a tile (object must be within range OF the tile).
---@param ids number|number[]
---@param tile FFPOINT
---@param range number max distance from tile to the object
---@param opts table|nil { op={action,route}|action, route, maxdist=50, isreachable }
---@return boolean
function DX.Objects.interactNear(ids, tile, range, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x29, opts.route or API.OFF_ACT_GeneralObject_route0)
    return API.DoAction_Object_r(action, route, idList(ids), opts.maxdist or 50, tile, range or 0, nil, opts.isreachable)
end

---Dispatch an action on an already-found AllObject.
---@param obj AllObject
---@param op table|number DX.Act pair or action code
---@param route number|nil required when op is an action code
---@return boolean
function DX.Objects.direct(obj, op, route)
    if obj == nil then return false end
    local action, r = actPair(op, op, route or API.OFF_ACT_GeneralObject_route0)
    return API.DoAction_Object_Direct(action, r, obj)
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.NPC — npc find + interact
----------------------------------------------------------------------------------------------------
DX.NPC = {}
DX.NPC.TYPES = { 1 }

---@param ids number|number[]
---@param maxdist number|nil search radius (default 25)
---@return AllObject[] nearest-first
function DX.NPC.find(ids, maxdist)
    local ok, arr = pcall(API.GetAllObjArrayInteract, idList(ids), maxdist or 25, DX.NPC.TYPES)
    if not ok then return {} end
    return stateToTable(arr) or {}
end

---@param ids number|number[]
---@param maxdist number|nil
---@return AllObject|nil
function DX.NPC.first(ids, maxdist)
    local arr = DX.NPC.find(ids, maxdist)
    return arr[1]
end

---@param ids number|number[]
---@param maxdist number|nil
---@return boolean true when a matching npc is in range
function DX.NPC.present(ids, maxdist)
    return DX.NPC.first(ids, maxdist) ~= nil
end

---@param ids number|number[]
---@param maxdist number|nil
---@return number
function DX.NPC.count(ids, maxdist)
    return #DX.NPC.find(ids, maxdist)
end

---@param names string|string[] npc name(s)
---@param maxdist number|nil
---@return AllObject|nil
function DX.NPC.firstByName(names, maxdist)
    local ok, arr = pcall(API.GetAllObjArrayInteract_str, names, maxdist or 25, DX.NPC.TYPES)
    if not ok then return nil end
    arr = stateToTable(arr)
    return arr and arr[1] or nil
end

---Interact with npcs by id list.
---@param ids number|number[]
---@param opts table|nil { op={action,route}|action, route, maxdist=50, tile, ignore_star, health, isreachable }
---@return boolean
function DX.NPC.interact(ids, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x29, opts.route or API.OFF_ACT_InteractNPC_route)
    return API.DoAction_NPC(action, route, idList(ids), opts.maxdist or 50,
        opts.tile, opts.ignore_star, opts.health, opts.isreachable)
end

---Interact with npcs by name.
---@param names string|string[]
---@param opts table|nil { op={action,route}|action, route, maxdist=50, ignore_star, health, isreachable }
---@return boolean
function DX.NPC.interactName(names, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x29, opts.route or API.OFF_ACT_InteractNPC_route)
    return API.DoAction_NPC_str(action, route, names, opts.maxdist or 50,
        opts.ignore_star, opts.health, opts.isreachable)
end

---@param ids number|number[]
---@param opts table|nil same options as interact
---@return boolean
function DX.NPC.talk(ids, opts)
    opts = opts or {}
    opts.op = opts.op or DX.Act.NPC_TALK
    return DX.NPC.interact(ids, opts)
end

---@param ids number|number[]
---@param opts table|nil same options as interact
---@return boolean
function DX.NPC.attack(ids, opts)
    opts = opts or {}
    opts.op = opts.op or DX.Act.NPC_ATTACK
    return DX.NPC.interact(ids, opts)
end

---Interact with npcs inside a rectangle.
---@param ids number|number[]
---@param bottomLeft FFPOINT
---@param topRight FFPOINT
---@param opts table|nil { op={action,route}|action, route, maxdist=50, ignore_star, health, isreachable }
---@return boolean
function DX.NPC.interactInArea(ids, bottomLeft, topRight, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x29, opts.route or API.OFF_ACT_InteractNPC_route)
    return API.DoAction_NPC_In_Area(action, route, idList(ids), opts.maxdist or 50,
        bottomLeft, topRight, opts.ignore_star, opts.health, opts.isreachable)
end

---Dispatch an action on an already-found AllObject npc.
---@param obj AllObject
---@param op table|number DX.Act pair or action code
---@param route number|nil required when op is an action code
---@return boolean
function DX.NPC.direct(obj, op, route)
    if obj == nil then return false end
    local action, r = actPair(op, op, route or API.OFF_ACT_InteractNPC_route)
    return API.DoAction_NPC__Direct(action, r, obj)
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Ground — ground items find + take/loot
----------------------------------------------------------------------------------------------------
DX.Ground = {}
DX.Ground.TYPES = { 3 }

---@param ids number|number[]
---@param maxdist number|nil search radius (default 25)
---@return AllObject[] nearest-first
function DX.Ground.find(ids, maxdist)
    local ok, arr = pcall(API.GetAllObjArrayInteract, idList(ids), maxdist or 25, DX.Ground.TYPES)
    if not ok then return {} end
    return stateToTable(arr) or {}
end

---@param ids number|number[]
---@param maxdist number|nil
---@return AllObject|nil
function DX.Ground.first(ids, maxdist)
    local arr = DX.Ground.find(ids, maxdist)
    return arr[1]
end

---@param ids number|number[]
---@param maxdist number|nil
---@return boolean
function DX.Ground.present(ids, maxdist)
    return DX.Ground.first(ids, maxdist) ~= nil
end

---Pick up ground items.
---@param ids number|number[]
---@param opts table|nil { action=0x2a, route=Pickup_route, maxdist=50, tile, radius, isreachable }
---@return boolean
function DX.Ground.take(ids, opts)
    opts = opts or {}
    local action, route = actPair(opts.op, opts.action or 0x2a, opts.route or API.OFF_ACT_Pickup_route)
    local dist = opts.maxdist or 50
    if opts.tile then
        return API.DoAction_G_Items_r2(action, route, idList(ids), dist, opts.tile, opts.radius or 0, opts.isreachable)
    end
    return API.DoAction_G_Items1(action, idList(ids), dist, opts.isreachable)
end

---Pick up an already-found ground AllObject.
---@param obj AllObject
---@param op table|number|nil DX.Act pair or action code (default DX.Act.TAKE)
---@return boolean
function DX.Ground.takeDirect(obj, op)
    if obj == nil then return false end
    local action, route = actPair(op or DX.Act.TAKE, 0x2d, API.OFF_ACT_Pickup_route)
    return API.DoAction_G_Items_Direct(action, route, obj)
end

---Area loot: loot window plus reachable ground items.
---Wanted = item id in ids, OR name contains one of names, OR action contains one of actions.
---@param opts table { ids={}, names={}, actions={}, maxdist=20, tile=player, radius=20, options=LootOptions }
---@return boolean true when at least one item was taken
function DX.Ground.loot(opts)
    opts = opts or {}
    local tile = opts.tile or API.PlayerCoordfloat()
    return API.DoAction_Loot_p(opts.ids or {}, opts.names or {}, opts.maxdist or 20,
        tile, opts.radius or 20, opts.options)
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Walk — movement + pathing
----------------------------------------------------------------------------------------------------
DX.Walk = {}

---@param tile FFPOINT|WPOINT
---@return number straight-line tile distance from the player
function DX.Walk.distTo(tile)
    local p = API.PlayerCoord()
    local dx = p.x - tile.x
    local dy = p.y - tile.y
    return math.sqrt(dx * dx + dy * dy)
end

---Walk to a tile using the local mover (short hops; the game walks the rest).
---@param tile FFPOINT|WPOINT
---@param opts table|nil { sleep=50, isreachable }
---@return boolean
function DX.Walk.to(tile, opts)
    opts = opts or {}
    return API.DoAction_Walker(tile, opts.sleep or 50, opts.isreachable)
end

---Click a tile (minimap/direct click walk).
---@param tile FFPOINT
---@param isreachable number|nil -1 disabled, 0-16 StarPath reach tolerance
---@return boolean
function DX.Walk.click(tile, isreachable)
    return API.DoAction_Tile(tile, isreachable)
end

---Walk to a tile via StarPath: local A* for near goals, precomputed navpath web for far ones.
---@param tile FFPOINT
---@return boolean arrived
function DX.Walk.navigate(tile)
    return API.StarPathWalker(tile)
end

---@param tile FFPOINT
---@param allowMapLinks boolean|nil allow teleports/shortcuts in the path
---@param tolerance number|nil accept any tile within this many tiles of goal
---@return boolean
function DX.Walk.canReach(tile, allowMapLinks, tolerance)
    return API.StarPathReachable(tile, allowMapLinks, tolerance)
end

---@param name string StarPath location name (e.g. "Grand Exchange")
---@return boolean arrived
function DX.Walk.toLocation(name)
    return API.StarPathWalkLocation(name)
end

---@return boolean
function DX.Walk.isMoving()
    return API.ReadPlayerMovin2() == true
end

---Wait until the player is within tol tiles of tile (straight-line, same plane checked by caller if needed).
---@param tile FFPOINT|WPOINT
---@param tol number|nil default 3
---@param timeoutSec number|nil default 15
---@return boolean
function DX.Walk.waitArrived(tile, tol, timeoutSec)
    tol = tol or 3
    return DX.Wait.forCondition(function()
        local p = API.PlayerCoord()
        return math.abs(p.x - tile.x) <= tol and math.abs(p.y - tile.y) <= tol
    end, timeoutSec or 15, "arrive at tile", { randomEvents = false, stateChecks = false })
end

---Wait until movement (and optionally animation) finishes. Wraps WaitUntilMovingEnds:
---@param ticks number|nil how many 600ms ticks to wait (default 10)
---@param checks number|nil stop early after this many idle checks (default 3)
---@param includeAnim boolean|nil also wait for animations to end
---@return boolean
function DX.Walk.waitSettled(ticks, checks, includeAnim)
    if includeAnim then
        return API.WaitUntilMovingandAnimEnds(ticks or 10, checks or 3)
    end
    return API.WaitUntilMovingEnds(ticks or 10, checks or 3)
end

---Walk to a tile and wait for arrival.
---@param tile FFPOINT|WPOINT
---@param tol number|nil arrival tolerance (default 3)
---@param opts table|nil { sleep=50, isreachable, timeoutSec=15 }
---@return boolean
function DX.Walk.toAndWait(tile, tol, opts)
    opts = opts or {}
    if not DX.Walk.to(tile, opts) then return false end
    return DX.Walk.waitArrived(tile, tol, opts.timeoutSec)
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Dialog — chat box, continue prompts, option menus
----------------------------------------------------------------------------------------------------
DX.Dialog = {}

---@return boolean true when a dialog/chat box is open
function DX.Dialog.isOpen()
    local ok, open = pcall(API.Check_Dialog_Open)
    if ok and open ~= nil then return open == true end
    return DX.Vars.state(DX.Vars.ID.INTERFACE_STATE, 1, 0) == 12
end

---Press "click here to continue" (native action, spacebar fallback).
---@return boolean
function DX.Dialog.continue()
    local ok, done = pcall(API.DoContinue_Dialog)
    if ok and done then return true end
    return API.KeyboardPress31(32, 0, 0) == true
end

---Send spacebar (dialog continue / text advance).
---@return boolean
function DX.Dialog.space()
    return API.KeyboardPress31(32, 0, 0) == true
end

---Send a dialog numeric key (1-9) to pick a chat option.
---@param n number 1-9
---@return boolean
function DX.Dialog.key(n)
    return API.KeyboardPress31(0x30 + n, 0, 0) == true
end

---Pick a chat option by text (partial match ok, acts directly when exact).
---@param text string
---@return boolean
function DX.Dialog.option(text)
    return API.DoDialog_Option(text)
end

---Read the option number for a chat option text (0 when absent).
---@param text string
---@return number
function DX.Dialog.optionIndex(text)
    return API.Dialog_Option(text)
end

---@param timeoutSec number|nil default 10
---@return boolean
function DX.Dialog.waitOpen(timeoutSec)
    return DX.Wait.forCondition(DX.Dialog.isOpen, timeoutSec or 10, "dialog open",
        { randomEvents = false, stateChecks = false })
end

---Wait for a dialog then press space to continue.
---@param timeoutSec number|nil default 10
---@return boolean
function DX.Dialog.waitAndContinue(timeoutSec)
    if not DX.Dialog.waitOpen(timeoutSec) then return false end
    return DX.Dialog.continue()
end

---Wait for a dialog then pick an option by number.
---@param n number
---@param timeoutSec number|nil
---@return boolean
function DX.Dialog.waitAndKey(n, timeoutSec)
    if not DX.Dialog.waitOpen(timeoutSec) then return false end
    return DX.Dialog.key(n)
end

---@param word string search the npc/player sayd text
---@return boolean
function DX.Dialog.said(word)
    return API.Dialog_compare_sayd(word)
end

---@return string npc dialog text
function DX.Dialog.readNpc()
    return API.Dialog_Read_NPC()
end

---@return string player dialog text
function DX.Dialog.readPlayer()
    return API.Dialog_Read_Player()
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Session — xp/session statistics (replaces per-script xp trackers)
----------------------------------------------------------------------------------------------------
DX.Session = {}
DX.Session.__index = DX.Session

---Start a session tracker. Call once at script start.
---@param skills string[]|nil skill names to track, e.g. {"THIEVING", "HUNTER"}
---@return table session
function DX.Session.new(skills)
    local s = setmetatable({ startTime = os.time(), startXp = {}, counters = {} }, DX.Session)
    for _, skill in ipairs(skills or {}) do
        local ok, xp = pcall(API.GetSkillXP, skill)
        s.startXp[skill] = (ok and type(xp) == "number") and xp or 0
    end
    return s
end

---@return number seconds since session start
function DX.Session:elapsed()
    return os.time() - self.startTime
end

---@return string "HH:MM:SS"
function DX.Session:fmtElapsed()
    return DX.Util.fmtTime(self:elapsed())
end

---@param skill string
---@return number xp gained this session
function DX.Session:xpGained(skill)
    local ok, xp = pcall(API.GetSkillXP, skill)
    if not ok or type(xp) ~= "number" then return 0 end
    return xp - (self.startXp[skill] or 0)
end

---@return number total xp gained across all tracked skills
function DX.Session:xpTotal()
    local total = 0
    for skill, _ in pairs(self.startXp) do
        total = total + self:xpGained(skill)
    end
    return total
end

---@param skill string|nil tracked skill (nil = total)
---@return number xp per hour
function DX.Session:xpHr(skill)
    local gained = skill and self:xpGained(skill) or self:xpTotal()
    return DX.Util.perHour(gained, self:elapsed())
end

---Seconds until a target level at the current rate.
---@param skill string tracked skill
---@param level number target level
---@return number|nil seconds remaining, nil when rate is 0 or already past
function DX.Session:etaLevel(skill, level)
    local rate = self:xpHr(skill)
    if rate <= 0 then return nil end
    local ok, now = pcall(API.GetSkillXP, skill)
    if not ok or type(now) ~= "number" then return nil end
    local need = API.XPForLevel(level) - now
    if need <= 0 then return 0 end
    return (need / rate) * 3600
end

---Register a named counter (e.g. kills, laps). value = current total or a fn returning it.
---@param name string
---@param value number|function|nil starting value or getter (default 0)
function DX.Session:counter(name, value)
    self.counters[name] = value or 0
end

---@param name string
---@param amount number|nil increment (default 1)
function DX.Session:bump(name, amount)
    self.counters[name] = (self.counters[name] or 0) + (amount or 1)
end

---@param name string
---@return number counter value (calls getter functions)
function DX.Session:count(name)
    local c = self.counters[name]
    if type(c) == "function" then
        local ok, v = pcall(c)
        return (ok and type(v) == "number") and v or 0
    end
    return c or 0
end

---@param name string
---@return number counter value per hour
function DX.Session:rate(name)
    return DX.Util.perHour(self:count(name), self:elapsed())
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.GUI — shared ImGui theme + widgets (the workspace purple style)
----------------------------------------------------------------------------------------------------
DX.GUI = {}

DX.GUI.colors = {
    dark   = { 0.08, 0.05, 0.12 },
    medium = { 0.15, 0.08, 0.20 },
    light  = { 0.25, 0.12, 0.35 },
    bright = { 0.45, 0.20, 0.55 },
    glow   = { 0.65, 0.30, 0.80 },
    accent = { 0.30, 0.70, 0.40 },
    warn   = { 0.85, 0.55, 0.15 },
    bad    = { 0.80, 0.25, 0.25 },
}

-- 9-tuples {button rgb, hovered rgb, active rgb} for bigButton
DX.GUI.buttons = {
    pause  = { 0.25, 0.15, 0.30, 0.35, 0.20, 0.40, 0.45, 0.25, 0.50 },
    resume = { 0.15, 0.35, 0.20, 0.20, 0.45, 0.25, 0.10, 0.50, 0.15 },
    stop   = { 0.50, 0.15, 0.15, 0.60, 0.20, 0.20, 0.70, 0.25, 0.25 },
}

local GUI_IC = ImGuiCol or {}
local GUI_WARNED = false

local function guiPresent()
    if type(ImGui) ~= "table" then
        if not GUI_WARNED then
            GUI_WARNED = true
            API.logDebug("DX.GUI: ImGui not available on this client")
        end
        return false
    end
    return true
end

---Colored section separator in the house style.
---@param text string
function DX.GUI.sectionHeader(text)
    if not guiPresent() then return end
    local g = DX.GUI.colors.glow
    if GUI_IC.Text ~= nil then ImGui.PushStyleColor(GUI_IC.Text, g[1], g[2], g[3], 1.0) end
    ImGui.SeparatorText(text)
    if GUI_IC.Text ~= nil then ImGui.PopStyleColor(1) end
end

---Full-width colored button.
---@param label string
---@param colors string|table|nil DX.GUI.buttons name or a 9-tuple {btn,hover,active}; nil = default button
---@param h number|nil height (default 28)
---@return boolean clicked
function DX.GUI.bigButton(label, colors, h)
    if not guiPresent() then return false end
    local c = type(colors) == "string" and DX.GUI.buttons[colors] or colors
    if c then
        ImGui.PushStyleColor(GUI_IC.Button, c[1], c[2], c[3], 0.9)
        ImGui.PushStyleColor(GUI_IC.ButtonHovered, c[4], c[5], c[6], 1.0)
        ImGui.PushStyleColor(GUI_IC.ButtonActive, c[7], c[8], c[9], 1.0)
        local clicked = ImGui.Button(label, -1, h or 28)
        ImGui.PopStyleColor(3)
        return clicked == true
    end
    return ImGui.Button(label, -1, h or 28) == true
end

---"Label ... value" row.
---@param label string
---@param value any
---@param color table|nil {r,g,b} value color (default accent)
function DX.GUI.statRow(label, value, color)
    if not guiPresent() then return end
    ImGui.TextDisabled(label)
    ImGui.SameLine()
    local c = color or DX.GUI.colors.accent
    ImGui.TextColored(c[1], c[2], c[3], 1.0, tostring(value))
end

---Accent-colored progress bar with an overlay label.
---@param frac number 0.0 - 1.0
---@param label string|nil
---@param color table|nil {r,g,b} fill color (default accent)
function DX.GUI.progressBar(frac, label, color)
    if not guiPresent() or type(ImGui.ProgressBar) ~= "function" then return end
    local c = color or DX.GUI.colors.accent
    frac = math.max(0, math.min(1, frac or 0))
    ImGui.PushStyleColor(GUI_IC.PlotHistogram, c[1], c[2], c[3], 0.75)
    ImGui.PushStyleColor(GUI_IC.Text, 1.0, 1.0, 1.0, 1.0)
    ImGui.ProgressBar(frac, -1, 18, label)
    ImGui.PopStyleColor(2)
end

---Bound checkbox: writes state[key], returns true on change (save your config then).
---@param state table settings table the value lives in
---@param key string
---@param label string
---@return boolean changed
function DX.GUI.checkbox(state, key, label)
    if not guiPresent() then return false end
    local ch, v = ImGui.Checkbox(label, state[key])
    if ch then state[key] = v return true end
    return false
end

---Bound integer slider: writes state[key], returns true on change.
---@param state table
---@param key string
---@param label string
---@param min number
---@param max number
---@return boolean changed
function DX.GUI.sliderInt(state, key, label, min, max)
    if not guiPresent() then return false end
    local ch, v = ImGui.SliderInt(label, state[key], min, max)
    if ch then state[key] = v return true end
    return false
end

---Show tooltip when the last widget is hovered.
---@param text string
function DX.GUI.tooltip(text)
    if guiPresent() and ImGui.IsItemHovered() then
        ImGui.SetTooltip(text)
    end
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Config — per-character JSON settings persistence
-- Saves "<tag>-<player>.config.json" next to the calling script (or a path you give).
----------------------------------------------------------------------------------------------------
DX.Config = {}

local function configDirFor(level)
    local src = (debug.getinfo(level, "S") or {}).source or ""
    if src:sub(1, 1) == "@" then src = src:sub(2) end
    return src:match("(.*[/\\])") or ""
end

---Resolve a config path. tag "mythief" -> "<scriptdir>/mythief-<player>.config.json";
---a tag containing / or \ is used as a literal path.
---@param tag string
---@return string
function DX.Config.path(tag)
    if tag:find("[/\\]") then return tag end
    local dir = configDirFor(3)
    local player = "default"
    pcall(function() player = API.GetLocalPlayerName() or "default" end)
    return string.format("%s%s-%s.config.json", dir, tag, player)
end

---Save data (table) as JSON. Returns true on success.
---@param tag string
---@param data table
---@return boolean
function DX.Config.save(tag, data)
    local ok, json = pcall(API.JsonEncode, data)
    if not (ok and type(json) == "string") then return false end
    local f = io.open(DX.Config.path(tag), "w")
    if not f then return false end
    f:write(json)
    f:close()
    return true
end

---Load saved JSON.
---@param tag string
---@return table|nil decoded data or nil when missing/invalid
function DX.Config.load(tag)
    local f = io.open(DX.Config.path(tag), "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    if not content or content == "" then return nil end
    local ok, data = pcall(API.JsonDecode, content)
    if ok and type(data) == "table" then return data end
    return nil
end

---Load and merge: copies top-level keys of the saved table into target.
---@param tag string
---@param target table
---@return boolean true when anything was merged
function DX.Config.loadInto(tag, target)
    local data = DX.Config.load(tag)
    if type(data) ~= "table" then return false end
    for k, v in pairs(data) do target[k] = v end
    return true
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.run — standard main-loop runner
-- Wraps the while-Read_LoopyLoop boilerplate: state checks, random events, error guard,
-- periodic console dump, on-exit hook. Replaces per-script main() scaffolding.
----------------------------------------------------------------------------------------------------

---Run stepFn once per loop iteration until the script is stopped.
---@param stepFn function called once per iteration (pcall-wrapped)
---@param opts table|nil { stateChecks=true, randomEvents=true, consoleFile=nil,
---  consoleIntervalSec=60, onErrorSleepMs=1000, onExit=nil }
function DX.run(stepFn, opts)
    opts = opts or {}
    local consoleFile = opts.consoleFile
    local interval = opts.consoleIntervalSec or 60
    local backoff = opts.onErrorSleepMs or 1000
    local lastSave = os.time()
    while API.Read_LoopyLoop() do
        if opts.stateChecks ~= false and not DX.Game.stateChecks() then
            break
        end
        if opts.randomEvents ~= false then
            pcall(DX.Game.handleRandomEvents)
        end
        local ok, err = pcall(stepFn)
        if not ok then
            API.logError("[DX.run] " .. tostring(err))
            DX.Wait.sleep(backoff, 100, 200)
        end
        if consoleFile and (os.time() - lastSave) >= interval then
            pcall(API.SaveConsoleToFile, consoleFile, false)
            lastSave = os.time()
        end
    end
    if consoleFile then
        pcall(API.SaveConsoleToFile, consoleFile, false)
    end
    if opts.onExit then
        pcall(opts.onExit)
    end
end

DX.Lodestone = {}

local function lodestoneAt(lode)
    local playerLoc = API.PlayerCoord()
    local xDiff = math.abs(playerLoc.x - lode.loc.x)
    local yDiff = math.abs(playerLoc.y - lode.loc.y)
    return xDiff <= 20 and yDiff <= 20
end

local function lodestoneTeleport(lode)
    if lodestoneAt(lode) then
        print("At lodestone area")
        return true
    end
    print("Teleporting to lodestone")
    for attempt = 1, 3 do
        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1465, 34, -1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1500, 300, 300)
        if API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1092, lode.id, -1, API.OFF_ACT_GeneralInterface_route) then
            if DX.Wait.forCondition(function() return API.ReadPlayerAnim() > 0 or lodestoneAt(lode) end, 10, "teleport channel start", { randomEvents = false, stateChecks = false }) then
                if DX.Wait.forCondition(function() return lodestoneAt(lode) end, 5, "teleported to lodestone", { randomEvents = false, stateChecks = false }) then
                    print("finished waiting for teleport")
                    API.RandomSleep2(2000, 500, 300)
                    return true
                end
                print("Channel seen but arrival not detected")
            else
                print("No teleport channel started (attempt " .. attempt .. ")")
            end
        else
            print("Map click failed (attempt " .. attempt .. ")")
        end
    end
    return false
end

local function buildLodestone(id, loc)
    local lode = { id = id, loc = loc }
    lode.teleport = function()
        return lodestoneTeleport(lode)
    end
    lode.isAt = function()
        return lodestoneAt(lode)
    end
    return lode
end

---@param lode table
---@return boolean
function DX.Lodestone.teleport(lode)
    return lode.teleport()
end

---@param lode table
---@return boolean
function DX.Lodestone.isAt(lode)
    return lode.isAt()
end

DX.Lodestone.AL_KHARID = buildLodestone(10, FFPOINT.new(3297, 3184, 0))
DX.Lodestone.ANACHRONIA = buildLodestone(24, FFPOINT.new(5431, 2338, 0))
DX.Lodestone.ARDOUGNE = buildLodestone(11, FFPOINT.new(2634, 3348, 0))
DX.Lodestone.ASHDALE = buildLodestone(33, FFPOINT.new(2474, 2708, 2))
DX.Lodestone.BANDIT_CAMP = buildLodestone(8, FFPOINT.new(3214, 2955, 0))
DX.Lodestone.BURTHOPE = buildLodestone(12, FFPOINT.new(2899, 3544, 0))
DX.Lodestone.CANIFIS = buildLodestone(26, FFPOINT.new(3517, 3515, 0))
DX.Lodestone.CATHERBY = buildLodestone(13, FFPOINT.new(2811, 3449, 0))
DX.Lodestone.DRAYNOR_VILLAGE = buildLodestone(14, FFPOINT.new(3105, 3298, 0))
DX.Lodestone.EAGLES_PEAK = buildLodestone(27, FFPOINT.new(2366, 3479, 0))
DX.Lodestone.EDGEVILLE = buildLodestone(15, FFPOINT.new(3067, 3505, 0))
DX.Lodestone.FALADOR = buildLodestone(16, FFPOINT.new(2967, 3403, 0))
DX.Lodestone.FORT_FORINTHRY = buildLodestone(22, FFPOINT.new(3298, 3525, 0))
DX.Lodestone.FREMENNIK_PROVINCE = buildLodestone(28, FFPOINT.new(2712, 3677, 0))
DX.Lodestone.KARAMJA = buildLodestone(29, FFPOINT.new(2761, 3147, 0))
DX.Lodestone.LUNAR_ISLE = buildLodestone(9, FFPOINT.new(2085, 3914, 0))
DX.Lodestone.LUMBRIDGE = buildLodestone(17, FFPOINT.new(3233, 3221, 0))
DX.Lodestone.MENAPHOS = buildLodestone(23, FFPOINT.new(3216, 2716, 0))
DX.Lodestone.OOGLOG = buildLodestone(30, FFPOINT.new(2532, 2871, 0))
DX.Lodestone.PORT_SARIM = buildLodestone(18, FFPOINT.new(3011, 3215, 0))
DX.Lodestone.PRIFDDINAS = buildLodestone(34, FFPOINT.new(2208, 3360, 1))
DX.Lodestone.SEERS_VILLAGE = buildLodestone(19, FFPOINT.new(2689, 3482, 0))
DX.Lodestone.TAVERLEY = buildLodestone(20, FFPOINT.new(2878, 3442, 0))
DX.Lodestone.TIRANNWN = buildLodestone(31, FFPOINT.new(2254, 3149, 0))
DX.Lodestone.UM = buildLodestone(35, FFPOINT.new(1084, 1768, 1))
DX.Lodestone.VARROCK = buildLodestone(21, FFPOINT.new(3214, 3376, 0))
DX.Lodestone.WENDLEWICK = buildLodestone(41, FFPOINT.new(3461, 1520, 0))
DX.Lodestone.WILDERNESS = buildLodestone(32, FFPOINT.new(3143, 3636, 0))
DX.Lodestone.YANILLE = buildLodestone(25, FFPOINT.new(2529, 3095, 0))

----------------------------------------------------------------------------------------------------
--# SECTION: DX.PlayerManager — player state, survival and buff management
--#   Ported from Sonson's player_manager.lua v1.2.4
--#   https://github.com/sonsonmagro/Sonsons-Player-Manager
--#   Adapted to this client's API shapes and conventions. Fixes upstream bugs:
--#   wrong inv_Container field names, dead critical-prayer check, inverted
--#   teleport cooldown, triple GetABs_names read, global `debug` leak,
--#   PlayerRegion().z used as plane (it is RegionId), missing status dispatch.
--#   Devexity extensions on top of upstream: `statuses` config + manageStatuses()
--#   re-added (upstream dropped status dispatch in v1.2.0), `detector`-only
--#   locations table optional.
----------------------------------------------------------------------------------------------------
DX.PlayerManager = {}
DX.PlayerManager.__index = DX.PlayerManager

local PM_ACTION_INTERVAL = 2 -- ticks between managed actions (eat/drink/buff/excal/shard)
local PM_TELE_COOLDOWN = 20  -- ticks between panic teleports
local PM_EXCAL_IDS = { 14632, 36619 } -- enhanced excalibur, augmented enhanced excalibur
local PM_ELVEN_SHARD_ID = 43358
local PM_ADRENALINE_VB = 679 -- varbit, state/10 = percent

-- inventory categorization; first matching category wins
local PM_ITEM_CATEGORIES = {
    { name = "prayer", patterns = {
        "Prayer", "Super restore", "Sanfew", "Super prayer",
        "Spiritual prayer", "Extreme prayer", "Blessed flask" } },
    { name = "potion", patterns = {
        "Guthix rest", "Super Guthix brew", "Saradomin brew" } },
    { name = "jellyfish", patterns = { "blubber jellyfish" } },
    { name = "food", patterns = {
        "Kebab", "Bread", "Doughnut", "Roll", "Square sandwich",
        "Crayfish", "Shrimps", "Sardine", "Herring", "Mackerel",
        "Anchovies", "Cooked chicken", "Cooked meat", "Trout", "Cod",
        "Pike", "Salmon", "Tuna", "Bass", "Lobster", "Swordfish",
        "Desert sole", "Catfish", "Monkfish", "Beltfish", "Ghostly sole",
        "Cooked eeligator", "Shark", "Sea turtle", "Great white shark", "Cavefish",
        "Manta ray", "Rocktail", "Tiger shark", "Sailfish", "Baron shark",
        "Potato with cheese", "Tuna potato", "Great maki", "Great gunkan",
        "Rocktail soup", "Sailfish soup", "Fury shark", "Primal feast" } },
}

---@param config table|nil {health, prayer, locations, statuses, panicTeleport, debug}
---@return table
function DX.PlayerManager.new(config)
    config = config or {}
    local self = setmetatable({}, DX.PlayerManager)

    self.config = config
    self.config.health = config.health or {
        normal   = { type = "percent", value = 50 },
        critical = { type = "percent", value = 25 },
        special  = { type = "percent", value = 75 }, -- excalibur threshold
    }
    self.config.prayer = config.prayer or {
        normal   = { type = "current", value = 200 },
        critical = { type = "percent", value = 10 },
        special  = { type = "current", value = 600 }, -- elven shard threshold
    }
    self.config.locations = config.locations or {}
    self.config.statuses = config.statuses or {}
    if config.panicTeleport == nil then self.config.panicTeleport = true end
    self.debug = config.debug or false

    -- sort statuses by priority ascending; lowest number runs first
    table.sort(self.config.statuses, function(a, b)
        return (a.priority or math.huge) < (b.priority or math.huge)
    end)

    self.state = {
        health = { current = 0, max = 0, percent = 0 },
        prayer = { current = 0, max = 0, percent = 0 },
        adrenaline = 0,
        location = "UNKNOWN",
        status = nil,
        orientation = 999,
        coords = { x = 0, y = 0, z = 0 },
        animation = -1,
        moving = false,
        inCombat = false,
    }
    self.timestamp = { eat = 0, drink = 0, buff = 0, excal = 0, shard = 0, tele = 0 }
    self.inventory = { food = {}, prayer = {} }
    self.buffs = { managed = {}, toggle = {} }
    return self
end

function DX.PlayerManager:debugLog(message)
    if self.debug then API.logDebug("[PM] " .. message) end
end

--#region state

---@private
function DX.PlayerManager:_determineLocation()
    local pos = self.state.coords
    for _, loc in ipairs(self.config.locations) do
        if loc.coords and API.PInArea(loc.coords.x, loc.coords.range or 0,
                loc.coords.y, loc.coords.range or 0, loc.coords.z or pos.z) then
            return loc.name
        end
        if loc.detector and loc.detector() then
            return loc.name
        end
    end
    return "UNKNOWN"
end

---@return boolean
function DX.PlayerManager:isPlayerIdle()
    return self.state.animation == 0 and not self.state.moving
end

---@param coords table {x, y, range, z?}
---@return boolean
function DX.PlayerManager:isPlayerAtLocation(coords)
    return API.PInArea(coords.x, coords.range or 0, coords.y,
        coords.range or 0, coords.z or self.state.coords.z)
end

---@private
---@return number facing degrees 0-359
function DX.PlayerManager:_determineOrientation()
    local ok, o = pcall(API.calculatePlayerOrientation)
    return (ok and type(o) == "number") and math.floor(o) % 360 or 999
end

---@return string cardinal direction
function DX.PlayerManager:getFacingDirection()
    local deg = self.state.orientation % 360
    if deg >= 338 or deg <= 22 then return "North" end
    local dirs = {
        { 23,  "Northeast", 67 }, { 68,  "East",      112 },
        { 113, "Southeast", 157 }, { 158, "South",     202 },
        { 203, "Southwest", 247 }, { 248, "West",      292 },
        { 293, "Northwest", 337 },
    }
    for _, d in ipairs(dirs) do
        if deg >= d[1] and deg <= d[3] then return d[2] end
    end
    return "North"
end

---@private
function DX.PlayerManager:_createStat(current, max)
    return {
        current = current, max = max,
        percent = max > 0 and math.floor((current / max) * 100) or 0,
    }
end

---@private
function DX.PlayerManager:_updatePlayerState()
    self.state.health = self:_createStat(API.GetHP_() or 0, API.GetHPMax_() or 0)
    self.state.prayer = self:_createStat(API.GetPray_() or 0, API.GetPrayMax_() or 0)
    local adren = API.VB_FindPSettinOrder(PM_ADRENALINE_VB)
    self.state.adrenaline = (adren and adren.state) and adren.state / 10 or 0
    local pos = API.PlayerCoord()
    self.state.coords = { x = pos.x, y = pos.y, z = pos.z }
    self.state.location = self:_determineLocation()
    self.state.orientation = self:_determineOrientation()
    self.state.animation = API.ReadPlayerAnim() or -1
    self.state.moving = API.ReadPlayerMovin2() or false
    self.state.inCombat = API.GetInCombBit() or false
end

--#endregion

--#region inventory scan

---@private
function DX.PlayerManager:_scanInventory()
    local ok, items = pcall(function() return Inventory:GetItems() end)
    if not ok or items == nil then return end
    items = stateToTable(items)
    if type(items) ~= "table" then return end

    local rawFoods, rawPrayers = {}, {}
    for _, it in pairs(items) do
        if type(it) == "table" then
            local id = it.id or it.item_id
            local qty = it.amount or it.item_stack or 1
            local cleanName = (it.name or it.item_name or ""):gsub("<[^>]*>", "")
            if id and id > 0 and cleanName ~= "" then
                for _, category in ipairs(PM_ITEM_CATEGORIES) do
                    local matched = false
                    for _, pattern in ipairs(category.patterns) do
                        if cleanName:find(pattern, 1, true) then
                            matched = true
                            break
                        end
                    end
                    if matched then
                        local entry = { name = cleanName, id = id, type = category.name, count = qty }
                        table.insert(category.name == "prayer" and rawPrayers or rawFoods, entry)
                        break
                    end
                end
            end
        end
    end
    self.inventory.food = self:_mergeDuplicates(rawFoods)
    self.inventory.prayer = self:_mergeDuplicates(rawPrayers)
end

---@private
function DX.PlayerManager:_mergeDuplicates(items)
    local merged, seen = {}, {}
    for _, item in ipairs(items) do
        local key = item.id .. ":" .. item.name
        if seen[key] then
            seen[key].count = seen[key].count + item.count
        else
            seen[key] = { name = item.name, id = item.id, type = item.type, count = item.count }
            table.insert(merged, seen[key])
        end
    end
    return merged
end

---@private
function DX.PlayerManager:_itemCount(items)
    local n = 0
    for _, item in pairs(items or {}) do n = n + (item.count or 1) end
    return n
end

---@private
---@param foodType string "food"|"jellyfish"|"potion"
---@return table[]
function DX.PlayerManager:_foodItems(foodType)
    local filtered = {}
    for _, item in ipairs(self.inventory.food) do
        if item.type == foodType then table.insert(filtered, item) end
    end
    -- jellyfish: eat partials first (1/3, then 2/3, then full)
    if foodType == "jellyfish" then
        table.sort(filtered, function(a, b)
            local function rank(n)
                local p = n:match("^(%d)/3")
                return p and tonumber(p) or 3
            end
            return rank(a.name) < rank(b.name)
        end)
    end
    return filtered
end

---@private
---@param resource string "health"|"prayer"
---@param thresholdType string "normal"|"critical"|"special"
function DX.PlayerManager:_checkThreshold(resource, thresholdType)
    local stat = self.state[resource]
    local threshold = self.config[resource][thresholdType]
    if not stat or not threshold then return false end
    local compare = threshold.type == "percent" and stat.percent or stat.current
    return compare <= threshold.value
end

---@param buffId number
---@return table {found: boolean, remaining: number}
function DX.PlayerManager:getBuff(buffId)
    local buff = API.Buffbar_GetIDstatus(buffId, false)
    local found = buff ~= nil and buff.found or false
    return { found = found, remaining = (found and API.Bbar_ConvToSeconds(buff)) or 0 }
end

---@param debuffId number
---@return table {found: boolean, remaining: number}
function DX.PlayerManager:getDebuff(debuffId)
    local debuff = API.DeBuffbar_GetIDstatus(debuffId, false)
    local found = debuff ~= nil and debuff.found or false
    return { found = found, remaining = (found and API.Bbar_ConvToSeconds(debuff)) or 0 }
end

--#endregion

--#region health

---@private
---@return table|boolean {location, id} or false
function DX.PlayerManager:_hasExcalibur()
    for _, id in ipairs(PM_EXCAL_IDS) do
        if Inventory:Contains(id) then
            return { location = "inventory", id = id }
        end
        if Equipment:Contains(id) then
            return { location = "equipped", id = id }
        end
    end
    return false
end

---@return boolean
function DX.PlayerManager:useExcalibur()
    local excal = self:_hasExcalibur()
    if not excal or self:getDebuff(PM_EXCAL_IDS[1]).found then return false end
    if API.Get_tick() - self.timestamp.excal < PM_ACTION_INTERVAL then return false end

    local used = false
    if excal.location == "inventory" then
        used = API.DoAction_Inventory1(excal.id, 0, 1, API.OFF_ACT_GeneralInterface_route)
    else
        used = Equipment:DoAction(excal.id, 1)
    end
    if used then self.timestamp.excal = API.Get_tick() end
    return used
end

---@private
function DX.PlayerManager:_eat(foodType)
    local item = self:_foodItems(foodType)[1]
    if not item then return false end
    if API.DoAction_Inventory1(item.id, 0, 1, API.OFF_ACT_GeneralInterface_route) then
        API.RandomSleep2(60, 10, 20)
        return true
    end
    return false
end

---eat food + jellyfish (+ brew if allowed) in one tick
---@param critical boolean also eat solid food (costs adrenaline)
function DX.PlayerManager:oneTickEat(critical)
    local tick = API.Get_tick()
    if tick - self.timestamp.eat < PM_ACTION_INTERVAL then return end
    self:debugLog(string.format("Health low (%s | %s%%), eating",
        self.state.health.current, self.state.health.percent))

    if critical and #self:_foodItems("food") > 0 and self:_eat("food") then
        self.timestamp.eat = tick
    end
    if #self:_foodItems("jellyfish") > 0 and self:_eat("jellyfish") then
        self.timestamp.eat = tick
    end
    if tick - 1 <= self.timestamp.drink then return end
    if #self:_foodItems("potion") > 0 and self:_eat("potion") then
        self.timestamp.drink = tick
    end
end

function DX.PlayerManager:manageHealth()
    local normal = self:_checkThreshold("health", "normal")
    local critical = self:_checkThreshold("health", "critical")
    local special = self:_checkThreshold("health", "special")

    if special then self:useExcalibur() end
    if normal and #self.inventory.food > 0 then
        self:oneTickEat(critical)
        return
    end
    if critical and #self.inventory.food == 0 then
        self:_teleportToWars()
    end
end

--#endregion

--#region prayer

---@private
function DX.PlayerManager:_hasElvenShard()
    return Inventory:Contains(PM_ELVEN_SHARD_ID)
end

---@return boolean
function DX.PlayerManager:useElvenShard()
    if not self:_hasElvenShard() or self:getDebuff(PM_ELVEN_SHARD_ID).found then return false end
    if API.Get_tick() - self.timestamp.shard < PM_ACTION_INTERVAL then return false end
    if API.DoAction_Inventory1(PM_ELVEN_SHARD_ID, 0, 1, API.OFF_ACT_GeneralInterface_route) then
        self.timestamp.shard = API.Get_tick()
        return true
    end
    return false
end

---@param potionId number|nil defaults to first prayer item found
---@return boolean
function DX.PlayerManager:drink(potionId)
    if API.Get_tick() - self.timestamp.drink < PM_ACTION_INTERVAL then return false end
    local itemId = potionId or (self.inventory.prayer[1] and self.inventory.prayer[1].id)
    if not itemId or not Inventory:Contains(itemId) then return false end
    if API.DoAction_Inventory1(itemId, 0, 1, API.OFF_ACT_GeneralInterface_route) then
        self.timestamp.drink = API.Get_tick()
        API.RandomSleep2(60, 10, 20)
        return true
    end
    return false
end

function DX.PlayerManager:managePrayer()
    local normal = self:_checkThreshold("prayer", "normal")
    local critical = self:_checkThreshold("prayer", "critical")
    local special = self:_checkThreshold("prayer", "special")

    if special then self:useElvenShard() end
    if normal and #self.inventory.prayer > 0 then
        self:drink()
        return
    end
    if critical and #self.inventory.prayer == 0 then
        self:_teleportToWars()
    end
end

--#endregion

--#region buffs

---manage a buff list. Each buff: {buffName, buffId, execute():bool,
--- canApply?: bool|fun(self):bool, toggle?: bool, refreshAt?: seconds,
--- untoggleBelow?: seconds -- toggle buffs only switch off if remaining > this}
function DX.PlayerManager:manageBuffs(buffs)
    local tick = API.Get_tick()
    local managedBuffs, toggleBuffs = {}, {}
    local canExecute = (tick - self.timestamp.buff) >= PM_ACTION_INTERVAL

    for _, buff in pairs(buffs) do
        local allowApply = true
        if type(buff.canApply) == "function" then
            allowApply = buff.canApply(self)
        elseif type(buff.canApply) == "boolean" then
            allowApply = buff.canApply
        end

        local activeBuff = self:getBuff(buff.buffId)
        buff.refreshAt = buff.refreshAt or 0

        if buff.toggle then
            table.insert(toggleBuffs, {
                buffName = buff.buffName, buffId = buff.buffId,
                execute = buff.execute, canApply = buff.canApply,
                untoggleBelow = buff.untoggleBelow,
            })
        end
        if activeBuff.found and activeBuff.remaining >= buff.refreshAt then
            table.insert(managedBuffs, {
                buffName = buff.buffName, buffId = buff.buffId,
                remaining = activeBuff.remaining, execute = buff.execute,
                canApply = buff.canApply, untoggleBelow = buff.untoggleBelow,
            })
        elseif canExecute and allowApply then
            if buff.execute() then
                self.timestamp.buff = tick
                canExecute = false
            end
        end
    end

    self.buffs.toggle = toggleBuffs
    self.buffs.managed = managedBuffs
end

---@private switch off toggle buffs whose canApply no longer holds
function DX.PlayerManager:_untoggleBuffs()
    local tick = API.Get_tick()
    local canExecute = (tick - self.timestamp.buff) >= PM_ACTION_INTERVAL

    for _, toggleBuff in ipairs(self.buffs.toggle) do
        local shouldBeOn = true
        if type(toggleBuff.canApply) == "function" then
            shouldBeOn = toggleBuff.canApply(self)
        elseif type(toggleBuff.canApply) == "boolean" then
            shouldBeOn = toggleBuff.canApply
        end

        if not shouldBeOn then
            local activeBuff = self:getBuff(toggleBuff.buffId)
            local active = activeBuff.found
                and activeBuff.remaining > (toggleBuff.untoggleBelow or 0)
            if active and canExecute then
                if toggleBuff.execute() then
                    self.timestamp.buff = tick
                    canExecute = false
                end
            end
        end
    end
end

---@private
function DX.PlayerManager:_getBuffName(buff)
    for _, m in pairs(self.buffs.managed) do
        if buff.id == m.buffId then return m.buffName end
    end
    return "UNKNOWN"
end

--#endregion

--#region statuses & abilities

---evaluate configured statuses in priority order; run the first match's execute()
---@return string|nil name of the active status
function DX.PlayerManager:manageStatuses()
    self.state.status = nil
    for _, status in ipairs(self.config.statuses) do
        local ok, match = pcall(status.condition, self)
        if ok and match then
            self.state.status = status.name
            if status.execute then
                local okE, err = pcall(status.execute, self)
                if not okE then
                    API.logError("[PM] status '" .. status.name .. "' execute failed: " .. tostring(err))
                end
            end
            return status.name
        end
    end
    return nil
end

---@private
function DX.PlayerManager:_canUseAbility(abilityName)
    local abs = API.GetABs_names({ abilityName })
    local ab = abs and abs[1]
    return ab ~= nil and ab.enabled and (ab.cooldown_timer or 0) <= 1
end

---@private
function DX.PlayerManager:_useAbility(abilityName)
    if self:_canUseAbility(abilityName) then
        return API.DoAction_Ability(abilityName, 1, API.OFF_ACT_GeneralInterface_route, true)
    end
    return false
end

---@private panic teleport to War's Retreat (respects config.panicTeleport)
function DX.PlayerManager:_teleportToWars()
    if not self.config.panicTeleport then return end
    local tick = API.Get_tick()
    if tick - self.timestamp.tele < PM_TELE_COOLDOWN then return end
    if self:_useAbility("War's Retreat Teleport") then
        self:debugLog(string.format("Out of supplies (%s | %s%%), teleporting out!",
            self.state.health.current, self.state.health.percent))
        self.timestamp.tele = tick
    end
end

--#endregion

--#region tracking (for UI dashboards)

function DX.PlayerManager:stateTracking()
    return {
        { "Player State:", "" },
        { "- Health",  string.format("%s/%s (%s%%)", self.state.health.current, self.state.health.max, self.state.health.percent) },
        { "- Prayer",  string.format("%s/%s (%s%%)", self.state.prayer.current, self.state.prayer.max, self.state.prayer.percent) },
        { "- Adrenaline", self.state.adrenaline },
        { "- Location",   self.state.location },
        { "- Status",     self.state.status or "-" },
        { "- Direction",  self:getFacingDirection() .. " (" .. self.state.orientation .. " deg)" },
        { "- Coordinates", string.format("(%s, %s, %s)", self.state.coords.x, self.state.coords.y, self.state.coords.z) },
        { "- Animation",  self.state.animation == 0 and "Idle" or self.state.animation },
        { "- Moving?",    self.state.moving and "Yes" or "No" },
        { "- In Combat?", self.state.inCombat and "Yes" or "No" },
    }
end

function DX.PlayerManager:managementTracking()
    return {
        { "Player Management:", "" },
        { "- Items:", "" },
        { "-- Has Excalibur?",          self:_hasExcalibur() and "Yes" or "No" },
        { "-- Has Elven ritual shard?", self:_hasElvenShard() and "Yes" or "No" },
        { "-- Edible food count:",      self:_itemCount(self.inventory.food) },
        { "-- Prayer items count:",     self:_itemCount(self.inventory.prayer) },
    }
end

function DX.PlayerManager:foodItemsTracking()
    local metrics = { { "- Food Items:", "" } }
    if #self.inventory.food < 1 then
        table.insert(metrics, { "-- No foods found", "" })
    else
        for _, i in ipairs(self.inventory.food) do
            table.insert(metrics, { "-- " .. i.count .. "x " .. i.type, i.name })
        end
    end
    return metrics
end

function DX.PlayerManager:prayerItemsTracking()
    local metrics = { { "- Prayer Items:", "" } }
    if #self.inventory.prayer < 1 then
        table.insert(metrics, { "-- No prayer items found", "" })
    else
        for _, i in ipairs(self.inventory.prayer) do
            table.insert(metrics, { "-- " .. i.count .. "x " .. i.type, i.name })
        end
    end
    return metrics
end

function DX.PlayerManager:managedBuffsTracking()
    local metrics = { { "- Managed Buffs:", "" } }
    if #self.buffs.managed < 1 then
        table.insert(metrics, { "-- No buffs found", "" })
    else
        for _, i in pairs(self.buffs.managed) do
            table.insert(metrics, { "-- " .. i.buffId .. ": " .. i.buffName, "Remaining: " .. i.remaining })
        end
    end
    return metrics
end

function DX.PlayerManager:activeBuffsTracking()
    local metrics = { { "- Active Buffs:", "" } }
    local activeBuffs = API.Buffbar_GetAllIDs(false) or {}
    if #activeBuffs < 1 then
        table.insert(metrics, { "-- No buffs found", "" })
    else
        for _, i in pairs(activeBuffs) do
            table.insert(metrics, { "-- " .. i.id .. ": " .. self:_getBuffName(i),
                "Text (conv): " .. tostring(i.text) .. " (" .. tostring(i.conv_text) .. ")" })
        end
    end
    return metrics
end

--#endregion

---refresh player state + inventory, untoggle stale buffs, dispatch statuses.
---call once per loop before manageHealth/managePrayer/manageBuffs.
function DX.PlayerManager:update()
    self:_untoggleBuffs()
    self.buffs.managed = {}
    self:_updatePlayerState()
    self:_scanInventory()
    self:manageStatuses()
end

--# SECTION: DX.Bank — "Bank Toolbox" v1.2.0 by Spectre011, vendored + local fixes
--#   https://github.com/spectre011-code/Public-ME-Scripts/blob/main/Libraries/bank.lua
--#   Upstream bugs fixed here (not in upstream v1.2.0):
--#     - DepositBoxContains: body used `itemID`, param is `ItemID` (always false)
--#     - ColletionBoxCollectToInventory/ToBank called HasItemsToCollect(), which
--#       does not exist upstream -> now call ColletionBoxHasItems()
--#   (upstream changelog below is kept verbatim for provenance)
local ScriptName = "Bank Toolbox"
local Author = "Spectre011"
local ScriptVersion = "1.2.0"
local ReleaseDate = "02-05-2025"
local DiscordHandle = "not_spectre011"
--[[
Changelog:
v1.0.0 - 02-05-2025
    - Initial release.
v1.0.1 - 02-05-2025
    - Forgot to add changelog.
v1.0.2 - 02-05-2025
    - Renamed some functions to be more similar to other ME functions.
v1.0.3 - 02-05-2025
    - More renames.
    - Removed empty lines.
v1.0.4 - 04-05-2025
    - Edited credits variables to be local to prevent some funny interactions with my other scripts.
    - Added functions: 
        BANK:GetTransferTab()
        BANK:SetTransferTab()
        BANK:PresetSettingsIsOpen()
        BANK:PresetSettingsOpen()
        BANK:PresetSettingsReturnToBank()
        BANK:PresetSettingsGetSelectedPreset()
        BANK:PresetSettingsSelectPreset()
        BANK:PresetSettingsGetInventory()
        BANK:PresetSettingsGetEquipment()
        BANK:PrintInventory()
    - Edited relevant functions to check for transfer/preset tabs.
    - Edited some prints to be more descriptive.
v1.0.5 - 06-05-2025
    - Functions now use : instead of .
    - Modified tables to be inside the BANK table.
    - Modified functions to use the tables with the atribute self.
    - Modified functions BANK:PresetSettingsGetEquipment() and BANK:PresetSettingsGetInventory() to include the item name.
    - Added function BANK:PresetSettingsGetCheckBox().
    - Added function BANK:PresetSettingsSetCheckBox().
    - Renamed some functions to be more descriptive of their class.
    - Reordered function by class:
        General bank
        Deposit box
        Collection box
        Preset settings
v1.0.6 - 08-05-2025
    - Fixed VB read in BANK:GetOpenedTab().
    - Fixed VB read in BANK:GetQuantitySelected().
    - Fixed typos in BANK:WithdrawToBoB() and BANK:Withdraw().
    - Fixed typos for Head Guard in BANK:Open().
    - Added Head Guard to BANK:LoadLastPreset().
v1.0.7 - 19-05-2025
    - BANK:Contains() and BANK:InventoryContains() now accepts number and table.
    - Added functions:
        BANK:ContainsAny()
        BANK:InventoryContainsAny()
        BANK:EquipmentContains()
        BANK:EquipmentContainsAny()
v1.0.8 - 07-06-2025
    - Added functions:
        BANK:Withdraw1()
        BANK:Withdraw5()
        BANK:Withdraw10()
        BANK:WithdrawX()
        BANK:WithdrawAll()
        BANK:Deposit1()
        BANK:Deposit5()
        BANK:Deposit10()
        BANK:DepositX()
        BANK:DepositAll()
v1.0.9 - 14-06-2025
    - Change some functions params descriptions to remove warnings.
    - Added functions:
        BANK:IsPINOpen()
        BANK:EnterPIN()
        BANK:GetTotalSpaces()
        BANK:GetUsedSpaces()
        BANK:GetFreeSpaces()
        BANK:GetItemAmount()
        BANK:InventoryGetItemAmount()
        BANK:EquipmentGetItemAmount()        
        BANK:DepositBoxContains()
        BANK:DepositBoxGetSlot()
        BANK:DepositBoxDeposit1()
        BANK:DepositBoxDeposit5()
        BANK:DepositBoxDeposit10()
        BANK:DepositBoxDepositAll2()  
        BANK:Close()      
        BANK:DepositBoxClose()
        BANK:CollectionBoxClose()
v1.0.10 - 25-06-2025
    - Added functions:
        BANK:WoodBoxDepositLogs()
        BANK:WoodBoxDepositWoodSpirits()
        BANK:OreBoxDepositOres()
        BANK:OreBoxDepositStoneSpirits()
v1.0.11 - 26-06-2025
    - Added function:
        BANK:SoilBoxDepositSoil()
v1.1.0 - 06-08-2025
    - Added bank table BANK.Banks
    - Added function:
        GetNearestBank()
    - Changed functions BANK:Open(), BANK:LoadLastPreset() and BANK:CollectionBoxOpen() to use the nearest bank.
v1.2.0 - 21-09-2025
    - Added banks:
        Emerald Benedict
        Gundai
        Dead man's chest
v1.2.1 - 19-01-2026
    - Fixed API.DoAction_Interface interface ID
]]


local BANK = {}
DX.Bank = BANK

BANK.Banks = {
    {Name = "Gundai", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "NPC"},
    {Name = "Banker", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "NPC"},
    {Name = "Head Guard", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "NPC"},
    {Name = "Gnome Banker", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "NPC"},
    {Name = "Emerald Benedict", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "NPC"},

    {Name = "Counter", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "Object"},
    {Name = "Bank chest", OpenAction = "Use", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "Object"},
    {Name = "Bank booth", OpenAction = "Bank", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "Object"},    
    {Name = "Dead man's chest", OpenAction = "Use", LoadLastPresetAction = "Load Last Preset from", CollectionBoxAction = "Collect", InteractType = "Object"}
}

BANK.Interfaces = {}

BANK.Interfaces.PIN = { 
    { 759,5,-1,0 } 
}

BANK.Interfaces.BankSpaces = {
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,230,-1,0 }, { 517,231,-1,0 }, { 517,245,-1,0 }, { 517,246,-1,0 }, { 517,249,-1,0 } }, --Used space
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,230,-1,0 }, { 517,231,-1,0 }, { 517,245,-1,0 }, { 517,246,-1,0 }, { 517,250,-1,0 } } --Total space
}

BANK.Interfaces.DepositBoxSlots = {
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,0,0 } }, --slot 1
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,1,0 } }, --slot 2
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,2,0 } }, --slot 3
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,3,0 } }, --slot 4
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,4,0 } }, --slot 5
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,5,0 } }, --slot 6
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,6,0 } }, --slot 7
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,7,0 } }, --slot 8
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,8,0 } }, --slot 9
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,9,0 } }, --slot 10
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,10,0 } }, --slot 11
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,11,0 } }, --slot 12
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,12,0 } }, --slot 13
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,13,0 } }, --slot 14
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,14,0 } }, --slot 15
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,15,0 } }, --slot 16
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,16,0 } }, --slot 17
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,17,0 } }, --slot 18
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,18,0 } }, --slot 19
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,19,0 } }, --slot 20
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,20,0 } }, --slot 21
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,21,0 } }, --slot 22
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,22,0 } }, --slot 23
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,23,0 } }, --slot 24
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,24,0 } }, --slot 25
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,25,0 } }, --slot 26
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,26,0 } }, --slot 27
    { { 11,16,-1,0 }, { 11,18,-1,0 }, { 11,19,-1,0 }, { 11,19,27,0 } } --slot 28
} 

BANK.Interfaces.CollectionBoxSlots = { -- https://imgur.com/WN60RRo. 
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,15,-1,0 }, { 109,14,-1,0 }, { 109,14,1,0 } }, -- Slot 1
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,15,-1,0 }, { 109,14,-1,0 }, { 109,14,3,0 } }, -- Slot 2

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,21,-1,0 }, { 109,12,-1,0 }, { 109,12,1,0 } }, -- Slot 3
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,21,-1,0 }, { 109,12,-1,0 }, { 109,12,3,0 } }, -- Slot 4

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,22,-1,0 }, { 109,10,-1,0 }, { 109,10,1,0 } }, -- Slot 5
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,22,-1,0 }, { 109,10,-1,0 }, { 109,10,3,0 } }, -- Slot 6

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,23,-1,0 }, { 109,7,-1,0 }, { 109,7,1,0 } }, -- Slot 7
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,23,-1,0 }, { 109,7,-1,0 }, { 109,7,3,0 } }, -- Slot 8

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,24,-1,0 }, { 109,4,-1,0 }, { 109,4,1,0 } }, -- Slot 9
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,24,-1,0 }, { 109,4,-1,0 }, { 109,4,3,0 } }, -- Slot 10

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,25,-1,0 }, { 109,1,-1,0 }, { 109,1,1,0 } }, -- Slot 11
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,25,-1,0 }, { 109,1,-1,0 }, { 109,1,3,0 } }, -- Slot 12

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,26,-1,0 }, { 109,62,-1,0 }, { 109,62,1,0 } }, -- Slot 13
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,26,-1,0 }, { 109,62,-1,0 }, { 109,62,3,0 } }, -- Slot 14

    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,27,-1,0 }, { 109,67,-1,0 }, { 109,67,1,0 } }, -- Slot 15
    { { 109,37,-1,0 }, { 109,39,-1,0 }, { 109,27,-1,0 }, { 109,67,-1,0 }, { 109,67,3,0 } } -- Slot 16
}

BANK.Interfaces.PresetSettings = {}

BANK.Interfaces.PresetSettings.Inventory = { 
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,0,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,1,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,2,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,3,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,4,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,5,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,6,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,7,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,8,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,9,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,10,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,11,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,12,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,13,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,14,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,15,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,16,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,17,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,18,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,19,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,20,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,21,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,22,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,23,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,24,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,25,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,26,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,277,-1,0 }, { 517,280,-1,0 }, { 517,280,27,0 } }
}

BANK.Interfaces.PresetSettings.Equipment = {
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,0,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,1,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,2,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,3,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,4,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,5,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,7,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,9,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,10,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,12,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,13,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,14,0 } },
    { { 517,0,-1,0 }, { 517,2,-1,0 }, { 517,153,-1,0 }, { 517,261,-1,0 }, { 517,262,-1,0 }, { 517,281,-1,0 }, { 517,283,-1,0 }, { 517,284,-1,0 }, { 517,286,-1,0 }, { 517,290,-1,0 }, { 517,290,17,0 } }
}

BANK.Items = {}

BANK.Items.OreBoxes = {
    44779, -- Bronze
    44781, -- Iron
    44783, -- Steel
    44785, -- Mithril
    44787, -- Adamant
    44789, -- Rune
    44791, -- Orikalkum
    44793, -- Necronium
    44795, -- Bane
    44797, -- Elder rune
    57172 -- Primal
}

BANK.Items.WoodBoxes = {
    54895, -- Wood
    54897, -- Oak
    54899, -- Willow
    54901, -- Teak
    54903, -- Maple
    54905, -- Acadia
    54907, -- Mahogany
    54909, -- Yew
    54911, -- Magic
    54913, -- Elder
    58253 -- Eternal magic
}

-- ##################################
-- #                                #
-- #     GENERAL BANK FUNCTIONS     #
-- #                                #
-- ##################################

-- Returns the nearest bank's name, open action, load preset action, collection box action, and interact type.
---@return table | false -- {name, OpenAction, LoadLastPresetAction, CollectionBoxAction, InteractType} or false
local function GetNearestBank()
    local BankNames = {}
    for _, bank in ipairs(BANK.Banks) do
        table.insert(BankNames, bank.Name)
    end
    
    local AllBanks = API.GetAllObjArrayInteract_str(BankNames, 50, {0, 1, 12})
    
    if not AllBanks or #AllBanks == 0 then
        return false
    end
    
    local NearestBank = nil
    local ShortestDistance = math.huge
    
    for _, bank in ipairs(AllBanks) do
        if bank.Distance and bank.Distance < ShortestDistance then
            ShortestDistance = bank.Distance
            NearestBank = bank
        end
    end
    
    if not NearestBank then
        return false
    end

    for _, BankData in ipairs(BANK.Banks) do
        if BankData.Name == NearestBank.Name then
            print("[BANK] Nearest bank found:", BankData.Name)
            return {
                name = BankData.Name,
                OpenAction = BankData.OpenAction,
                LoadLastPresetAction = BankData.LoadLastPresetAction,
                CollectionBoxAction = BankData.CollectionBoxAction,
                InteractType = BankData.InteractType
            }
        end
    end

    return false
end

-- Check if Bank interface is open.
---@return boolean
function BANK:IsOpen()
    if API.VB_FindPSettinOrder(2874, 0).state == 24 then
        print("[BANK] Bank interface open.")
        return true
    else
        print("[BANK] Bank interface is not open.")
        return false
    end
end

-- Attempts to open your bank using the nearest bank. Requires cache enabled https://imgur.com/5I9a46V.
---@return boolean
function BANK:Open()
    print("[BANK] Opening nearest bank:")
    local NearestBank = GetNearestBank()
    
    if not NearestBank then
        print("[BANK] No bank found nearby or no matching bank in configuration.")
        return false
    end

    local success = false
    
    if NearestBank.InteractType == "NPC" then
        success = Interact:NPC(NearestBank.name, NearestBank.OpenAction, 50)
    elseif NearestBank.InteractType == "Object" then
        success = Interact:Object(NearestBank.name, NearestBank.OpenAction, 50)
    end
    
    if success then
        print("[BANK] " .. NearestBank.name .. " succeeded.")
        return true
    end
    
    print("[BANK] Could not interact with " .. NearestBank.name)
    return false
end

-- Attempts to close the bank interface.
---@return boolean
function BANK:Close()
    if BANK:IsOpen() then
        print("[BANK] Closing bank.")
        return API.DoAction_Interface(0x24,0xffffffff,1,517,318,-1,API.OFF_ACT_GeneralInterface_route)
    else
        print("[BANK] Bank not open.")
        return false
    end    
end

-- Attempts to load the last bank preset using the nearest bank. Requires cache enabled https://imgur.com/5I9a46V.
---@return boolean
function BANK:LoadLastPreset()
    print("[BANK] Loading last preset from nearest bank:")
    local NearestBank = GetNearestBank()
    
    if not NearestBank then
        print("[BANK] No bank found nearby or no matching bank in configuration.")
        return false
    end

    local success = false
    
    if NearestBank.InteractType == "NPC" then
        success = Interact:NPC(NearestBank.name, NearestBank.LoadLastPresetAction, 50)
    elseif NearestBank.InteractType == "Object" then
        success = Interact:Object(NearestBank.name, NearestBank.LoadLastPresetAction, 50)
    end
    
    if success then
        print("[BANK] " .. NearestBank.name .. " succeeded.")
        return true
    end
    
    print("[BANK] Could not load preset from " .. NearestBank.name)
    return false
end

-- Check if PIN interface is open.
---@return boolean
function BANK:IsPINOpen()
    local pin = API.ScanForInterfaceTest2Get(true, self.Interfaces.PIN)
    if #pin > 0 then
        print("[BANK] Bank PIN interface open.")
        return true
    else
        print("[BANK] Bank PIN interface is not open.")
        return false
    end
end

-- Insets the bank pin.
---@param digit1 number
---@param digit2 number
---@param digit3 number
---@param digit4 number
---@return boolean
function BANK:EnterPIN(digit1, digit2, digit3, digit4)
    local digits = {digit1, digit2, digit3, digit4}

    if not BANK:IsPINOpen() then
        print("[BANK] PIN interface is not open.")
        return false
    end

    for i, digit in ipairs(digits) do
        if type(digit) ~= "number" then
            print("[BANK] Error: Digit " .. i .. " must be a number, got " .. type(digit))
            return false
        end
        if digit < 0 or digit > 9 or digit ~= math.floor(digit) then
            print("[BANK] Error: Digit " .. i .. " must be an integer between 0-9, got " .. tostring(digit))
            return false
        end
    end  
    
    print("[BANK] Entering PIN: " .. digit1 .. digit2 .. digit3 .. digit4)
    for i, digit in ipairs(digits) do
        if i <= 3 then
            local interface_id = digit * 5 + 10
            API.DoAction_Interface(0xffffffff,0xffffffff,1,759,interface_id,-1,API.OFF_ACT_GeneralInterface_route)
        else
            local interface_id = digit + 5
            API.DoAction_Interface(0xffffffff,0xffffffff,0,13,interface_id,-1,API.OFF_ACT_GeneralInterface_Choose_option)
        end
        print("[BANK] Entered digit " .. i .. ": " .. digit)
        API.RandomSleep2(1000, 1000, 1000)
    end

    API.RandomSleep2(500, 750, 1000)
    
    return true
end

-- Get the total number of spaces in the bank.
---@return number
function BANK:GetTotalSpaces()
    local TotalSpace = API.ScanForInterfaceTest2Get(false, self.Interfaces.BankSpaces[2])
    local CleanText = string.gsub(TotalSpace[1].textids, ",", "")
    local SpaceCount = tonumber(CleanText)
    
    if not SpaceCount then
        print("[BANK] Error: Could not convert space text to number: " .. tostring(CleanText))
        return 0
    end
    
    print("[BANK] Total spaces: " .. tostring(SpaceCount))
    return SpaceCount
end

-- Get the total number of items in the bank.
---@return number
function BANK:GetUsedSpaces()
    local TotalItems = API.ScanForInterfaceTest2Get(false, self.Interfaces.BankSpaces[1])    
    local CleanText = string.gsub(TotalItems[1].textids, ",", "")
    local ItemCount = tonumber(CleanText)
    
    if not ItemCount then
        print("[BANK] Error: Could not convert items text to number: " .. tostring(CleanText))
        return 0
    end
    
    print("[BANK] Total items: " .. tostring(ItemCount))
    return ItemCount
end

-- Get the total number of free spaces in the bank.
---@return number
function BANK:GetFreeSpaces()
    local TotalSpaces = BANK:GetTotalSpaces()
    local TotalItems = BANK:GetUsedSpaces()    
    local FreeSpaces = TotalSpaces - TotalItems
    
    print("[BANK] Free spaces calculation: " .. TotalSpaces .. " - " .. TotalItems .. " = " .. FreeSpaces)
    return FreeSpaces
end

-- Checks if item is equipped.
---@param ItemID number
---@return boolean
function BANK:IsEquipped(ItemID)
    if type(ItemID) ~= "number" then
        print("[BANK] Error: Expected a number, got "..tostring(ItemID).." ("..type(ItemID)..")")
        return false
    end
    local Items = API.Container_Get_all(94)
    local FoundItem = false

    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or there are none.")
        return false
    end

    for _, item in ipairs(Items) do
        if item.item_id and item.item_id == ItemID and item.item_stack > 0 then
            FoundItem = true
        end
    end

    if FoundItem then
        print("[BANK] Item ID: "..ItemID.." found in equipment.")
    else
        print("[BANK] Item ID: "..ItemID.." not found in equipment.")
    end

    return FoundItem
end

-- Checks if bank has item(s).
---@param ItemID number|table
---@return boolean
function BANK:Contains(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(95)
    local foundItems = {}
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read bank items or there are none.")
        return false
    end

    for _, id in ipairs(itemIds) do
        foundItems[id] = false
    end
    
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and foundItems[item.item_id] ~= nil then
            foundItems[item.item_id] = true
        end
    end

    local allFound = true
    local someFound = false
    local resultMessage = "[BANK] Item search results:"
    
    for _, id in ipairs(itemIds) do
        if foundItems[id] then
            resultMessage = resultMessage.."\n- ID: "..id.." FOUND."
            someFound = true
        else
            resultMessage = resultMessage.."\n- ID: "..id.." NOT FOUND."
            allFound = false
        end
    end
    
    print(resultMessage)

    return allFound
end

-- Checks if bank has any of the requested item(s).
---@param ItemID number|table
---@return boolean
function BANK:ContainsAny(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(95)
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read bank items or there are none.")
        return false
    end

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            for _, id in ipairs(itemIds) do
                if item.item_id == id then
                    print("[BANK] Item ID: "..id.." found in BANK.")
                    return true
                end
            end
        end
    end
    
    print("[BANK] None of the requested items found in BANK.")
    return false
end

-- Get the amount of the requested item in the bank.
---@param ItemID number
---@return number|boolean
function BANK:GetItemAmount(ItemID)
    if type(ItemID) ~= "number" then
        print("[BANK] Error: Expected a number for ItemID, got " .. type(ItemID))
        return false
    end
    
    local Items = API.Container_Get_all(95)
    local amount = 0

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and item.item_id == ItemID then
            amount = amount + item.item_stack
            print("[BANK] Found stack of " .. item.item_stack .. " (total: " .. amount .. ")")
        end
    end
    
    if amount > 0 then
        print("[BANK] Total amount of item ID " .. ItemID .. ": " .. amount)
    else
        print("[BANK] Item ID " .. ItemID .. " not found in bank.")
    end
    
    return amount
end

-- Checks if inventory has item(s).
---@param ItemID number|table
---@return boolean
function BANK:InventoryContains(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    local foundItems = {}
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or there are none.")
        return false
    end

    for _, id in ipairs(itemIds) do
        foundItems[id] = false
    end

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and foundItems[item.item_id] ~= nil then
            foundItems[item.item_id] = true
        end
    end

    local allFound = true
    local resultMessage = "[BANK] Item search results:"
    
    for _, id in ipairs(itemIds) do
        if foundItems[id] then
            resultMessage = resultMessage.."\n- ID: "..id.." FOUND."
        else
            resultMessage = resultMessage.."\n- ID: "..id.." NOT FOUND."
            allFound = false
        end
    end
    
    print(resultMessage)
    
    return allFound
end

-- Get the amount of the requested item in the inventory.
---@param ItemID number
---@return number|boolean
function BANK:InventoryGetItemAmount(ItemID)
    if type(ItemID) ~= "number" then
        print("[BANK] Error: Expected a number for ItemID, got " .. type(ItemID))
        return false
    end
    
    local Items = API.Container_Get_all(93)
    local amount = 0

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and item.item_id == ItemID then
            amount = amount + item.item_stack
            print("[BANK] Found stack of " .. item.item_stack .. " (total: " .. amount .. ")")
        end
    end
    
    if amount > 0 then
        print("[BANK] Total amount of item ID " .. ItemID .. ": " .. amount)
    else
        print("[BANK] Item ID " .. ItemID .. " not found in inventory.")
    end
    
    return amount
end

-- Checks if inventory has any of the requested item(s).
---@param ItemID number|table
---@return boolean
function BANK:InventoryContainsAny(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or there are none.")
        return false
    end

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            for _, id in ipairs(itemIds) do
                if item.item_id == id then
                    print("[BANK] Item ID: "..id.." found in inventory.")
                    return true
                end
            end
        end
    end

    print("[BANK] None of the requested items found in inventory.")
    return false
end

-- Checks if equipment has item(s).
---@param ItemID number|table
---@return boolean
function BANK:EquipmentContains(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(94)
    local foundItems = {}
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read equipment items or there are none.")
        return false
    end

    for _, id in ipairs(itemIds) do
        foundItems[id] = false
    end
    
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and foundItems[item.item_id] ~= nil then
            foundItems[item.item_id] = true
        end
    end
    
    local allFound = true
    local resultMessage = "[BANK] Item search results:"
    
    for _, id in ipairs(itemIds) do
        if foundItems[id] then
            resultMessage = resultMessage.."\n- ID: "..id.." FOUND."
        else
            resultMessage = resultMessage.."\n- ID: "..id.." NOT FOUND."
            allFound = false
        end
    end
    
    print(resultMessage)
    
    return allFound
end

-- Checks if equipment has any of the requested item(s).
---@param ItemID number|table
---@return boolean
function BANK:EquipmentContainsAny(ItemID)
    local itemIds = {}
    
    -- Handle single number input
    if type(ItemID) == "number" then
        table.insert(itemIds, ItemID)
    -- Handle table input
    elseif type(ItemID) == "table" then
        for _, id in pairs(ItemID) do
            if type(id) == "number" then
                table.insert(itemIds, id)
            else
                print("[BANK] Error: Expected a table of numbers, got a table containing "..tostring(id).." ("..type(id)..").")
                return false
            end
        end
    else
        print("[BANK] Error: Expected a number or table of numbers, got "..tostring(ItemID).." ("..type(ItemID)..").")
        return false
    end
    
    local Items = API.Container_Get_all(94)
    
    if not Items or #Items == 0 then
        print("[BANK] Could not read equipment items or there are none.")
        return false
    end
    
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            for _, id in ipairs(itemIds) do
                if item.item_id == id then
                    print("[BANK] Item ID: "..id.." found in equipment.")
                    return true
                end
            end
        end
    end

    print("[BANK] None of the requested items found in equipment.")
    return false
end

-- Get the amount of the requested item in equipment.
---@param ItemID number
---@return number|boolean
function BANK:EquipmentGetItemAmount(ItemID)
    if type(ItemID) ~= "number" then
        print("[BANK] Error: Expected a number for ItemID, got " .. type(ItemID))
        return false
    end
    
    local Items = API.Container_Get_all(94)
    local amount = 0

    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 and item.item_id == ItemID then
            amount = amount + item.item_stack
            print("[BANK] Found stack of " .. item.item_stack .. " (total: " .. amount .. ")")
        end
    end
    
    if amount > 0 then
        print("[BANK] Total amount of item ID " .. ItemID .. ": " .. amount)
    else
        print("[BANK] Item ID " .. ItemID .. " not found in equipment.")
    end
    
    return amount
end

-- Get the player tab opened in the bank(Inventory, Equipment or Beast of burden).
---@return number|boolean
function BANK:GetOpenedTab()
    local VB = API.VB_FindPSettinOrder(6680).state & 0x3
    if VB == 0 then
        print("[BANK] Inventory tab is opened.")
        return 1
    elseif VB == 1 then
        print("[BANK] Beast of burden tab is opened.")
        return 2
    elseif VB == 2 then
        print("[BANK] Equipment tab is opened.")
        return 3
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:GetOpenedTab()")
        local var = API.VB_FindPSettinOrder(6680)
        print("--------------------------")
        print("state: " .. var.state)
        print("addr: " .. var.addr)
        print("indexaddr_orig: " .. var.indexaddr_orig)
        print("id: " .. var.id)
        print("--------------------------")
        return false
    end
end

--Open the specified player tab inside the bank(1 = Inventory, 2 = Beast of burden and 3 = Equipment).
---@param tabID number
---@return boolean
function BANK:OpenTab(tabID)
    print("[BANK] Opening tab: "..tostring(tabID)..".")
    if type(tabID) ~= "number" then
        print("[BANK] Error: Expected a number, got "..tostring(tabID).." ("..type(tabID)..")")
        return false
    end
    
    if tabID < 1 or tabID > 3 then
        print("[BANK] Error: Can only accept numbers 1 to 3, you passed: "..tostring(tabID))
        return false
    end

    if tabID == 1 then
        if BANK:GetOpenedTab() == 1 then
            print("[BANK] Inventory tab already open. No action needed.")
            return true
        else
            print("[BANK] Opening inventory tab.")
            API.DoAction_Interface(0x24,0xffffffff,1,517,56,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    elseif tabID == 2 then
        if BANK:GetOpenedTab() == 2 then
            print("[BANK] Beast of burden tab already open. No action needed.")
            return true
        else
            print("[BANK] Opening Beast of burden tab.")
            API.DoAction_Interface(0x24,0xffffffff,1,517,64,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    elseif tabID == 3 then
        if BANK:GetOpenedTab() == 3 then
            print("[BANK] Equipment tab open. No action needed.")
            return true
        else
            print("[BANK] Opening Equipment tab.")
            API.DoAction_Interface(0x24,0xffffffff,1,517,60,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:OpenTab()")
        print("--------------------------")
        print("Value passed: "..tostring(tabID))
        print("Return GetOpenedTab(): "..tostring(BANK:GetOpenedTab()))
        print("--------------------------")
        return false
    end
end

-- Get transfer or preset tab. 0 = transfer and 1 = preset.
---@return number|boolean
function BANK:GetTransferTab()
    local VB = API.VB_FindPSettinOrder(6680).state >> 12
    if VB == 0 then
        print("[BANK] Bank is showing transfer.")
        return 0
    elseif VB == 1 then
        print("[BANK] Bank is showing preset.")
        return 1
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:GetTransferTab()")
        print("--------------------------")
        print("VB Value: "..tostring(VB))
        print("--------------------------")
        return false
    end
end

-- Set transfer or preset tab. 0 = transfer and 1 = preset.
---@param number number
---@return boolean
function BANK:SetTransferTab(number)
    if tonumber(number) == 0 then
        if BANK:GetTransferTab() ~= 0 then
            print("[BANK] Opening transfer tab.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,151,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            return true
        end
    elseif tonumber(number) == 1 then
        if BANK:GetTransferTab() ~= 1 then
            print("[BANK] Opening preset tab.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,152,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            return true
        end
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:SetTransferTab()")
        print("--------------------------")
        print("VB Value: "..tostring(number))
        print("--------------------------")
        return false
    end
end

-- Retrieves the currently selected quantity option from the interface.
---@return number|string|boolean
function BANK:GetQuantitySelected()
    local VB = API.VB_FindPSettinOrder(8958).state & 0x7

    if VB == 2 then
        print("[BANK] Current quantity selected: 1")
        return 1
    elseif VB == 3 then
        print("[BANK] Current quantity selected: 5")
        return 5
    elseif VB == 4 then
        print("[BANK] Current quantity selected: 10")
        return 10
    elseif VB == 5 then
        local XValue = API.VB_FindPSettinOrder(111).state
        print("[BANK] Current quantity selected: X (Custom Value: " .. tostring(XValue) .. ")")
        return "X"
    elseif VB == 7 then
        print("[BANK] Current quantity selected: All")
        return "All"
    elseif VB == 0 then
        print("[BANK] Could not read selected quantity.")
        return false
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:GetQuantitySelected()")
        local var = API.VB_FindPSettinOrder(8958)
        print("--------------------------")
        print("state: " .. var.state)
        print("addr: " .. var.addr)
        print("indexaddr_orig: " .. var.indexaddr_orig)
        print("id: " .. var.id)
        print("--------------------------")
        return false
    end
    
    return false
end

-- Set the quantity to transfer. Valid inputs are: 1, 5, 10, "All", or "X".
---@param Qtitty number|string
---@return boolean
function BANK:SetQuantity(Qtitty)
    if type(Qtitty) ~= "number" and type(Qtitty) ~= "string" then
        print("[BANK] Error: Invalid input type. Expected number or string, got: "..type(Qtitty))
        return false
    end

    if type(Qtitty) == "number" then
        if Qtitty ~= 1 and Qtitty ~= 5 and Qtitty ~= 10 then
            print("[BANK] Error: Number quantity must be 1, 5, or 10. Got: "..tostring(Qtitty))
            return false
        end
    end
    
    if type(Qtitty) == "string" then
        local lowerQtitty = Qtitty:lower()
        if lowerQtitty ~= "all" and lowerQtitty ~= "x" then
            print("[BANK] Error: String quantity must be 'All' or 'X'. Got: "..Qtitty)
            return false
        end
    end

    BANK:SetTransferTab(0)

    if Qtitty == 1 then
        if BANK:GetQuantitySelected() ~= 1 then
            print("[BANK] Transfer quantity set to 1.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,93,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Transfer quantity already set to 1. No action needed.")
            return true
        end
    elseif Qtitty == 5 then
        if BANK:GetQuantitySelected() ~= 5 then
            print("[BANK] Transfer quantity set to 5.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,96,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Transfer quantity already set to 5. No action needed.")
            return true
        end
    elseif Qtitty == 10 then        
        if BANK:GetQuantitySelected() ~= 10 then
            print("[BANK] Transfer quantity set to 10.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,99,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Transfer quantity already set to 10. No action needed.")
            return true
        end
    elseif Qtitty == "All" then
        if BANK:GetQuantitySelected() ~= "All" then
            print("[BANK] Transfer quantity set to All.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,103,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Transfer quantity already set to All. No action needed.")
            return true
        end
    elseif Qtitty == "X" then
        if BANK:GetQuantitySelected() ~= "X" then
            print("[BANK] Transfer quantity set to X.")
            API.DoAction_Interface(0x2e,0xffffffff,1,517,106,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Transfer quantity already set to X. No action needed.")
            return true
        end
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:SetQuantity()")
        print("--------------------------")
        print("Value passed: "..tostring(Qtitty))
        print("Type passed: "..type(Qtitty))
        print("Return GetQuantitySelected(): "..tostring(BANK:GetQuantitySelected()))
        print("Return GetXQuantity(): "..tostring(BANK:GetXQuantity()))
        print("--------------------------")
        return false
    end    
end

-- Retrieves the currently X quantity value from the VB.
---@return number
function BANK:GetXQuantity()
    local XValue = API.VB_FindPSettinOrder(111).state
    print("[BANK] X value: "..tostring(XValue))
    return XValue
end

-- Set the X quantity to transfer. 
---@param Qtitty number
---@return boolean
function BANK:SetXQuantity(Qtitty)
    print("[BANK] Setting X quantitty to: "..tostring(Qtitty))
    if type(Qtitty) ~= "number" then
        print("[BANK] Error: Expect number, received: "..tostring(type(Qtitty)))
        return false
    end

    if Qtitty <= 0 then
        print("[BANK] Error: Quantity must be positive, received: "..tostring(Qtitty))
        return false
    end

    if BANK:GetXQuantity() == Qtitty then
        print("[BANK] X quantity already set to "..tostring(Qtitty)..".")
        return true
    end
    
    BANK:SetTransferTab(0)

    API.DoAction_Interface(0xffffffff,0xffffffff,1,517,114,-1,API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(1000, 1000, 1000)

    local digits = tostring(Qtitty)
    for i = 1, #digits do
        local char = digits:sub(i, i)
        API.KeyboardPress2(string.byte(char), 40, 60)
        API.RandomSleep2(200,200,200)
    end
    
    API.KeyboardPress2(0x0D, 50, 80)
    API.RandomSleep2(500, 600, 700)
    
    return true
end

-- Checks if bank is set to note mode.
---@return boolean
function BANK:IsNoteModeEnabled()
    local VB = API.VB_FindPSettinOrder(160).state

    if VB == 0 then
        print("[BANK] Withdraw as note is disabled.")
        return false
    elseif VB == 1 then
        print("[BANK] Withdraw as note is enabled.")
        return true
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: IsNoteModeEnabled()")
        local var = API.VB_FindPSettinOrder(160)
        print("--------------------------")
        print("state: " .. var.state)
        print("addr: " .. var.addr)
        print("indexaddr_orig: " .. var.indexaddr_orig)
        print("id: " .. var.id)
        print("--------------------------")
        return false
    end
end

-- Set withdraw mode. True = note and false = item.
---@param boolean boolean
---@return boolean
function BANK:SetNoteMode(boolean)
    if type(boolean) ~= "boolean" then
        print("[BANK] Error: Expected a boolean, got "..tostring(boolean).." ("..type(boolean)..")")
        return false
    end

    if boolean == true then
        if BANK:IsNoteModeEnabled() then
            print("[BANK] Note mode already enabled. No action needed.")
            return true
        else
            print("[BANK] Enabling note mode.")
            API.DoAction_Interface(0xffffffff,0xffffffff,1,517,127,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    elseif boolean == false then
        if not BANK:IsNoteModeEnabled() then
            print("[BANK] Note mode already disabled. No action needed.")
            return true
        else
            print("[BANK] Disabling note mode.")
            API.DoAction_Interface(0xffffffff,0xffffffff,1,517,127,-1,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:SetNoteMode()")
        print("--------------------------")
        print("Value passed: "..tostring(boolean))
        print("Return IsNoteModeEnabled(): "..tostring(BANK:IsNoteModeEnabled()))
        print("--------------------------")
        return false
    end
end

-- Get preset page. Page 1 = (1 -> 9), page 2 = (10 -> 18).
---@return number|boolean
function BANK:GetPresetPage()
    local VB = API.VB_FindPSettinOrder(9932).state >> 15
    if VB == 0 then
        print("[BANK] Bank is showing page 1, presets 1 to 9.")
        return 1
    elseif VB == 1 then
        print("[BANK] Bank is showing page 2, presets 10 to 18.")
        return 2
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:GetPresetPage()")
        print("--------------------------")
        print("VB Value: "..tostring(VB))
        print("--------------------------")
        return false
    end
end

-- Sets the bank preset page to the specified number (1 or 2).
---@param number number
---@return boolean
function BANK:SetPresetPage(number)
    if type(number) ~= "number" then
        print("[BANK] Error: Expected a number, got "..tostring(number).." ("..type(number)..")")
        return false
    end

    BANK:SetTransferTab(1)

    if number == 1 then
        if BANK:GetPresetPage() == 1 then
            print("[BANK] Preset page already 1. No action needed.")
            return true
        else
            print("[BANK] Changing preset page to 1.")
            API.DoAction_Interface(0x24,0xffffffff,1,517,119,100,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    elseif number == 2 then
        if BANK:GetPresetPage() == 2 then
            print("[BANK] Preset page already 2. No action needed.")
            return true
        else
            print("[BANK] Changing preset page to 2.")
            API.DoAction_Interface(0x24,0xffffffff,1,517,119,100,API.OFF_ACT_GeneralInterface_route)
            return true
        end
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:SetPresetPage()")
        print("--------------------------")
        print("Value passed: "..tostring(number))
        print("Return GetPresetPage(): "..tostring(BANK:GetPresetPage()))
        print("--------------------------")
        return false
    end
end

-- Saves the current bank preset to the specified preset slot (1-18).
---@param number number
---@return boolean
function BANK:SavePreset(number)
    if type(number) ~= "number" then
        print("[BANK] Error: Expected a number, got "..tostring(number).." ("..type(number)..")")
        return false
    end
    
    if number < 1 or number > 18 then
        print("[BANK] Error: Can only save to presets 1 to 18, you passed: "..tostring(number))
        return false
    end

    BANK:SetTransferTab(1)

    local slot = number
    if slot < 10 then
        BANK:SetPresetPage(1)
        API.RandomSleep2(200, 200, 200)
        print("[BANK] Saving preset number: "..tostring(number))
        API.DoAction_Interface(0xffffffff,0xffffffff,2,517,119,slot,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        slot = slot - 9
        BANK:SetPresetPage(2)
        API.Sleep_tick(1)
        API.RandomSleep2(200, 200, 200)
        print("[BANK] Saving preset number: "..tostring(number))
        API.DoAction_Interface(0xffffffff,0xffffffff,2,517,119,slot,API.OFF_ACT_GeneralInterface_route)
        return true
    end

    return false
end

-- Saves the current beast of burden's preset.
---@return boolean
function BANK:SaveSummonPreset()
    print("[BANK] Saving beast of burden preset")
    BANK:SetTransferTab(1)
    return API.DoAction_Interface(0xffffffff,0xffffffff,2,517,119,10,API.OFF_ACT_GeneralInterface_route)
end

-- Loads the specified preset (1-18).
---@param number number
---@return boolean
function BANK:LoadPreset(number)
    if type(number) ~= "number" then
        print("[BANK] Error: Expected a number, got "..tostring(number).." ("..type(number)..")")
        return false
    end
    
    if number < 1 or number > 18 then
        print("[BANK] Error: Can only load to presets 1 to 18, you passed: "..tostring(number))
        return false
    end

    local slot = number
    if slot < 10 then
        BANK:SetPresetPage(1)
        API.RandomSleep2(200, 200, 200)
        print("[BANK] Loading preset number: "..tostring(number))
        API.DoAction_Interface(0x24,0xffffffff,1,517,119,slot,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        slot = slot - 9
        BANK:SetPresetPage(2)
        API.Sleep_tick(1)
        API.RandomSleep2(200, 200, 200)
        print("[BANK] Loading preset number: "..tostring(number))
        API.DoAction_Interface(0x24,0xffffffff,1,517,119,slot,API.OFF_ACT_GeneralInterface_route)
        return true
    end

    return false
end

-- Loads the beast of burden's preset.
---@return boolean
function BANK:LoadSummonPreset()
    print("[BANK] Loading beast of burden preset")
    BANK:SetTransferTab(1)
    return API.DoAction_Interface(0x24,0xffffffff,1,517,119,10,API.OFF_ACT_GeneralInterface_route)
end

-- Empty your backpack into your bank.
---@return boolean
function BANK:DepositInventory()
    print("[BANK] Depositing inventory.")
    return API.DoAction_Interface(0xffffffff,0xffffffff,1,517,39,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty the items you are wearing into the bank.
---@return boolean
function BANK:DepositEquipment()
    print("[BANK] Depositing equipment.")
    return API.DoAction_Interface(0xffffffff,0xffffffff,1,517,42,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty your beast of burden's inventory into your bank.
---@return boolean
function BANK:DepositSummon()
    print("[BANK] Depositing beast of burden's inventory.")
    return API.DoAction_Interface(0xffffffff,0xffffffff,1,517,45,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty your money pouch into MY bank.
---@return boolean
function BANK:DepositMoneyPouch()
    print("[BANK] Depositing all your money.")
    return API.DoAction_Interface(0xffffffff,0xffffffff,1,517,48,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Withdraws item(s) from your bank. The amount is set with BANK:SetQuantity(Qtitty).
---@param ItemID number|table
---@return boolean
function BANK:Withdraw(ItemID)
    BANK:OpenTab(1)
    local Items = API.Container_Get_all(95)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local ItemIDHex = string.format("0x%X", ItemID)
        local slot = nil

        if not BANK:Contains(ItemID) then
            return false
        end

        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end

        if slot then
            print("[BANK] Withdrawing item: "..tostring(ItemID)..".")
            API.DoAction_Interface(0xffffffff,ItemIDHex,1,517,201,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Could not find slot for item: "..tostring(ItemID)..".")
            return false
        end
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Withdraw(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Withdraw. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Withdraws 1x item(s) from your bank.
---@param ItemID number|table
---@return boolean
function BANK:Withdraw1(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(95)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:Contains(ItemID) then
            print("[BANK] Item not found in bank: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 1  -- First option (1)
        elseif currentQuantity == 5 then
            option = 2  -- Second option (1)
        elseif currentQuantity == 10 then
            option = 2  -- Second option (1)
        elseif currentQuantity == "X" then
            option = 2  -- Second option (1)
        elseif currentQuantity == "All" then
            option = 2  -- Second option (1)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Withdrawing 1x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,201,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Withdraw1(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Withdraw1. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Withdraws 5x item(s) from your bank.
---@param ItemID number|table
---@return boolean
function BANK:Withdraw5(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(95)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:Contains(ItemID) then
            print("[BANK] Item not found in bank: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 3  -- Second option (5)
        elseif currentQuantity == 5 then
            option = 1  -- First option (5)
        elseif currentQuantity == 10 then
            option = 3  -- Third option (5)
        elseif currentQuantity == "X" then
            option = 3  -- Third option (5)
        elseif currentQuantity == "All" then
            option = 3  -- Third option (5)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Withdrawing 5x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,201,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Withdraw5(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Withdraw5. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Withdraws 10x item(s) from your bank.
---@param ItemID number|table
---@return boolean
function BANK:Withdraw10(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(95)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:Contains(ItemID) then
            print("[BANK] Item not found in bank: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 4  -- Third option (10)
        elseif currentQuantity == 5 then
            option = 4  -- Third option (10)
        elseif currentQuantity == 10 then
            option = 1  -- First option (10)
        elseif currentQuantity == "X" then
            option = 4  -- Fourth option (10)
        elseif currentQuantity == "All" then
            option = 4  -- Fourth option (10)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Withdrawing 10x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,201,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Withdraw10(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Withdraw10. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Withdraws X amount of item(s) from your bank.
---@param ItemID number|table
---@return boolean
function BANK:WithdrawX(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(95)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:Contains(ItemID) then
            print("[BANK] Item not found in bank: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == 5 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == 10 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == "X" then
            option = 1  -- First option (X)
        elseif currentQuantity == "All" then
            option = 5  -- Fifth option (X)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Withdrawing X amount of item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,201,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:WithdrawX(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for WithdrawX. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Withdraws All of item(s) from your bank.
---@param ItemID number|table
---@return boolean
function BANK:WithdrawAll(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(95)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:Contains(ItemID) then
            print("[BANK] Item not found in bank: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        local route = nil
        
        if currentQuantity == 1 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == 5 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == 10 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == "X" then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == "All" then
            option = 1  -- First option (All)
            route = API.OFF_ACT_GeneralInterface_route
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Withdrawing all of item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,201,slot,route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:WithdrawAll(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for WithdrawAll. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits item(s) into your bank. The amount is set with BANK:SetQuantity(Qtitty).
---@param ItemID number|table
---@return boolean
function BANK:Deposit(ItemID)
    BANK:OpenTab(1)
    local Items = API.Container_Get_all(93)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local ItemIDHex = string.format("0x%X", ItemID)
        local slot = nil

        if not BANK:InventoryContains(ItemID) then
            return false
        end

        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end

        if slot then
            print("[BANK] Depositing item: "..tostring(ItemID)..".")
            API.DoAction_Interface(0xffffffff,ItemIDHex,1,517,15,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Could not find slot for item: "..tostring(ItemID)..".")
            return false
        end
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Deposit(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositItem. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits 1x item(s) into your bank.
---@param ItemID number|table
---@return boolean
function BANK:Deposit1(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(93)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:InventoryContains(ItemID) then
            print("[BANK] Item not found in inventory: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 1  -- First option (1)
        elseif currentQuantity == 5 then
            option = 2  -- Second option (1)
        elseif currentQuantity == 10 then
            option = 2  -- Second option (1)
        elseif currentQuantity == "X" then
            option = 2  -- Second option (1)
        elseif currentQuantity == "All" then
            option = 2  -- Second option (1)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Depositing 1x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,15,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Deposit1(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Deposit1. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits 5x item(s) into your bank.
---@param ItemID number|table
---@return boolean
function BANK:Deposit5(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(93)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:InventoryContains(ItemID) then
            print("[BANK] Item not found in inventory: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 3  -- Second option (5)
        elseif currentQuantity == 5 then
            option = 1  -- First option (5)
        elseif currentQuantity == 10 then
            option = 3  -- Third option (5)
        elseif currentQuantity == "X" then
            option = 3  -- Third option (5)
        elseif currentQuantity == "All" then
            option = 3  -- Third option (5)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Depositing 5x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,15,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Deposit5(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Deposit5. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits 10x item(s) into your bank.
---@param ItemID number|table
---@return boolean
function BANK:Deposit10(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(93)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:InventoryContains(ItemID) then
            print("[BANK] Item not found in inventory: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 4  -- Third option (10)
        elseif currentQuantity == 5 then
            option = 4  -- Third option (10)
        elseif currentQuantity == 10 then
            option = 1  -- First option (10)
        elseif currentQuantity == "X" then
            option = 4  -- Fourth option (10)
        elseif currentQuantity == "All" then
            option = 4  -- Fourth option (10)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Depositing 10x item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,15,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Deposit10(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for Deposit10. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits X amount of item(s) into your bank.
---@param ItemID number|table
---@return boolean
function BANK:DepositX(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(93)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:InventoryContains(ItemID) then
            print("[BANK] Item not found in inventory: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        
        if currentQuantity == 1 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == 5 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == 10 then
            option = 5  -- Fourth option (X)
        elseif currentQuantity == "X" then
            option = 1  -- First option (X)
        elseif currentQuantity == "All" then
            option = 5  -- Fifth option (X)
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Depositing X amount of item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,15,slot,API.OFF_ACT_GeneralInterface_route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositX(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositX. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits All of item(s) into your bank.
---@param ItemID number|table
---@return boolean
function BANK:DepositAll(ItemID)
    BANK:OpenTab(1)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local Items = API.Container_Get_all(93)
        local ItemIDHex = string.format("0x%X", ItemID)
        
        if not BANK:InventoryContains(ItemID) then
            print("[BANK] Item not found in inventory: "..tostring(ItemID))
            return false
        end
        
        local slot = nil
        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end
        
        if not slot then
            print("[BANK] Could not find slot for item: "..tostring(ItemID))
            return false
        end
        
        local currentQuantity = BANK:GetQuantitySelected()
        local option = nil
        local route = nil
        
        if currentQuantity == 1 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == 5 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == 10 then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == "X" then
            option = 7  -- Sixth option (All)
            route = API.OFF_ACT_GeneralInterface_route2
        elseif currentQuantity == "All" then
            option = 1  -- First option (All)
            route = API.OFF_ACT_GeneralInterface_route
        else
            print("[BANK] Unknown quantity setting: "..tostring(currentQuantity))
            return false
        end
        
        print("[BANK] Depositing all of item: "..tostring(ItemID))
        API.DoAction_Interface(0xffffffff,ItemIDHex,option,517,15,slot,route)
        return true
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositAll(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositAll. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposits logs from wood boxes in inventory.
---@return boolean
function BANK:WoodBoxDepositLogs()
    if not BANK:IsOpen() then
        print("[BANK] Bank interface is not open.")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or inventory is empty.")
        return false
    end
    
    local woodBoxesFound = {}
    local success = true
    
    -- Find all wood boxes in inventory
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            for _, woodBoxId in ipairs(self.Items.WoodBoxes) do
                if item.item_id == woodBoxId then
                    table.insert(woodBoxesFound, {
                        id = item.item_id,
                        slot = item.item_slot,
                        stack = item.item_stack
                    })
                    print("[BANK] Found wood box ID: " .. item.item_id .. " in slot " .. item.item_slot)
                    break
                end
            end
        end
    end
    
    if #woodBoxesFound == 0 then
        print("[BANK] No wood boxes found in inventory.")
        return false
    end
    
    print("[BANK] Found " .. #woodBoxesFound .. " wood box(es). Depositing logs...")
    
    -- Deposit logs from each wood box found
    for _, woodBox in ipairs(woodBoxesFound) do
        local ItemIDHex = string.format("0x%X", woodBox.id)
        
        -- Use the "Deposit logs" option (option 8) on the wood box
        print("[BANK] Depositing logs from wood box ID: " .. woodBox.id)
        local result = API.DoAction_Interface(0xffffffff, ItemIDHex, 8, 517, 15, woodBox.slot, API.OFF_ACT_GeneralInterface_route2)
        
        if not result then
            print("[BANK] Failed to deposit logs from wood box ID: " .. woodBox.id)
            success = false
        end
    end
    
    if success then
        print("[BANK] Successfully deposited logs from all wood boxes.")
    else
        print("[BANK] Some wood box log deposits may have failed.")
    end
    
    return success
end

-- Deposits wood spirits from wood boxes in inventory.
---@return boolean
function BANK:WoodBoxDepositWoodSpirits()
    if not BANK:IsOpen() then
        print("[BANK] Bank interface is not open.")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or inventory is empty.")
        return false
    end
    
    local woodBoxesFound = {}
    local success = true
    
    -- Find all wood boxes in inventory
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            -- Check if this item ID is in our wood boxes table
            for _, woodBoxId in ipairs(self.Items.WoodBoxes) do
                if item.item_id == woodBoxId then
                    table.insert(woodBoxesFound, {
                        id = item.item_id,
                        slot = item.item_slot,
                        stack = item.item_stack
                    })
                    print("[BANK] Found wood box ID: " .. item.item_id .. " in slot " .. item.item_slot)
                    break
                end
            end
        end
    end
    
    if #woodBoxesFound == 0 then
        print("[BANK] No wood boxes found in inventory.")
        return false
    end
    
    print("[BANK] Found " .. #woodBoxesFound .. " wood box(es). Depositing wood spirits...")
    
    -- Deposit wood spirits from each wood box found
    for _, woodBox in ipairs(woodBoxesFound) do
        local ItemIDHex = string.format("0x%X", woodBox.id)
        
        -- Use the "Deposit wood spirits" option (option 9) on the wood box
        print("[BANK] Depositing wood spirits from wood box ID: " .. woodBox.id)
        local result = API.DoAction_Interface(0xffffffff, ItemIDHex, 9, 517, 15, woodBox.slot, API.OFF_ACT_GeneralInterface_route2)
        
        if not result then
            print("[BANK] Failed to deposit wood spirits from wood box ID: " .. woodBox.id)
            success = false
        end
    end
    
    if success then
        print("[BANK] Successfully deposited wood spirits from all wood boxes.")
    else
        print("[BANK] Some wood box wood spirit deposits may have failed.")
    end
    
    return success
end

-- Deposits ore from ore boxes in inventory.
---@return boolean
function BANK:OreBoxDepositOres()
    if not BANK:IsOpen() then
        print("[BANK] Bank interface is not open.")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or inventory is empty.")
        return false
    end
    
    local oreBoxesFound = {}
    local success = true
    
    -- Find all ore boxes in inventory
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            -- Check if this item ID is in our ore boxes table
            for _, oreBoxId in ipairs(self.Items.OreBoxes) do
                if item.item_id == oreBoxId then
                    table.insert(oreBoxesFound, {
                        id = item.item_id,
                        slot = item.item_slot,
                        stack = item.item_stack
                    })
                    print("[BANK] Found ore box ID: " .. item.item_id .. " in slot " .. item.item_slot)
                    break
                end
            end
        end
    end
    
    if #oreBoxesFound == 0 then
        print("[BANK] No ore boxes found in inventory.")
        return false
    end
    
    print("[BANK] Found " .. #oreBoxesFound .. " ore box(es). Depositing ore...")
    
    -- Deposit ore from each ore box found
    for _, oreBox in ipairs(oreBoxesFound) do
        local ItemIDHex = string.format("0x%X", oreBox.id)
        
        -- Use the "Deposit ore" option (option 8) on the ore box
        print("[BANK] Depositing ore from ore box ID: " .. oreBox.id)
        local result = API.DoAction_Interface(0xffffffff, ItemIDHex, 8, 517, 15, oreBox.slot, API.OFF_ACT_GeneralInterface_route2)
        
        if not result then
            print("[BANK] Failed to deposit ore from ore box ID: " .. oreBox.id)
            success = false
        end
    end
    
    if success then
        print("[BANK] Successfully deposited ore from all ore boxes.")
    else
        print("[BANK] Some ore box ore deposits may have failed.")
    end
    
    return success
end

-- Deposits stone spirits from ore boxes in inventory.
---@return boolean
function BANK:OreBoxDepositStoneSpirits()
    if not BANK:IsOpen() then
        print("[BANK] Bank interface is not open.")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or inventory is empty.")
        return false
    end
    
    local oreBoxesFound = {}
    local success = true
    
    -- Find all ore boxes in inventory
    for _, item in ipairs(Items) do
        if item.item_id and item.item_stack > 0 then
            -- Check if this item ID is in our ore boxes table
            for _, oreBoxId in ipairs(self.Items.OreBoxes) do
                if item.item_id == oreBoxId then
                    table.insert(oreBoxesFound, {
                        id = item.item_id,
                        slot = item.item_slot,
                        stack = item.item_stack
                    })
                    print("[BANK] Found ore box ID: " .. item.item_id .. " in slot " .. item.item_slot)
                    break
                end
            end
        end
    end
    
    if #oreBoxesFound == 0 then
        print("[BANK] No ore boxes found in inventory.")
        return false
    end
    
    print("[BANK] Found " .. #oreBoxesFound .. " ore box(es). Depositing stone spirits...")
    
    -- Deposit stone spirits from each ore box found
    for _, oreBox in ipairs(oreBoxesFound) do
        local ItemIDHex = string.format("0x%X", oreBox.id)
        
        -- Use the "Deposit stone spirits" option (option 9) on the ore box
        print("[BANK] Depositing stone spirits from ore box ID: " .. oreBox.id)
        local result = API.DoAction_Interface(0xffffffff, ItemIDHex, 9, 517, 15, oreBox.slot, API.OFF_ACT_GeneralInterface_route2)
        
        if not result then
            print("[BANK] Failed to deposit stone spirits from ore box ID: " .. oreBox.id)
            success = false
        end
    end
    
    if success then
        print("[BANK] Successfully deposited stone spirits from all ore boxes.")
    else
        print("[BANK] Some ore box stone spirit deposits may have failed.")
    end
    
    return success
end

-- Deposits soil from soil box in inventory.
---@return boolean
function BANK:SoilBoxDepositSoil()
    if not BANK:IsOpen() then
        print("[BANK] Bank interface is not open.")
        return false
    end
    
    local Items = API.Container_Get_all(93)
    if not Items or #Items == 0 then
        print("[BANK] Could not read inventory items or inventory is empty.")
        return false
    end

    local soilBoxId = 49538 -- Soil box item ID

    -- Find the soil box in inventory
    for _, item in ipairs(Items) do
        if item.item_id and item.item_id == soilBoxId and item.item_stack > 0 then
            API.DoAction_Interface(0xffffffff, 0xc182, 9, 517, 15, item.item_slot, API.OFF_ACT_GeneralInterface_route2)
            
            print("[BANK] Deposited soil from soil box")
            return true
        end
    end

    print("[BANK] No soil box found in inventory.")
    return false 
end

-- Equips an item from your bank.
---@param ItemID number
---@return boolean
function BANK:Equip(ItemID)
    local Items = API.Container_Get_all(95)
    BANK:OpenTab(3)

    local ItemIDHex = string.format("0x%X", ItemID)
    local slot = nil

    if not BANK:Contains(ItemID) then
        return false
    end

    for i, item in ipairs(Items) do
        if item.item_id and item.item_id == ItemID then
            slot = item.item_slot
            break
        end
    end

    if slot then
        print("[BANK] Equipping item: "..tostring(ItemID)..".")
        API.DoAction_Interface(0xffffffff,ItemIDHex,1,517,201,slot, API.OFF_ACT_GeneralInterface_route)
        return true
    else
        print("[BANK] Could not find slot for item: "..tostring(ItemID)..".")
        return false
    end
end

-- Withdraws item(s) from your bank to your beast of burden. The amount is set with BANK:SetQuantity(Qtitty).
---@param ItemID number|table
---@return boolean
function BANK:WithdrawToBoB(ItemID)
    BANK:OpenTab(2)
    local Items = API.Container_Get_all(95)
    local success = true
    
    -- Handle single item case
    if type(ItemID) == "number" then
        local ItemIDHex = string.format("0x%X", ItemID)
        local slot = nil

        if not BANK:Contains(ItemID) then
            return false
        end

        for i, item in ipairs(Items) do
            if item.item_id and item.item_id == ItemID then
                slot = item.item_slot
                break
            end
        end

        if slot then
            print("[BANK] Withdrawing item: "..tostring(ItemID).." to beast of burden.")
            API.DoAction_Interface(0xffffffff,ItemIDHex,1,517,201,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Could not find slot for item: "..tostring(ItemID)..".")
            return false
        end
        
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:Withdraw(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for WithdrawToBoB. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- #################################
-- #                               #
-- #     DEPOSIT BOX FUNCTIONS     #
-- #                               #
-- #################################

-- Check if Deposit box interface is open.
---@return boolean
function BANK:DepositBoxIsOpen()
    if API.VB_FindPSettinOrder(2874, 0).state == 69 then
        print("[BANK] Deposit box interface open.")
        return true
    else
        print("[BANK] Deposit box interface is not open.")
        return false
    end
end

-- Attempts to open a deposit box. Requires cache enabled https://imgur.com/5I9a46V.
---@return boolean
function BANK:DepositBoxOpen()
    print("[BANK] Opening Deposit box.")
    if Interact:Object("Deposit box", "Deposit", 50) then
        return true
    end

    print("[BANK] Could not interact with any Deposit box.")
    return false
end

-- Attempts to close the deposit box interface.
---@return boolean
function BANK:DepositBoxClose()
    if BANK:DepositBoxIsOpen() then
        print("[BANK] Closing deposit box.")
        return API.DoAction_Interface(0x24,0xffffffff,1,11,23,-1,API.OFF_ACT_GeneralInterface_route)
    else
        print("[BANK] Deposit box not open.")
        return false
    end    
end

-- Check if a specific item is in the deposit box.
---@param ItemID number
---@return boolean
function BANK:DepositBoxContains(ItemID)
    local FoundItem = false
    for i = 1, 28 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.DepositBoxSlots[i])[1]
        if slot.itemid1 and slot.itemid1 == ItemID then
            FoundItem = true
        end
    end

    if FoundItem then
        print("[BANK] Item ID: "..ItemID.." found.")
    else
        print("[BANK] Item ID: "..ItemID.." not found.")
    end

    return FoundItem
end

-- Get the slot of a specific item in the deposit box (0-27).
---@param ItemID number
---@return number|boolean
function BANK:DepositBoxGetSlot(ItemID)
    for i = 1, 28 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.DepositBoxSlots[i])[1]
        if slot.itemid1 and slot.itemid1 == ItemID then
            print("[BANK] Item ID: "..ItemID.." found in slot: "..(i)..".")
            return i - 1
        end
    end

    print("[BANK] Item ID: "..ItemID.." not found.")
    return false
end

-- Empty your backpack into a deposit box.
---@return boolean
function BANK:DepositBoxDepositInventory()
    print("[BANK] Depositing inventory in deposit box.")
    return API.DoAction_Interface(0x24,0xffffffff,1,11,5,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty the items you are wearing into a deposit box.
---@return boolean
function BANK:DepositBoxDepositEquipment()
    print("[BANK] Depositing equipment in deposit box.")
    return API.DoAction_Interface(0x24,0xffffffff,1,11,11,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty your beast of burden's inventory into a deposit box.
---@return boolean
function BANK:DepositSummonDepositBox()
    print("[BANK] Depositing beast of burden's inventory into a deposit box.")
    return API.DoAction_Interface(0x24,0xffffffff,1,11,11,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Empty your money pouch into a deposit box.
---@return boolean
function BANK:DepositBoxDepositMoneyPouch()
    print("[BANK] Depositing all your money into a deposit box.")
    return API.DoAction_Interface(0x24,0xffffffff,1,11,14,-1,API.OFF_ACT_GeneralInterface_route)
end

-- Attempts to deposit-all in a deposit box. Requires cache enabled https://imgur.com/5I9a46V.
---@return boolean
function BANK:DepositBoxDepositAll()
    print("[BANK] Depositing-All in a deposit box.")
    if Interact:Object("Deposit box", "Deposit-All", 50) then
        return true
    end

    print("[BANK] Could not interact with any Deposit box.")
    return false
end

-- Deposit 1 of a specific item(s) into a deposit box.
---@param ItemID number|table
---@return boolean
function BANK:DepositBoxDeposit1(ItemID)
    -- Handle single item case
    if type(ItemID) == "number" then     
        local ItemIDHex = string.format("0x%X", ItemID)  
        local slot = BANK:DepositBoxGetSlot(ItemID)     

        if slot then
            print("[BANK] Depositing 1 of item: "..ItemID.." into deposit box.")
            API.DoAction_Interface(0xffffffff,ItemIDHex,1,11,19,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Item ID: "..ItemID.." not found in deposit box interface.")
            return false
        end
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        local success = true
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositBoxDeposit1(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositBoxDeposit1. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposit 5 of a specific item(s) into a deposit box.
---@param ItemID number|table
---@return boolean
function BANK:DepositBoxDeposit5(ItemID)
    -- Handle single item case
    if type(ItemID) == "number" then     
        local ItemIDHex = string.format("0x%X", ItemID)  
        local slot = BANK:DepositBoxGetSlot(ItemID)     

        if slot then
            print("[BANK] Depositing 5 of item: "..ItemID.." into deposit box.")
            API.DoAction_Interface(0xffffffff,ItemIDHex,2,11,19,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Item ID: "..ItemID.." not found in deposit box interface.")
            return false
        end
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        local success = true
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositBoxDeposit5(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositBoxDeposit5. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposit 10 of a specific item(s) into a deposit box.
---@param ItemID number|table
---@return boolean
function BANK:DepositBoxDeposit10(ItemID)
    -- Handle single item case
    if type(ItemID) == "number" then     
        local ItemIDHex = string.format("0x%X", ItemID)  
        local slot = BANK:DepositBoxGetSlot(ItemID)     

        if slot then
            print("[BANK] Depositing 10 of item: "..ItemID.." into deposit box.")
            API.DoAction_Interface(0xffffffff,ItemIDHex,3,11,19,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Item ID: "..ItemID.." not found in deposit box interface.")
            return false
        end
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        local success = true
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositBoxDeposit10(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositBoxDeposit10. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- Deposit ALL of a specific item(s) into a deposit box.
---@param ItemID number|table
---@return boolean
function BANK:DepositBoxDepositAll2(ItemID)
    -- Handle single item case
    if type(ItemID) == "number" then     
        local ItemIDHex = string.format("0x%X", ItemID)  
        local slot = BANK:DepositBoxGetSlot(ItemID)     

        if slot then
            print("[BANK] Depositing ALL of item: "..ItemID.." into deposit box.")
            API.DoAction_Interface(0xffffffff,ItemIDHex,4,11,19,slot,API.OFF_ACT_GeneralInterface_route)
            return true
        else
            print("[BANK] Item ID: "..ItemID.." not found in deposit box interface.")
            return false
        end
    -- Handle table of items case
    elseif type(ItemID) == "table" then
        local success = true
        for _, id in ipairs(ItemID) do
            local currentSuccess = BANK:DepositBoxDepositAll2(id)
            if not currentSuccess then
                success = false
            end
        end
        return success
    else
        print("[BANK] Invalid input type for DepositBoxDepositAll2. Expected number or table, got "..type(ItemID))
        return false
    end
end

-- ####################################
-- #                                  #
-- #     COLLECTION BOX FUNCTIONS     #
-- #                                  #
-- ####################################

-- Check if Collect interface is open.
---@return boolean
function BANK:ColletionBoxIsOpen()
    if API.VB_FindPSettinOrder(2874, 0).state == 18 then
        print("[BANK] Collect interface open.")
        return true
    else
        print("[BANK] Collect interface is not open.")
        return false
    end 
end

-- Attempts to open your collection box using the listed options. Requires cache enabled https://imgur.com/5I9a46V.
---@return boolean
function BANK:ColletionBoxOpen()
    print("[BANK] Opening collection box from nearest bank:")
    local NearestBank = GetNearestBank()
    
    if not NearestBank then
        print("[BANK] No bank found nearby or no matching bank in configuration.")
        return false
    end



    local success = false
    
    if NearestBank.InteractType == "NPC" then
        success = Interact:NPC(NearestBank.name, NearestBank.CollectionBoxAction, 50)
    elseif NearestBank.InteractType == "Object" then
        success = Interact:Object(NearestBank.name, NearestBank.CollectionBoxAction, 50)
    end
    
    if success then
        print("[BANK] " .. NearestBank.name .. " succeeded.")
        return true
    end
    
    print("[BANK] Could not open collection box from " .. NearestBank.name)
    return false
end

-- Attempts to close the collection box interface.
---@return boolean
function BANK:CollectionBoxClose()
    if BANK:ColletionBoxIsOpen() then
        print("[BANK] Closing collection box.")
        return API.DoAction_Interface(0x24,0xffffffff,1,109,42,-1,API.OFF_ACT_GeneralInterface_route)
    else
        print("[BANK] Collection box not open.")
        return false
    end
end

-- Check if there are items to collect.
---@return boolean
function BANK:ColletionBoxHasItems()
    local FoundItem = false

    for i = 1, 16 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.CollectionBoxSlots[i])[1]
        if slot.itemid1 and slot.itemid1 ~= -1 then
            FoundItem = true
        end
    end

    if FoundItem then
        print("[BANK] There is at least one item to collect.")
    else
        print("[BANK] There are no items to collect.")
    end

    return FoundItem
end

-- Check if there is a specific item to collect.
---@param itemID number
---@return boolean
function BANK:ColletionBoxContains(itemID)
    local FoundItem = false

    for i = 1, 16 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.CollectionBoxSlots[i])[1]
        if slot.itemid1 and slot.itemid1 == itemID then
            FoundItem = true
        end
    end

    if FoundItem then
        print("[BANK] Item ID: "..itemID.." found.")
    else
        print("[BANK] Item ID: "..itemID.." not found.")
    end

    return FoundItem
end

-- Collects all to inventory from Collect interface.
---@return boolean
function BANK:ColletionBoxCollectToInventory()
    if BANK:ColletionBoxHasItems() then
        print("[BANK] Collecting all to inventory.")
        API.DoAction_Interface(0x24,0xffffffff,1,109,55,-1,API.OFF_ACT_GeneralInterface_route) 
        return true
    else
        print("[BANK] There are no items to collect.")
        return false        
    end    
end

-- Collects all to bank from Collect interface.
---@return boolean
function BANK:ColletionBoxCollectToBank()
    if BANK:ColletionBoxHasItems() then
        print("[BANK] Collecting all to BANK:")
        API.DoAction_Interface(0x24,0xffffffff,1,109,47,-1,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        print("[BANK] There are no items to collect.")
        return false        
    end
end

-- #####################################
-- #                                   #
-- #     PRESET SETTINGS FUNCTIONS     #
-- #                                   #
-- #####################################

-- Check if preset settings interface is open.
---@return boolean
function BANK:PresetSettingsIsOpen()
    local VB = API.VB_FindPSettinOrder(6680).state >> 20

    if VB == 0 then
        print("[BANK] Preset settings interface is not open.")
        return false
        
    elseif VB == 1 then
        print("[BANK] Preset settings interface is open.")
        return true
    else
        print("[BANK] Something went horribly wrong here. Send me a screenshot of the console on Discord: not_spectre011.")
        print("Function: BANK:PresetSettingsIsOpen()")
        local var = API.VB_FindPSettinOrder(6680)
        print("--------------------------")
        print("state: " .. var.state)
        print("addr: " .. var.addr)
        print("indexaddr_orig: " .. var.indexaddr_orig)
        print("id: " .. var.id)
        print("--------------------------")
        return false
    end
end

-- Open preset settings interface.
---@return boolean
function BANK:PresetSettingsOpen()
    if not BANK:PresetSettingsIsOpen() then
        print("[BANK] Opening preset settings.")
        API.DoAction_Interface(0x24,0xffffffff,1,517,119,0,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        print("[BANK] Preset settings interface is already open.")
        return true
    end
    return false
end

-- Returns to bank.
---@return boolean
function BANK:PresetSettingsReturnToBank()
    if BANK:PresetSettingsIsOpen() then
        print("[BANK] Return to BANK:")
        API.DoAction_Interface(0xffffffff,0xffffffff,1,517,86,-1,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        print("[BANK] Bank interface already open.")
        return true
    end
    return false
end

-- Returns selected preset from the preset settings interface.
---@return number|boolean
function BANK:PresetSettingsGetSelectedPreset()
    if not BANK:PresetSettingsIsOpen() then
        print("[BANK] Preset settings interface is not open. Open it first with BANK:PresetSettingsOpen()")
        return false
    end

    local VB = API.VB_FindPSettinOrder(9932).state
    print("[BANK] Selected preset: "..VB)
    return tonumber(VB)
end

-- Select a preset (1-19). 19 is beast of burden.
---@param preset number
---@return boolean
function BANK:PresetSettingsSelectPreset(preset)
    if type(preset) ~= "number" then
        print("[BANK] Invalid preset type. Expected a number, got " .. type(preset))
        return false
    end

    local slot = tonumber(preset)
    if not slot or slot < 1 or slot > 19 then
        print("[BANK] Invalid preset number. Must be between 1 and 19, got " .. tostring(preset))
        return false
    end

    if BANK:PresetSettingsIsOpen() then
        print("[BANK] Selecting preset " .. slot .. ".")
        API.DoAction_Interface(0xffffffff,0xffffffff,1,517,268,slot,-1,API.OFF_ACT_GeneralInterface_route)
        return true
    else
        print("[BANK] Preset settings interface is not open. Open it first with BANK:PresetSettingsOpen().")
        return false
    end
end

---Get the itemID of all inventory slots inside the preset settings interface.
---@return table|boolean
function BANK:PresetSettingsGetInventory()
    local inventory = {}

    for i = 1, 28 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.PresetSettings.Inventory[i])[1]
        if slot and slot.itemid1 then
            table.insert(inventory, { index = i, itemid1 = slot.itemid1, textitem = slot.textitem })
        end
    end

    if #inventory == 0 then
        return false
    end

    return inventory
end

---Get the itemID of all equipment slots inside the preset settings interface.
---@return table|boolean
function BANK:PresetSettingsGetEquipment()
    local equipment = {}

    for i = 1, 13 do
        local slot = API.ScanForInterfaceTest2Get(false, self.Interfaces.PresetSettings.Equipment[i])[1]
        if slot and slot.itemid1 then
            table.insert(equipment, { index = i, itemid1 = slot.itemid1, textitem = slot.textitem })
        end
    end

    if #equipment == 0 then
        return false
    end

    return equipment
end

---Checks if a specific checkbox is enabled in the bank preset settings. Valid options are "Inventory", "Equipment", or "Summon".
---@param option string
---@return boolean|nil
function BANK:PresetSettingsGetCheckBox(option)
    if type(option) ~= "string" then
        print("[BANK] Error: Expected a string for 'option', got " .. type(option))
        return nil
    end

    if option == "Inventory" then
        local VB = (tonumber(API.VB_FindPSettinOrder(4338).state) >> 22) & 1
        if VB == 0 then
            print("[BANK] Inventory CheckBox Enabled.")
            return true
        elseif VB == 1 then
            print("[BANK] Inventory CheckBox Disabled.")
            return false
        else
            print("[BANK] Inventory CheckBox Unknown.")
            return nil
        end
    elseif option == "Equipment" then
        local VB = (tonumber(API.VB_FindPSettinOrder(4338).state) >> 23) & 1
        if VB == 0 then
            print("[BANK] Equipment CheckBox Enabled.")
            return true
        elseif VB == 1 then
            print("[BANK] Equipment CheckBox Disabled.")
            return false
        else
            print("[BANK] Equipment CheckBox Unknown.")
            return nil
        end        
    elseif option == "Summon" then
        local VB = (tonumber(API.VB_FindPSettinOrder(4915).state)) & 1
        if VB == 0 then
            print("[BANK] Summon CheckBox Disabled.")
            return false
        elseif VB == 1 then
            print("[BANK] Summon CheckBox Enabled.")
            return true
        else
            print("[BANK] Summon CheckBox Unknown.")
            return nil
        end
    else
        print("[BANK] Invalid option: '" .. option .. "'. Accepted values are: Inventory, Equipment, or Summon.")
        return nil
    end
    
end

---Set a specific checkbox to be enaled or disabled in the bank preset settings. Valid options are "Inventory", "Equipment", or "Summon".
---@param option string
---@param state boolean
---@return boolean|nil
function BANK:PresetSettingsSetCheckBox(option, state)
    if type(option) ~= "string" then
        print("[BANK] Error: Expected a string for 'option', got " .. type(option))
        return nil
    end

    if type(state) ~= "boolean" then
        print("[BANK] Error: Expected a boolean for 'state', got " .. type(state))
        return nil
    end

    if option == "Inventory" then
        local CheckBox = BANK:PresetSettingsGetCheckBox("Inventory")
        if state then
            if not CheckBox then
                print("[BANK] Enabling inventory checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,296,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif CheckBox then
                print("[BANK] Inventory checkbox already enabled. No action needed.")
                return true
            else
                print("BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        elseif not state then
            if CheckBox then
                print("[BANK] Disabling inventory checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,296,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif not CheckBox then
                print("[BANK] Inventory checkbox already disabled. No action needed.")
                return true
            else
                print("[BANK] BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        else
            print("[BANK] State invalid: " .. tostring(state))
            return false
        end
    
    elseif option == "Equipment" then
        local CheckBox = BANK:PresetSettingsGetCheckBox("Equipment")
        if state then
            if not CheckBox then
                print("[BANK] Enabling equipment checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,298,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif CheckBox then
                print("[BANK] Equipment checkbox already enabled. No action needed.")
                return true
            else
                print("[BANK] BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        elseif not state then
            if CheckBox then
                print("[BANK] Disabling equipment checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,298,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif not CheckBox then
                print("[BANK] Equipment checkbox already disabled. No action needed.")
                return true
            else
                print("[BANK] BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        else
            print("[BANK] State invalid: " .. tostring(state))
            return false
        end
    
    elseif option == "Summon" then
        local CheckBox = BANK:PresetSettingsGetCheckBox("Summon")
        if state then
            if not CheckBox then
                print("[BANK] Enabling summon checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,300,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif CheckBox then
                print("[BANK] Summon checkbox already enabled. No action needed.")
                return true
            else
                print("BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        elseif not state then
            if CheckBox then
                print("[BANK] Disabling summon checkbox.")
                API.DoAction_Interface(0xffffffff,0xffffffff,1,517,300,-1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif not CheckBox then
                print("[BANK] Summon checkbox already disabled. No action needed.")
                return true
            else
                print("[BANK] BANK:PresetSettingsGetCheckBox() returned nil.")
                return false
            end
        else
            print("[BANK] State invalid: " .. tostring(state))
            return false
        end
    else
        print("[BANK] Unknown option: " .. tostring(option))
        return false
    end
end

---Prints the data from BANK:PresetSettingsGetInventory() and BANK:PresetSettingsGetEquipment().
---@param data table
---@return boolean
function BANK:PresetSettingsPrintData(data)
    print("Contents:")
    for _, item in ipairs(data) do
        print(string.format("Slot %02d: Item ID = %d Name: %s", item.index, item.itemid1, item.textitem))
    end
    return true
end

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Quest — Spectre011 quest.lua v1.1.0 (dialog/movement helpers), vendored
--#   https://github.com/spectre011-code/Public-ME-Scripts/blob/main/Libraries/quest.lua
local ScriptName = "Quest toolbox"
local Author = "Spectre011"
local ScriptVersion = "1.1.0"
local ReleaseDate = "03-05-2025"
local DiscordHandle = "not_spectre011"

--[[
Changelog:
v1.0.0 - 03-05-2025
    - Initial release.
v1.1.0 - 08-05-2025
    - Added functions
    - Changed . to :
]]

local QUEST = {}

QUEST.Interfaces = {}

QUEST.Interfaces.ChatOptions = { { 1188, 5, -1, -1}, { 1188, 3, -1, 5}, { 1188, 3, 14, 3} }

-- Simple sleep
---@param seconds number
---@return boolean
function QUEST:Sleep(seconds)
    local endTime = os.clock() + seconds
    while API.Read_LoopyLoop() and os.clock() < endTime do
    end
    return true
end

-- Is the option dialog box open
---@return boolean
function QUEST:HasOption()
    local option = API.ScanForInterfaceTest2Get(false, self.Interfaces.ChatOptions)

    if #option > 0 and #option[1].textids > 0 then
        return option[1].textids
    end

    return false
end

-- Select the first option found in the given table. 
--[[Table example:
local options = {
    "Could I have the key back?",
    "6,000? Seems fair!",
    "Teleport to the clan camp south of Falador.",
    "I wish to drop it."
}
]]
---@param options table
---@return boolean
function QUEST:OptionSelector(options)
    for i, optionText in ipairs(options) do
        local optionNumber = tonumber(API.Dialog_Option(optionText))
        if optionNumber and optionNumber > 0 then
            local keyCode = 0x30 + optionNumber
            API.KeyboardPress2(keyCode, 60, 100)
            API.RandomSleep2(400,300,600)
            return true
        end
    end
    return false
end

-- Is a Dialogue Window open
---@return boolean
function QUEST:DialogBoxOpen()
    return API.VB_FindPSett(2874, 1, 0).state == 12
end

-- Presses space bar with sleep added after
---@return boolean
function QUEST:PressSpace()
    return API.KeyboardPress2(0x20, 40, 60), API.RandomSleep2(400,300,600)
end

-- Busy sleep that waits for a dialog box with a timeout in seconds
---@param timeout number
---@return boolean
function QUEST:WaitForDialogBox(timeout)
    local startTime = os.clock()
    while API.Read_LoopyLoop() and not QUEST:DialogBoxOpen() do
        if os.clock() - startTime > timeout then
            return false
        end
        QUEST:Sleep(0.6)
    end
    return true
end

--Checks if the player is in a specified area
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function QUEST:IsPlayerInArea(x, y, z, radius)
    local coord = API.PlayerCoord()
    local dx = math.abs(coord.x - x)
    local dy = math.abs(coord.y - y)
    local distance = math.sqrt(dx^2 + dy^2)
    if distance <= radius and coord.z == z then
        return true
    else
        return false
    end
end

-- Moves to a certain location within a specified distance tolerance
---@param x number
---@param y number
---@param z number
---@param Tolerance number
---@return boolean
function QUEST:MoveTo(X, Y, Z, Tolerance)
    while API.Read_LoopyLoop() and not QUEST:IsPlayerInArea(X, Y, Z, Tolerance + 2) do
        if not API.IsPlayerMoving_(API.GetLocalPlayerName()) then
            print("Not moving. Walking...")
            API.DoAction_WalkerW(WPOINT.new(X + math.random(-Tolerance, Tolerance),Y + math.random(-Tolerance, Tolerance),Z))
        end
        QUEST:Sleep(0.6)
    end
    return true
end

-- Wait until the object appears
---@return boolean
function QUEST:WaitForObjectToAppear(ObjID, ObjType)    
    local objects = API.GetAllObjArray1({ObjID}, 75, {ObjType})
    if objects and #objects > 0 then
        for _, object in ipairs(objects) do
            local id = object.Id or 0
            local objType = object.Type or 0           
            if id == ObjID and objType == ObjType then
                return true
            end
        end
    else
        print("No objects found on this attempt.")
    end
    QUEST:Sleep(0.6)
    return true
end

-- Check if an object exists
---@param ObjID number
---@param Range number
---@param ObjType number
---@return boolean
function QUEST:DoesObjectExist(ObjID, Range, ObjType)
    local objects = API.GetAllObjArray1({ObjID}, Range, {ObjType})
    if objects and #objects > 0 then
        for _, object in ipairs(objects) do
            if object.Id == ObjID and ObjType == object.Type then
                return true
            end
        end
    end
    return false
end

-- Checks the bool1 field of a given object(12) is equal to 1
---@param ObjID number
---@return boolean
function QUEST:Bool1Check(ObjID)
    local objects = API.GetAllObjArray1({ObjID}, 75, {12})
    if objects and #objects > 0 then
        for _, object in ipairs(objects) do
            if object.Bool1 == 1 then 
                return true
            end
        end
    end
    return false
end

-- Check if the player is in a cutscene(maybe)
---@return boolean
function QUEST:IsInCutscene()
    return API.GetVarbitValue(16903) == 1
end

DX.Quest = QUEST

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Spectre — Spectre011 spectre.lua v1.0 (misc helpers incl. GWD2 kc,
--#   incense sticks, silverhawk recharge, mem-strand tele, SurgeIfFacing, Dive)
--#   https://github.com/spectre011-code/Public-ME-Scripts/blob/main/Libraries/spectre.lua
--#   (upstream's global Author/DiscordHandle/VERSION made `local` here — same fix
--#    upstream itself applied in bank v1.0.4 to avoid global name clashes)
local Author = "Spectre011"
local DiscordHandle = "not_spectre011"

local SpectreUtils = {}

local VERSION = "1.0"

--Simple sleep
---@param seconds number
---@return boolean
function SpectreUtils.Sleep(seconds)
    local endTime = os.clock() + seconds
    while os.clock() < endTime do
    end
    return true
end

--Prints all the buffs
---@return boolean
function SpectreUtils.GetBuffs()
    local buffs = API.Buffbar_GetAllIDs()
    if buffs then
        for _, object in ipairs(buffs) do
            print("----------")
            print("id: ", object.id)
            print("found: ", object.found)
            print("text: ", object.text)
            print("conv_text: ", object.conv_text)
            print("----------")
        end
    end
    return true
end

--Prints all the debuffs
---@return boolean
function SpectreUtils.GetDebuffs()
    local debuffs = API.DeBuffbar_GetAllIDs()
    if debuffs then
        for _, object in ipairs(buffs) do
            print("----------")
            print("id: ", object.id)
            print("found: ", object.found)
            print("text: ", object.text)
            print("conv_text: ", object.conv_text)
            print("----------")
        end
    end
    return true
end

--Prints all the items in inventory
---@return boolean
function SpectreUtils.GetItemsInInventory()
    local items = API.ReadInvArrays33()
    if items and #items > 0 then
        for _, item in ipairs(items) do
            print("-----------------")
            print("item.x:", item.x)
            print("item.xs:", item.xs)
            print("item.y:", item.y)
            print("item.ys:", item.ys)
            print("item.box_x:", item.box_x)
            print("item.box_y:", item.box_y)
            print("item.scroll_y:", item.scroll_y)
            print("item.id1:", item.id1)
            print("item.id2:", item.id2)
            print("item.id3:", item.id3)
            print("item.id4:", item.id4)
            print("item.itemid1:", item.itemid1) -- Item ID
            print("item.itemid1_size:", item.itemid1_size) -- Item Quantity
            print("item.itemid2:", item.itemid2)
            print("item.hov:", item.hov)
            print("item.textids:", item.textids)
            print("item.textitem:", item.textitem) -- Item Name
            print("item.memloc:", item.memloc)
            print("item.memloctop:", item.memloctop)
            print("item.index:", item.index)
            print("item.fullpath:", item.fullpath)
            print("item.fullIDpath:", item.fullIDpath)
            print("item.notvisible:", item.notvisible)
            print("item.OP:", item.OP)
            print("item.xy:", item.xy)
            print("-----------------")            
        end
    end
    return true
end

--Prints all abitilies from specified ability bar
---@param BarID number
---@return boolean
function SpectreUtils.GetAbilitiesFromBar(BarID)
    local bar = API.GetABarInfo(BarID)
    for _, ability in ipairs(bar) do
        print("----------------------------")
        print("ability.slot: ", ability.slot)
        print("ability.id: ", ability.id)
        print("ability.name: ", ability.name)
        print("ability.hotkey: ", ability.hotkey)
        print("ability.cooldown_timer: ", ability.cooldown_timer)
        print("ability.info: ", ability.info)
        print("ability.action: ", ability.action)
        print("ability.enabled: ", ability.enabled)
        print("----------------------------")
    end
    return true
end

--Prints all objects with specified parameters
---@param Id table|number
---@param Range number
---@param Type table|number
---@return boolean
function SpectreUtils.GetAllObjects(Id, Range, Type)
    local objects = API.GetAllObjArray1({Id}, Range, {Type})
    if objects and #objects > 0 then
        for _, object in ipairs(objects) do
            print("---------------------------------")  
            print("object.Mem: ", object.Mem)
            print("object.MemE: ", object.MemE)
            print("object.TileX: ", object.TileX)
            print("object.TileY: ", object.TileY)
            print("object.TileZ: ", object.TileZ)
            print("object.Id: ", object.Id)
            print("object.Life: ", object.Life)
            print("object.Anim: ", object.Anim)
            print("object.Name: ", object.Name)
            print("object.Action: ", object.Action)
            print("object.Floor: ", object.Floor)
            print("object.Amount: ", object.Amount)
            print("object.Type: ", object.Type)
            print("object.Bool1: ", object.Bool1)
            print("object.ItemIndex: ", object.ItemIndex)
            print("object.ViewP: ", object.ViewP)
            print("object.ViewF: ", object.ViewF)
            print("object.Distance: ", object.Distance)
            print("object.Cmb_lv: ", object.Cmb_lv)
            print("object.Unique_Id: ", object.Unique_Id)
            print("object.CalcX: ", object.CalcX)
            print("object.CalcY: ", object.CalcY)
            print("object.Tile_XYZ: ", object.Tile_XYZ)
            print("object.Tile_XYZ.x: ", object.Tile_XYZ.x)
            print("object.Tile_XYZ.y: ", object.Tile_XYZ.y)
            print("object.Tile_XYZ.z: ", object.Tile_XYZ.z)
            print("object.Pixel_XYZ: ", object.Pixel_XYZ)            
            print("---------------------------------")          
        end
    end
    return true
end

--Prints info about specified VB
---@param VB number
---@return boolean
function SpectreUtils.GetVB(VB)
    local var = API.VB_FindPSettinOrder(VB)
    print("--------------------------")
    print("state: " .. var.state)
    print("addr: " .. var.addr)
    print("indexaddr_orig: " .. var.indexaddr_orig)
    print("id: " .. var.id)
    print("--------------------------")
    return true
end

---Prints container contents of non empty slots. 93 = inventory and 94 = equipment
---@param containerId number The ID of the container to print contents from
---@return nil Prints to console but doesnt return a value
function SpectreUtils.PrintContainerContents(containerId)
    local items = API.Container_Get_all(containerId)
    if not items or #items == 0 then
        print("Container is empty")
        return
    end

    local validItemCount = 0
    for _, item in ipairs(items) do
        if item.item_id and item.item_id > 0 then
            validItemCount = validItemCount + 1
        end
    end
    
    print("=== Container Contents ===")
    print("Valid items: " .. validItemCount)
    print("--------------------------")

    for i, item in ipairs(items) do
        if item.item_id and item.item_id > 0 then
            print("Item #" .. i)
            print("  item_id: " .. tostring(item.item_id))
            print("  item_stack: " .. tostring(item.item_stack))
            print("  item_slot: " .. tostring(item.item_slot))

            print("  Extra_mem:")
            if item.Extra_mem then
                for k, v in pairs(item.Extra_mem) do
                    print("    " .. tostring(k) .. ": " .. tostring(v))
                end
            else
                print("    nil")
            end

            print("  Extra_ints:")
            if item.Extra_ints then
                for k, v in pairs(item.Extra_ints) do
                    print("    " .. tostring(k) .. ": " .. tostring(v))
                end
            else
                print("    nil")
            end
            
            print("--------------------------")
        end
    end
end


--Checks if the player is in a specified area
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function SpectreUtils.IsPlayerInArea(x, y, z, radius)
    local coord = API.PlayerCoord()
    local dx = math.abs(coord.x - x)
    local dy = math.abs(coord.y - y)
    local distance = math.sqrt(dx^2 + dy^2)
    if distance <= radius and coord.z == z then
        return true
    else
        return false
    end
end

--Checks if the player is a the specified coordinates
---@param x number
---@param y number
---@param z number
---@return boolean
function SpectreUtils.IsPlayerAtCoords(x, y, z)
    local coord = API.PlayerCoord()
    if x == coord.x and y == coord.y and z == coord.z then
        return true
    else
        return false
    end
end

--Walks to specified coordinates
---@param x number
---@param y number
---@param z number
---@return boolean
function SpectreUtils.WalkToCoordinates(x,y,z)
    if API.DoAction_Tile(WPOINT.new(x,y,z)) then
        return true
    else
        return false
    end
end

--Checks if the timer of an instance is at 00:00
---@return boolean
function SpectreUtils.TimerHitZero()
    local timer = {
        InterfaceComp5.new(861, 0, -1, 0),
        InterfaceComp5.new(861, 2, -1, 0),
        InterfaceComp5.new(861, 4, -1, 0),
        InterfaceComp5.new(861, 8, -1, 0)
    }
    local result = API.ScanForInterfaceTest2Get(false, timer)
    if result and #result > 0 and result[1].textids then
        local textids = result[1].textids
        local startIndex, endIndex = string.find(textids, "00:00")
        if startIndex then
            return true
        else
            return false
        end
    else
        print("No result or textids field not found.")
    end
end

--Use ability by name
---@param string string
---@return boolean
function SpectreUtils.UseAbilityByName(string)    
    local ability = UTILS.getSkillOnBar(string)
    if ability ~= nil then
        return API.DoAction_Ability_Direct(ability, 1, API.OFF_ACT_GeneralInterface_route)
    end
    return false
end

-- Checks if a message from an NPC appeared on chat recently up to defined seconds. Can check from a list
---@param search_strings table|string
---@param max_seconds number
---@return string
function SpectreUtils.CheckNPCMessagesRecent(search_strings, max_seconds)
    local chat = API.ChatGetMessages()
    local current_time = os.date("*t")
    local current_seconds = current_time.hour * 3600 + current_time.min * 60 + current_time.sec
    if type(search_strings) ~= "table" then
        search_strings = {search_strings}
    end
    for _, msg in ipairs(chat) do
        local time_text = string.match(msg.text, "<col=7fa9ff>(%d%d:%d%d:%d%d)")
        local message_text = string.match(msg.text, "<col=99ff99>(.-)</col>")
        if time_text then
            local hours, minutes, seconds = string.match(time_text, "(%d%d):(%d%d):(%d%d)")
            if hours and minutes and seconds then
                local message_time_seconds = tonumber(hours) * 3600 + tonumber(minutes) * 60 + tonumber(seconds)
                local time_difference = current_seconds - message_time_seconds
                if time_difference <= max_seconds and message_text then
                    for _, search_string in ipairs(search_strings) do
                        if string.find(message_text, search_string) then
                            return search_strings[_] -- or return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Wait until the object appears
---@return boolean
function SpectreUtils.WaitForObjectToAppear(ObjID, ObjType)
    while API.Read_LoopyLoop() do
        local objects = API.GetAllObjArray1({ObjID}, 75, {ObjType})
        if objects and #objects > 0 then
            for _, object in ipairs(objects) do
                local id = object.Id or 0
                local objType = object.Type or 0           
                if id == ObjID and objType == ObjType then
                    return
                end
            end
        else
            print("No objects found on this attempt.")
        end
        SpectreUtils.Sleep(0.2)
    end
    return true
end

--Memory strand teleport from currency pouch
---@return boolean
function SpectreUtils.MemStrandTele()
    API.DoAction_Interface(0x24, 0x9A3E, 1, 1473, 10, 4097, API.OFF_ACT_GeneralInterface_route) -- Open currency pouch
    SpectreUtils.Sleep(0.2)
    while API.Read_LoopyLoop() and not SpectreUtils.IsPlayerInArea(2293, 3554, 0, 5) do
        API.DoAction_Interface(0x24, 0x9A3E, 1, 1473, 21, 10, API.OFF_ACT_GeneralInterface_route) -- Memory Strand teleport  
        SpectreUtils.Sleep(6)
    end
    API.DoAction_Interface(0x24, 0x9A3E, 1, 1473, 15, -1, API.OFF_ACT_GeneralInterface_route) -- Close currency pouch
    return true
end

local activationTick = 0
local delayTicks = 2
--Activates prayer
---@param PrayerBuffID number
---@return boolean
function SpectreUtils.ActivatePrayer(PrayerBuffID)
    local prayerMapping = {
        [26033] = "Soul Split",
        [26041] = "Deflect Magic",
        [26044] = "Deflect Ranged",
        [26040] = "Deflect Melee",
        [30745] = "Deflect Necromancy",
        [25959] = "Protect from Magic",
        [25960] = "Protect from Ranged",
        [25961] = "Protect from Melee",
        [30831] = "Protect from Necromancy"        
    }
    local PrayerName = prayerMapping[PrayerBuffID]
    if not PrayerName then
        print("Invalid PrayerBuffID: " .. PrayerBuffID)
        return
    end
    local currentTick = API.Get_tick()
    if not API.Buffbar_GetIDstatus(PrayerBuffID).found then
        if activationTick == 0 or currentTick > activationTick + delayTicks then
            if API.DoAction_Ability(PrayerName, 1, API.OFF_ACT_GeneralInterface_route) then
                activationTick = currentTick
                return true
            else 
                return false
            end            
        end
    end
end

--Deactivates prayer
---@param PrayerBuffID number
---@return boolean
function SpectreUtils.DeactivatePrayer(PrayerBuffID)
    local prayerMapping = {
        [26033] = "Soul Split",
        [26041] = "Deflect Magic",
        [26044] = "Deflect Ranged",
        [26040] = "Deflect Melee",
        [30745] = "Deflect Necromancy",
        [25959] = "Protect from Magic",
        [25960] = "Protect from Ranged",
        [25961] = "Protect from Melee",
        [30831] = "Protect from Necromancy"        
    }
    local PrayerName = prayerMapping[PrayerBuffID]
    if not PrayerName then
        print("Invalid PrayerBuffID: " .. PrayerBuffID)
        return
    end
    local currentTick = API.Get_tick()
    if API.Buffbar_GetIDstatus(PrayerBuffID).found then
        if activationTick == 0 or currentTick > activationTick + delayTicks then
            if API.DoAction_Ability(PrayerName, 1, API.OFF_ACT_GeneralInterface_route) then
                activationTick = currentTick
                return true
            else
                return false
            end
        end
    end
end

--Uses incense sticks and keep them active
---@param buffID number
---@return boolean
function SpectreUtils.CheckIncenseStick(buffID)
    local buffs = API.Buffbar_GetAllIDs()
    local found = false
    if buffs then
        for _, object in ipairs(buffs) do
            if object.id == buffID then
                found = true
                local time, level = string.match(object.text, "(%d+)%a* %((%d+)%)")
                time = tonumber(time)
                level = tonumber(level)
                if level < 4 then
                    API.DoAction_Inventory1(buffID, 0, 2, API.OFF_ACT_GeneralInterface_route) -- Overload
                end
                if time < 50 then
                    local randomCount = math.random(1, 5)
                    for i = 1, randomCount do
                        API.DoAction_Inventory1(buffID, 0, 1, API.OFF_ACT_GeneralInterface_route) -- Extend
                        SpectreUtils.Sleep(0.2)
                    end
                end
                break
            end
        end
        return true
    end    
    if not found then
        API.DoAction_Inventory1(buffID, 0, 2, API.OFF_ACT_GeneralInterface_route) -- Overload
        for i = 1, 5 do
            API.DoAction_Inventory1(buffID, 0, 1, API.OFF_ACT_GeneralInterface_route) -- Extend
            SpectreUtils.Sleep(0.2)
        end
        return true
    end
    return false
end

--Recharges silverhawk boots when stored feathers are bellow minimum quantity
---@param minQuantity number
---@return boolean
function SpectreUtils.RechargeSilverhawkBoots(minQuantity)
    local item = API.Container_Get_s(94,30924)
    if item.item_id == 30924 then
        if item.Extra_ints[2] < minQuantity then
            local silverhawkFeather = API.CheckInvStuff0(30915)
            local silverhawkDown = API.CheckInvStuff0(34823)
            if silverhawkFeather ~= false then
                API.DoAction_Inventory1(30915,0,1,API.OFF_ACT_GeneralInterface_route)
                return true
            elseif silverhawkDown ~= false then
                API.DoAction_Inventory1(34823,0,1,API.OFF_ACT_GeneralInterface_route)
                return true
            end
        end
        return false
    end
    return false
end

--Checks if from a list of IDS if the items are in players Inventory
---@param ids number
---@return boolean
function SpectreUtils.inventoryContainsAny(ids)
    for _, id in ipairs(ids) do
        if Inventory:Contains(id) then
            return true
        end
    end
    return false
end

--Surges if the player is facing the specified orientation
---@param Orientation number
---@return boolean
function SpectreUtils.SurgeIfFacing(Orientation)
    local Surge = API.GetABs_id(14233)
    local PlayerFacing = math.floor(API.calculatePlayerOrientation())
    if PlayerFacing == 0 then PlayerFacing = 360 end
    if Orientation == 0 then Orientation = 360 end
    
    if Orientation == PlayerFacing then
        if (Surge.id ~= 0 and Surge.enabled and Surge.cooldown_timer < 1) then
            if API.DoAction_Ability_Direct(Surge, 1, API.OFF_ACT_GeneralInterface_route) then
                return true
            else
                return false
            end
        end
    end
end

--Dives to the specified coordinates
---@param X number
---@param Y number
---@param Z number
---@return boolean
function SpectreUtils.Dive(X, Y, Z)
    local Bdive = API.GetABs_id(30331)
    local Dive = API.GetABs_id(23714)
    if (Bdive.id ~= 0 and Bdive.enabled and Bdive.cooldown_timer < 1) or (Dive.id ~= 0 and Bdive.enabled and Dive.cooldown_timer < 1) then
        if not API.DoAction_BDive_Tile(WPOINT.new(X, Y, Z)) then
            if API.DoAction_Dive_Tile(WPOINT.new(X, Y, Z)) then
                return true
            else
                return false
            end
        end
    end
end

--Retrieves the kill counts GWD 2 followers
---@return table<string, number>
function SpectreUtils.GetGWD2KillCounts()
    local baseAddresses = {
        { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,43,-1,0 }, { 1746,47,-1,0 } },
        { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,49,-1,0 }, { 1746,54,-1,0 } },
        { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,55,-1,0 }, { 1746,60,-1,0 } },
        { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,61,-1,0 }, { 1746,66,-1,0 } },
    }

    local keyNames = { "Seren", "Sliske", "Zamorak", "Zaros" }
    local results = {}

    for i, baseAddress in ipairs(baseAddresses) do
        local data = API.ScanForInterfaceTest2Get(false, baseAddress)
        if #data >= 0 then
            local amount = API.ReadCharsLimit(data[1].memloc + API.I_itemids3, 255)
            results[keyNames[i]] = tonumber(amount)
        end
    end

    print("Kill Counts:")
    print("Seren:", results.Seren)
    print("Sliske:", results.Sliske)
    print("Zamorak:", results.Zamorak)
    print("Zaros:", results.Zaros)
    
    return results
end

DX.Spectre = SpectreUtils

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Slib — Spectre011 slib.lua v1.0.17 (full utility library: logging,
--#   param validation, waits, print-dump tools, VB helpers, instance/dungeon tools,
--#   GWD kc, loot window, runes, abilities, movement, alch/note, buff upkeep)
--#   https://github.com/spectre011-code/Public-ME-Scripts/blob/main/Libraries/slib.lua
--#   One local change: Slib.ChatMessages starts empty — upstream fills it at require
--#   time via API.GatherEvents_chat_check(), which destructively drains the shared
--#   chat buffer; it is filled lazily by Slib:RecentMessageCheck instead.
--asslib
local ScriptName = "Spectre011's Lua Utility Library" 
local Author = "Spectre011"
local ScriptVersion = "1.0.17"
local ReleaseDate = "09-07-2025"
local DiscordHandle = "not_spectre011"

--[[
======================================================================================
                       Spectre011's Lua Utility Library (Slib)                       
======================================================================================
A comprehensive utility library for RuneScape 3 scripting and automation, providing a 
robust foundation for bot development with extensive debugging capabilities, parameter 
validation, and game interaction functions.
---------------------------------------------------------------------------------------
                                    CREDITS                                       
---------------------------------------------------------------------------------------
Primary Author: Spectre011 (Discord: not_spectre011)
GitHub: https://github.com/spectre011-code
AI Assistant: Claude (Anthropic) - Code generation and optimization 

This library was developed with AI assistance for:
• Code structure and organization
• Comprehensive documentation
• Performance optimization and error handling
---------------------------------------------------------------------------------------

Changelog:
v1.0.0 - 09-07-2025
    - Initial release.
v1.0.1 - 12-07-2025
    - Added RandomNumber function.
v1.0.2 - 15-07-2025
    - Added write to file logging functionality.
v1.0.3 - 01-08-2025
    - Added lobby fuction.
    - Modified logging system to write files per session instead of just one file per account.
v1.0.4 - 22-08-2025
    - Added GetSpellBook function.
    - Added Note function.
    - Added HighAlch function.
v1.0.5 - 20-09-2025
    - Added AbilityExists function.
    - Added CanCastAbility function.
v1.0.6 - 28-10-2025
    - MoveTo() function will only use surge if the distance from the final coordinate is less than 10 tiles.
    - PrintQuestData() function now prints isComplete method correcly.
v1.0.7 - 10-01-2026
    - Updated PrintInterfaceInfo() function to print all(I hope) the mem reads of the interface elements.
v1.0.8 - 19-01-2026
    - Fixed the Slib.Interfaces.CurrencyPouch ID after interface changes.
    - Fixed MemoryStrandTeleport function after interface changes.
    - Fixed SetInstanceInterfaceOptions where it would disable practice mode if hardmode was passed as false and practice mode as true.
v1.0.9 - 19-01-2026
    - Fixed AreaLootOpen function after interface changes.
v1.0.10 - 22-01-2026
    - Added PrintVarpVb function.
    - Added IsBitActive function.
v1.0.11 - 27-03-2026
    - Added GetSpecialKeyVK function.
    - Added PressKey function.
v1.0.12 - 03-04-2026
    - Added WorkSleepUntil function.
v1.0.13 - 17-04-2026
    - Added BuffUpKeep function.
    - Added GetIDSFromTable function.
    - Removed CheckIncenseStick function.
v1.0.14 - 04-07-2026
    - Fixed HighAlch function.
v1.0.15 - 01-08-2026
    - Added Powders and Aspects to BuffUpKeep() function.
v1.0.16 - 04-08-2026
    - Fixed varc reading function on GetRuneAmounts() and PrintRunes() functions.
v1.0.17 - 31-08-2026
    - Added Charming Potion to BuffUpKeep() function.
]]

local Slib = {}

Slib.Items = {}
Slib.Buffs = {}
Slib.Interfaces = {}
Slib.ChatMessages = {}

Slib.Items.Runes = {
    Normal = { --Normal runes.
        Fire    = {Id = 554, InventoryVB = 5888, Name = "Fire rune"     },
        Water   = {Id = 555, InventoryVB = 5887, Name = "Water rune"    },
        Air     = {Id = 556, InventoryVB = 5886, Name = "Air rune"      },
        Earth   = {Id = 557, InventoryVB = 5889, Name = "Earth rune"    },
        Mind    = {Id = 558, InventoryVB = 5902, Name = "Mind rune"     },
        Body    = {Id = 559, InventoryVB = 5896, Name = "Body rune"     },
        Death   = {Id = 560, InventoryVB = 5901, Name = "Death rune"    },
        Nature  = {Id = 561, InventoryVB = 5899, Name = "Nature rune"   },
        Chaos   = {Id = 562, InventoryVB = 5898, Name = "Chaos rune"    },
        Law     = {Id = 563, InventoryVB = 5900, Name = "Law rune"      },
        Cosmic  = {Id = 564, InventoryVB = 5897, Name = "Cosmic rune"   },
        Blood   = {Id = 565, InventoryVB = 5904, Name = "Blood rune"    },
        Soul    = {Id = 566, InventoryVB = 5905, Name = "Soul rune"     },
        Astral  = {Id = 9075, InventoryVB = 5903, Name = "Astral rune"  },
        Armadyl = {Id = 21773, InventoryVB = 5906, Name = "Armadyl rune"},
        Time    = {Id = 58450, InventoryVB = 8291, Name = "Time rune"   }
    },

    Combination = { --They dont have an InventoryVB as they change the InventoryVB of the runes that were combined.
        Steam   = {Id = 4694, Name = "Steam rune"   }, -- Water + Fire
        Mist    = {Id = 4695, Name = "Mist rune"    }, -- Air + Water
        Dust    = {Id = 4696, Name = "Dust rune"    }, -- Air + Earth
        Smoke   = {Id = 4697, Name = "Smoke rune"   }, -- Air + Fire
        Mud     = {Id = 4698, Name = "Mud rune"     }, -- Water + Earth
        Lava    = {Id = 4699, Name = "Lava rune"    } -- Earth + Fire
    },

    Necromancy = { --They dont have an InventoryVB but can be read from container 953 if inside nexus.
        Spirit  = {Id = 55337, Name = "Spirit rune" },
        Bone    = {Id = 55338, Name = "Bone rune"   },
        Flesh   = {Id = 55339, Name = "Flesh rune"  },
        Miasma  = {Id = 55340, Name = "Miasma rune" }
    }
}

Slib.Items.Overloads = {
    -- Pure Overloads
    OverloadVial4               = { Id = 15332, Name = "Overload (4)"                  },
    OverloadVial3               = { Id = 15333, Name = "Overload (3)"                  },
    OverloadVial2               = { Id = 15334, Name = "Overload (2)"                  },
    OverloadVial1               = { Id = 15335, Name = "Overload (1)"                  },
    OverloadFlask6              = { Id = 23531, Name = "Overload flask (6)"            },
    OverloadFlask5              = { Id = 23532, Name = "Overload flask (5)"            },
    OverloadFlask4              = { Id = 23533, Name = "Overload flask (4)"            },
    OverloadFlask3              = { Id = 23534, Name = "Overload flask (3)"            },
    OverloadFlask2              = { Id = 23535, Name = "Overload flask (2)"            },
    OverloadFlask1              = { Id = 23536, Name = "Overload flask (1)"            },

    -- Combination Overloads
    HolyOverloadsFlask6         = { Id = 33246, Name = "Holy overload potion (6)"      },
    HolyOverloadsFlask5         = { Id = 33244, Name = "Holy overload potion (5)"      },
    HolyOverloadsFlask4         = { Id = 33242, Name = "Holy overload potion (4)"      },
    HolyOverloadsFlask3         = { Id = 33240, Name = "Holy overload potion (3)"      },
    HolyOverloadsFlask2         = { Id = 33238, Name = "Holy overload potion (2)"      },
    HolyOverloadsFlask1         = { Id = 33236, Name = "Holy overload potion (1)"      },
    AggroverloadFlask6          = { Id = 48239, Name = "Aggroverload (6)"              },
    AggroverloadFlask5          = { Id = 48237, Name = "Aggroverload (5)"              },
    AggroverloadFlask4          = { Id = 48235, Name = "Aggroverload (4)"              },
    AggroverloadFlask3          = { Id = 48233, Name = "Aggroverload (3)"              },
    AggroverloadFlask2          = { Id = 48231, Name = "Aggroverload (2)"              },
    AggroverloadFlask1          = { Id = 48229, Name = "Aggroverload (1)"              },
    SearingOverloadFlask6       = { Id = 33258, Name = "Searing overload potion (6)"   },
    SearingOverloadFlask5       = { Id = 33256, Name = "Searing overload potion (5)"   },
    SearingOverloadFlask4       = { Id = 33254, Name = "Searing overload potion (4)"   },
    SearingOverloadFlask3       = { Id = 33252, Name = "Searing overload potion (3)"   },
    SearingOverloadFlask2       = { Id = 33250, Name = "Searing overload potion (2)"   },
    SearingOverloadFlask1       = { Id = 33248, Name = "Searing overload potion (1)"   },
    OverloadSalveFlask6         = { Id = 33198, Name = "Overload salve (6)"            },
    OverloadSalveFlask5         = { Id = 33196, Name = "Overload salve (5)"            },
    OverloadSalveFlask4         = { Id = 33194, Name = "Overload salve (4)"            },
    OverloadSalveFlask3         = { Id = 33192, Name = "Overload salve (3)"            },
    OverloadSalveFlask2         = { Id = 33190, Name = "Overload salve (2)"            },
    OverloadSalveFlask1         = { Id = 33188, Name = "Overload salve (1)"            },
    HolyAggroverloadFlask6      = { Id = 50877, Name = "Holy aggroverload (6)"         },
    HolyAggroverloadFlask5      = { Id = 50875, Name = "Holy aggroverload (5)"         },
    HolyAggroverloadFlask4      = { Id = 50873, Name = "Holy aggroverload (4)"         },
    HolyAggroverloadFlask3      = { Id = 50871, Name = "Holy aggroverload (3)"         },
    HolyAggroverloadFlask2      = { Id = 50869, Name = "Holy aggroverload (2)"         },
    HolyAggroverloadFlask1      = { Id = 50867, Name = "Holy aggroverload (1)"         }
}

Slib.Items.SupremeOverloads = {
    SupremeOverloadFlask6       = { Id = 33210, Name = "Supreme overload potion (6)"   },
    SupremeOverloadFlask5       = { Id = 33208, Name = "Supreme overload potion (5)"   },
    SupremeOverloadFlask4       = { Id = 33206, Name = "Supreme overload potion (4)"   },
    SupremeOverloadFlask3       = { Id = 33204, Name = "Supreme overload potion (3)"   },
    SupremeOverloadFlask2       = { Id = 33202, Name = "Supreme overload potion (2)"   },
    SupremeOverloadFlask1       = { Id = 33200, Name = "Supreme overload potion (1)"   },
    SupremeOverloadSalveFlask6  = { Id = 33222, Name = "Supreme overload salve (6)"    },
    SupremeOverloadSalveFlask5  = { Id = 33220, Name = "Supreme overload salve (5)"    },
    SupremeOverloadSalveFlask4  = { Id = 33218, Name = "Supreme overload salve (4)"    },
    SupremeOverloadSalveFlask3  = { Id = 33216, Name = "Supreme overload salve (3)"    },
    SupremeOverloadSalveFlask2  = { Id = 33214, Name = "Supreme overload salve (2)"    },
    SupremeOverloadSalveFlask1  = { Id = 33212, Name = "Supreme overload salve (1)"    }
}

Slib.Items.ElderOverloads = {
    ElderOverloadFlask6         = { Id = 49039, Name = "Elder overload potion (6)"     },
    ElderOverloadFlask5         = { Id = 49037, Name = "Elder overload potion (5)"     },
    ElderOverloadFlask4         = { Id = 49035, Name = "Elder overload potion (4)"     },
    ElderOverloadFlask3         = { Id = 49033, Name = "Elder overload potion (3)"     },
    ElderOverloadFlask2         = { Id = 49031, Name = "Elder overload potion (2)"     },
    ElderOverloadFlask1         = { Id = 49029, Name = "Elder overload potion (1)"     },
    ElderOverloadSalveFlask6    = { Id = 49052, Name = "Elder overload salve (6)"      },
    ElderOverloadSalveFlask5    = { Id = 49050, Name = "Elder overload salve (5)"      },
    ElderOverloadSalveFlask4    = { Id = 49048, Name = "Elder overload salve (4)"      },
    ElderOverloadSalveFlask3    = { Id = 49046, Name = "Elder overload salve (3)"      },
    ElderOverloadSalveFlask2    = { Id = 49044, Name = "Elder overload salve (2)"      },
    ElderOverloadSalveFlask1    = { Id = 49042, Name = "Elder overload salve (1)"      }
}

Slib.Items.IncenseSticks = {
    ["Guam"]        = { Id = 47699, Name = "Guam incense sticks"        },
    ["Tarromin"]    = { Id = 47700, Name = "Tarromin incense sticks"    },
    ["Marrentill"]  = { Id = 47701, Name = "Marrentill incense sticks"  },
    ["Harralander"] = { Id = 47702, Name = "Harralander incense sticks" },
    ["Ranarr"]      = { Id = 47703, Name = "Ranarr incense sticks"      },
    ["Toadflax"]    = { Id = 47704, Name = "Toadflax incense sticks"    },
    ["Spirit Weed"] = { Id = 47705, Name = "Spirit weed incense sticks" },
    ["Irit"]        = { Id = 47706, Name = "Irit incense sticks"        },
    ["Wergali"]     = { Id = 47707, Name = "Wergali incense sticks"     },
    ["Avantoe"]     = { Id = 47708, Name = "Avantoe incense sticks"     },
    ["Kwuarm"]      = { Id = 47709, Name = "Kwuarm incense sticks"      },
    ["Bloodweed"]   = { Id = 47710, Name = "Bloodweed incense sticks"   },
    ["Snapdragon"]  = { Id = 47711, Name = "Snapdragon incense sticks"  },
    ["Cadantine"]   = { Id = 47712, Name = "Cadantine incense sticks"   },
    ["Lantadyme"]   = { Id = 47713, Name = "Lantadyme incense sticks"   },
    ["Dwarf Weed"]  = { Id = 47714, Name = "Dwarf weed incense sticks"  },
    ["Torstol"]     = { Id = 47715, Name = "Torstol incense sticks"     },
    ["Fellstalk"]   = { Id = 47716, Name = "Fellstalk incense sticks"   }
}

Slib.Items.WeaponPoisons = {
    --+++
    PlusPlusPlusFlask6 = { Id = 48626, Name = "Weapon poison+++ flask (6)"  },
    PlusPlusPlusFlask5 = { Id = 48628, Name = "Weapon poison+++ flask (5)"  },
    PlusPlusPlusFlask4 = { Id = 48630, Name = "Weapon poison+++ flask (4)"  },
    PlusPlusPlusFlask3 = { Id = 48632, Name = "Weapon poison+++ flask (3)"  },
    PlusPlusPlusFlask2 = { Id = 48634, Name = "Weapon poison+++ flask (2)"  },
    PlusPlusPlusFlask1 = { Id = 48636, Name = "Weapon poison+++ flask (1)"  },
    PlusPlusPlusVial4  = { Id = 49115, Name = "Weapon poison+++ (4)"        },
    PlusPlusPlusVial3  = { Id = 49117, Name = "Weapon poison+++ (3)"        },
    PlusPlusPlusVial2  = { Id = 49119, Name = "Weapon poison+++ (2)"        },
    PlusPlusPlusVial1  = { Id = 49121, Name = "Weapon poison+++ (1)"        },

    --++
    PlusPlusFlask6 = { Id = 25533, Name = "Weapon poison++ flask (6)"       },
    PlusPlusFlask5 = { Id = 25535, Name = "Weapon poison++ flask (5)"       },
    PlusPlusFlask4 = { Id = 25537, Name = "Weapon poison++ flask (4)"       },
    PlusPlusFlask3 = { Id = 25539, Name = "Weapon poison++ flask (3)"       },
    PlusPlusFlask2 = { Id = 25541, Name = "Weapon poison++ flask (2)"       },
    PlusPlusFlask1 = { Id = 25543, Name = "Weapon poison++ flask (1)"       },
    PlusPlusVial4  = { Id = 25501, Name = "Weapon poison++ (4)"             },
    PlusPlusVial3  = { Id = 25503, Name = "Weapon poison++ (3)"             },
    PlusPlusVial2  = { Id = 25505, Name = "Weapon poison++ (2)"             },
    PlusPlusVial1  = { Id = 25507, Name = "Weapon poison++ (1)"             },

    --+
    PlusFlask6 = { Id = 25521, Name = "Weapon poison+ flask (6)"            },
    PlusFlask5 = { Id = 25523, Name = "Weapon poison+ flask (5)"            },
    PlusFlask4 = { Id = 25525, Name = "Weapon poison+ flask (4)"            },
    PlusFlask3 = { Id = 25527, Name = "Weapon poison+ flask (3)"            },
    PlusFlask2 = { Id = 25529, Name = "Weapon poison+ flask (2)"            },
    PlusFlask1 = { Id = 25531, Name = "Weapon poison+ flask (1)"            },
    PlusVial4  = { Id = 25493, Name = "Weapon poison+ (4)"                  },
    PlusVial3  = { Id = 25495, Name = "Weapon poison+ (3)"                  },
    PlusVial2  = { Id = 25497, Name = "Weapon poison+ (2)"                  },
    PlusVial1  = { Id = 25499, Name = "Weapon poison+ (1)"                  },

    --Normal
    NormalFlask6 = { Id = 25509, Name = "Weapon poison flask (6)"           },
    NormalFlask5 = { Id = 25511, Name = "Weapon poison flask (5)"           },
    NormalFlask4 = { Id = 25513, Name = "Weapon poison flask (4)"           },
    NormalFlask3 = { Id = 25515, Name = "Weapon poison flask (3)"           },
    NormalFlask2 = { Id = 25517, Name = "Weapon poison flask (2)"           },
    NormalFlask1 = { Id = 25519, Name = "Weapon poison flask (1)"           },
    NormalVial4  = { Id = 25485, Name = "Weapon poison (4)"                 },
    NormalVial3  = { Id = 25487, Name = "Weapon poison (3)"                 },
    NormalVial2  = { Id = 25489, Name = "Weapon poison (2)"                 },
    NormalVial1  = { Id = 25491, Name = "Weapon poison (1)"                 }
}

Slib.Items.AggressionPotions = {
    AggressionFlask6 = { Id = 37939, Name = "Aggression flask (6)"  },
    AggressionFlask5 = { Id = 37937, Name = "Aggression flask (5)"  },
    AggressionFlask4 = { Id = 37935, Name = "Aggression flask (4)"  },
    AggressionFlask3 = { Id = 37933, Name = "Aggression flask (3)"  },
    AggressionFlask2 = { Id = 37931, Name = "Aggression flask (2)"  },
    AggressionFlask1 = { Id = 37929, Name = "Aggression flask (1)"  },
    AggressionVial4  = { Id = 37971, Name = "Aggression potion (4)" },
    AggressionVial3  = { Id = 37969, Name = "Aggression potion (3)" },
    AggressionVial2  = { Id = 37967, Name = "Aggression potion (2)" },
    AggressionVial1  = { Id = 37965, Name = "Aggression potion (1)" }
}

Slib.Items.CharmingPotions = {
    CharmingFlask6 = { Id = 48662, Name = "Charming potion flask (6)" },
    CharmingFlask5 = { Id = 48664, Name = "Charming potion flask (5)" },
    CharmingFlask4 = { Id = 48666, Name = "Charming potion flask (4)" },
    CharmingFlask3 = { Id = 48668, Name = "Charming potion flask (3)" },
    CharmingFlask2 = { Id = 48670, Name = "Charming potion flask (2)" },
    CharmingFlask1 = { Id = 48672, Name = "Charming potion flask (1)" },
    CharmingVial4  = { Id = 48984, Name = "Charming potion (4)"       },
    CharmingVial3  = { Id = 48986, Name = "Charming potion (3)"       },
    CharmingVial2  = { Id = 48988, Name = "Charming potion (2)"       },
    CharmingVial1  = { Id = 48990, Name = "Charming potion (1)"       }
}

Slib.Items.LuckPotions = {
    LuckPotion          = { Id = 37963, Name = "Luck potion"            },
    EnhancedLuckPotion  = { Id = 39820, Name = "Enhanced luck potion"   }
}

Slib.Buffs.Overloads = {
    Overload    = {Id = 26093, Name = "Overload"        },
    Supreme     = {Id = 33210, Name = "Supreme Overload"},
    Elder       = {Id = 49039, Name = "Elder Overload"  }
}

Slib.Buffs.IncenseSticks = {
    ["Guam"]        = { Id = 47699, Name = "Guam incense sticks"        },
    ["Tarromin"]    = { Id = 47700, Name = "Tarromin incense sticks"    },
    ["Marrentill"]  = { Id = 47701, Name = "Marrentill incense sticks"  },
    ["Harralander"] = { Id = 47702, Name = "Harralander incense sticks" },
    ["Ranarr"]      = { Id = 47703, Name = "Ranarr incense sticks"      },
    ["Toadflax"]    = { Id = 47704, Name = "Toadflax incense sticks"    },
    ["Spirit Weed"] = { Id = 47705, Name = "Spirit weed incense sticks" },
    ["Irit"]        = { Id = 47706, Name = "Irit incense sticks"        },
    ["Wergali"]     = { Id = 47707, Name = "Wergali incense sticks"     },
    ["Avantoe"]     = { Id = 47708, Name = "Avantoe incense sticks"     },
    ["Kwuarm"]      = { Id = 47709, Name = "Kwuarm incense sticks"      },
    ["Bloodweed"]   = { Id = 47710, Name = "Bloodweed incense sticks"   },
    ["Snapdragon"]  = { Id = 47711, Name = "Snapdragon incense sticks"  },
    ["Cadantine"]   = { Id = 47712, Name = "Cadantine incense sticks"   },
    ["Lantadyme"]   = { Id = 47713, Name = "Lantadyme incense sticks"   },
    ["Dwarf Weed"]  = { Id = 47714, Name = "Dwarf weed incense sticks"  },
    ["Torstol"]     = { Id = 47715, Name = "Torstol incense sticks"     },
    ["Fellstalk"]   = { Id = 47716, Name = "Fellstalk incense sticks"   }
}

Slib.Buffs.WeaponPoisons = {
    Poisonous = { Id = 30095, Name = "Poisonous" },
}

Slib.Buffs.AggressionPotions = {
    Aggression = { Id = 37969, Name = "Aggression" }
}

Slib.Buffs.CharmingPotions = {
    Charming = { Id = 48986, Name = "Charming" }
}

Slib.Buffs.LuckPotions = {
    LuckPotion          = { Id = 37963, Name = "LUCK_POTION_ACTIVE"             },
    EnhancedLuckPotion  = { Id = 39820, Name = "ENHANCED_LUCK_POTION_ACTIVE"    }
}

Slib.Buffs.Aspects = {
    ["Vampyrism"]        = { Id = 35768, AbilityId = 35770, Name = "Vampyrism"        },
    ["Penance"]          = { Id = 35769, AbilityId = 35771, Name = "Penance"          },
    ["Darkness"]         = { Id = 30122, AbilityId = 30700, Name = "Darkness"         },
    ["Animate Dead"]     = { Id = 14764, AbilityId = 14768, Name = "Animate Dead"     },
    ["Temporal Anomaly"] = { Id = 1368,  AbilityId = 10367, Name = "Temporal Anomaly" }
}

Slib.Buffs.Powders = {
    ["Powder of Defense"]        = { Id = 52801, ItemId = 52801, Name = "Powder of defense"         },
    ["Powder of Protection"]     = { Id = 52802, ItemId = 52802, Name = "Powder of protection"      },
    ["Powder of Item Protection"]= { Id = 52803, ItemId = 52803, Name = "Powder of item protection" },
    ["Powder of Pulverising"]    = { Id = 52804, ItemId = 52804, Name = "Powder of pulverising"     },
    ["Powder of Burials"]        = { Id = 52805, ItemId = 52805, Name = "Powder of burials"         },
    ["Powder of Penance"]        = { Id = 52806, ItemId = 52806, Name = "Powder of penance"         }
}

Slib.Interfaces.TextInput = { 
    { { 1469,0,-1,0 }, { 1469,1,-1,0 } }
}

Slib.Interfaces.InstanceOptions = {
    { {1591,12,-1,0} }, -- Base
    { {1591,12,-1,0}, {1591,14,-1,0}, {1591,41,-1,0}, {1591,42,-1,0}, {1591,70,-1,0}, {1591,71,-1,0} }, -- Max Players
    { {1591,12,-1,0}, {1591,14,-1,0}, {1591,45,-1,0}, {1591,72,-1,0}, {1591,79,-1,0}, {1591,80,-1,0} }, -- Min Combat
    { {1591,12,-1,0}, {1591,14,-1,0}, {1591,46,-1,0}, {1591,81,-1,0}, {1591,90,-1,0}, {1591,91,-1,0} }, -- Spawn Speed
    { {1591,12,-1,0}, {1591,14,-1,0}, {1591,47,-1,0}, {1591,48,-1,0}, {1591,98,-1,0}, {1591,99,-1,0} } -- Protection

}

Slib.Interfaces.InstanceTimer = { 
    { { 861,0,-1,0 }, { 861,2,-1,0 }, { 861,4,-1,0 }, { 861,8,-1,0 } } -- 1
}

Slib.Interfaces.GWD1KillCounts = {
    { {601,11,-1,0}, {601,9,-1,0}, { 601,18,-1,0 } }, -- Armadyl
    { {601,11,-1,0}, {601,9,-1,0}, { 601,19,-1,0 } }, -- Bandos
    { {601,11,-1,0}, {601,9,-1,0}, { 601,20,-1,0 } }, -- Saradomin
    { {601,11,-1,0}, {601,9,-1,0}, { 601,21,-1,0 } }, -- Zamorak
    { {601,11,-1,0}, {601,9,-1,0}, { 601,22,-1,0 } }  -- Zaros
}

Slib.Interfaces.GWD2KillCounts = {
    { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,43,-1,0 }, { 1746,47,-1,0 } },  -- Seren
    { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,49,-1,0 }, { 1746,54,-1,0 } },  -- Sliske
    { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,55,-1,0 }, { 1746,60,-1,0 } },  -- Zamorak
    { { 1746,0,-1,0 }, { 1746,38,-1,0 }, { 1746,41,-1,0 }, { 1746,61,-1,0 }, { 1746,66,-1,0 } }   -- Zaros
}

Slib.Interfaces.CurrencyPouch = {
    { {1473,0,-1,0}, {1473,12,-1,0}, {1473,16,-1,0}, {1473,17,-1,0}, {1473,20,-1,0} }
}

Slib.Interfaces.AreaLoot = {
    { {1622,4,-1,0}, {1622,6,-1,0}, {1622,1,-1,0}, {1622,11,-1,0} }
}

Slib.ChatMessages = {} -- filled by RecentMessageCheck (GatherEvents_chat_check is destructive; not run at require)

-- ##################################
-- #                                #
-- #       LOGGING FUNCTIONS        #
-- #                                #
-- ##################################

-- Static flag to track if logs directory has been created
Slib._logsDirectoryCreated = false

-- Static cache for player name to avoid issues when character goes to lobby/dc
Slib._cachedPlayerName = nil

-- Static cache for session-specific log filename
Slib._sessionLogFileName = nil

-- Static flag to control file writing behavior
-- Set this to true at the start of your script to enable file logging
Slib._writeToFile = false

-- Helper function to create logs directory without command prompt flash
---@return boolean success True if directory exists or was created successfully
function Slib:EnsureLogsDirectory()
    -- Only try to create directory once per script run
    if self._logsDirectoryCreated then
        return true
    end
    
    -- Get the logs directory path
    local LogsDir = os.getenv("USERPROFILE") .. "\\MemoryError\\Lua_Scripts\\logs\\"
    
    -- Try to create a test file in the logs directory
    local TestFilePath = LogsDir .. "test.tmp"
    local TestFile = io.open(TestFilePath, "w")
    if TestFile then
        -- Directory exists, clean up test file
        TestFile:close()
        os.remove(TestFilePath)
        self._logsDirectoryCreated = true
        return true
    end
    
    -- Directory doesn't exist, try to create it using file system approach
    local Success = pcall(function()
        -- Create the full directory path using mkdir with /p flag for creating parent directories
        local Handle = io.popen('mkdir "' .. LogsDir .. '" 2>nul', 'r')
        if Handle then
            Handle:close()
        end
    end)
    
    -- Verify directory was created by testing file creation again
    local VerifyFile = io.open(TestFilePath, "w")
    if VerifyFile then
        VerifyFile:close()
        os.remove(TestFilePath)
        self._logsDirectoryCreated = true
        return true
    end
    
    return false
end

-- Helper function to write log messages to file
---@param Level string The log level (LOG, INFO, WARN, ERROR)
---@param Message string The message to write to file
---@return boolean success True if file write was successful, false otherwise
function Slib:WriteToLogFile(Level, Message)
    -- Generate session-specific filename if not already cached
    if not self._sessionLogFileName then
        -- Get player name for filename (use cached name if available)
        local PlayerName = self._cachedPlayerName
        
        -- If no cached name, try to get current player name
        if not PlayerName then
            local CurrentPlayerName = API.GetLocalPlayerName()
            if CurrentPlayerName and CurrentPlayerName ~= "" then
                -- Cache the valid player name for future use
                self._cachedPlayerName = CurrentPlayerName
                PlayerName = CurrentPlayerName
            else
                PlayerName = "Unknown_Player"
            end
        end
        
        -- Clean player name for filename (remove invalid characters)
        PlayerName = string.gsub(PlayerName, "[<>:\"/\\|?*]", "_")
        
        -- Generate session timestamp for unique filename
        local SessionTimestamp = os.date("%Y-%m-%d_%H-%M-%S")
        
        -- Create session-specific filename and cache it
        self._sessionLogFileName = PlayerName .. "_" .. SessionTimestamp .. ".txt"
    end
    
    -- Create logs directory path
    local LogsDir = os.getenv("USERPROFILE") .. "\\MemoryError\\Lua_Scripts\\logs\\"
    local LogFilePath = LogsDir .. self._sessionLogFileName
    
    -- Ensure logs directory exists (only once per script run)
    if not self:EnsureLogsDirectory() then
        return false
    end
    
    -- Get current timestamp
    local Timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    -- Format log entry
    local LogEntry = string.format("[%s] [Slib][%s] %s\n", Timestamp, Level, Message)
    
    -- Write to file
    local File, Err = io.open(LogFilePath, "a")
    if not File then
        -- Silent failure to avoid logging errors in logging system
        return false
    end
    
    local Success, WriteErr = pcall(function()
        File:write(LogEntry)
        File:flush()
        File:close()
    end)
    
    if not Success then
        -- Silent failure to avoid logging errors in logging system
        if File then
            pcall(File.close, File)
        end
        return false
    end
    
    return true
end

-- Logs a general message with Slib prefix
---@param Message string The message to log
---@return string Message The logged message
function Slib:Log(Message)
    if not self:Sanitize(Message, "string", "Message") then
        return ""
    end
    
    API.printlua("[Slib][LOG] " .. tostring(Message), 0, false)
    if self._writeToFile then
        self:WriteToLogFile("LOG", tostring(Message))
    end
    return Message
end

-- Logs an informational message with INFO level
---@param Message string The informational message to log
---@return string Message The logged message
function Slib:Info(Message)
    if not self:Sanitize(Message, "string", "Message") then
        return ""
    end
    
    API.printlua("[Slib][INFO] " .. tostring(Message), 7, false)
    if self._writeToFile then
        self:WriteToLogFile("INFO", tostring(Message))
    end
    return Message
end

-- Logs a warning message with WARN level
---@param Message string The warning message to log
---@return string Message The logged message
function Slib:Warn(Message)
    if not self:Sanitize(Message, "string", "Message") then
        return ""
    end
    
    API.printlua("[Slib][WARN] " .. tostring(Message), 2, false)
    if self._writeToFile then
        self:WriteToLogFile("WARN", tostring(Message))
    end
    return Message
end

-- Logs an error message with ERROR level
---@param Message string The error message to log
---@return string Message The logged message
function Slib:Error(Message)
    -- Manual validation to avoid circular dependency with sanitization system
    if Message == nil then
        API.printlua("[Slib][ERROR] Error function received nil message", 4, false)
        if self._writeToFile then
            self:WriteToLogFile("ERROR", "Error function received nil message")
        end
        return ""
    end
    if type(Message) ~= "string" then
        local ErrorMsg = "Error function received non-string message: " .. tostring(Message)
        API.printlua("[Slib][ERROR] " .. ErrorMsg, 4, false)
        if self._writeToFile then
            self:WriteToLogFile("ERROR", ErrorMsg)
        end
        return tostring(Message)
    end
    
    API.printlua("[Slib][ERROR] " .. tostring(Message), 4, false)
    if self._writeToFile then
        self:WriteToLogFile("ERROR", tostring(Message))
    end
    return Message
end

-- ##################################
-- #                                #
-- #    SANITIZATION FUNCTIONS      #
-- #                                #
-- ##################################

-- Validates that a value matches the specified type(s) with support for complex types
---
--- **Basic Lua Types:**
---   - "string", "number", "boolean", "function", "table", "userdata", "thread"
---   - "any" - accepts any non-nil value (unless AllowNil is true)
---
--- **Enhanced Number Types:**
---   - "id" - non-negative integers (0, 1, 2, 3...)
---   - "positive_number" - numbers greater than 0
---   - "non_negative_number" - numbers >= 0  
---   - "integer" - whole numbers (positive, negative, or zero)
---
--- **Enhanced String Types:**
---   - "non_empty_string" - strings that aren't empty
---
--- **Table Types:**
---   - "table_of_strings" - array of strings
---   - "table_of_numbers" - array of numbers
---   - "table_of_ids" - array of non-negative integers
---   - "table_of_positive_numbers" - array of positive numbers
---   - "table_of_integers" - array of whole numbers
---   - "non_empty_table" - table that has at least one element
---
---@param Value any The value to validate
---@param ExpectedType string|table The expected type(s) - can be single type or array of types
---@param ParamName string|nil Optional parameter name for error messages (default: "Parameter")
---@param AllowNil boolean|nil Whether nil values should be considered valid (optional, default: false)
---@param CallingFunction string|nil Optional calling function name for error messages
---@return boolean IsValid True if validation passes, false otherwise (errors logged via self:Error)
function Slib:Sanitize(Value, ExpectedType, ParamName, AllowNil, CallingFunction)
    -- Set defaults
    ParamName = ParamName or "Parameter"
    if AllowNil == nil then
        AllowNil = false
    end
    
    -- Get calling function name for better error messages
    if not CallingFunction then
        CallingFunction = "Unknown"
        local Info = debug.getinfo(2, "n")
        if Info and Info.name then
            CallingFunction = Info.name
        end
    end
    
    -- Handle nil values
    if Value == nil then
        if AllowNil then
            return true
        else
            self:Error("[" .. CallingFunction .. "] " .. ParamName .. " cannot be nil")
            return false
        end
    end
    
    -- Ensure ExpectedType is a table for consistent processing
    local TypeTable = type(ExpectedType) == "table" and ExpectedType or {ExpectedType}
    
    -- Get actual type of the value
    local ActualType = type(Value)
    
    -- Check each expected type
    for _, ExpectedPattern in ipairs(TypeTable) do
        if type(ExpectedPattern) ~= "string" then
            self:Error("[" .. CallingFunction .. "] Invalid type specification: " .. tostring(ExpectedPattern))
            return false
        end
        
        -- Check basic Lua types
        if ExpectedPattern == ActualType then
            return true
        end
        
        -- Check for 'any' type (accepts anything except nil unless AllowNil is true)
        if ExpectedPattern == "any" then
            return true
        end
        
        -- Check for 'id' type (non-negative integer)
        if ExpectedPattern == "id" then
            if ActualType == "number" and Value >= 0 and math.floor(Value) == Value then
                return true
            end
        end
        
        -- Check for 'positive_number' type
        if ExpectedPattern == "positive_number" then
            if ActualType == "number" and Value > 0 then
                return true
            end
        end
        
        -- Check for 'non_negative_number' type
        if ExpectedPattern == "non_negative_number" then
            if ActualType == "number" and Value >= 0 then
                return true
            end
        end
        
        -- Check for 'integer' type
        if ExpectedPattern == "integer" then
            if ActualType == "number" and math.floor(Value) == Value then
                return true
            end
        end
        
        -- Check for 'non_empty_string' type
        if ExpectedPattern == "non_empty_string" then
            if ActualType == "string" and Value ~= "" then
                return true
            end
        end
        
        -- Check for table-based complex types
        if ActualType == "table" or ActualType == "userdata" then
            -- Check for 'table_of_strings'
            if ExpectedPattern == "table_of_strings" then
                for I, Item in ipairs(Value) do
                    if type(Item) ~= "string" then
                        self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be a table of strings (item " .. I .. " is " .. type(Item) .. ")")
                        return false
                    end
                end
                return true
            end
            
            -- Check for 'table_of_numbers'
            if ExpectedPattern == "table_of_numbers" then
                for I, Item in ipairs(Value) do
                    if type(Item) ~= "number" then
                        self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be a table of numbers (item " .. I .. " is " .. type(Item) .. ")")
                        return false
                    end
                end
                return true
            end
            
            -- Check for 'table_of_ids'
            if ExpectedPattern == "table_of_ids" then
                for I, Item in ipairs(Value) do
                    if type(Item) ~= "number" or Item < 0 or math.floor(Item) ~= Item then
                        self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be a table of IDs (non-negative integers) (item " .. I .. " is invalid)")
                        return false
                    end
                end
                return true
            end
            
            -- Check for 'table_of_positive_numbers'
            if ExpectedPattern == "table_of_positive_numbers" then
                for I, Item in ipairs(Value) do
                    if type(Item) ~= "number" or Item <= 0 then
                        self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be a table of positive numbers (item " .. I .. " is invalid)")
                        return false
                    end
                end
                return true
            end
            
            -- Check for 'table_of_integers'
            if ExpectedPattern == "table_of_integers" then
                for I, Item in ipairs(Value) do
                    if type(Item) ~= "number" or math.floor(Item) ~= Item then
                        self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be a table of integers (item " .. I .. " is invalid)")
                        return false
                    end
                end
                return true
            end
            
            -- Check for 'non_empty_table'
            if ExpectedPattern == "non_empty_table" then
                if next(Value) ~= nil then
                    return true
                else
                    self:Error("[" .. CallingFunction .. "] " .. ParamName .. " cannot be an empty table")
                    return false
                end
            end
            

        end
    end
    
    -- If no types matched, log error and return false
    local ExpectedStr = type(ExpectedType) == "table" and table.concat(ExpectedType, " or ") or tostring(ExpectedType)
    self:Error("[" .. CallingFunction .. "] " .. ParamName .. " must be " .. ExpectedStr .. " (got " .. ActualType .. ")")
    return false
end

-- Validates function parameters using the sanitization system
---
--- **Usage Examples:**
--- -- Basic validation
--- if not self:ValidateParams({
---     {PlayerName, "non_empty_string", "PlayerName"},
---     {NpcIds, "table_of_ids", "NpcIds"},
---     {Range, "positive_number", "Range"}
--- }) then
---     return false
--- end
---
--- -- With optional parameters
--- if not self:ValidateParams({
---     {ItemId, "id", "ItemId"},
---     {Timeout, "positive_number", "Timeout", true}, -- AllowNil = true
---     {Options, "table", "Options", true}
--- }) then
---     return false
--- end
---
--- -- Multiple allowed types
--- if not self:ValidateParams({
---     {SearchCriteria, {"string", "table_of_strings"}, "SearchCriteria"},
---     {Coords, {"number", "table_of_numbers"}, "Coords"}
--- }) then
---     return false
--- end
---
---@param Params table Array of parameter specs: {Value, ExpectedType, ParamName, AllowNil}
---   - **Value**: The parameter value to validate
---   - **ExpectedType**: Type(s) to validate against (see Sanitize documentation for all types)
---   - **ParamName**: Name for error messages (optional, defaults to "Parameter N")
---   - **AllowNil**: Whether nil is acceptable (optional, defaults to false)
---@return boolean AllValid True if all parameters are valid, false otherwise (errors logged via self:Error)
function Slib:ValidateParams(Params)
    -- Get calling function name for better error messages
    local CallingFunction = "Unknown"
    local Info = debug.getinfo(2, "n")
    if Info and Info.name then
        CallingFunction = Info.name
    end
    
    if not Params or type(Params) ~= "table" then
        self:Error("[" .. CallingFunction .. "] ValidateParams requires a table of parameter specifications")
        return false
    end
    
    for I, ParamSpec in ipairs(Params) do
        if type(ParamSpec) ~= "table" then
            self:Error("[" .. CallingFunction .. "] Parameter specification " .. I .. " must be a table")
            return false
        end
        
        -- Extract parameters with explicit nil checking to handle false values
        local Value
        if ParamSpec[1] ~= nil then
            Value = ParamSpec[1]
        else
            Value = ParamSpec.Value
        end
        
        local ExpectedType = ParamSpec[2] or ParamSpec.ExpectedType
        local ParamName = ParamSpec[3] or ParamSpec.ParamName or ("Parameter " .. I)
        
        local AllowNil
        if ParamSpec[4] ~= nil then
            AllowNil = ParamSpec[4]
        else
            AllowNil = ParamSpec.AllowNil or false
        end
        
        if not self:Sanitize(Value, ExpectedType, ParamName, AllowNil, CallingFunction) then
            return false
        end
    end
    
    return true
end

-- ##################################
-- #                                #
-- #       UTILITY FUNCTIONS        #
-- #                                #
-- ##################################

-- Generic sleep function
---@param Duration number The sleep duration (must be positive)
---@param Unit string The time unit: "ms", "s", "m", "h", "tick" (milliseconds, seconds, minutes, hours, ticks)
---@return boolean success True if sleep completed successfully, false if interrupted or invalid parameters
function Slib:Sleep(Duration, Unit)
    -- Parameter validation
    if not self:ValidateParams({
        {Duration, "positive_number", "Duration"},
        {Unit, "string", "Unit"}
    }) then
        return false
    end
    
    -- Normalize unit to lowercase
    Unit = string.lower(Unit)
    
    -- Handle tick-based sleep separately
    if Unit == "tick" or Unit == "ticks" or Unit == "t" then
        local StartTick = API.Get_tick()
        local TargetTick = StartTick + Duration
        
        while API.Read_LoopyLoop() and API.Get_tick() < TargetTick do
            -- Yield CPU briefly while waiting for ticks
            collectgarbage("step", 1)
        end
        
        return API.Get_tick() >= TargetTick
    end
    
    -- Convert duration to seconds and implement sleep logic for time-based units
    local TargetDuration = 0
    local YieldInterval = 0
    
    if Unit == "ms" or Unit == "milli" or Unit == "millisecond" or Unit == "milliseconds" then
        TargetDuration = Duration / 1000
        YieldInterval = 0.001  -- 1ms yield for precision
    elseif Unit == "s" or Unit == "sec" or Unit == "second" or Unit == "seconds" then
        TargetDuration = Duration
        YieldInterval = 0.01   -- 10ms yield for balance
    elseif Unit == "m" or Unit == "min" or Unit == "minute" or Unit == "minutes" then
        TargetDuration = Duration * 60
        YieldInterval = 0.1    -- 100ms yield for longer sleeps
    elseif Unit == "h" or Unit == "hr" or Unit == "hour" or Unit == "hours" then
        TargetDuration = Duration * 3600
        YieldInterval = 0.5    -- 500ms yield for very long sleeps
    else
        self:Error("Invalid time unit: " .. Unit .. ". Valid units: ms, s, m, h, tick")
        return false
    end
    
    -- Implement sleep logic
    local StartTime = os.clock()
    local LastYield = StartTime
    
    while API.Read_LoopyLoop() and (os.clock() - StartTime) < TargetDuration do
        -- Yield CPU at appropriate intervals based on duration
        if (os.clock() - LastYield) >= YieldInterval then
            -- Force garbage collection periodically to yield CPU
            collectgarbage("step", 1)
            LastYield = os.clock()
        end
    end
    
    return (os.clock() - StartTime) >= TargetDuration
end

-- Sleeps for a random duration between min and max values
---@param MinDuration number The minimum sleep duration (must be positive)
---@param MaxDuration number The maximum sleep duration (must be greater than MinDuration)
---@param Unit string The time unit: "ms", "s", "m", "h", "tick" (milliseconds, seconds, minutes, hours, ticks)
---@return boolean success True if sleep completed successfully, false if interrupted or invalid parameters
function Slib:RandomSleep(MinDuration, MaxDuration, Unit)
    -- Parameter validation
    if not self:ValidateParams({
        {MinDuration, "positive_number", "MinDuration"},
        {MaxDuration, "positive_number", "MaxDuration"},
        {Unit, "string", "Unit"}
    }) then
        return false
    end
    
    -- Validate min/max relationship
    if MinDuration >= MaxDuration then
        self:Error("[RandomSleep] MinDuration must be less than MaxDuration")
        return false
    end
    
    -- Generate random duration
    local Duration
    if string.lower(Unit) == "tick" or string.lower(Unit) == "ticks" or string.lower(Unit) == "t" then
        -- For ticks, use integer values
        Duration = math.random(MinDuration, MaxDuration)
        self:Info(string.format("[RandomSleep] Sleeping for %d %s", Duration, Unit))
    else
        -- For time-based units, use decimal values
        Duration = MinDuration + math.random() * (MaxDuration - MinDuration)
        self:Info(string.format("[RandomSleep] Sleeping for %.2f %s", Duration, Unit))
    end
    
    -- Use existing Sleep function
    return self:Sleep(Duration, Unit)
end

-- Sleeps until a condition is met or timeout occurs
---@param ConditionFunc function The function to check (should return boolean)
---@param TimeoutSeconds number|nil Maximum wait time in seconds (optional, default: 30)
---@param CheckIntervalMs number|nil How often to check condition in milliseconds (optional, default: 100)
---@return boolean success True if condition was met, false if timeout or error occurred
function Slib:SleepUntil(ConditionFunc, TimeoutSeconds, CheckIntervalMs)
    -- Set defaults
    TimeoutSeconds = TimeoutSeconds or 30
    CheckIntervalMs = CheckIntervalMs or 100
    
    -- Parameter validation
    if not self:ValidateParams({
        {ConditionFunc, "function", "ConditionFunc"},
        {TimeoutSeconds, "positive_number", "TimeoutSeconds"},
        {CheckIntervalMs, "positive_number", "CheckIntervalMs"}
    }) then
        return false
    end
    
    local StartTime = os.clock()
    local MaxTime = TimeoutSeconds
    local CheckCount = 0
    
    self:Info("Waiting for condition with " .. TimeoutSeconds .. "s timeout, checking every " .. CheckIntervalMs .. "ms...")
    
    while API.Read_LoopyLoop() do
        CheckCount = CheckCount + 1
        
        -- Check timeout
        if (os.clock() - StartTime) >= MaxTime then
            self:Warn("Timeout reached (" .. TimeoutSeconds .. "s) after " .. CheckCount .. " condition checks")
            return false
        end
        
        -- Test condition with error handling
        local Success, Result = pcall(ConditionFunc)
        if not Success then
            self:Error("Condition function error: " .. tostring(Result))
            return false
        end
        
        if Result then
            local Elapsed = os.clock() - StartTime
            self:Info("Condition met after " .. string.format("%.2f", Elapsed) .. " seconds (" .. CheckCount .. " checks)")
            return true
        end
        
        -- Sleep between checks
        self:Sleep(CheckIntervalMs, "ms")
    end
    
    self:Warn("Loop stopped while waiting for condition after " .. CheckCount .. " checks")
    return false
end

-- Sleeps and performs action until a condition is met or timeout occurs
---@param ConditionFunc function The function to check (should return boolean)
---@param TimeoutSeconds number|nil Maximum wait time in seconds (optional, default: 30)
---@param CheckIntervalMs number|nil How often to check condition in milliseconds (optional, default: 100)
---@param ActionFunc function The function to perform until the condition is true
---@param ActionInterval number|nil How often to call ActionFunc in milliseconds (optional, default: 600)
---@return boolean success True if condition was met, false if timeout or error occurred
function Slib:WorkSleepUntil(ConditionFunc, TimeoutSeconds, CheckIntervalMs, ActionFunc, ActionInterval)
    -- Set defaults
    TimeoutSeconds = TimeoutSeconds or 30
    CheckIntervalMs = CheckIntervalMs or 100
    ActionInterval = ActionInterval or 600

    -- Parameter validation
    if not self:ValidateParams({
        {ConditionFunc, "function", "ConditionFunc"},
        {TimeoutSeconds, "positive_number", "TimeoutSeconds"},
        {CheckIntervalMs, "positive_number", "CheckIntervalMs"},
        {ActionFunc, "function", "ActionFunc"},
        {ActionInterval, "positive_number", "ActionInterval"}
    }) then
        return false
    end

    local StartTime = os.clock()
    local MaxTime = TimeoutSeconds
    local CheckCount = 0
    local ActionClickInterval = math.max(1, math.floor(ActionInterval / CheckIntervalMs))

    self:Info("Waiting for condition with " .. TimeoutSeconds .. "s timeout, checking every " .. CheckIntervalMs .. "ms, acting every " .. ActionInterval .. "ms...")

    while API.Read_LoopyLoop() do
        CheckCount = CheckCount + 1

        -- Check timeout
        if (os.clock() - StartTime) >= MaxTime then
            self:Warn("Timeout reached (" .. TimeoutSeconds .. "s) after " .. CheckCount .. " condition checks")
            return false
        end

        -- Test condition with error handling
        local Success, Result = pcall(ConditionFunc)
        if not Success then
            self:Error("Condition function error: " .. tostring(Result))
            return false
        end

        if Result then
            local Elapsed = os.clock() - StartTime
            self:Info("Condition met after " .. string.format("%.2f", Elapsed) .. " seconds (" .. CheckCount .. " checks)")
            return true
        end

        -- Perform action on interval
        if CheckCount % ActionClickInterval == 0 then
            local ActionSuccess, ActionResult = pcall(ActionFunc)
            if not ActionSuccess then
                self:Error("Action function error: " .. tostring(ActionResult))
                return false
            end
        end

        -- Sleep between checks
        self:Sleep(CheckIntervalMs, "ms")
    end

    self:Warn("Loop stopped while waiting for condition after " .. CheckCount .. " checks")
    return false
end

-- Converts a character to its corresponding Windows Virtual-Key code
-- Only supports letters (A-Z, a-z), numbers (0-9), and spaces
---@param char string Single character to convert (letters, numbers, spaces only)
---@return number|nil vkCode Virtual-Key code for the character, or nil if unsupported character
function Slib:CharToVirtualKey(char)
    -- Parameter validation
    if not self:ValidateParams({
        {char, "string", "char"}
    }) then
        self:Error("[CharToVirtualKey] Invalid character parameter")
        return nil
    end
    
    if #char ~= 1 then
        self:Error("[CharToVirtualKey] Parameter must be a single character, received: '" .. char .. "'")
        return nil
    end
    
    local byte = string.byte(char)
    
    -- Space character
    if char == " " then
        return 0x20 -- VK_SPACE
    end
    
    -- Letters A-Z (convert both uppercase and lowercase to uppercase VK codes)
    if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) then
        local upperChar = string.upper(char)
        return string.byte(upperChar) -- VK_A=0x41 through VK_Z=0x5A
    end
    
    -- Numbers 0-9 (Virtual-Key codes match ASCII values)
    if byte >= 48 and byte <= 57 then
        return byte -- VK_0=0x30 through VK_9=0x39
    end
    
    -- Unsupported character
    self:Error(string.format("[CharToVirtualKey] Unsupported character: '%s' (ASCII: %d, Hex: 0x%02X)", char, byte, byte))
    self:Error("[CharToVirtualKey] Only letters (A-Z, a-z), numbers (0-9), and spaces are supported")
    
    return nil
end

--- Retrieves the virtual-key code (VK) for a supported special key.
--- @param key string # The name of the special key (case-insensitive).
--- @return number|nil # Returns the virtual-key code if the key is supported; Otherwise returns nil.                   
function Slib:GetSpecialKeyVK(key)
    local keys = {
        F1 = 0x70, F2 = 0x71, F3 = 0x72, F4 = 0x73,
        F5 = 0x74, F6 = 0x75, F7 = 0x76, F8 = 0x77,
        F9 = 0x78, F10 = 0x79, F11 = 0x7A, F12 = 0x7B,
        
        ENTER = 0x0D,
        TAB = 0x09,
        ESC = 0x1B,
        SHIFT = 0x10,
        CTRL = 0x11,
        ALT = 0x12
    }

    return keys[string.upper(key)]
end

-- Generates a random number between Min and Max and adds it to the Base
---@param Base number The base number to add the random number to
---@param Min number The minimum value of the random number
---@param Max number The maximum value of the random number
---@return number RandomNumber The random number generated
function Slib:RandomNumber(Base, Min, Max)
    -- Parameter validation
    if not self:ValidateParams({
        {Base, "number", "Base"},
        {Min, "number", "Min"},
        {Max, "number", "Max"}
    }) then
        return false
    end

    local RandomNumber = math.random(Min, Max)
    return Base + RandomNumber
end

-- Returns a table of IDs from a table of items in the form of {Id = 12345, Name = "Item Name"}
---@param TB table
function Slib:GetIDSFromTable(TB)
    local ids = {}
    for _, item in pairs(TB) do
        if type(item) == "table" and item.Id then
            table.insert(ids, item.Id)
        end
    end
    return ids
end

-- ##################################
-- #                                #
-- #       DEBUG FUNCTIONS          #
-- #                                #
-- ##################################

-- Prints all the buffs currently active with detailed information
---@return boolean Success True if buffs were found and printed, false if no buffs or error occurred
function Slib:PrintBuffs()
    -- Protected API call with validation
    local Buffs = API.Buffbar_GetAllIDs()
    
    -- Check if API returned valid data
    if not Buffs then
        self:Error("API returned nil for buffs")
        return false
    end
    
    if type(Buffs) ~= "table" and type(Buffs) ~= "userdata" then
        self:Error("API returned invalid buff data type: " .. type(Buffs))
        return false
    end
    
    if #Buffs == 0 then
        self:Info("No buffs currently active")
        return false
    end
    
    self:Info("Found " .. #Buffs .. " active buffs:")
    print("")
    
    -- Safe iteration with bounds checking
    for I = 1, #Buffs do
        local Buff = Buffs[I]
        
        -- Check if buff exists and is valid
        if not Buff then
            self:Warn("Skipping nil buff at index " .. I)
            goto continue
        end
        
        if type(Buff) ~= "table" and type(Buff) ~= "userdata" then
            self:Warn("Skipping invalid buff at index " .. I .. " (type: " .. type(Buff) .. ")")
            goto continue
        end
        
        -- Format buff information with nice borders
        print("+=========================+")
        print("|         BUFF #" .. I .. "         |")
        print("+=========================+")
        print("|   ID             : " .. tostring(Buff.id or "N/A"))
        print("|   Found          : " .. tostring(Buff.found or "N/A"))
        print("|   Text           : " .. tostring(Buff.text or "N/A"))
        print("|   Conv Text      : " .. tostring(Buff.conv_text or "N/A"))      
        print("+=========================+")
        print("")
        
        ::continue::
    end
    
    self:Info("Buff scan completed successfully")
    return true
end

-- Prints all the debuffs currently active with detailed information
---@return boolean Success True if debuffs were found and printed, false if no debuffs or error occurred
function Slib:PrintDebuffs()
    -- Protected API call with validation
    local Debuffs = API.DeBuffbar_GetAllIDs()
    
    -- Check if API returned valid data
    if not Debuffs then
        self:Error("API returned nil for debuffs")
        return false
    end
    
    if type(Debuffs) ~= "table" and type(Debuffs) ~= "userdata" then
        self:Error("API returned invalid debuff data type: " .. type(Debuffs))
        return false
    end
    
    if #Debuffs == 0 then
        self:Info("No debuffs currently active")
        return false
    end
    
    self:Info("Found " .. #Debuffs .. " active debuffs:")
    print("")
    
    -- Safe iteration with bounds checking
    for I = 1, #Debuffs do
        local Debuff = Debuffs[I]
        
        -- Check if debuff exists and is valid
        if not Debuff then
            self:Warn("Skipping nil debuff at index " .. I)
            goto continue
        end
        
        if type(Debuff) ~= "table" and type(Debuff) ~= "userdata" then
            self:Warn("Skipping invalid debuff at index " .. I .. " (type: " .. type(Debuff) .. ")")
            goto continue
        end
        
        -- Format debuff information with nice borders
        print("+=========================+")
        print("|        DEBUFF #" .. I .. "        |")
        print("+=========================+")
        print("|   ID             : " .. tostring(Debuff.id or "N/A"))
        print("|   Found          : " .. tostring(Debuff.found or "N/A"))
        print("|   Text           : " .. tostring(Debuff.text or "N/A"))
        print("|   Conv Text      : " .. tostring(Debuff.conv_text or "N/A"))
        
        -- Add additional fields if they exist
        if Debuff.duration then
            print("|   Duration       : " .. tostring(Debuff.duration))
        end
        
        if Debuff.remaining then
            print("|   Remaining      : " .. tostring(Debuff.remaining))
        end
        
        if Debuff.stacks then
            print("|   Stacks         : " .. tostring(Debuff.stacks))
        end
        
        if Debuff.icon then
            print("|   Icon           : " .. tostring(Debuff.icon))
        end
        
        print("+=========================+")
        print("")
        
        ::continue::
    end
    
    self:Info("Debuff scan completed successfully")
    return true
end

-- Prints container contents with detailed information for each item (93 = inventory, 94 = equipment, 95 = bank)
---@param ContainerId number
---@return boolean Success
function Slib:PrintContainer(ContainerId)
    -- Parameter validation
    if not self:Sanitize(ContainerId, "number", "ContainerId") then
        return false
    end
    
    -- API call to get container contents
    local Items = API.Container_Get_all(ContainerId)
    
    -- Check if API returned valid data
    if not Items then
        self:Error("API returned nil for container " .. ContainerId)
        return false
    end
    
    if type(Items) ~= "table" and type(Items) ~= "userdata" then
        self:Error("API returned invalid container data type: " .. type(Items))
        return false
    end
    
    if #Items == 0 then
        self:Info("Container " .. ContainerId .. " is empty")
        return false
    end

    -- Count valid items (items with valid item_id >= 0)
    local ValidItemCount = 0
    for I = 1, #Items do
        local Item = Items[I]
        if Item and Item.item_id and Item.item_id >= 0 then
            ValidItemCount = ValidItemCount + 1
        end
    end
    
    if ValidItemCount == 0 then
        self:Info("Container " .. ContainerId .. " has no valid items")
        return false
    end
    
    self:Info("=== Container " .. ContainerId .. " Contents ===")
    self:Info("Valid items: " .. ValidItemCount .. " / " .. #Items .. " total slots")
    print("")

    -- Safe iteration with bounds checking
    for I = 1, #Items do
        local Item = Items[I]
        local ItemName = nil
        if Item and Item.item_id and Item.item_id >= 0 and Item.Get then
            local Success, ItemData = pcall(Item.Get, Item, Item.item_id)
            if Success and ItemData and ItemData.name then
                ItemName = ItemData.name
            end
        elseif Item and Item.item_id and Item.item_id >= 0 and Item.Get == nil and Item.Get ~= nil then
            -- fallback if Item is not a class instance, try global Item
            if Item.Get then
                local Success, ItemData = pcall(Item.Get, Item.item_id)
                if Success and ItemData and ItemData.name then
                    ItemName = ItemData.name
                end
            end
        elseif _G.Item and _G.Item.Get then
            local Success, ItemData = pcall(_G.Item.Get, _G.Item, Item.item_id)
            if Success and ItemData and ItemData.name then
                ItemName = ItemData.name
            end
        end
        
        -- Check if item exists and is valid
        if not Item then
            self:Warn("Skipping nil item at slot " .. I)
            goto continue
        end
        
        if type(Item) ~= "table" and type(Item) ~= "userdata" then
            self:Warn("Skipping invalid item at slot " .. I .. " (type: " .. type(Item) .. ")")
            goto continue
        end
        
        -- Only print items that have a valid item_id (>= 0)
        if not Item.item_id or Item.item_id < 0 then
            goto continue
        end
        
        -- Format item information with nice borders
        print("+========================+")
        print("|      ITEM #" .. I .. "          |")
        print("+========================+")
        print("|   Item Name      : " .. tostring(ItemName or "N/A"))
        print("|   Item ID        : " .. tostring(Item.item_id or "N/A"))
        print("|   Item Stack     : " .. tostring(Item.item_stack or "N/A"))
        print("|   Item Slot      : " .. tostring(Item.item_slot or "N/A"))
        
        -- Print Extra_mem table if it exists
        print("|   Extra_mem      :")
        if Item.Extra_mem then
            if type(Item.Extra_mem) == "table" or type(Item.Extra_mem) == "userdata" then
                local MemCount = 0
                for K, V in pairs(Item.Extra_mem) do
                    print("|     " .. tostring(K) .. " : " .. tostring(V))
                    MemCount = MemCount + 1
                end
                if MemCount == 0 then
                    print("|     (empty)")
                end
            else
                print("|     (type: " .. type(Item.Extra_mem) .. ", value: " .. tostring(Item.Extra_mem) .. ")")
            end
        else
            print("|     N/A")
        end
        
        -- Print Extra_ints table if it exists
        print("|   Extra_ints     :")
        if Item.Extra_ints then
            if type(Item.Extra_ints) == "table" or type(Item.Extra_ints) == "userdata" then
                local IntCount = 0
                for K, V in pairs(Item.Extra_ints) do
                    print("|     " .. tostring(K) .. " : " .. tostring(V))
                    IntCount = IntCount + 1
                end
                if IntCount == 0 then
                    print("|     (empty)")
                end
            else
                print("|     (type: " .. type(Item.Extra_ints) .. ", value: " .. tostring(Item.Extra_ints) .. ")")
            end
        else
            print("|     N/A")
        end
        
        print("+========================+")
        print("")
        
        ::continue::
    end
    
    self:Info("Container scan completed successfully")
    return true
end

-- Searches containers 1-10000 for a specific item ID and returns detailed results
---@param ItemId number The item ID to search for
---@return table|nil results Table containing search results, or nil if item not found
---@return table results.containers Array of container data where item was found
---@return number results.total_found Total number of containers containing the item
---@return number results.total_quantity Total quantity of the item found across all containers
function Slib:FindItemInContainers(ItemId)
    -- Parameter validation
    if not self:ValidateParams({
        {ItemId, "id", "ItemId"}
    }) then
        return nil
    end
    
    -- Progress is always printed every 1000 containers
    
    self:Info("Starting search for item ID " .. ItemId .. " in containers 1-10000...")
    
    local Results = {
        containers = {},
        total_found = 0,
        total_quantity = 0
    }
    
    local ContainersScanned = 0
    local ContainersWithItems = 0
    local ContainersWithTargetItem = 0
    
    -- Search through containers 1 to 10000
    for ContainerId = 1, 10000 do
        ContainersScanned = ContainersScanned + 1
        
        -- Progress reporting every 1000 containers
        if ContainerId % 1000 == 0 then
            self:Info(string.format("Progress: Scanned %d/10000 containers, found item in %d containers so far", 
                ContainerId, ContainersWithTargetItem))
        end
        
        -- Get container contents
        local Items = API.Container_Get_all(ContainerId)
        
        -- Skip if API returned invalid data
        if not Items then
            goto continue_container
        end
        
        if type(Items) ~= "table" and type(Items) ~= "userdata" then
            goto continue_container
        end
        
        if #Items == 0 then
            goto continue_container
        end
        
        ContainersWithItems = ContainersWithItems + 1
        
        -- Check each item in the container
        local ItemsFound = {}
        local ContainerQuantity = 0
        
        for I = 1, #Items do
            local Item = Items[I]
            
            -- Validate item
            if not Item then
                goto continue_item
            end
            
            if type(Item) ~= "table" and type(Item) ~= "userdata" then
                goto continue_item
            end
            
            -- Check if this is our target item
            if Item.item_id == ItemId then
                local ItemStack = Item.item_stack or 1
                local ItemSlot = Item.item_slot or I
                
                table.insert(ItemsFound, {
                    slot = ItemSlot,
                    stack = ItemStack
                })
                
                ContainerQuantity = ContainerQuantity + ItemStack
            end
            
            ::continue_item::
        end
        
        -- If we found the target item in this container, record it
        if #ItemsFound > 0 then
            ContainersWithTargetItem = ContainersWithTargetItem + 1
            
            table.insert(Results.containers, {
                container_id = ContainerId,
                items_found = ItemsFound,
                total_in_container = ContainerQuantity
            })
            
            Results.total_quantity = Results.total_quantity + ContainerQuantity
            
            self:Info(string.format("Found item ID %d in container %d (quantity: %d)", 
                ItemId, ContainerId, ContainerQuantity))
        end
        
        ::continue_container::
    end
    
    Results.total_found = ContainersWithTargetItem
    
    -- Print summary
    self:Info("=== Search Complete ===")
    self:Info(string.format("Containers scanned: %d", ContainersScanned))
    self:Info(string.format("Containers with items: %d", ContainersWithItems))
    self:Info(string.format("Containers containing item ID %d: %d", ItemId, Results.total_found))
    self:Info(string.format("Total quantity found: %d", Results.total_quantity))
    
    if Results.total_found > 0 then
        print("")
        print("+=================================+")
        print("|          SEARCH RESULTS         |")
        print("+=================================+")
        print(string.format("|   Item ID        : %-12s |", ItemId))
        print(string.format("|   Containers     : %-12s |", Results.total_found))
        print(string.format("|   Total Quantity : %-12s |", Results.total_quantity))
        print("+=================================+")
        print("")
        
        -- Print details for each container
        for I, Container in ipairs(Results.containers) do
            print(string.format("Container %d (ID: %d) - Quantity: %d", 
                I, Container.container_id, Container.total_in_container))
            
            for J, Item in ipairs(Container.items_found) do
                print(string.format("  Slot %d: Stack %d", Item.slot, Item.stack))
            end
            print("")
        end
        
        return Results
    else
        self:Info("Item ID " .. ItemId .. " was not found in any containers")
        return nil
    end
end

-- Prints all abilities from specified ability bar(s)
---@param BarId number|table
---@return boolean Success
function Slib:PrintAbilityBar(BarId)
    -- Parameter validation
    if not self:Sanitize(BarId, {"number", "table_of_numbers"}, "BarId") then
        return false
    end
    
    -- Ensure BarId is a table for consistent processing
    local BarTable = type(BarId) == "table" and BarId or {BarId}
    
    -- Validate range (0-4) for each bar ID
    for I, Bar in ipairs(BarTable) do
        if Bar < 0 or Bar > 4 then
            self:Error("BarId must be between 0-4, got: " .. Bar .. " at index " .. I)
            return false
        end
    end
    
    local TotalAbilities = 0
    local ProcessedBars = 0
    
    -- Process each ability bar
    for _, Bar in ipairs(BarTable) do
        local BarInfo = API.GetABarInfo(Bar)
        
        if not BarInfo then
            self:Warn("Unable to get ability bar " .. Bar)
            goto continue
        end
        
        if type(BarInfo) ~= "table" and type(BarInfo) ~= "userdata" then
            self:Warn("Invalid data type for bar " .. Bar .. ": " .. type(BarInfo))
            goto continue
        end
        
        if #BarInfo == 0 then
            self:Info("Ability bar " .. Bar .. " is empty")
            goto continue
        end
        
        -- Count valid abilities in this bar
        local ValidAbilities = 0
        for I = 1, #BarInfo do
            local Ability = BarInfo[I]
            if Ability and Ability.id and Ability.id ~= 65535 then
                ValidAbilities = ValidAbilities + 1
            end
        end
        
        if ValidAbilities == 0 then
            self:Info("No valid abilities found in bar " .. Bar)
            goto continue
        end
        
        self:Info("=== Ability Bar " .. Bar .. " ===")
        self:Info("Found " .. ValidAbilities .. " abilities:")
        print("")
        
        -- Safe iteration through abilities
        for I = 1, #BarInfo do
            local Ability = BarInfo[I]
            
            -- Check if ability exists and is valid
            if not Ability then
                self:Warn("Skipping nil ability at slot " .. I .. " in bar " .. Bar)
                goto continue_ability
            end
            
            if type(Ability) ~= "table" and type(Ability) ~= "userdata" then
                self:Warn("Skipping invalid ability at slot " .. I .. " in bar " .. Bar .. " (type: " .. type(Ability) .. ")")
                goto continue_ability
            end
            
            -- Skip empty/invalid abilities (ID 65535 is empty slot)
            if not Ability.id or Ability.id == 65535 then
                goto continue_ability
            end
            
            -- Format ability information with nice borders
            print("+========================+")
            print("|     ABILITY SLOT #" .. string.format("%-2s", I) .. "   |")
            print("|        (Bar " .. Bar .. ")         |")
            print("+========================+")
            print("|   slot           : " .. tostring(Ability.slot or "N/A"))
            print("|   id             : " .. tostring(Ability.id or "N/A"))
            print("|   name           : " .. tostring(Ability.name or "N/A"))
            print("|   hotkey         : " .. tostring(Ability.hotkey or "N/A"))
            print("|   cooldown_timer : " .. tostring(Ability.cooldown_timer or "N/A"))
            print("|   action         : " .. tostring(Ability.action or "N/A"))
            print("|   enabled        : " .. tostring(Ability.enabled or "N/A"))

            -- Print ability info if it exists
            if Ability.info then
                local Info = Ability.info
                print("|                        ")
                print("|     --- info ---       ")
                print("|   x              : " .. tostring(Info.x or "N/A"))
                print("|   xs             : " .. tostring(Info.xs or "N/A"))
                print("|   y              : " .. tostring(Info.y or "N/A"))
                print("|   ys             : " .. tostring(Info.ys or "N/A"))
                print("|   box_x          : " .. tostring(Info.box_x or "N/A"))
                print("|   box_y          : " .. tostring(Info.box_y or "N/A"))
                print("|   scroll_y       : " .. tostring(Info.scroll_y or "N/A"))
                print("|   id1            : " .. tostring(Info.id1 or "N/A"))
                print("|   id2            : " .. tostring(Info.id2 or "N/A"))
                print("|   id3            : " .. tostring(Info.id3 or "N/A"))
                print("|   itemid1        : " .. tostring(Info.itemid1 or "N/A"))
                print("|   itemid1_size   : " .. tostring(Info.itemid1_size or "N/A"))
                print("|   itemid2        : " .. tostring(Info.itemid2 or "N/A"))
                print("|   hov            : " .. tostring(Info.hov or "N/A"))
                print("|   textids        : " .. tostring(Info.textids or "N/A"))
                print("|   textitem       : " .. tostring(Info.textitem or "N/A"))
                print("|   memloc         : " .. tostring(Info.memloc or "N/A"))
                print("|   memloctop      : " .. tostring(Info.memloctop or "N/A"))
                print("|   index          : " .. tostring(Info.index or "N/A"))
                print("|   fullpath       : " .. tostring(Info.fullpath or "N/A"))
                print("|   fullIDpath     : " .. tostring(Info.fullIDpath or "N/A"))
                print("|   notvisible     : " .. tostring(Info.notvisible or "N/A"))
                print("|   OP             : " .. tostring(Info.OP or "N/A"))
                print("|   xy             : " .. tostring(Info.xy or "N/A"))
                print("|   xy.x           : " .. tostring(Info.xy.x or "N/A"))
                print("|   xy.y           : " .. tostring(Info.xy.y or "N/A"))
            else
                print("|   info           : N/A")
            end
            
            print("+========================+")
            print("")
            
            TotalAbilities = TotalAbilities + 1
            
            ::continue_ability::
        end
        
        ProcessedBars = ProcessedBars + 1
        
        ::continue::
    end
    
    if ProcessedBars == 0 then
        self:Error("No ability bars could be processed")
        return false
    end
    
    self:Info("Ability scan completed - processed " .. ProcessedBars .. " bar(s) with " .. TotalAbilities .. " total abilities")
    return true
end

-- Prints all objects with specified parameters
---@param Id number|table
---@param Range number
---@param Type number|table
---@return boolean Success
function Slib:PrintObjects(Id, Range, Type)
    -- Parameter validation
    if not self:ValidateParams({
        {Id, {"number", "table_of_numbers"}, "Id"},
        {Range, "non_negative_number", "Range"},
        {Type, {"number", "table_of_numbers"}, "Type"}
    }) then
        return false
    end
    
    -- Ensure Id and Type are tables
    local IdTable = type(Id) == "table" and Id or {Id}
    local TypeTable = type(Type) == "table" and Type or {Type}
    
    -- Direct API call
    local Objects = API.GetAllObjArray1(IdTable, Range, TypeTable)
    
    -- Check if API returned valid data
    if not Objects then
        self:Error("API returned nil")
        return false
    end
    
    if type(Objects) ~= "table" and type(Objects) ~= "userdata" then
        self:Error("API returned invalid data type: " .. type(Objects))
        return false
    end
    
    if #Objects == 0 then
        self:Info("No objects found matching criteria")
        return false
    end
    
    self:Info("Found " .. #Objects .. " objects:")
    
    -- Safe iteration with bounds checking
    for I = 1, #Objects do
        local Object = Objects[I]
        
        -- Check if object exists and is valid
        if not Object then
            self:Warn("Skipping nil object at index " .. I)
            goto continue
        end
        
        if type(Object) ~= "table" and type(Object) ~= "userdata" then
            self:Warn("Skipping invalid object at index " .. I .. " (type: " .. type(Object) .. ")")
            goto continue
        end
        
        -- Direct object printing
        print("+==============================+")
        print("|          OBJECT #" .. I .. "           |")
        print("+==============================+")
        print("|    Name           : " .. tostring(Object.Name or "N/A"))
        print("|    Id             : " .. tostring(Object.Id or "N/A"))
        print("|    Type           : " .. tostring(Object.Type or "N/A"))
        print("|    Life           : " .. tostring(Object.Life or "N/A"))
        print("|    Action         : " .. tostring(Object.Action or "N/A"))
        print("|    Anim           : " .. tostring(Object.Anim or "N/A"))
        print("|    Amount         : " .. tostring(Object.Amount or "N/A"))
        print("|    Distance       : " .. tostring(Object.Distance or "N/A"))
        print("|    Floor          : " .. tostring(Object.Floor or "N/A"))
        print("|    CalcX          : " .. tostring(Object.CalcX or "N/A"))
        print("|    CalcY          : " .. tostring(Object.CalcY or "N/A"))
        print("|    TileX          : " .. tostring(Object.TileX or "N/A") .. " (÷512: " .. tostring(Object.TileX and (Object.TileX/512) or "N/A") .. ")")
        print("|    TileY          : " .. tostring(Object.TileY or "N/A") .. " (÷512: " .. tostring(Object.TileY and (Object.TileY/512) or "N/A") .. ")")
        print("|    TileZ          : " .. tostring(Object.TileZ or "N/A") .. " (÷512: " .. tostring(Object.TileZ and (Object.TileZ/512) or "N/A") .. ")")
        print("|    Tile_XYZ.x     : " .. tostring(Object.Tile_XYZ and Object.Tile_XYZ.x or "N/A"))
        print("|    Tile_XYZ.y     : " .. tostring(Object.Tile_XYZ and Object.Tile_XYZ.y or "N/A"))
        print("|    Tile_XYZ.z     : " .. tostring(Object.Tile_XYZ and Object.Tile_XYZ.z or "N/A"))
        print("|    Pixel_XYZ.x    : " .. tostring(Object.Pixel_XYZ and Object.Pixel_XYZ.x or "N/A"))
        print("|    Pixel_XYZ.y    : " .. tostring(Object.Pixel_XYZ and Object.Pixel_XYZ.y or "N/A"))
        print("|    Pixel_XYZ.z    : " .. tostring(Object.Pixel_XYZ and Object.Pixel_XYZ.z or "N/A"))
        print("|    Mem            : " .. tostring(Object.Mem or "N/A"))
        print("|    MemE           : " .. tostring(Object.MemE or "N/A"))
        print("|    Unique_Id      : " .. tostring(Object.Unique_Id or "N/A"))
        print("|    Cmb_lv         : " .. tostring(Object.Cmb_lv or "N/A"))
        print("|    ItemIndex      : " .. tostring(Object.ItemIndex or "N/A"))
        print("|    Bool1          : " .. tostring(Object.Bool1 or "N/A"))
        print("|    ViewP          : " .. tostring(Object.ViewP or "N/A"))
        print("|    ViewF          : " .. tostring(Object.ViewF or "N/A"))
        print("+==============================+")
        print("")
        
        ::continue::
    end
    
    return true
end

-- Prints info about specified VarBit(s)
---@param Vb number|table
---@return boolean Success
function Slib:PrintVb(Vb)
    -- Parameter validation
    if not self:Sanitize(Vb, {"number", "table_of_numbers"}, "Vb") then
        return false
    end
    
    -- Ensure Vb is a table for consistent processing
    local VbTable = type(Vb) == "table" and Vb or {Vb}
    
    local TotalFound = 0
    local ProcessedVbs = 0
    
    -- Process each VarBit
    for _, VbId in ipairs(VbTable) do
        local Var = API.VB_FindPSettinOrder(VbId)
        
        if not Var then
            self:Warn("VarBit " .. VbId .. " not found")
            goto continue
        end
        
        if type(Var) ~= "table" and type(Var) ~= "userdata" then
            self:Warn("Invalid data type for VarBit " .. VbId .. ": " .. type(Var))
            goto continue
        end
        
        -- Format VarBit information with nice borders
        print("+========================+")
        print("|      VARBIT #" .. string.format("%-2s", VbId) .. "      |")
        print("+========================+")
        print("|   id             : " .. tostring(Var.id or "N/A"))
        print("|   state          : " .. tostring(Var.state or "N/A"))
        print("|   addr           : " .. tostring(Var.addr or "N/A"))
        print("|   indexaddr_orig : " .. tostring(Var.indexaddr_orig or "N/A"))
        print("+========================+")
        print("")
        
        TotalFound = TotalFound + 1
        ProcessedVbs = ProcessedVbs + 1
        
        ::continue::
    end
    
    if ProcessedVbs == 0 then
        self:Error("No VarBits could be processed")
        return false
    end
    
    self:Info("VarBit scan completed - processed " .. ProcessedVbs .. " VarBit(s), found " .. TotalFound .. " valid")
    return true
end

-- Prints detailed information about VarBits associated with a specified Varp
---@param VarpId number|table The Varp ID(s) to query for associated VarBits
---@return boolean Success True if VarBits were found and processed, false otherwise
function Slib:PrintVarpVb(VarpId)
    -- Parameter validation
    if not self:Sanitize(VarpId, {"number", "table_of_numbers"}, "VarpId") then
        return false
    end
    
    -- Ensure VarpId is a table for consistent processing
    local VarpTable = type(VarpId) == "table" and VarpId or {VarpId}
    
    local TotalVarBits = 0
    local ProcessedVarps = 0
    
    -- Process each Varp
    for _, VarpIdValue in ipairs(VarpTable) do
        ProcessedVarps = ProcessedVarps + 1
        
        local VB = API.GetVarbitsFromVarp(VarpIdValue)
        
        if not VB then
            self:Warn("No VarBits found for Varp " .. VarpIdValue)
            goto continue
        end
        
        -- Accept both table and userdata types (userdata is common for API returns)
        if type(VB) ~= "table" and type(VB) ~= "userdata" then
            self:Warn("Invalid data type returned for Varp " .. VarpIdValue .. ": " .. type(VB))
            goto continue
        end
        
        -- Convert to table if needed, or get length
        local VarBitCount = 0
        local VarBitList = {}
        
        -- Try to determine count and build iterable list
        if type(VB) == "table" then
            VarBitCount = #VB
            VarBitList = VB
        elseif type(VB) == "userdata" then
            -- Try to get size if it's an array-like userdata
            local success, size = pcall(function() return #VB end)
            if success and size then
                VarBitCount = size
                -- Build list by indexing
                for i = 1, size do
                    local item_success, item = pcall(function() return VB[i] end)
                    if item_success and item then
                        table.insert(VarBitList, item)
                    end
                end
            else
                -- Try iterating with pairs if it's dictionary-like
                local pair_success = pcall(function()
                    for _, varbit in pairs(VB) do
                        VarBitCount = VarBitCount + 1
                        table.insert(VarBitList, varbit)
                    end
                end)
                
                if not pair_success then
                    self:Warn("Unable to iterate userdata for Varp " .. VarpIdValue)
                    goto continue
                end
            end
        end
        
        if VarBitCount == 0 then
            self:Warn("Varp " .. VarpIdValue .. " has no associated VarBits")
            goto continue
        end
        
        -- Print header for this Varp
        print("+=============================+")
        print("|    VARP #" .. string.format("%-4s", VarpIdValue) .. " VARBITS    |")
        print("+=============================+")
        print("")
        
        -- Process each VarBit in the collection
        for _, varbit in ipairs(VarBitList) do
            if varbit then
                print("+-----------------------------+")
                
                -- Safely access fields with pcall for userdata
                local function safeGet(obj, field)
                    local success, value = pcall(function() return obj[field] end)
                    return success and value or "N/A"
                end
                
                print("|   id       : " .. tostring(safeGet(varbit, "id")))
                print("|   varp     : " .. tostring(safeGet(varbit, "varp")))
                print("|   startBit : " .. tostring(safeGet(varbit, "startBit")))
                print("|   endBit   : " .. tostring(safeGet(varbit, "endBit")))
                print("|   domain   : " .. tostring(safeGet(varbit, "domain")))
                print("+-----------------------------+")
                print("")
                
                TotalVarBits = TotalVarBits + 1
            end
        end
        
        ::continue::
    end
    
    if TotalVarBits == 0 then
        self:Error("No VarBits could be processed from any Varp")
        return false
    end
    
    self:Info("Varp scan completed - processed " .. ProcessedVarps .. " Varp(s), found " .. TotalVarBits .. " VarBit(s)")
    return true
end

-- Checks if a specific bit position is active (set to 1) in a VarBit's state
---@param VbId number The VarBit ID to check
---@param BitPosition number|table The bit position(s) to check (0-indexed)
---@return boolean|table|nil Success Returns boolean for single bit, table of results for multiple bits, or nil on error
function Slib:IsBitActive(VbId, BitPosition)
    -- Parameter validation
    if not self:Sanitize(VbId, {"number"}, "VbId") then
        return nil
    end
    
    if not self:Sanitize(BitPosition, {"number", "table_of_numbers"}, "BitPosition") then
        return nil
    end
    
    -- Retrieve the VarBit
    local Var = API.VB_FindPSettinOrder(VbId)
    
    if not Var then
        self:Warn("VarBit " .. VbId .. " not found")
        return nil
    end
    
    if type(Var) ~= "table" and type(Var) ~= "userdata" then
        self:Warn("Invalid data type for VarBit " .. VbId .. ": " .. type(Var))
        return nil
    end
    
    -- Safely get the state value
    local BigVB
    if type(Var) == "table" then
        BigVB = Var.state
    else
        -- Handle userdata with pcall
        local success, state = pcall(function() return Var.state end)
        if not success or not state then
            self:Warn("Unable to retrieve state for VarBit " .. VbId)
            return nil
        end
        BigVB = state
    end
    
    if not BigVB or type(BigVB) ~= "number" then
        self:Warn("Invalid state value for VarBit " .. VbId .. ": " .. tostring(BigVB))
        return nil
    end
    
    -- Process single bit position
    if type(BitPosition) == "number" then
        if BitPosition < 0 then
            self:Warn("Bit position must be non-negative, got: " .. BitPosition)
            return nil
        end
        
        local isActive = ((BigVB >> BitPosition) & 1) == 1
        return isActive
    end
    
    -- Process multiple bit positions
    local results = {}
    for _, pos in ipairs(BitPosition) do
        if pos < 0 then
            self:Warn("Skipping invalid bit position: " .. pos .. " (must be non-negative)")
            results[pos] = nil
        else
            results[pos] = ((BigVB >> pos) & 1) == 1
        end
    end
    
    return results
end

-- Prints detailed information about interface elements recursively
---@param TargetUnder boolean True to recursively scan all children, false to get exact interface only
---@param InterfaceToScan table|userdata The interface path to scan
---@return boolean Success
function Slib:PrintInterfaceInfo(TargetUnder, InterfaceToScan)
    -- Parameter validation
    if not self:ValidateParams({
        {TargetUnder, "boolean", "TargetUnder"},
        {InterfaceToScan, {"table", "userdata"}, "InterfaceToScan"}
    }) then
        return false
    end
    
    if TargetUnder then
        -- Recursive scanning of all children
        self:Info("Starting recursive interface scan...")
        print("")
        
        local ElementCounter = {count = 0}
        local VisitedPaths = {}
        local SeenMemlocs = {}
        local MaxDepth = 100000
        
        -- Internal recursive function
        local function ScanRecursive(CurrentPath, Depth)
            if Depth > MaxDepth then
                print("Warning: Max depth reached (" .. Depth .. ")")
                return
            end
            
            -- Create path key for duplicate detection
            local PathParts = {}
            for I, Segment in ipairs(CurrentPath) do
                table.insert(PathParts, Segment[1] .. "," .. Segment[2] .. "," .. Segment[3] .. "," .. Segment[4])
            end
            local PathKey = table.concat(PathParts, ";")
            
            if VisitedPaths[PathKey] then
                return
            end
            VisitedPaths[PathKey] = true
            
            -- Try to get the exact interface at this path
            local ExactSuccess, ExactInterface = pcall(function() 
                return API.ScanForInterfaceTest2Get(false, CurrentPath) 
            end)
            
            if ExactSuccess and ExactInterface and #ExactInterface > 0 then
                local Element = ExactInterface[1]
                
                -- Check if we've already seen this interface
                if not (Element.memloc and SeenMemlocs[Element.memloc]) then
                    if Element.memloc then 
                        SeenMemlocs[Element.memloc] = true 
                    end
                    
                    ElementCounter.count = ElementCounter.count + 1
                    
                    -- Format interface element information with nice borders
                    print("+=============================================+")
                    print("|       ELEMENT #" .. string.format("%-2s", ElementCounter.count) .. " (Depth: " .. Depth .. ")              |")
                    print("+=============================================+")
                    print("|   x              : " .. tostring(Element.x or "N/A"))
                    print("|   xs             : " .. tostring(Element.xs or "N/A"))
                    print("|   y              : " .. tostring(Element.y or "N/A"))
                    print("|   ys             : " .. tostring(Element.ys or "N/A"))
                    print("|   box_x          : " .. tostring(Element.box_x or "N/A"))
                    print("|   box_y          : " .. tostring(Element.box_y or "N/A"))
                    print("|   scroll_y       : " .. tostring(Element.scroll_y or "N/A"))
                    print("|   id1            : " .. tostring(Element.id1 or "N/A"))
                    print("|   id2            : " .. tostring(Element.id2 or "N/A"))
                    print("|   id3            : " .. tostring(Element.id3 or "N/A"))
                    print("|   itemid1        : " .. tostring(Element.itemid1 or "N/A"))
                    print("|   itemid1_size   : " .. tostring(Element.itemid1_size or "N/A"))
                    print("|   itemid2        : " .. tostring(Element.itemid2 or "N/A"))
                    print("|   hov            : " .. tostring(Element.hov or "N/A"))
                    print("|   textids        : " .. tostring(Element.textids or "N/A"))
                    print("|   textitem       : " .. tostring(Element.textitem or "N/A"))
                    print("|   memloc         : " .. tostring(Element.memloc or "N/A"))
                    print("|   memloctop      : " .. tostring(Element.memloctop or "N/A"))
                    print("|   index          : " .. tostring(Element.index or "N/A"))
                    print("|   fullpath       : " .. tostring(Element.fullpath or "N/A"))
                    print("|   fullIDpath     : " .. tostring(Element.fullIDpath or "N/A"))
                    print("|   notvisible     : " .. tostring(Element.notvisible or "N/A"))
                    print("|   OP             : " .. tostring(Element.OP or "N/A"))
                    print("|   xy             : " .. tostring(Element.xy or "N/A"))
                    if Element.xy then
                        print("|   xy.x           : " .. tostring(Element.xy.x or "N/A"))
                        print("|   xy.y           : " .. tostring(Element.xy.y or "N/A"))
                    end
                    
                    -- Add memory read information if memloc is available
                    if Element.memloc and type(Element.memloc) == "number" then
                        print("|                                             |")
                        print("|     --- MEMORY READS ---                    |")
                        print("|                                             |")
                        
                        -- Define API constants
                        local ApiConstants = {
                            {name = "I_00textP", value = API.I_00textP},
                            {name = "I_itemids3", value = API.I_itemids3},
                            {name = "I_itemids", value = API.I_itemids},
                            {name = "I_itemstack", value = API.I_itemstack},
                            {name = "I_slides", value = API.I_slides},
                            {name = "I_buffb", value = API.I_buffb}
                        }
                        
                        -- Group memory reads by function type
                        local MemReadGroups = {
                            {
                                name = "Mem_Read_char",
                                func = API.Mem_Read_char,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_short", 
                                func = API.Mem_Read_short,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_int",
                                func = API.Mem_Read_int,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_uint64",
                                func = API.Mem_Read_uint64,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "ReadCharsLimit",
                                func = API.ReadCharsLimit,
                                reads = {}
                            },
                            {
                                name = "ReadChars",
                                func = API.ReadChars,
                                reads = {}
                            },
                            {
                                name = "ReadCharsLimitPointer",
                                func = API.ReadCharsLimitPointer,
                                reads = {}
                            },
                            {
                                name = "ReadCharsPointer",
                                func = API.ReadCharsPointer,
                                reads = {},
                                no_limit = true
                            }
                        }
                        
                        -- Add constant combinations
                        for _, Constant in ipairs(ApiConstants) do
                            if Constant.value and type(Constant.value) == "number" then
                                for _, Group in ipairs(MemReadGroups) do
                                    if Group.name ~= "ReadCharsLimit" and Group.name ~= "ReadChars" and 
                                       Group.name ~= "ReadCharsLimitPointer" and Group.name ~= "ReadCharsPointer" then
                                        table.insert(Group.reads, {name = "memloc+" .. Constant.name, offset = Constant.value})
                                    end
                                end
                                
                                for _, Group in ipairs(MemReadGroups) do
                                    if Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" or Group.name == "ReadCharsPointer" then
                                        table.insert(Group.reads, {name = "memloc+" .. Constant.name, offset = Constant.value, limit = 255})
                                    end
                                end
                            end
                        end
                        
                        -- Build function names for formatting
                        local allFunctionNames = {}
                        for _, Group in ipairs(MemReadGroups) do
                            for _, Read in ipairs(Group.reads) do
                                local FunctionName
                                if Group.no_limit then
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" then
                                    FunctionName = Group.name .. "(" .. Read.name .. ", 255)"
                                else
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                end
                                table.insert(allFunctionNames, FunctionName)
                            end
                        end
                        
                        local maxFuncNameLen = 0
                        for _, name in ipairs(allFunctionNames) do
                            if #name > maxFuncNameLen then maxFuncNameLen = #name end
                        end
                        maxFuncNameLen = math.max(maxFuncNameLen, 20)
                        local formatString = string.format("|   %%-%ds : %%s", maxFuncNameLen)

                        -- Process each group
                        for _, Group in ipairs(MemReadGroups) do
                            for _, Read in ipairs(Group.reads) do
                                local FunctionName
                                if Group.no_limit then
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" then
                                    FunctionName = Group.name .. "(" .. Read.name .. ", 255)"
                                else
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                end
                                
                                local Success, Result = pcall(function()
                                    if Group.no_limit then
                                        return Group.func(Element.memloc + Read.offset)
                                    elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                           Group.name == "ReadCharsLimitPointer" then
                                        return Group.func(Element.memloc + Read.offset, Read.limit)
                                    else
                                        return Group.func(Element.memloc + Read.offset)
                                    end
                                end)
                                
                                if Success and Result ~= nil then
                                    local FormattedResult
                                    local ResultType = type(Result)
                                    
                                    if ResultType == "number" then
                                        -- Safe format helper inline
                                        if Result ~= Result then
                                            FormattedResult = "NaN"
                                        elseif Result == math.huge then
                                            FormattedResult = "Infinity"
                                        elseif Result == -math.huge then
                                            FormattedResult = "-Infinity"
                                        elseif math.abs(Result) > 9007199254740991 then
                                            FormattedResult = string.format("%.0f (too large)", Result)
                                        elseif Result < 0 then
                                            FormattedResult = string.format("%.0f (negative)", Result)
                                        elseif math.floor(Result) ~= Result then
                                            FormattedResult = string.format("%.6f (fractional)", Result)
                                        else
                                            local hexFormat
                                            if Group.func == API.Mem_Read_char then
                                                hexFormat = "0x%02X"
                                            elseif Group.func == API.Mem_Read_short then
                                                hexFormat = "0x%04X"
                                            elseif Group.func == API.Mem_Read_int then
                                                hexFormat = "0x%08X"
                                            elseif Group.func == API.Mem_Read_uint64 then
                                                hexFormat = "0x%016X"
                                            end
                                            
                                            if hexFormat then
                                                local success, formattedHex = pcall(string.format, hexFormat, Result)
                                                local success2, formattedDec = pcall(string.format, "%.0f", Result)
                                                if success and success2 then
                                                    FormattedResult = formattedHex .. " (" .. formattedDec .. ")"
                                                else
                                                    FormattedResult = tostring(Result)
                                                end
                                            else
                                                FormattedResult = tostring(Result)
                                            end
                                        end
                                    elseif ResultType == "string" then
                                        if Result == "" then
                                            FormattedResult = '"" (empty)'
                                        else
                                            local EscapedResult = string.gsub(Result, "[\0-\31\127-\255]", function(c)
                                                return string.format("\\x%02X", string.byte(c))
                                            end)
                                            if #EscapedResult > 50 then
                                                EscapedResult = string.sub(EscapedResult, 1, 47) .. "..."
                                            end
                                            FormattedResult = '"' .. EscapedResult .. '"'
                                        end
                                    else
                                        FormattedResult = tostring(Result) .. " (" .. ResultType .. ")"
                                    end
                                    
                                    print(string.format(formatString, FunctionName, FormattedResult))
                                else
                                    print(string.format(formatString, FunctionName, "Error"))
                                end
                            end
                        end
                    else
                        print("|                                             |")
                        print("|     --- MEMORY READS ---                    |")
                        print("|   No memloc available                       |")
                    end
                    
                    print("+=============================================+")
                    print("")
                end
            end
            
            -- Now get all children of this path
            local ChildrenSuccess, Children = pcall(function() 
                return API.ScanForInterfaceTest2Get(true, CurrentPath) 
            end)
            
            if not ChildrenSuccess or not Children or #Children == 0 then
                return
            end
            
            -- Track unique child combinations to explore
            local UniqueChildren = {}
            for _, Child in ipairs(Children) do
                local ChildKey = (Child.id1 or 0) .. "," .. (Child.id2 or 0) .. "," .. (Child.id3 or 0)
                if not UniqueChildren[ChildKey] then
                    UniqueChildren[ChildKey] = {
                        id1 = Child.id1 or 0,
                        id2 = Child.id2 or 0,
                        id3 = Child.id3 or 0
                    }
                end
            end
            
            -- Recursively explore each unique child path
            for _, ChildIds in pairs(UniqueChildren) do
                -- Create child path
                local ChildPath = {}
                for I = 1, #CurrentPath do
                    local PathSegment = {}
                    for K, V in ipairs(CurrentPath[I]) do
                        PathSegment[K] = V
                    end
                    table.insert(ChildPath, PathSegment)
                end
                table.insert(ChildPath, { ChildIds.id1, ChildIds.id2, ChildIds.id3, 0 })
                
                -- Create child path key
                local ChildPathParts = {}
                for I, Segment in ipairs(ChildPath) do
                    table.insert(ChildPathParts, Segment[1] .. "," .. Segment[2] .. "," .. Segment[3] .. "," .. Segment[4])
                end
                local ChildPathKey = table.concat(ChildPathParts, ";")
                
                if not VisitedPaths[ChildPathKey] then
                    ScanRecursive(ChildPath, Depth + 1)
                end
            end
        end
        
        -- Start recursive scan
        ScanRecursive(InterfaceToScan, 0)
        
        print("")
        self:Info("Found " .. ElementCounter.count .. " total interface elements")
        self:Info("Interface scan completed successfully")
    else
        -- Single interface scan (exact path)
        local Success, Interface = pcall(function() 
            return API.ScanForInterfaceTest2Get(false, InterfaceToScan) 
        end)
        
        if not Success then
            self:Error("Failed to scan interface - " .. tostring(Interface))
            return false
        end
        
        if not Interface or #Interface == 0 then
            self:Info("No interface found at specified path")
            return false
        end
        
        self:Info("Found 1 interface element:")
        print("")
        
        -- Print single interface (reuse recursive function with depth 0 and max depth 0)
        local ElementCounter = {count = 0}
        local VisitedPaths = {}
        local SeenMemlocs = {}
        
        local function ScanSingle(CurrentPath)
            -- Create path key
            local PathParts = {}
            for I, Segment in ipairs(CurrentPath) do
                table.insert(PathParts, Segment[1] .. "," .. Segment[2] .. "," .. Segment[3] .. "," .. Segment[4])
            end
            local PathKey = table.concat(PathParts, ";")
            
            if VisitedPaths[PathKey] then
                return
            end
            VisitedPaths[PathKey] = true
            
            local ExactSuccess, ExactInterface = pcall(function() 
                return API.ScanForInterfaceTest2Get(false, CurrentPath) 
            end)
            
            if ExactSuccess and ExactInterface and #ExactInterface > 0 then
                local Element = ExactInterface[1]
                
                if not (Element.memloc and SeenMemlocs[Element.memloc]) then
                    if Element.memloc then 
                        SeenMemlocs[Element.memloc] = true 
                    end
                    
                    ElementCounter.count = ElementCounter.count + 1
                    
                    print("+=============================================+")
                    print("|       ELEMENT #1                            |")
                    print("+=============================================+")
                    print("|   x              : " .. tostring(Element.x or "N/A"))
                    print("|   xs             : " .. tostring(Element.xs or "N/A"))
                    print("|   y              : " .. tostring(Element.y or "N/A"))
                    print("|   ys             : " .. tostring(Element.ys or "N/A"))
                    print("|   box_x          : " .. tostring(Element.box_x or "N/A"))
                    print("|   box_y          : " .. tostring(Element.box_y or "N/A"))
                    print("|   scroll_y       : " .. tostring(Element.scroll_y or "N/A"))
                    print("|   id1            : " .. tostring(Element.id1 or "N/A"))
                    print("|   id2            : " .. tostring(Element.id2 or "N/A"))
                    print("|   id3            : " .. tostring(Element.id3 or "N/A"))
                    print("|   itemid1        : " .. tostring(Element.itemid1 or "N/A"))
                    print("|   itemid1_size   : " .. tostring(Element.itemid1_size or "N/A"))
                    print("|   itemid2        : " .. tostring(Element.itemid2 or "N/A"))
                    print("|   hov            : " .. tostring(Element.hov or "N/A"))
                    print("|   textids        : " .. tostring(Element.textids or "N/A"))
                    print("|   textitem       : " .. tostring(Element.textitem or "N/A"))
                    print("|   memloc         : " .. tostring(Element.memloc or "N/A"))
                    print("|   memloctop      : " .. tostring(Element.memloctop or "N/A"))
                    print("|   index          : " .. tostring(Element.index or "N/A"))
                    print("|   fullpath       : " .. tostring(Element.fullpath or "N/A"))
                    print("|   fullIDpath     : " .. tostring(Element.fullIDpath or "N/A"))
                    print("|   notvisible     : " .. tostring(Element.notvisible or "N/A"))
                    print("|   OP             : " .. tostring(Element.OP or "N/A"))
                    print("|   xy             : " .. tostring(Element.xy or "N/A"))
                    if Element.xy then
                        print("|   xy.x           : " .. tostring(Element.xy.x or "N/A"))
                        print("|   xy.y           : " .. tostring(Element.xy.y or "N/A"))
                    end
                    
                    -- Add memory read information if memloc is available
                    if Element.memloc and type(Element.memloc) == "number" then
                        print("|                                             |")
                        print("|     --- MEMORY READS ---                    |")
                        print("|                                             |")
                        
                        -- Define API constants
                        local ApiConstants = {
                            {name = "I_00textP", value = API.I_00textP},
                            {name = "I_itemids3", value = API.I_itemids3},
                            {name = "I_itemids", value = API.I_itemids},
                            {name = "I_itemstack", value = API.I_itemstack},
                            {name = "I_slides", value = API.I_slides},
                            {name = "I_buffb", value = API.I_buffb}
                        }
                        
                        -- Group memory reads by function type
                        local MemReadGroups = {
                            {
                                name = "Mem_Read_char",
                                func = API.Mem_Read_char,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_short", 
                                func = API.Mem_Read_short,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_int",
                                func = API.Mem_Read_int,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "Mem_Read_uint64",
                                func = API.Mem_Read_uint64,
                                reads = {{name = "memloc", offset = 0}}
                            },
                            {
                                name = "ReadCharsLimit",
                                func = API.ReadCharsLimit,
                                reads = {}
                            },
                            {
                                name = "ReadChars",
                                func = API.ReadChars,
                                reads = {}
                            },
                            {
                                name = "ReadCharsLimitPointer",
                                func = API.ReadCharsLimitPointer,
                                reads = {}
                            },
                            {
                                name = "ReadCharsPointer",
                                func = API.ReadCharsPointer,
                                reads = {},
                                no_limit = true
                            }
                        }
                        
                        -- Add constant combinations
                        for _, Constant in ipairs(ApiConstants) do
                            if Constant.value and type(Constant.value) == "number" then
                                for _, Group in ipairs(MemReadGroups) do
                                    if Group.name ~= "ReadCharsLimit" and Group.name ~= "ReadChars" and 
                                       Group.name ~= "ReadCharsLimitPointer" and Group.name ~= "ReadCharsPointer" then
                                        table.insert(Group.reads, {name = "memloc+" .. Constant.name, offset = Constant.value})
                                    end
                                end
                                
                                for _, Group in ipairs(MemReadGroups) do
                                    if Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" or Group.name == "ReadCharsPointer" then
                                        table.insert(Group.reads, {name = "memloc+" .. Constant.name, offset = Constant.value, limit = 255})
                                    end
                                end
                            end
                        end
                        
                        -- Build function names for formatting
                        local allFunctionNames = {}
                        for _, Group in ipairs(MemReadGroups) do
                            for _, Read in ipairs(Group.reads) do
                                local FunctionName
                                if Group.no_limit then
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" then
                                    FunctionName = Group.name .. "(" .. Read.name .. ", 255)"
                                else
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                end
                                table.insert(allFunctionNames, FunctionName)
                            end
                        end
                        
                        local maxFuncNameLen = 0
                        for _, name in ipairs(allFunctionNames) do
                            if #name > maxFuncNameLen then maxFuncNameLen = #name end
                        end
                        maxFuncNameLen = math.max(maxFuncNameLen, 20)
                        local formatString = string.format("|   %%-%ds : %%s", maxFuncNameLen)

                        -- Process each group
                        for _, Group in ipairs(MemReadGroups) do
                            for _, Read in ipairs(Group.reads) do
                                local FunctionName
                                if Group.no_limit then
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                       Group.name == "ReadCharsLimitPointer" then
                                    FunctionName = Group.name .. "(" .. Read.name .. ", 255)"
                                else
                                    FunctionName = Group.name .. "(" .. Read.name .. ")"
                                end
                                
                                local Success, Result = pcall(function()
                                    if Group.no_limit then
                                        return Group.func(Element.memloc + Read.offset)
                                    elseif Group.name == "ReadCharsLimit" or Group.name == "ReadChars" or 
                                           Group.name == "ReadCharsLimitPointer" then
                                        return Group.func(Element.memloc + Read.offset, Read.limit)
                                    else
                                        return Group.func(Element.memloc + Read.offset)
                                    end
                                end)
                                
                                if Success and Result ~= nil then
                                    local FormattedResult
                                    local ResultType = type(Result)
                                    
                                    if ResultType == "number" then
                                        -- Safe format helper inline
                                        if Result ~= Result then
                                            FormattedResult = "NaN"
                                        elseif Result == math.huge then
                                            FormattedResult = "Infinity"
                                        elseif Result == -math.huge then
                                            FormattedResult = "-Infinity"
                                        elseif math.abs(Result) > 9007199254740991 then
                                            FormattedResult = string.format("%.0f (too large)", Result)
                                        elseif Result < 0 then
                                            FormattedResult = string.format("%.0f (negative)", Result)
                                        elseif math.floor(Result) ~= Result then
                                            FormattedResult = string.format("%.6f (fractional)", Result)
                                        else
                                            local hexFormat
                                            if Group.func == API.Mem_Read_char then
                                                hexFormat = "0x%02X"
                                            elseif Group.func == API.Mem_Read_short then
                                                hexFormat = "0x%04X"
                                            elseif Group.func == API.Mem_Read_int then
                                                hexFormat = "0x%08X"
                                            elseif Group.func == API.Mem_Read_uint64 then
                                                hexFormat = "0x%016X"
                                            end
                                            
                                            if hexFormat then
                                                local success, formattedHex = pcall(string.format, hexFormat, Result)
                                                local success2, formattedDec = pcall(string.format, "%.0f", Result)
                                                if success and success2 then
                                                    FormattedResult = formattedHex .. " (" .. formattedDec .. ")"
                                                else
                                                    FormattedResult = tostring(Result)
                                                end
                                            else
                                                FormattedResult = tostring(Result)
                                            end
                                        end
                                    elseif ResultType == "string" then
                                        if Result == "" then
                                            FormattedResult = '"" (empty)'
                                        else
                                            local EscapedResult = string.gsub(Result, "[\0-\31\127-\255]", function(c)
                                                return string.format("\\x%02X", string.byte(c))
                                            end)
                                            if #EscapedResult > 50 then
                                                EscapedResult = string.sub(EscapedResult, 1, 47) .. "..."
                                            end
                                            FormattedResult = '"' .. EscapedResult .. '"'
                                        end
                                    else
                                        FormattedResult = tostring(Result) .. " (" .. ResultType .. ")"
                                    end
                                    
                                    print(string.format(formatString, FunctionName, FormattedResult))
                                else
                                    print(string.format(formatString, FunctionName, "Error"))
                                end
                            end
                        end
                    else
                        print("|                                             |")
                        print("|     --- MEMORY READS ---                    |")
                        print("|   No memloc available                       |")
                    end
                    
                    print("+=============================================+")
                    print("")
                end
            end
        end
        
        ScanSingle(InterfaceToScan)
        
        print("")
        self:Info("Interface scan completed successfully")
    end
    
    return true
end

-- Prints all fields of a QuestData object
---@param QuestIdsOrNames number|string|table
---@return boolean Success
function Slib:PrintQuestData(QuestIdsOrNames)
    -- Parameter validation
    if not self:Sanitize(QuestIdsOrNames, {"number", "string", "table_of_strings", "table_of_numbers"}, "QuestIdsOrNames") then
        return false
    end
    
    -- Ensure QuestIdsOrNames is a table for consistent processing
    local QuestTable = type(QuestIdsOrNames) == "table" and QuestIdsOrNames or {QuestIdsOrNames}
    
    local TotalFound = 0
    local ProcessedQuests = 0
    
    -- Process each quest
    for _, QuestId in ipairs(QuestTable) do
        -- API call to get quest data
        local QuestData = Quest:Get(QuestId)
        
        if not QuestData then
            self:Warn("Quest not found: " .. tostring(QuestId))
            goto continue
        end
        
        if type(QuestData) ~= "table" and type(QuestData) ~= "userdata" then
            self:Warn("Invalid quest data type for " .. tostring(QuestId) .. ": " .. type(QuestData))
            goto continue
        end

        self:Info("=== Quest: " .. tostring(QuestId) .. " ===")
        print("")
    
        -- Format quest information with nice borders
        print("+================================+")
        print("|           QUEST DATA           |")
        print("+================================+")
        print("|   id                 : " .. tostring(QuestData.id or "N/A"))
        print("|   name               : " .. tostring(QuestData.name or "N/A"))
        print("|   list_name          : " .. tostring(QuestData.list_name or "N/A"))
        print("|   members            : " .. tostring(QuestData.members or "N/A"))
        print("|   category           : " .. tostring(QuestData.category or "N/A"))
        print("|   difficulty         : " .. tostring(QuestData.difficulty or "N/A"))
        print("|   points_reward      : " .. tostring(QuestData.points_reward or "N/A"))
        print("|   points_required    : " .. tostring(QuestData.points_required or "N/A"))
        print("|   progress_start_bit : " .. tostring(QuestData.progress_start_bit or "N/A"))
        print("|   progress_end_bit   : " .. tostring(QuestData.progress_end_bit or "N/A"))
        print("|   progress_varbit    : " .. tostring(QuestData.progress_varbit or "N/A"))
        print("|                                ")
        print("|     --- Methods ---            ")
        
        -- Call methods safely
        if QuestData.isComplete then
            local Success, Result = pcall(function() return QuestData:isComplete() end)
            if Success then
                print("|   isComplete()       : " .. tostring(Result))
            else
                print("|   isComplete()       : ERROR - " .. tostring(Result))
            end
        else
            print("|   isComplete()       : N/A")
        end
        
        if QuestData.isStarted then
            local Success, Started = pcall(function() return QuestData:isStarted() end)
            print("|   isStarted()        : " .. tostring(Success and Started or "Error"))
        else
            print("|   isStarted()        : N/A")
        end
        
        if QuestData.getProgress then
            local Success, Progress = pcall(function() return QuestData:getProgress() end)
            print("|   getProgress()      : " .. tostring(Success and Progress or "Error"))
        else
            print("|   getProgress()       : N/A")
        end
        
        print("|                                ")
        print("|   --- Required Quests ---      ")
        
        -- Print required quests with debugging
        if QuestData.required_quests then
            if (type(QuestData.required_quests) == "table" or type(QuestData.required_quests) == "userdata") and #QuestData.required_quests > 0 then
                for I, ReqQuest in ipairs(QuestData.required_quests) do
                    if ReqQuest and (type(ReqQuest) == "table" or type(ReqQuest) == "userdata") then
                        local ReqQuestId = tostring(ReqQuest.id or "N/A")
                        local ReqQuestName = tostring(ReqQuest.name or "N/A")
                        -- Split long lines to fit within border
                        print("|   [" .. I .. "] ID: " .. ReqQuestId)
                        if string.len(ReqQuestName) > 25 then
                            print("|       Name: " .. string.sub(ReqQuestName, 1, 22) .. "...")
                        else
                            print("|       Name: " .. ReqQuestName)
                        end
                    else
                        print("|   [" .. I .. "] Invalid quest data     ")
                    end
                end
            else
                print("|   None                         ")
            end
        else
            print("|   N/A                          ")
        end

        print("|                                ")
        print("|   --- Required Skills ---      ")
        
        -- Print required skills with debugging  
        if QuestData.required_skills then
            if (type(QuestData.required_skills) == "table" or type(QuestData.required_skills) == "userdata") and #QuestData.required_skills > 0 then
                for I, Skill in ipairs(QuestData.required_skills) do
                    if Skill and (type(Skill) == "table" or type(Skill) == "userdata") then
                        local SkillId = Skill.id or "N/A"
                        local SkillLevel = tostring(Skill.level or "N/A")
                        
                        -- Get skill name from API
                        local SkillName = "Unknown"
                        if SkillId ~= "N/A" then
                            local SkillData = API.GetSkillById(SkillId)
                            if SkillData and SkillData.name then
                                SkillName = SkillData.name
                            else
                                SkillName = "ID:" .. tostring(SkillId)
                            end
                        end
                        
                        print("|   [" .. I .. "] " .. SkillName .. " Level: " .. SkillLevel)
                    else
                        print("|   [" .. I .. "] Invalid skill data    ")
                    end
                end
            else
                print("|   None                         ")
            end
        else
            print("|   N/A                          ")
        end
        
        print("+================================+")
        print("")
        
        TotalFound = TotalFound + 1
        ProcessedQuests = ProcessedQuests + 1
        
        ::continue::
    end
    
    if ProcessedQuests == 0 then
        self:Error("No quests could be processed")
        return false
    end
    
    self:Info("Quest data scan completed - processed " .. ProcessedQuests .. " quest(s), found " .. TotalFound .. " valid")
    return true
end

-- Prints all items in the currency pouch with detailed information
---@return boolean Success True if currency pouch items were found and printed, false if no items or error occurred
function Slib:PrintCurrencyPouch()
    if not self.Interfaces or not self.Interfaces.CurrencyPouch then
        self:Error("CurrencyPouch interface not defined")
        return false
    end
    
    local TotalFound = 0
    local ProcessedInterfaces = 0
    
    -- Process each interface configuration
    for I = 1, #self.Interfaces.CurrencyPouch do
        local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.CurrencyPouch[I])
        
        -- Count valid items in this interface
        local ValidItems = 0
        for _, Item in pairs(Interface) do
            if Item and Item.itemid1 and Item.itemid1 >= 0 then
                ValidItems = ValidItems + 1
            end
        end
        
        if ValidItems > 0 then
            self:Info("=== Currency Pouch Interface " .. I .. " ===")
            self:Info("Found " .. ValidItems .. " items:")
            print("")
            
            -- Process each item
            for _, Item in pairs(Interface) do
                if Item and Item.itemid1 and Item.itemid1 >= 0 then
                    TotalFound = TotalFound + 1
                    -- Format item information with nice borders
                    print("+================================+")
                    print("|      CURRENCY ITEM #" .. string.format("%-2s", TotalFound) .. "       |")
                    print("+================================+")
                    print("|   x              : " .. tostring(Item.x or "N/A"))
                    print("|   xs             : " .. tostring(Item.xs or "N/A"))
                    print("|   y              : " .. tostring(Item.y or "N/A"))
                    print("|   ys             : " .. tostring(Item.ys or "N/A"))
                    print("|   box_x          : " .. tostring(Item.box_x or "N/A"))
                    print("|   box_y          : " .. tostring(Item.box_y or "N/A"))
                    print("|   scroll_y       : " .. tostring(Item.scroll_y or "N/A"))
                    print("|   id1            : " .. tostring(Item.id1 or "N/A"))
                    print("|   id2            : " .. tostring(Item.id2 or "N/A"))
                    print("|   id3            : " .. tostring(Item.id3 or "N/A"))
                    print("|   itemid1        : " .. tostring(Item.itemid1 or "N/A"))
                    print("|   itemid1_size   : " .. tostring(Item.itemid1_size or "N/A"))
                    print("|   itemid2        : " .. tostring(Item.itemid2 or "N/A"))
                    print("|   hov            : " .. tostring(Item.hov or "N/A"))
                    print("|   textids        : " .. tostring(Item.textids or "N/A"))
                    print("|   textitem       : " .. tostring(Item.textitem or "N/A"))
                    print("|   memloc         : " .. tostring(Item.memloc or "N/A"))
                    print("|   memloctop      : " .. tostring(Item.memloctop or "N/A"))
                    print("|   index          : " .. tostring(Item.index or "N/A"))
                    print("|   fullpath       : " .. tostring(Item.fullpath or "N/A"))
                    print("|   fullIDpath     : " .. tostring(Item.fullIDpath or "N/A"))
                    print("|   notvisible     : " .. tostring(Item.notvisible or "N/A"))
                    print("|   OP             : " .. tostring(Item.OP or "N/A"))
                    print("|   xy             : " .. tostring(Item.xy or "N/A"))
                    
                    print("+================================+")
                    print("")
                end
            end
        end
        
        ProcessedInterfaces = ProcessedInterfaces + 1
        
        ::continue::
    end
    
    if ProcessedInterfaces == 0 then
        self:Error("No currency pouch interfaces could be processed")
        return false
    end
    
    if TotalFound == 0 then
        self:Info("No currency items found in pouch")
        return false
    end
    
    self:Info("Currency pouch scan completed - processed " .. ProcessedInterfaces .. " interface(s), found " .. TotalFound .. " items")
    return true
end

-- Prints all rune types with their current quantities in an organized format
---@return boolean success True if all rune information was printed successfully, false if error occurred
function Slib:PrintRunes()
    self:Info("=== Rune Inventory Report ===")
    
    -- Print Normal Runes (from pouches + inventory)
    print("Normal Runes (Pouches + Inventory):")
    print("+================================+")
    
    for _, Rune in pairs(self.Items.Runes.Normal) do
        local Success, Result = pcall(function()
            return API.VC_FindPSett(Rune.InventoryVB, 1)
        end)
        
        local RuneAmount = 0
        if Success and Result and Result.state then
            RuneAmount = tonumber(Result.state) or 0
        end
        
        print(string.format("|   %-15s: %8d   |", Rune.Name:gsub(" rune", ""), RuneAmount))
    end
    
    print("+================================+")
    print("")
    
    -- Print Combination Runes (inventory only)
    print("Combination Runes (Inventory Only):")
    print("+================================+")
    
    for _, Rune in pairs(self.Items.Runes.Combination) do
        local Success, RuneAmount = pcall(function()
            return tonumber(Inventory:GetItemAmount(Rune.Id)) or 0
        end)
        
        if not Success then
            RuneAmount = 0
        end
        
        print(string.format("|   %-15s: %8d   |", Rune.Name:gsub(" rune", ""), RuneAmount))
    end
    
    print("+================================+")
    print("")
    
    -- Print Necromancy Runes (inventory + nexus)
    print("Necromancy Runes (Inventory + Nexus):")
    print("+================================+")
    
    local NexusRunes = API.Container_Get_all(953)
    
    for _, Rune in pairs(self.Items.Runes.Necromancy) do
        -- Get inventory amount
        local InventoryAmount = 0
        local Success, Result = pcall(function()
            return Inventory:GetItemAmount(Rune.Id)
        end)
        
        if Success and Result then
            InventoryAmount = Result
        end
        
        -- Get nexus amount
        local NexusAmount = 0
        if NexusRunes then
            for _, ContainerItem in pairs(NexusRunes) do
                if ContainerItem and ContainerItem.item_id == Rune.Id then
                    NexusAmount = NexusAmount + (ContainerItem.item_stack or 0)
                end
            end
        end
        
        local TotalAmount = InventoryAmount + NexusAmount
        
        -- Show breakdown if there are runes in both locations
        if InventoryAmount > 0 and NexusAmount > 0 then
            print(string.format("|   %-15s: %8d   |", Rune.Name:gsub(" rune", ""), TotalAmount))
            print(string.format("|     Inventory  : %8d   |", InventoryAmount))
            print(string.format("|     Nexus      : %8d   |", NexusAmount))
        else
            print(string.format("|   %-15s: %8d   |", Rune.Name:gsub(" rune", ""), TotalAmount))
        end
    end
    
    print("+================================+")
    print("")
    
    self:Info("Rune inventory report completed successfully")
    return true
end

-- Prints a table's contents in a formatted, readable way
---@param Tbl table The table to print (supports nested tables)
---@return boolean success True if table was printed successfully, false if invalid table
function Slib:PrintTable(Tbl)
    -- Parameter validation
    if not self:Sanitize(Tbl, "table", "Tbl") then
        return false
    end
    
    -- Try to get the variable name from debug info
    local TableName = "Table"
    
    -- Helper function to recursively print table contents
    local function printTableRecursive(tbl, indent)
        local spacing = string.rep("  ", indent)
        
        -- Sort keys for consistent output
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end
        
        table.sort(keys, function(a, b)
            local aType = type(a)
            local bType = type(b)
            if aType == bType then
                return tostring(a) < tostring(b)
            else
                return aType == "number" and bType ~= "number"
            end
        end)
        
        for _, key in ipairs(keys) do
            local value = tbl[key]
            local keyStr = type(key) == "string" and key or "[" .. tostring(key) .. "]"
            
            if type(value) == "table" then
                print(spacing .. keyStr .. " = {")
                printTableRecursive(value, indent + 1)
                print(spacing .. "}")
            elseif type(value) == "string" then
                print(spacing .. keyStr .. ' = "' .. tostring(value) .. '"')
            elseif type(value) == "function" then
                print(spacing .. keyStr .. " = [Function]")
            elseif type(value) == "userdata" then
                print(spacing .. keyStr .. " = [UserData]")
            else
                print(spacing .. keyStr .. " = " .. tostring(value))
            end
        end
    end
    
    -- Check if table is empty
    if next(Tbl) == nil then
        print(TableName .. " = {} (empty)")
        return true
    end
    
    -- Print the table
    print(TableName .. " = {")
    printTableRecursive(Tbl, 1)
    print("}")
    
    return true
end

-- ##################################
-- #                                #
-- #       HELPER FUNCTIONS         #
-- #                                #
-- ##################################

-- Checks if the player is in a specified area (circular radius)
---@param X number The center X coordinate
---@param Y number The center Y coordinate  
---@param Z number The Z coordinate (floor/plane)
---@param Radius number The radius in tiles (must be non-negative)
---@return boolean inArea True if player is within the specified circular area, false otherwise
function Slib:IsPlayerInArea(X, Y, Z, Radius)
    -- Parameter validation
    if not self:ValidateParams({
        {X, "number", "X"},
        {Y, "number", "Y"},
        {Z, "number", "Z"},
        {Radius, "non_negative_number", "Radius"}
    }) then
        return false
    end
    
    -- Get player coordinates safely
    local Coord = API.PlayerCoord()
    if not Coord then
        self:Error("Failed to get player coordinates")
        return false
    end
    
    -- Calculate distance
    local Dx = Coord.x - X
    local Dy = Coord.y - Y
    local Distance = math.sqrt(Dx^2 + Dy^2)
    
    -- Check if player is in area
    local InArea = Distance <= Radius and Coord.z == Z
    return InArea
end

-- Checks if the player is in a rectangular area
---@param MinX number The minimum X coordinate (left boundary)
---@param MaxX number The maximum X coordinate (right boundary)
---@param MinY number The minimum Y coordinate (top boundary)
---@param MaxY number The maximum Y coordinate (bottom boundary)
---@param Z number The Z coordinate (floor/plane)
---@return boolean inArea True if player is within the specified rectangular area, false otherwise
function Slib:IsPlayerInRectangle(MinX, MaxX, MinY, MaxY, Z)
    -- Parameter validation
    if not self:ValidateParams({
        {MinX, "number", "MinX"},
        {MaxX, "number", "MaxX"},
        {MinY, "number", "MinY"},
        {MaxY, "number", "MaxY"},
        {Z, "number", "Z"}
    }) then
        return false
    end
    
    local Coord = API.PlayerCoord()
    if not Coord then
        self:Error("Failed to get player coordinates")
        return false
    end
    
    local InArea = Coord.x >= MinX and Coord.x <= MaxX and 
                   Coord.y >= MinY and Coord.y <= MaxY and 
                   Coord.z == Z
    
    return InArea
end

-- Checks if the player is at the specified coordinates
---@param X number The exact X coordinate
---@param Y number The exact Y coordinate
---@param Z number The exact Z coordinate (floor/plane)
---@return boolean atCoords True if player is at the exact coordinates, false otherwise
function Slib:IsPlayerAtCoords(X, Y, Z)
    -- Parameter validation
    if not self:ValidateParams({
        {X, "number", "X"},
        {Y, "number", "Y"},
        {Z, "number", "Z"}
    }) then
        return false
    end
    
    -- Get player coordinates safely
    local Coord = API.PlayerCoord()
    if not Coord then
        self:Error("Failed to get player coordinates")
        return false
    end
    
    local AtCoords = Coord.x == X and Coord.y == Y and Coord.z == Z
    return AtCoords
end

-- Gets the current instance timer text
---@return string timerText The instance timer text, or empty string if not found/unavailable
function Slib:GetInstanceTimer()
    if not self.Interfaces or not self.Interfaces.InstanceTimer then
        self:Error("InstanceTimer interface not defined")
        return ""
    end
    
    local Result = API.ScanForInterfaceTest2Get(false, self.Interfaces.InstanceTimer[1])
    if not Result then
        self:Warn("Failed to scan instance timer interface")
        return ""
    end
    
    if type(Result) ~= "table" and type(Result) ~= "userdata" then
        self:Error("Invalid result type from interface scan: " .. type(Result))
        return ""
    end
    
    if #Result == 0 then
        self:Warn("No timer interface elements found")
        return ""
    end
    
    local Element = Result[1]
    if not Element or not Element.textids then
        self:Warn("Timer element or textids not found")
        return ""
    end

    return tostring(Element.textids)
end

-- Checks if the instance timer matches a specific time value
---@param TimeToCheck string The time string to check for
---@return boolean matches True if timer matches the specified time, false otherwise
function Slib:InstanceTimerCheck(TimeToCheck)
    -- Parameter validation
    if not self:ValidateParams({
        {TimeToCheck, "string", "TimeToCheck"}
    }) then
        return false
    end
    
    local TimerText = self:GetInstanceTimer()
    
    -- Safety checks for nil or invalid return values
    if not TimerText then
        self:Warn("GetInstanceTimer returned nil")
        return false
    end
    
    if type(TimerText) ~= "string" then
        self:Warn("GetInstanceTimer returned non-string value: " .. type(TimerText))
        return false
    end
    
    if TimerText == "" then
        return false
    end
    
    local Found = string.find(TimerText, TimeToCheck, 1, true)
    return Found ~= nil
end

-- Retrieves the kill counts for GWD1 (God Wars Dungeon 1) followers
---@return table<string, number>|nil killCounts Table containing kill counts for each faction, or nil if failed to retrieve data
function Slib:GetGWD1KillCounts()

    local FactionNames = { "Armadyl", "Bandos", "Saradomin", "Zamorak", "Zaros" }
    local Results = {}
    local SuccessCount = 0

    -- Process each faction
    for i, BaseAddress in ipairs(self.Interfaces.GWD1KillCounts) do
        local FactionName = FactionNames[i]
        
        -- Scan interface for faction data
        local Data = API.ScanForInterfaceTest2Get(false, BaseAddress)
        if not Data then
            self:Warn(string.format("[GetGWD1KillCounts] Failed to scan interface for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        if type(Data) ~= "table" and type(Data) ~= "userdata" then
            self:Error(string.format("[GetGWD1KillCounts] Invalid data type for %s: %s", FactionName, type(Data)))
            Results[FactionName] = 0
            goto continue
        end
        
        if #Data == 0 then
            self:Warn(string.format("[GetGWD1KillCounts] No interface data found for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Get the first element and validate it
        local Element = Data[1]
        if not Element or not Element.memloc then
            self:Warn(string.format("[GetGWD1KillCounts] Invalid element data for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Read kill count from memory
        local Amount = API.ReadCharsLimit(Element.memloc + API.I_itemids3, 255)
        if not Amount then
            self:Warn(string.format("[GetGWD1KillCounts] Failed to read kill count for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Convert to number
        local KillCount = tonumber(Amount)
        if not KillCount then
            self:Warn(string.format("[GetGWD1KillCounts] Invalid kill count value for %s: %s", FactionName, tostring(Amount)))
            Results[FactionName] = 0
            goto continue
        end
        
        Results[FactionName] = KillCount
        SuccessCount = SuccessCount + 1
        self:Info(string.format("[GetGWD1KillCounts] %s kill count: %d", FactionName, KillCount))
        
        ::continue::
    end

    -- Print formatted results
    if SuccessCount > 0 then
        return Results
    else
        self:Error("[GetGWD1KillCounts] Failed to retrieve any kill counts")
        return nil
    end
end

-- Retrieves the kill counts for GWD2 (God Wars Dungeon 2) followers
---@return table<string, number>|nil killCounts Table containing kill counts for each faction, or nil if failed to retrieve data
function Slib:GetGWD2KillCounts()

    local FactionNames = { "Seren", "Sliske", "Zamorak", "Zaros" }
    local Results = {}
    local SuccessCount = 0

    -- Process each faction
    for i, BaseAddress in ipairs(self.Interfaces.GWD2KillCounts) do
        local FactionName = FactionNames[i]
        
        -- Scan interface for faction data
        local Data = API.ScanForInterfaceTest2Get(false, BaseAddress)
        if not Data then
            self:Warn(string.format("[GetGWD2KillCounts] Failed to scan interface for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        if type(Data) ~= "table" and type(Data) ~= "userdata" then
            self:Error(string.format("[GetGWD2KillCounts] Invalid data type for %s: %s", FactionName, type(Data)))
            Results[FactionName] = 0
            goto continue
        end
        
        if #Data == 0 then
            self:Warn(string.format("[GetGWD2KillCounts] No interface data found for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Get the first element and validate it
        local Element = Data[1]
        if not Element or not Element.memloc then
            self:Warn(string.format("[GetGWD2KillCounts] Invalid element data for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Read kill count from memory
        local Amount = API.ReadCharsLimit(Element.memloc + API.I_itemids3, 255)
        if not Amount then
            self:Warn(string.format("[GetGWD2KillCounts] Failed to read kill count for %s", FactionName))
            Results[FactionName] = 0
            goto continue
        end
        
        -- Convert to number
        local KillCount = tonumber(Amount)
        if not KillCount then
            self:Warn(string.format("[GetGWD2KillCounts] Invalid kill count value for %s: %s", FactionName, tostring(Amount)))
            Results[FactionName] = 0
            goto continue
        end
        
        Results[FactionName] = KillCount
        SuccessCount = SuccessCount + 1
        self:Info(string.format("[GetGWD2KillCounts] %s kill count: %d", FactionName, KillCount))
        
        ::continue::
    end

    -- Print formatted results
    if SuccessCount > 0 then
        return Results
    else
        self:Error("[GetGWD2KillCounts] Failed to retrieve any kill counts")
        return nil
    end
end

-- Checks recent chat messages for specified patterns and returns true if any are found
---@param Patterns string|table The pattern(s) to search for in chat messages
---@param DebugPrint boolean|nil Whether to print debug information (optional, default: false)
---@return boolean found True if any pattern was found in recent messages, false otherwise
function Slib:RecentMessageCheck(Patterns, DebugPrint)
    -- Parameter validation
    if not self:ValidateParams({
        {Patterns, {"string", "table_of_strings"}, "Patterns"},
        {DebugPrint, "boolean", "DebugPrint", true} -- allow_nil = true
    }) then
        return false
    end
    
    -- Convert single string to table for consistent processing
    local PatternTable = type(Patterns) == "table" and Patterns or {Patterns}
    
    -- Default debug_print to false
    DebugPrint = DebugPrint or false
    
    -- Gather recent chat messages
    self.ChatMessages = API.GatherEvents_chat_check()
    if not self.ChatMessages then
        self:Warn("Failed to gather chat self.ChatMessages")
        return false
    end
    
    if type(self.ChatMessages) ~= "table" and type(self.ChatMessages) ~= "userdata" then
        self:Error("Invalid self.ChatMessages data type: " .. type(self.ChatMessages))
        return false
    end
    
    if #self.ChatMessages == 0 then
        return false
    end
    
    -- Process each message
    for i, Message in ipairs(self.ChatMessages) do
        -- Validate message structure
        if not Message or not Message.text then
            if DebugPrint then
                self:Warn("Skipping invalid message at index " .. i)
            end
            goto continue_message
        end
        
        -- Debug print if requested
        if DebugPrint then
            print(string.format("[Chat Message] %s", Message.text))
        end
        
        -- Check message against all patterns (case insensitive)
        for _, Pattern in ipairs(PatternTable) do
            if string.find(string.lower(Message.text), string.lower(Pattern)) then
                if DebugPrint then
                    print(string.format("[RecentMessageCheck] Pattern matched: '%s'", Pattern))
                end
                return true
            end
        end
        
        ::continue_message::
    end
    
    -- No patterns matched
    return false
end

-- Waits for a specific object to appear within range
---@param ObjID number|table The object ID(s) to wait for
---@param Range number Maximum search distance in tiles
---@param ObjType number|table The object type(s) to search for
---@param TimeoutSeconds number Maximum wait time in seconds
---@return boolean found True if object was found within timeout, false otherwise
function Slib:WaitForObjectToAppear(ObjID, Range, ObjType, TimeoutSeconds)
    -- Parameter validation
    if not self:ValidateParams({
        {ObjID, {"number", "table_of_numbers"}, "ObjID"},
        {Range, "positive_number", "Range"},
        {ObjType, {"number", "table_of_numbers"}, "ObjType"},
        {TimeoutSeconds, "positive_number", "TimeoutSeconds"}
    }) then
        return false
    end
    
    -- Convert single numbers to tables for consistent processing
    local ObjIdTable = type(ObjID) == "table" and ObjID or {ObjID}
    local ObjTypeTable = type(ObjType) == "table" and ObjType or {ObjType}
    
    local StartTime = os.clock()
    local MaxTime = TimeoutSeconds
    
    -- Create descriptive strings for logging
    local ObjIdStr = type(ObjID) == "table" and table.concat(ObjIdTable, ", ") or tostring(ObjID)
    local ObjTypeStr = type(ObjType) == "table" and table.concat(ObjTypeTable, ", ") or tostring(ObjType)
    
    self:Info("Waiting for object ID(s) [" .. ObjIdStr .. "] (Type(s) [" .. ObjTypeStr .. "]) within range " .. Range .. " tiles...")
    
    while API.Read_LoopyLoop() do
        -- Check timeout
        if (os.clock() - StartTime) >= MaxTime then
            self:Warn("Timeout reached (" .. TimeoutSeconds .. "s) while waiting for object ID(s) [" .. ObjIdStr .. "]")
            return false
        end
        
        -- Search for the objects
        local Objects = API.GetAllObjArray1(ObjIdTable, Range, ObjTypeTable)
        
        if not Objects then
            self:Warn("API returned nil for object search")
            goto continue_wait
        end
        
        if type(Objects) ~= "table" and type(Objects) ~= "userdata" then
            self:Error("Invalid objects data type: " .. type(Objects))
            return false
        end
        
        if #Objects > 0 then
            -- Check each object to find exact match
            for _, Object in ipairs(Objects) do
                if not Object then
                    goto continue_object
                end
                
                local Id = Object.Id or 0
                local ObjectType = Object.Type or 0
                
                -- Check if this object matches any of our target IDs and types
                local IdMatch = false
                local TypeMatch = false
                
                for _, TargetId in ipairs(ObjIdTable) do
                    if Id == TargetId then
                        IdMatch = true
                        break
                    end
                end
                
                for _, TargetType in ipairs(ObjTypeTable) do
                    if ObjectType == TargetType then
                        TypeMatch = true
                        break
                    end
                end
                
                if IdMatch and TypeMatch then
                    local Elapsed = os.clock() - StartTime
                    self:Info("Object found! ID " .. Id .. " (Type " .. ObjectType .. ") after " .. string.format("%.1f", Elapsed) .. " seconds")
                    return true
                end
                
                ::continue_object::
            end
        end
        
        ::continue_wait::
        
        -- Short sleep to prevent excessive CPU usage
        self:Sleep(200, "ms")
    end
    
    self:Warn("Loop stopped while waiting for object ID(s) [" .. ObjIdStr .. "]")
    return false
end

-- Waits for a specific object to appear within range using GetAllObjArray2 (supports x, y, z parameters)
---@param ObjID number|table The object ID(s) to wait for
---@param Range number Maximum search distance in tiles
---@param ObjType number|table The object type(s) to search for
---@param x number The x coordinate to search from
---@param y number The y coordinate to search from
---@param z number The z coordinate to search from
---@param TimeoutSeconds number Maximum wait time in seconds
---@return boolean found True if object was found within timeout, false otherwise
function Slib:WaitForObjectToAppear2(ObjID, Range, ObjType, x, y, z, TimeoutSeconds)
    -- Parameter validation
    if not self:ValidateParams({
        {ObjID, {"number", "table_of_numbers"}, "ObjID"},
        {Range, "positive_number", "Range"},
        {ObjType, {"number", "table_of_numbers"}, "ObjType"},
        {x, "number", "x"},
        {y, "number", "y"},
        {z, "number", "z"},
        {TimeoutSeconds, "positive_number", "TimeoutSeconds"}
    }) then
        return false
    end
    
    -- Convert single numbers to tables for consistent processing
    local ObjIdTable = type(ObjID) == "table" and ObjID or {ObjID}
    local ObjTypeTable = type(ObjType) == "table" and ObjType or {ObjType}
    
    local StartTime = os.clock()
    local MaxTime = TimeoutSeconds
    
    -- Create descriptive strings for logging
    local ObjIdStr = type(ObjID) == "table" and table.concat(ObjIdTable, ", ") or tostring(ObjID)
    local ObjTypeStr = type(ObjType) == "table" and table.concat(ObjTypeTable, ", ") or tostring(ObjType)
    local TileStr = "from tile (" .. tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z) .. ")"
    
    self:Info("Waiting for object ID(s) [" .. ObjIdStr .. "] (Type(s) [" .. ObjTypeStr .. "]) within range " .. Range .. " tiles " .. TileStr .. "...")
    
    -- Construct WPOINT from x, y, z
    local Tile = WPOINT.new(x, y, z)
    
    while API.Read_LoopyLoop() do
        -- Check timeout
        if (os.clock() - StartTime) >= MaxTime then
            self:Warn("Timeout reached (" .. TimeoutSeconds .. "s) while waiting for object ID(s) [" .. ObjIdStr .. "]")
            return false
        end
        
        -- Search for the objects using GetAllObjArray2
        local Objects = API.GetAllObjArray2(ObjIdTable, Range, ObjTypeTable, Tile)
        
        if not Objects then
            self:Warn("API returned nil for object search")
            goto continue_wait
        end
        
        if type(Objects) ~= "table" and type(Objects) ~= "userdata" then
            self:Error("Invalid objects data type: " .. type(Objects))
            return false
        end
        
        if #Objects > 0 then
            -- Check each object to find exact match
            for _, Object in ipairs(Objects) do
                if not Object then
                    goto continue_object
                end
                
                local Id = Object.Id or 0
                local ObjectType = Object.Type or 0
                
                -- Check if this object matches any of our target IDs and types
                local IdMatch = false
                local TypeMatch = false
                
                for _, TargetId in ipairs(ObjIdTable) do
                    if Id == TargetId then
                        IdMatch = true
                        break
                    end
                end
                
                for _, TargetType in ipairs(ObjTypeTable) do
                    if ObjectType == TargetType then
                        TypeMatch = true
                        break
                    end
                end
                
                if IdMatch and TypeMatch then
                    local Elapsed = os.clock() - StartTime
                    self:Info("Object found! ID " .. Id .. " (Type " .. ObjectType .. ") after " .. string.format("%.1f", Elapsed) .. " seconds")
                    return true
                end
                
                ::continue_object::
            end
        end
        
        ::continue_wait::
        
        -- Short sleep to prevent excessive CPU usage
        self:Sleep(200, "ms")
    end
    
    self:Warn("Loop stopped while waiting for object ID(s) [" .. ObjIdStr .. "]")
    return false
end

-- Finds the nearest object with specified ID(s) and type(s) within range
---@param ObjId number|table The object ID(s) to search for
---@param Distance number Maximum search distance in tiles
---@param ObjType number|table The object type(s) to search for
---@return table|nil nearest_object The nearest matching object, or nil if none found
function Slib:FindObj(ObjId, Distance, ObjType)
    -- Parameter validation
    if not self:ValidateParams({
        {ObjId, {"number", "table_of_numbers"}, "ObjId"},
        {Distance, "id", "Distance"},
        {ObjType, {"number", "table_of_numbers"}, "ObjType"}
    }) then
        return nil
    end
    
    -- Convert to tables for API call
    local ObjIdTable = type(ObjId) == "table" and ObjId or {ObjId}
    local ObjTypeTable = type(ObjType) == "table" and ObjType or {ObjType}
    
    -- Search for objects
    local Objects = API.GetAllObjArray1(ObjIdTable, Distance, ObjTypeTable)
    
    if not Objects or #Objects == 0 then
        return nil
    end
    
    -- Find nearest object
    local NearestObj = nil
    local NearestDistance = math.huge
    
    for _, Obj in ipairs(Objects) do
        if Obj and Obj.Distance and Obj.Distance < NearestDistance then
            NearestObj = Obj
            NearestDistance = Obj.Distance
        end
    end
    
    return NearestObj
end

-- Finds the nearest object with specified ID(s) and type(s) within range using GetAllObjArray2 (supports x, y, z parameters)
---@param ObjId number|table The object ID(s) to search for
---@param Distance number Maximum search distance in tiles
---@param ObjType number|table The object type(s) to search for
---@param x number The x coordinate to search from
---@param y number The y coordinate to search from
---@param z number The z coordinate to search from
---@return table|nil nearest_object The nearest matching object, or nil if none found
function Slib:FindObj2(ObjId, Distance, ObjType, x, y, z)
    -- Parameter validation
    if not self:ValidateParams({
        {ObjId, {"number", "table_of_numbers"}, "ObjId"},
        {Distance, "id", "Distance"},
        {ObjType, {"number", "table_of_numbers"}, "ObjType"},
        {x, "number", "x"},
        {y, "number", "y"},
        {z, "number", "z"}
    }) then
        return nil
    end
    
    -- Convert to tables for API call
    local ObjIdTable = type(ObjId) == "table" and ObjId or {ObjId}
    local ObjTypeTable = type(ObjType) == "table" and ObjType or {ObjType}
    
    -- Construct WPOINT from x, y, z
    local Tile = WPOINT.new(x, y, z)
    
    -- Search for objects using GetAllObjArray2
    local Objects = API.GetAllObjArray2(ObjIdTable, Distance, ObjTypeTable, Tile)
    
    if not Objects or #Objects == 0 then
        return nil
    end
    
    -- Find nearest object
    local NearestObj = nil
    local NearestDistance = math.huge
    
    for _, Obj in ipairs(Objects) do
        if Obj and Obj.Distance and Obj.Distance < NearestDistance then
            NearestObj = Obj
            NearestDistance = Obj.Distance
        end
    end
    
    return NearestObj
end

-- Checks if a specific buff is currently active
---@param BuffId number The buff ID to check for
---@return boolean found True if the buff is currently active, false otherwise
function Slib:HasBuff(BuffId)
    -- Parameter validation
    if not self:ValidateParams({
        {BuffId, "id", "BuffId"}
    }) then
        return false
    end
    
    -- Protected API call with validation
    local Buffs = API.Buffbar_GetAllIDs()
    
    -- Check if API returned valid data
    if not Buffs then
        self:Error("[HasBuff] API returned nil for buffs")
        return false
    end
    
    if type(Buffs) ~= "table" and type(Buffs) ~= "userdata" then
        self:Error("[HasBuff] API returned invalid buff data type: " .. type(Buffs))
        return false
    end
    
    if #Buffs == 0 then
        return false
    end
    
    -- Safe iteration with bounds checking
    for I = 1, #Buffs do
        local Buff = Buffs[I]
        
        -- Check if buff exists and is valid
        if not Buff then
            goto continue
        end
        
        if type(Buff) ~= "table" and type(Buff) ~= "userdata" then
            goto continue
        end
        
        -- Check if this is the buff we're looking for
        if Buff.id == BuffId then
            self:Info("[HasBuff] Found active buff with ID: " .. BuffId)
            return true
        end
        
        ::continue::
    end
    
    return false
end

-- Checks if a specific debuff is currently active
---@param DebuffId number The debuff ID to check for
---@return boolean found True if the debuff is currently active, false otherwise
function Slib:HasDebuff(DebuffId)
    -- Parameter validation
    if not self:ValidateParams({
        {DebuffId, "id", "DebuffId"}
    }) then
        return false
    end
    
    -- Protected API call with validation
    local Debuffs = API.DeBuffbar_GetAllIDs()
    
    -- Check if API returned valid data
    if not Debuffs then
        self:Error("[HasDebuff] API returned nil for debuffs")
        return false
    end
    
    if type(Debuffs) ~= "table" and type(Debuffs) ~= "userdata" then
        self:Error("[HasDebuff] API returned invalid debuff data type: " .. type(Debuffs))
        return false
    end
    
    if #Debuffs == 0 then
        return false
    end
    
    -- Safe iteration with bounds checking
    for I = 1, #Debuffs do
        local Debuff = Debuffs[I]
        
        -- Check if debuff exists and is valid
        if not Debuff then
            goto continue
        end
        
        if type(Debuff) ~= "table" and type(Debuff) ~= "userdata" then
            goto continue
        end
        
        -- Check if this is the debuff we're looking for
        if Debuff.id == DebuffId then
            self:Info("[HasDebuff] Found active debuff with ID: " .. DebuffId)
            return true
        end
        
        ::continue::
    end
    
    return false
end

-- Checks if the currency pouch contains an item with the given ID or any ID in a list
---@param Ids number|table The item ID or list of item IDs to check for
---@return boolean found True if at least one of the IDs is found in the currency pouch, false otherwise
function Slib:CurrencyPouchContains(Ids)
    -- Parameter validation
    if not self:Sanitize(Ids, {"number", "table_of_ids"}, "Ids") then
        return false
    end
    
    -- Convert to table for consistent processing
    local IdTable = type(Ids) == "table" and Ids or {Ids}
    
    -- Track which IDs have been found
    local found = {}
    for _, id in ipairs(IdTable) do
        found[id] = false
    end
    
    -- Scan all currency pouch interfaces
    for I = 1, #self.Interfaces.CurrencyPouch do
        local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.CurrencyPouch[I])
        if Interface and (type(Interface) == "table" or type(Interface) == "userdata") then
            for _, Item in pairs(Interface) do
                if Item and Item.itemid1 and Item.itemid1 >= 0 then
                    if found[Item.itemid1] == false then
                        found[Item.itemid1] = true
                    end
                end
            end
        end
    end
    -- Check if all IDs were found
    for _, id in ipairs(IdTable) do
        if not found[id] then
            return false
        end
    end
    return true
end

-- Checks if the area loot interface is currently open
---@return boolean isOpen True if area loot interface is open, false otherwise
function Slib:AreaLootIsOpen()
    -- Validate that AreaLoot interface is defined
    if not self.Interfaces or not self.Interfaces.AreaLoot or not self.Interfaces.AreaLoot[1] then
        self:Error("[AreaLootIsOpen] AreaLoot interface not defined")
        return false
    end
    
    -- Scan for the area loot interface
    local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.AreaLoot[1])
    if not Interface then
        return false
    end
    
    -- Validate interface data type
    if type(Interface) ~= "table" and type(Interface) ~= "userdata" then
        self:Error("[AreaLootIsOpen] Invalid interface data type: " .. type(Interface))
        return false
    end

    if #Interface > 0 then
        self:Info("[AreaLootIsOpen] Area loot interface is open")
        return true
    end
    
    self:Warn("[AreaLootIsOpen] Area loot interface is closed")
    return false
end

-- Retrieves all items currently visible in the area loot interface
---@return table|nil items Array of items {itemId, slotId} or nil if interface closed or no items found
function Slib:AreaLootGetItems()
    -- Check if area loot is open
    if not self:AreaLootIsOpen() then
        self:Warn("[AreaLootGetItems] Area loot interface is not open")
        return nil
    end
    
    -- Validate that AreaLoot interface is defined
    if not self.Interfaces or not self.Interfaces.AreaLoot or not self.Interfaces.AreaLoot[1] then
        self:Error("[AreaLootGetItems] AreaLoot interface not defined")
        return nil
    end
    
    -- Scan for the area loot interface
    local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.AreaLoot[1])
    if not Interface then
        self:Error("[AreaLootGetItems] Failed to scan area loot interface")
        return nil
    end
    
    -- Validate interface data type
    if type(Interface) ~= "table" and type(Interface) ~= "userdata" then
        self:Error("[AreaLootGetItems] Invalid interface data type: " .. type(Interface))
        return nil
    end
    
    local Items = {}
    local ItemCount = 0
    
    -- Process each interface element
    for I, Item in pairs(Interface) do
        -- Validate item structure
        if not Item then
            self:Warn("[AreaLootGetItems] Skipping nil item at index " .. tostring(I))
            goto continue_item
        end
        
        if type(Item) ~= "table" and type(Item) ~= "userdata" then
            self:Warn("[AreaLootGetItems] Skipping invalid item at index " .. tostring(I) .. " (type: " .. type(Item) .. ")")
            goto continue_item
        end
        
        -- Check for valid item ID (not -1 which indicates empty slot)
        if Item.itemid1 and Item.itemid1 ~= -1 and Item.itemid1 >= 0 then
            ItemCount = ItemCount + 1
            table.insert(Items, {Item.itemid1, Item.id3 or 0})
        end
        
        ::continue_item::
    end
    
    if ItemCount == 0 then
        self:Info("[AreaLootGetItems] No valid items found in area loot")
        return {}
    end

    return Items
end

-- Checks if the area loot contains all specified item IDs
---@param ItemIds number|table The item ID or table of item IDs to check for
---@return boolean allFound True if all specified items are found in area loot, false otherwise
function Slib:AreaLootContains(ItemIds)
    -- Parameter validation
    if not self:Sanitize(ItemIds, {"number", "table_of_ids"}, "ItemIds") then
        return false
    end
    
    -- Convert to table for consistent processing
    local IdTable = type(ItemIds) == "table" and ItemIds or {ItemIds}
    
    if not self:AreaLootIsOpen() then
        return false
    end

    local Items = self:AreaLootGetItems()
    if not Items then
        return false
    end
    
    -- Track which IDs have been found
    local foundIds = {}
    for _, targetId in ipairs(IdTable) do
        foundIds[targetId] = false
    end
    
    -- Check each item in area loot against all target IDs
    for _, item in pairs(Items) do
        for _, targetId in ipairs(IdTable) do
            if item[1] == targetId then
                foundIds[targetId] = true
                self:Info("Item " .. targetId .. " found in area loot")
            end
        end
    end
    
    -- Check if all IDs were found
    for _, targetId in ipairs(IdTable) do
        if not foundIds[targetId] then
            self:Info("Item " .. targetId .. " not found in area loot")
            return false
        end
    end
    
    self:Info("All specified items found in area loot")
    return true
end

-- Checks if the instance interface is currently open
---@return boolean IsOpen True if instance interface is open, false otherwise
function Slib:InstanceInterfaceIsOpen()
    local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.InstanceOptions[1])
    return #Interface > 0
end

-- Retrieves all available instance interface options and settings
---@return table|nil Options Table containing instance options or nil if interface is closed
---@return table Options.MaxPlayers Maximum players interface element
---@return table Options.MinCombat Minimum combat level interface element  
---@return table Options.SpawnSpeed Spawn speed interface element
---@return table Options.Protection Protection interface element
---@return boolean Options.PracticeMode Practice mode enabled state
---@return boolean Options.HardMode Hard mode enabled state
function Slib:GetInstanceInterfaceOptions()
    -- Validate interface state before proceeding
    if not self:InstanceInterfaceIsOpen() then
        self:Error("[GetInstanceInterfaceOptions] Instance interface is not open")
        return nil
    end

    -- Retrieve interface elements for each option
    local MaxPlayersRaw = API.ScanForInterfaceTest2Get(true, self.Interfaces.InstanceOptions[2])
    local MinCombatRaw = API.ScanForInterfaceTest2Get(true, self.Interfaces.InstanceOptions[3])
    local SpawnSpeedRaw = API.ScanForInterfaceTest2Get(true, self.Interfaces.InstanceOptions[4])
    local ProtectionRaw = API.ScanForInterfaceTest2Get(true, self.Interfaces.InstanceOptions[5])
    
    -- Parse values with proper nil checking
    local MaxPlayersTreated = tonumber(API.ReadCharsLimit(MaxPlayersRaw[1].memloc + API.I_itemids3, 255))
    local MinCombatTreated = tonumber(API.ReadCharsLimit(MinCombatRaw[1].memloc + API.I_itemids3, 255))
    local SpawnSpeedTreated = tostring(SpawnSpeedRaw[1].textids)
    local ProtectionTreated = tostring(ProtectionRaw[1].textids)

    
    -- Get mode settings from varbits (convert 0/1 to false/true)
    local PracticeMode = API.GetVarbitValue(27142) == 1
    local HardMode = API.GetVarbitValue(27141) == 1

    -- Debug output for interface values
    if MaxPlayersTreated then
        print("Max Players: " .. tostring(MaxPlayersTreated))
    end
    if MinCombatTreated then
        print("Min Combat: " .. tostring(MinCombatTreated))
    end
    if SpawnSpeedTreated then
        print("Spawn Speed: " .. SpawnSpeedTreated)
    end
    if ProtectionTreated then
        print("Protection: " .. ProtectionTreated)
    end
    print("Practice Mode: " .. tostring(PracticeMode))
    print("Hard Mode: " .. tostring(HardMode))

    -- Return structured options table
    return {
        MaxPlayers = MaxPlayersTreated,
        MinCombat = MinCombatTreated,
        SpawnSpeed = SpawnSpeedTreated,
        Protection = ProtectionTreated,
        PracticeMode = PracticeMode,
        HardMode = HardMode
    }
end

-- Checks if the text input interface is currently open
---@return boolean IsOpen True if text input interface is open, false otherwise
function Slib:TextInputIsOpen()
    local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.TextInput[1])
    return #Interface > 0
end

-- Gets the player's facing direction as a compass direction
---@return string direction The compass direction: "N", "NE", "E", "SE", "S", "SW", "W", "NW"
function Slib:PlayerFacing()
    local Azimuth = API.calculatePlayerOrientation()
    
    if not Azimuth then
        self:Error("[PlayerFacing] Failed to get player orientation")
        return "N" -- Default fallback
    end
    
    -- Normalize azimuth to 0-360 range
    Azimuth = Azimuth % 360
    if Azimuth < 0 then
        Azimuth = Azimuth + 360
    end
    
    -- Convert azimuth to compass direction
    -- Each direction covers 45° (360° / 8 = 45°)
    -- Centered on: N=0°, NE=45°, E=90°, SE=135°, S=180°, SW=225°, W=270°, NW=315°
    local Direction
    if Azimuth >= 337.5 or Azimuth < 22.5 then
        Direction = "N"
    elseif Azimuth >= 22.5 and Azimuth < 67.5 then
        Direction = "NE"
    elseif Azimuth >= 67.5 and Azimuth < 112.5 then
        Direction = "E"
    elseif Azimuth >= 112.5 and Azimuth < 157.5 then
        Direction = "SE"
    elseif Azimuth >= 157.5 and Azimuth < 202.5 then
        Direction = "S"
    elseif Azimuth >= 202.5 and Azimuth < 247.5 then
        Direction = "SW"
    elseif Azimuth >= 247.5 and Azimuth < 292.5 then
        Direction = "W"
    elseif Azimuth >= 292.5 and Azimuth < 337.5 then
        Direction = "NW"
    end
    
    self:Info("[PlayerFacing] Player facing " .. Direction .. " (" .. string.format("%.1f", Azimuth) .. "°)")
    return Direction
end

-- Checks if any object with specified ID and type has Bool1 property set to 1 within range
---@param ObjId number|table The object ID(s) to search for
---@param Range number Maximum search distance in tiles
---@param ObjType number|table The object type(s) to search for
---@return boolean hasBool1Object True if at least one object with Bool1=1 is found, false otherwise
function Slib:CheckObjectBool1(ObjId, Range, ObjType)
    -- Parameter validation
    if not self:ValidateParams({
        {ObjId, {"number", "table_of_numbers"}, "ObjId"},
        {Range, "non_negative_number", "Range"},
        {ObjType, {"number", "table_of_numbers"}, "ObjType"}
    }) then
        return false
    end
    
    -- Convert to tables for API call
    local ObjIdTable = type(ObjId) == "table" and ObjId or {ObjId}
    local ObjTypeTable = type(ObjType) == "table" and ObjType or {ObjType}
    
    -- Search for objects
    local Objects = API.GetAllObjArray1(ObjIdTable, Range, ObjTypeTable)
    
    if not Objects then
        self:Warn("[CheckObjectBool1] API returned nil for object search")
        return false
    end
    
    if type(Objects) ~= "table" and type(Objects) ~= "userdata" then
        self:Error("[CheckObjectBool1] Invalid objects data type: " .. type(Objects))
        return false
    end
    
    if #Objects == 0 then
        return false
    end
    
    -- Check each object for Bool1 property
    local Bool1Count = 0
    for _, Object in ipairs(Objects) do
        if Object and Object.Bool1 == 1 then
            Bool1Count = Bool1Count + 1
        end
    end
    
    if Bool1Count > 0 then
        self:Info("[CheckObjectBool1] Found " .. Bool1Count .. " object(s) with Bool1=1")
        return true
    end
    
    return false
end

-- Returns a simple table containing rune quantities organized by type
---@return table runes Table containing rune amounts organized by type
---@return table runes.Normal Normal runes amounts (from pouches and inventory)
---@return table runes.Combination Combination runes amounts (from inventory only)
---@return table runes.Necromancy Necromancy runes amounts (inventory + nexus total)
function Slib:GetRuneAmounts()
    local RuneAmounts = {
        Normal = {},
        Combination = {},
        Necromancy = {}
    }
    
    -- Get Normal Runes (from pouches + inventory)
    for RuneName, Rune in pairs(self.Items.Runes.Normal) do
        local Success, Result = pcall(function()
            return API.VC_FindPSett(Rune.InventoryVB, 1)
        end)
        
        local RuneAmount = 0
        if Success and Result and Result.state then
            RuneAmount = tonumber(Result.state) or 0
        end
        
        RuneAmounts.Normal[RuneName] = RuneAmount
    end
    
    -- Get Combination Runes (inventory only)
    for RuneName, Rune in pairs(self.Items.Runes.Combination) do
        local Success, RuneAmount = pcall(function()
            return tonumber(Inventory:GetItemAmount(Rune.Id)) or 0
        end)
        
        if not Success then
            RuneAmount = 0
        end
        
        RuneAmounts.Combination[RuneName] = RuneAmount
    end
    
    -- Get Necromancy Runes (inventory + nexus)
    local NexusRunes = API.Container_Get_all(953)
    
    for RuneName, Rune in pairs(self.Items.Runes.Necromancy) do
        -- Get inventory amount
        local InventoryAmount = 0
        local Success, Result = pcall(function()
            return Inventory:GetItemAmount(Rune.Id)
        end)
        
        if Success and Result then
            InventoryAmount = Result
        end
        
        -- Get nexus amount
        local NexusAmount = 0
        if NexusRunes then
            for _, ContainerItem in pairs(NexusRunes) do
                if ContainerItem and ContainerItem.item_id == Rune.Id then
                    NexusAmount = NexusAmount + (ContainerItem.item_stack or 0)
                end
            end
        end
        
        local TotalAmount = InventoryAmount + NexusAmount
        RuneAmounts.Necromancy[RuneName] = TotalAmount
    end
    
    return RuneAmounts
end

--- Get the currently active spellbook
---@return string The name of the active spellbook ("Standard", "Ancient", "Lunar") or unknown
function Slib:GetSpellBook()
    local spellbook = API.GetVarbitValue(39733)
    if spellbook == 0 then
        return "Standard"
    elseif spellbook == 1 then
        return "Ancient"
    elseif spellbook == 2 then
        return "Lunar"
    end
    return "Unknown"
end

-- Checks if an ability exists by its ID or name
---@param AbilityIdOrName number|string The ID (number) or name (string) of the ability to check
---@return boolean exists True if the ability exists, false otherwise
function Slib:AbilityExists(AbilityIdOrName)
    -- Parameter validation
    if not self:ValidateParams({
        {AbilityIdOrName, {"number", "string"}, "AbilityIdOrName"}
    }) then
        return false
    end
    
    self:Info(string.format("[AbilityExists] Checking if ability exists: %s (type: %s)", tostring(AbilityIdOrName), type(AbilityIdOrName)))
    
    local AbilityData = nil
    
    -- Get ability data based on parameter type
    if type(AbilityIdOrName) == "number" then
        AbilityData = API.GetABs_id(AbilityIdOrName)
        if not AbilityData or AbilityData.id == 0 then
            self:Warn(string.format("[AbilityExists] Ability with ID %d not found", AbilityIdOrName))
            return false
        end
    elseif type(AbilityIdOrName) == "string" then
        AbilityData = API.GetABs_name(AbilityIdOrName, true)
        if not AbilityData or AbilityData.id == 0 then
            self:Warn(string.format("[AbilityExists] Ability with name '%s' not found", AbilityIdOrName))
            return false
        end
    end
    
    self:Info(string.format("[AbilityExists] Ability found: %s", tostring(AbilityIdOrName)))
    return true
end

-- Checks if an ability can be cast
---@param AbilityIdOrName number|string The ID (number) or name (string) of the ability to check
---@return boolean True if the ability can be cast, false otherwise
function Slib:CanCastAbility(AbilityIdOrName)
    -- Parameter validation
    if not self:ValidateParams({
        {AbilityIdOrName, {"number", "string"}, "AbilityIdOrName"}
    }) then
        return false
    end
    
    self:Info(string.format("[CanCastAbility] Checking if ability can be cast: %s (type: %s)", tostring(AbilityIdOrName), type(AbilityIdOrName)))
    
    local AbilityData = nil
    
    -- Get ability data based on parameter type
    if type(AbilityIdOrName) == "number" then
        AbilityData = API.GetABs_id(AbilityIdOrName)
        if not AbilityData or not AbilityData.enabled or AbilityData.id == 0 or AbilityData.cooldown_timer > 0 then
            self:Warn(string.format("[CanCastAbility] Ability with ID %d cannot be cast", AbilityIdOrName))
            return false
        end
    elseif type(AbilityIdOrName) == "string" then
        AbilityData = API.GetABs_name(AbilityIdOrName, true)
        if not AbilityData or not AbilityData.enabled or AbilityData.id == 0 or AbilityData.cooldown_timer > 0 then
            self:Warn(string.format("[CanCastAbility] Ability with name '%s' cannot be cast", AbilityIdOrName))
            return false
        end
    end
    
    self:Info(string.format("[CanCastAbility] Ability can be cast: %s", tostring(AbilityIdOrName)))
    return true
end

-- ##################################
-- #                                #
-- #           PROCEDURES           #
-- #                                #
-- ##################################

-- Walks to specified coordinates
---@param X number The target X coordinate
---@param Y number The target Y coordinate
---@param Z number The target Z coordinate (floor/plane)
---@return boolean success True if walk was initiated or player is already at destination, false on failure
function Slib:WalkToCoordinates(X, Y, Z)
    self:Info("[WalkToCoordinates] Starting walk to coordinates (" .. X .. ", " .. Y .. ", " .. Z .. ")...")
    -- Parameter validation
    if not self:ValidateParams({
        {X, "number", "X"},
        {Y, "number", "Y"},
        {Z, "number", "Z"}
    }) then
        self:Error("[WalkToCoordinates] Parameter validation failed")
        return false
    end
    
    -- Check if already at destination
    local AtDest = self:IsPlayerAtCoords(X, Y, Z)
    if AtDest then
        self:Info("[WalkToCoordinates] Already at destination coordinates")
        return true
    end

    local WalkResult = API.DoAction_Tile(WPOINT.new(X, Y, Z))
    if not WalkResult then
        self:Error("[WalkToCoordinates] Failed to initiate walk to (" .. X .. ", " .. Y .. ", " .. Z .. ")")
        return false
    end

    return true
end

-- Dives to the specified coordinates using Bladed Dive or regular Dive
---@param X number The target X coordinate
---@param Y number The target Y coordinate
---@param Z number The target Z coordinate
---@return boolean success True if dive was successful, false if abilities on cooldown or dive failed
function Slib:Dive(X, Y, Z)
    -- Parameter validation
    if not self:ValidateParams({
        {X, "number", "X"},
        {Y, "number", "Y"},
        {Z, "number", "Z"}
    }) then
        return false
    end

    self:Info(string.format("[Dive] Attempting to dive to coordinates (%d, %d, %d)", X, Y, Z))
    
    -- Check Bladed Dive ability
    local BladedDive = API.GetABs_id(30331)
    if not BladedDive then
        self:Error("[Dive] Failed to get Bladed Dive ability info")
        return false
    end
    
    -- Check regular Dive ability
    local RegularDive = API.GetABs_id(23714)
    if not RegularDive then
        self:Error("[Dive] Failed to get regular Dive ability info")
        return false
    end
    
    -- Check if either ability is available
    local BladedDiveReady = BladedDive.id ~= 0 and BladedDive.enabled and BladedDive.cooldown_timer < 1
    local RegularDiveReady = RegularDive.id ~= 0 and RegularDive.enabled and RegularDive.cooldown_timer < 1
    
    if not (BladedDiveReady or RegularDiveReady) then
        self:Warn("[Dive] No dive abilities available (on cooldown or disabled)")
        return false
    end
    
    -- Create target point
    local TargetPoint = WPOINT.new(X, Y, Z)
    
    -- Try Bladed Dive first
    if BladedDiveReady then
        self:Info("[Dive] Attempting Bladed Dive...")
        if API.DoAction_BDive_Tile(TargetPoint) then
            self:Info("[Dive] Bladed Dive successful")
            return true
        end
        self:Warn("[Dive] Bladed Dive failed")
    end
    
    -- Try regular Dive as fallback
    if RegularDiveReady then
        self:Info("[Dive] Attempting regular Dive...")
        if API.DoAction_Dive_Tile(TargetPoint) then
            self:Info("[Dive] Regular Dive successful")
            return true
        end
        self:Warn("[Dive] Regular Dive failed")
    end
    
    self:Error("[Dive] All dive attempts failed")
    return false
end

-- Uses an ability by its ID
---@param AbilityId number The ID of the ability to use
---@return boolean success True if ability was used successfully, false if ability not found, on cooldown, or disabled
function Slib:UseAbilityById(AbilityId)
    -- Parameter validation
    if not self:ValidateParams({
        {AbilityId, "id", "AbilityId"}
    }) then
        return false
    end    

    self:Info(string.format("[UseAbilityById] Attempting to use ability with ID: %d", AbilityId))

    if not Slib:AbilityExists(AbilityId) then
        self:Error(string.format("[UseAbilityById] Ability with ID %d not found", AbilityId))
        return false
    end
    
    -- Get ability information
    local Ability = API.GetABs_id(AbilityId)
    
    -- Check if ability is available
    if not Ability.enabled then
        self:Info(string.format("[UseAbilityById] Ability %d is currently disabled", AbilityId))
        return false
    end
    
    -- Check cooldown
    if Ability.cooldown_timer >= 1 then
        self:Info(string.format("[UseAbilityById] Ability %d is on cooldown (%.1f seconds remaining)", AbilityId, Ability.cooldown_timer))
        return false
    end
    
    -- Attempt to use the ability
    self:Info(string.format("[UseAbilityById] Using ability %d", AbilityId))
    return API.DoAction_Ability_Direct(Ability, 1, API.OFF_ACT_GeneralInterface_route)
end

-- Uses an ability by name if it exists and is enabled. ExactMatch is used to check if the ability name is exact.
---@param AbilityName string
---@param ExactMatch boolean
---@return boolean
function Slib:UseAbilityByName(AbilityName, ExactMatch)    
    -- Parameter validation
    if not self:ValidateParams({
        {AbilityName, "non_empty_string", "AbilityName"},
        {ExactMatch, "boolean", "ExactMatch"}
    }) then
        self:Error("[UseAbilityByName] Parameter validation failed")
        return false
    end

    self:Info("[UseAbilityByName] Attempting to use ability: " .. AbilityName .. " (ExactMatch: " .. tostring(ExactMatch) .. ")")

    if not Slib:AbilityExists(AbilityName) then
        self:Error(string.format("[UseAbilityById] Ability with ID %d not found", AbilityId))
        return false
    end
    
    -- Get ability information using GetABs_name
    local Ability = API.GetABs_name(AbilityName, ExactMatch)
    
    if type(Ability) ~= "table" and type(Ability) ~= "userdata" then
        self:Error("[UseAbilityByName] Invalid ability data type: " .. type(Ability))
        return false
    end
    
    -- Check if ability is enabled
    if not Ability.enabled then
        self:Warn("[UseAbilityByName] Ability is not enabled: " .. AbilityName)
        return false
    end
    
    self:Info("[UseAbilityByName] Ability found and enabled. Attempting to use...")
    -- Attempt to use the ability
    local Result = API.DoAction_Ability(AbilityName,1,API.OFF_ACT_GeneralInterface_route,ExactMatch)
    if not Result then
        self:Error("[UseAbilityByName] Failed to use ability: " .. AbilityName)
        return false
    end
    
    self:Info("[UseAbilityByName] Ability used successfully: " .. AbilityName)
    return true
end

-- Moves the player to target coordinates using Dive and Surge
---@param X number The target X coordinate
---@param Y number The target Y coordinate  
---@param Z number The target Z coordinate
---@return boolean success True if movement was successful, false on failure
function Slib:MoveTo(X, Y, Z)
    -- Parameter validation
    if not self:ValidateParams({
        {X, "number", "X"},
        {Y, "number", "Y"},
        {Z, "number", "Z"}
    }) then
        return false
    end
    
    self:Info(string.format("[MoveTo] Starting movement to coordinates (%d, %d, %d)", X, Y, Z))
    
    -- Check if already at destination
    if self:IsPlayerAtCoords(X, Y, Z) then
        self:Info("[MoveTo] Already at destination")
        return true
    end
    
    local LastWalkTarget = nil
    local PlayerName = API.GetLocalPlayerName()
    local StuckCheckCount = 0
    local LastPosition = nil
    local MaxStuckChecks = 10  -- Fail after 10 consecutive checks of no movement/position change
    local LoopCount = 0  -- Made local to avoid global pollution
    
    if not PlayerName then
        self:Error("[MoveTo] Failed to get player name")
        return false
    end
    
    while API.Read_LoopyLoop() do
        -- Check if we've reached the destination
        if self:IsPlayerAtCoords(X, Y, Z) then
            self:Info("[MoveTo] Successfully reached destination")
            return true
        end
        
        -- Get current player position
        local CurrentPos = API.PlayerCoord()
        if not CurrentPos then
            self:Error("[MoveTo] Failed to get player coordinates")
            return false
        end
        
        -- Calculate distance to target
        local DistanceToTarget = math.sqrt((X - CurrentPos.x)^2 + (Y - CurrentPos.y)^2)
        -- Only show position info every 10 iterations to reduce spam
        LoopCount = LoopCount + 1
        if LoopCount % 10 == 1 then
            self:Info(string.format("[MoveTo] Position: (%d, %d, %d), Distance: %.1f", 
                CurrentPos.x, CurrentPos.y, CurrentPos.z, DistanceToTarget))
        end
        
        -- Check if player is moving
        local IsMoving = API.IsPlayerMoving_(PlayerName)
        
        -- Stuck detection - check if position hasn't changed and player isn't moving
        if LastPosition then
            local PositionChanged = (CurrentPos.x ~= LastPosition.x or CurrentPos.y ~= LastPosition.y)
            if not PositionChanged and not IsMoving then
                StuckCheckCount = StuckCheckCount + 1
                self:Warn(string.format("[MoveTo] Player appears stuck (check %d/%d)", StuckCheckCount, MaxStuckChecks))
                if StuckCheckCount >= MaxStuckChecks then
                    self:Error("[MoveTo] Player stuck - movement failed")
                    return false
                end
            else
                StuckCheckCount = 0  -- Reset stuck counter if player moved or position changed
            end
        end
        LastPosition = {x = CurrentPos.x, y = CurrentPos.y, z = CurrentPos.z}
        
        -- Try dive/surge when player is moving to enhance movement speed
        if IsMoving then
                -- Try dive first if available (bladed dive preferred over regular dive)
                local BladedDive = API.GetABs_id(30331)
                local RegularDive = API.GetABs_id(23714)
                
                local CanBladedDive = BladedDive and BladedDive.id ~= 0 and BladedDive.enabled and BladedDive.cooldown_timer < 1
                local CanRegularDive = RegularDive and RegularDive.id ~= 0 and RegularDive.enabled and RegularDive.cooldown_timer < 1
                
                if (CanBladedDive or CanRegularDive) and DistanceToTarget > 1 then
                    -- Dive directly to destination if within 10 tiles, otherwise dive 10 tiles toward destination
                    if DistanceToTarget <= 10 then
                        -- Dive directly to destination
                        if self:Dive(X, Y, Z) then
                            self:Info("[MoveTo] Dive to destination successful")
                            self:RandomSleep(100, 200, "ms")  -- Short delay after dive
                            -- Continue walking from new position toward destination
                            local WalkDistance = math.random(15, 30)
                            if DistanceToTarget > WalkDistance then
                                -- Calculate new intermediate walk point
                                local NewPos = API.PlayerCoord()
                                if NewPos then
                                    local DirectionX = X - NewPos.x
                                    local DirectionY = Y - NewPos.y
                                    local DirectionLength = math.sqrt(DirectionX^2 + DirectionY^2)
                                    local NormalizedX = DirectionX / DirectionLength
                                    local NormalizedY = DirectionY / DirectionLength
                                    local WalkX = math.floor(NewPos.x + (NormalizedX * WalkDistance))
                                    local WalkY = math.floor(NewPos.y + (NormalizedY * WalkDistance))
                                    self:WalkToCoordinates(WalkX, WalkY, Z)
                                    LastWalkTarget = {x = WalkX, y = WalkY, z = Z}
                                end
                            else
                                self:WalkToCoordinates(X, Y, Z)
                                LastWalkTarget = {x = X, y = Y, z = Z}
                            end
                            goto continue_loop
                        end
                    else
                        -- Dive 10 tiles toward destination (max dive range)
                        local DiveRange = 10  -- Maximum dive distance
                        local DirectionX = X - CurrentPos.x
                        local DirectionY = Y - CurrentPos.y
                        local DirectionLength = math.sqrt(DirectionX^2 + DirectionY^2)
                        
                        -- Calculate dive point (10 tiles toward destination)
                        local NormalizedX = DirectionX / DirectionLength
                        local NormalizedY = DirectionY / DirectionLength
                        local DiveX = math.floor(CurrentPos.x + (NormalizedX * DiveRange))
                        local DiveY = math.floor(CurrentPos.y + (NormalizedY * DiveRange))
                        
                        if self:Dive(DiveX, DiveY, Z) then
                            self:Info("[MoveTo] Dive toward destination successful")
                            self:RandomSleep(400, 600, "ms")  -- Short delay after dive
                            -- Continue walking from new position toward destination
                            local WalkDistance = math.random(15, 30)
                            if DistanceToTarget > WalkDistance then
                                -- Calculate new intermediate walk point from new position
                                local NewPos = API.PlayerCoord()
                                if NewPos then
                                    local NewDirectionX = X - NewPos.x
                                    local NewDirectionY = Y - NewPos.y
                                    local NewDirectionLength = math.sqrt(NewDirectionX^2 + NewDirectionY^2)
                                    local NewNormalizedX = NewDirectionX / NewDirectionLength
                                    local NewNormalizedY = NewDirectionY / NewDirectionLength
                                    local WalkX = math.floor(NewPos.x + (NewNormalizedX * WalkDistance))
                                    local WalkY = math.floor(NewPos.y + (NewNormalizedY * WalkDistance))
                                    self:WalkToCoordinates(WalkX, WalkY, Z)
                                    LastWalkTarget = {x = WalkX, y = WalkY, z = Z}
                                end
                            else
                                self:WalkToCoordinates(X, Y, Z)
                                LastWalkTarget = {x = X, y = Y, z = Z}
                            end
                            goto continue_loop
                        end
                    end
                end
                
                -- Try surge if available, facing compatible direction, AND more than 10 tiles from destination
                if DistanceToTarget > 10 then
                    local Surge = API.GetABs_id(14233)
                    local CanSurge = Surge and Surge.id ~= 0 and Surge.enabled and Surge.cooldown_timer < 1
                    
                    if CanSurge then
                        -- Get player facing direction using PlayerFacing helper function
                        local PlayerDirection = self:PlayerFacing()
                        
                        -- Determine target direction (walk target if available, otherwise destination)
                        local TargetX, TargetY
                        if LastWalkTarget then
                            TargetX = LastWalkTarget.x
                            TargetY = LastWalkTarget.y
                        else
                            TargetX = X
                            TargetY = Y
                        end
                        
                        local DeltaX = TargetX - CurrentPos.x
                        local DeltaY = TargetY - CurrentPos.y
                        
                        -- Calculate required movement direction based on position deltas
                        local MovementDirection
                        if math.abs(DeltaX) > math.abs(DeltaY) then
                            -- More horizontal movement
                            if DeltaX > 0 then
                                MovementDirection = math.abs(DeltaY) > math.abs(DeltaX) * 0.4 and (DeltaY > 0 and "NE" or "SE") or "E"
                            else
                                MovementDirection = math.abs(DeltaY) > math.abs(DeltaX) * 0.4 and (DeltaY > 0 and "NW" or "SW") or "W"
                            end
                        else
                            -- More vertical movement
                            if DeltaY > 0 then
                                MovementDirection = math.abs(DeltaX) > math.abs(DeltaY) * 0.4 and (DeltaX > 0 and "NE" or "NW") or "N"
                            else
                                MovementDirection = math.abs(DeltaX) > math.abs(DeltaY) * 0.4 and (DeltaX > 0 and "SE" or "SW") or "S"
                            end
                        end
                        
                        -- Check if player is facing movement direction or compatible adjacent direction
                        local CanSurgeInDirection = false
                        if PlayerDirection == MovementDirection then
                            CanSurgeInDirection = true
                        else
                            -- Allow surge for adjacent compass directions (e.g., N and NE are compatible)
                            local CompatibleDirections = {
                                N = {"NE", "NW"},
                                NE = {"N", "E"},
                                E = {"NE", "SE"},
                                SE = {"E", "S"},
                                S = {"SE", "SW"},
                                SW = {"S", "W"},
                                W = {"SW", "NW"},
                                NW = {"W", "N"}
                            }
                            
                            if CompatibleDirections[PlayerDirection] then
                                for _, compatDir in ipairs(CompatibleDirections[PlayerDirection]) do
                                    if compatDir == MovementDirection then
                                        CanSurgeInDirection = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        if CanSurgeInDirection then
                            if self:UseAbilityById(14233) then  -- Surge ability ID
                                self:Info("[MoveTo] Surge successful")
                                self:RandomSleep(200, 400, "ms")  -- Short delay after surge
                                -- Continue walking from new position toward destination
                                local WalkDistance = math.random(15, 30)
                                local NewPos = API.PlayerCoord()
                                if NewPos then
                                    local NewDistanceToTarget = math.sqrt((X - NewPos.x)^2 + (Y - NewPos.y)^2)
                                    if NewDistanceToTarget > WalkDistance then
                                        -- Calculate new intermediate walk point from post-surge position
                                        local DirectionX = X - NewPos.x
                                        local DirectionY = Y - NewPos.y
                                        local DirectionLength = math.sqrt(DirectionX^2 + DirectionY^2)
                                        local NormalizedX = DirectionX / DirectionLength
                                        local NormalizedY = DirectionY / DirectionLength
                                        local WalkX = math.floor(NewPos.x + (NormalizedX * WalkDistance))
                                        local WalkY = math.floor(NewPos.y + (NormalizedY * WalkDistance))
                                        self:WalkToCoordinates(WalkX, WalkY, Z)
                                        LastWalkTarget = {x = WalkX, y = WalkY, z = Z}
                                    else
                                        self:WalkToCoordinates(X, Y, Z)
                                        LastWalkTarget = {x = X, y = Y, z = Z}
                                    end
                                end
                                goto continue_loop
                            end
                        end
                    end
                end
        else
            -- Player not moving - initiate or restart walking
            local ShouldWalk = false
            local DistanceToLastWalk = 0
            
            if LastWalkTarget == nil then
                -- First iteration, always walk
                ShouldWalk = true
                self:Info("[MoveTo] Initiating walk")
            else
                -- Calculate distance to last walk target
                DistanceToLastWalk = math.sqrt((LastWalkTarget.x - CurrentPos.x)^2 + (LastWalkTarget.y - CurrentPos.y)^2)
                
                if DistanceToLastWalk <= 7 then
                    ShouldWalk = true
                else
                    ShouldWalk = true
                    self:Info("[MoveTo] Restarting walk")
                end
            end
            
            if ShouldWalk then
                -- Walk 15-30 random tiles toward destination
                local WalkDistance = math.random(15, 30)
                
                -- Walk directly to destination if within walk distance, otherwise walk intermediate distance
                if DistanceToTarget <= WalkDistance then
                    if self:WalkToCoordinates(X, Y, Z) then
                        LastWalkTarget = {x = X, y = Y, z = Z}
                        self:Info("[MoveTo] Walking to destination")
                    else
                        self:Error("[MoveTo] Failed to walk to target coordinates")
                        return false
                    end
                else
                    -- Calculate intermediate walk point toward destination
                    local DirectionX = X - CurrentPos.x
                    local DirectionY = Y - CurrentPos.y
                    local DirectionLength = math.sqrt(DirectionX^2 + DirectionY^2)
                    
                    -- Normalize direction vector and scale to walk distance
                    local NormalizedX = DirectionX / DirectionLength
                    local NormalizedY = DirectionY / DirectionLength
                    
                    local WalkX = math.floor(CurrentPos.x + (NormalizedX * WalkDistance))
                    local WalkY = math.floor(CurrentPos.y + (NormalizedY * WalkDistance))
                    
                    if self:WalkToCoordinates(WalkX, WalkY, Z) then
                        LastWalkTarget = {x = WalkX, y = WalkY, z = Z}
                        self:Info(string.format("[MoveTo] Walking %d tiles toward target", WalkDistance))
                    else
                        self:Error("[MoveTo] Failed to walk to intermediate coordinates")
                        return false
                    end
                end
                
                -- Brief delay after initiating walk to allow movement to start
                self:RandomSleep(500, 1000, "ms")
            else
                -- Wait briefly for movement status update
                self:Sleep(200, "ms")
            end
        end
        
        ::continue_loop::
        
        -- Small delay before next loop iteration
        self:Sleep(200, "ms")
    end
    
    -- Movement loop exited without success (should not normally reach here)
    self:Error("[MoveTo] Movement loop ended unexpectedly")
    return false
end

-- Teleports the player to Guthix Memorial using the Memory Strand currency from the currency pouch
---@return boolean success True if teleport was successful, false if Memory Strand not found or teleport failed
function Slib:MemoryStrandTeleport()
    if not self:CurrencyPouchContains(39486) then
        self:Error("[MemoryStrandTeleport] Memory Strand not found in currency pouch")
        return false
    end

    local MemStrandSlot = nil
    for I = 1, #self.Interfaces.CurrencyPouch do
        local Interface = API.ScanForInterfaceTest2Get(true, self.Interfaces.CurrencyPouch[I])
        if Interface and (type(Interface) == "table" or type(Interface) == "userdata") then
            for _, Item in pairs(Interface) do
                if Item and Item.itemid1 and Item.itemid1 == 39486 then
                    MemStrandSlot = Item.id3
                    break
                end
            end
        end
    end

    while API.Read_LoopyLoop() and not (self:IsPlayerInArea(2265, 3554, 0, 20) or self:IsPlayerInArea(2293, 3554, 0, 5)) do
        self:Info("[MemoryStrandTeleport] Attempting to use Memory Strand teleport...")
        API.DoAction_Interface(0xffffffff,0xffffffff,1,1473,9,4097,API.OFF_ACT_GeneralInterface_route) -- Open currency pouch
        API.DoAction_Interface(0x24,0x9a3e,1,1473,20,MemStrandSlot,API.OFF_ACT_GeneralInterface_route)
        self:SleepUntil(function()
            return self:IsPlayerInArea(2265, 3554, 0, 20) or self:IsPlayerInArea(2293, 3554, 0, 20)
        end, 6, 100)
        API.DoAction_Interface(0xffffffff,0xffffffff,1,1473,9,4097,API.OFF_ACT_GeneralInterface_route) -- Close currency pouch
    end

    return true
end

-- Recharges silverhawk boots when stored feathers are below minimum quantity
---@param MinQuantity number The minimum quantity of feathers to maintain
---@return boolean success True if boots were recharged successfully, false if no boots found or no feathers available
function Slib:RechargeSilverhawkBoots(MinQuantity)
    -- Parameter validation
    if not self:ValidateParams({
        {MinQuantity, "positive_number", "MinQuantity"}
    }) then
        return false
    end
   
    -- Check if boots are equipped
    local Boots = API.Container_Get_s(94, 30924)  -- 94 = equipment, 30924 = silverhawk boots
    if not Boots or not Boots.item_id or Boots.item_id ~= 30924 then
        self:Error("[RechargeSilverhawkBoots] Silverhawk boots not found in equipment")
        return false
    end
    
    local CurrentFeathers = Boots.Extra_ints[2]
    self:Info(string.format("[RechargeSilverhawkBoots] Current feathers: %d (Minimum: %d)", CurrentFeathers, MinQuantity))
    
    -- Check if recharge is needed
    if CurrentFeathers >= MinQuantity then
        self:Info("[RechargeSilverhawkBoots] Feather quantity sufficient")
        return false
    end
    
    -- Check for regular silverhawk feathers
    local HasFeathers = API.CheckInvStuff0(30915)
    if HasFeathers then
        self:Info("[RechargeSilverhawkBoots] Using regular silverhawk feathers")
        API.DoAction_Inventory1(30915,0,1,API.OFF_ACT_GeneralInterface_route)
        return true
    end

    -- Check for silverhawk down
    local HasDown = API.CheckInvStuff0(34823)
    if HasDown then
        self:Info("[RechargeSilverhawkBoots] Using silverhawk down")
        API.DoAction_Inventory1(34823,0,1,API.OFF_ACT_GeneralInterface_route)
        return true
    end
    
    self:Warn("[RechargeSilverhawkBoots] No feathers or down found in inventory")
    return false
end

-- Opens the area loot interface
---@return boolean success True if interface was opened successfully
function Slib:AreaLootOpen()
    -- Check if already open
    if self:AreaLootIsOpen() then
        self:Info("[AreaLootOpen] Area loot interface is already open")
        return true
    end
    
    self:Info("[AreaLootOpen] Attempting to open area loot interface...")
    
    -- Attempt to open the interface
    API.DoAction_Interface(0xffffffff,0xffffffff,1,1678,7,-1,API.OFF_ACT_GeneralInterface_route)
    
    -- Wait for the interface to actually open
    local Success = self:SleepUntil(function()
        return self:AreaLootIsOpen()
    end, 1, 100) -- 1 second timeout, check every 100ms
    
    if Success then
        self:Info("[AreaLootOpen] Area loot interface opened successfully")
        return true
    else
        self:Error("[AreaLootOpen] Failed to open area loot interface within timeout")
        return false
    end
end

-- Takes specified items from the area loot interface, prioritizing last slot first
---@param ItemIds number|table|string The item ID, table of item IDs, or strings ("custom", "all") to take from area loot
---@return boolean success True if all specified items were taken successfully, false otherwise
function Slib:AreaLootTakeItems(ItemIds)
    -- Parameter validation
    if not self:Sanitize(ItemIds, {"number", "table_of_ids", "string"}, "ItemIds") then
        return false
    end

     -- Check if area loot is open
     if not self:AreaLootIsOpen() then
        self:Error("[AreaLootTakeItems] Area loot interface is not open")
        return false
    end
    
    -- Handle special string cases
    if type(ItemIds) == "string" then
        local lowerItemIds = string.lower(ItemIds)
        
        if lowerItemIds == "custom" then
            self:Info("[AreaLootTakeItems] Taking custom loot selection...")
            API.DoAction_Interface(0x24, 0xffffffff, 1, 1622, 30, -1, API.OFF_ACT_GeneralInterface_route)
            return true
        elseif lowerItemIds == "all" then
            self:Info("[AreaLootTakeItems] Taking all loot...")
            API.DoAction_Interface(0x24, 0xffffffff, 1, 1622, 21, -1, API.OFF_ACT_GeneralInterface_route)
            return true
        else
            self:Error("[AreaLootTakeItems] Invalid string parameter: '" .. ItemIds .. "'. Valid options: 'custom', 'all'")
            return false
        end
    end
    
    -- Convert to table for consistent processing
    local IdTable = type(ItemIds) == "table" and ItemIds or {ItemIds}

    -- Get all items in area loot
    local Items = self:AreaLootGetItems()
    if not Items or #Items == 0 then
        self:Warn("[AreaLootTakeItems] No items found in area loot")
        return false
    end
    
    -- Track which IDs we need to take
    local targetIds = {}
    for _, id in ipairs(IdTable) do
        targetIds[id] = true
    end
    
    -- Find matching items and sort by slot (highest slot first for last-slot-first priority)
    local matchingItems = {}
    for _, item in ipairs(Items) do
        local itemId = item[1]
        local itemSlot = item[2]
        
        if targetIds[itemId] then
            table.insert(matchingItems, {itemId = itemId, slot = itemSlot})
            self:Info("[AreaLootTakeItems] Found target item: ID " .. itemId .. " in slot " .. itemSlot)
        end
    end
    
    if #matchingItems == 0 then
        self:Warn("[AreaLootTakeItems] No matching items found in area loot")
        return false
    end
    
    -- Sort by slot in descending order (highest slot first = last slot first)
    table.sort(matchingItems, function(a, b)
        return a.slot > b.slot
    end)
    
    local takenCount = 0
    local totalToTake = #matchingItems
        
    -- Take each matching item, starting from the last slot
    for i, item in ipairs(matchingItems) do
        local itemId = item.itemId
        local itemSlot = item.slot
        
        self:Info("[AreaLootTakeItems] Taking item " .. i .. "/" .. totalToTake .. ": ID " .. itemId .. " from slot " .. itemSlot)
        API.DoAction_Interface(0xffffffff, itemId, 1, 1622, 11, itemSlot, API.OFF_ACT_GeneralInterface_route)
        takenCount = takenCount + 1
            
        -- Small delay between taking items to prevent spam
        self:RandomSleep(50, 300, "ms")
    end
    
    local success = takenCount == totalToTake
    if success then
        self:Info("[AreaLootTakeItems] Successfully took all " .. takenCount .. " items from area loot")
    else
        self:Warn("[AreaLootTakeItems] Only took " .. takenCount .. "/" .. totalToTake .. " items from area loot")
    end
    
    return success
end

-- Types text character by character using virtual key codes with timing delays
---@param Text string The text to type character by character
---@return boolean success True if text was typed successfully, false if invalid parameters or typing failed
function Slib:TypeText(Text)
    -- Parameter validation
    if not self:ValidateParams({
        {Text, "non_empty_string", "Text"}
    }) then
        return false
    end
    
    self:Info("[TypeText] Starting to type text: '" .. Text .. "' (" .. #Text .. " characters)")
    
    local SuccessfulChars = 0
    local TotalChars = #Text
    
    -- Iterate through each character in the text string
    for CharacterIndex = 1, TotalChars do
        -- Extract the current character from the text
        local CurrentCharacter = Text:sub(CharacterIndex, CharacterIndex)
        
        -- Convert the character to its virtual key code
        local VirtualKeyCode = self:CharToVirtualKey(CurrentCharacter)
        
        -- Validate that we got a valid key code
        if not VirtualKeyCode or VirtualKeyCode == 0 then
            self:Error("[TypeText] Failed to get virtual key code for character: '" .. CurrentCharacter .. "' at position " .. CharacterIndex)
            return false
        end
        
        -- Press the key with timing delays
        local KeyResult = API.KeyboardPress2(VirtualKeyCode, 40, 60)
        if not KeyResult then
            self:Error("[TypeText] Failed to send key press for character: '" .. CurrentCharacter .. "' (VK: " .. VirtualKeyCode .. ") at position " .. CharacterIndex)
            return false
        end
        
        SuccessfulChars = SuccessfulChars + 1
        
        -- Small delay between characters to prevent input buffer overflow
        if CharacterIndex < TotalChars then
            self:RandomSleep(30, 70, "ms")
        end
    end
    
    if SuccessfulChars == TotalChars then
        self:Info("[TypeText] Successfully typed all " .. TotalChars .. " characters")
        return true
    else
        self:Error("[TypeText] Only typed " .. SuccessfulChars .. "/" .. TotalChars .. " characters successfully")
        return false
    end
end

--- Presses a key using its virtual-key code, supporting both single-character input and named special keys.
--- @param key string # The key to press.
--- @return boolean # Returns true if the key press was successful; False otherwise.
function Slib:PressKey(key)
    local vk = nil

    if #key == 1 then
        vk = self:CharToVirtualKey(key)
    else
        vk = self:GetSpecialKeyVK(key)
    end

    if not vk then
        self:Error("[PressKey] Invalid key: " .. tostring(key))
        return false
    end

    return API.KeyboardPress2(vk, 40, 60)
end

-- Sets instance interface options to specified values
---@param MaxPlayers number|nil Target maximum players (or nil to skip)
---@param MinCombat number|nil Target minimum combat level (or nil to skip)
---@param SpawnSpeed string|nil Target spawn speed ("Standard", "Fast", "Fastest", or nil to skip)
---@param Protection string|nil Target protection ("FFA", "PIN", "Friends only", "Friends Chat only", or nil to skip)
---@param PracticeMode boolean|nil Target practice mode state (or nil to skip)
---@param HardMode boolean|nil Target hard mode state (or nil to skip)
---@return boolean Success True if all settings were applied successfully
function Slib:SetInstanceInterfaceOptions(MaxPlayers, MinCombat, SpawnSpeed, Protection, PracticeMode, HardMode)
    -- Parameter validation
    if not self:ValidateParams({
        {MaxPlayers, "positive_number", "MaxPlayers", true}, -- allow_nil = true
        {MinCombat, "non_negative_number", "MinCombat", true}, -- allow_nil = true
        {SpawnSpeed, "string", "SpawnSpeed", true}, -- allow_nil = true
        {Protection, "string", "Protection", true}, -- allow_nil = true
        {PracticeMode, "boolean", "PracticeMode", true}, -- allow_nil = true
        {HardMode, "boolean", "HardMode", true} -- allow_nil = true
    }) then
        return false
    end
    
    -- Validate SpawnSpeed against allowed values
    if SpawnSpeed ~= nil then
        local ValidSpawnSpeeds = {"Standard", "Fast", "Fastest"}
        local SpeedValid = false
        for _, ValidSpeed in ipairs(ValidSpawnSpeeds) do
            if SpawnSpeed == ValidSpeed then
                SpeedValid = true
                break
            end
        end
        if not SpeedValid then
            self:Error("[SetInstanceInterfaceOptions] Invalid SpawnSpeed. Must be one of: Standard, Fast, Fastest (got: " .. tostring(SpawnSpeed) .. ")")
            return false
        end
    end
    
    -- Validate Protection against allowed values
    if Protection ~= nil then
        local ValidProtections = {"FFA", "PIN", "Friends only", "Friends Chat only"}
        local ProtectionValid = false
        for _, ValidProtection in ipairs(ValidProtections) do
            if Protection == ValidProtection then
                ProtectionValid = true
                break
            end
        end
        if not ProtectionValid then
            self:Error("[SetInstanceInterfaceOptions] Invalid Protection. Must be one of: FFA, PIN, Friends only, Friends Chat only (got: " .. tostring(Protection) .. ")")
            return false
        end
    end

    if not self:InstanceInterfaceIsOpen() then
        self:Error("[SetInstanceInterfaceOptions] Instance interface is not open")
        return false
    end

    local CurrentOptions = self:GetInstanceInterfaceOptions()
    if not CurrentOptions then
        self:Error("[SetInstanceInterfaceOptions] Failed to get current interface options")
        return false
    end

    -- Disable HardMode first if we're enabling PracticeMode
    if PracticeMode == true and CurrentOptions.HardMode == true then
        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 4, -1, API.OFF_ACT_GeneralInterface_route)
        self:RandomSleep(600, 1000, "ms")
    end

    -- Disable PracticeMode first if we're enabling HardMode
    if HardMode == true and CurrentOptions.PracticeMode == true then
        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 113, -1, API.OFF_ACT_GeneralInterface_route)
        self:RandomSleep(600, 1000, "ms")
    end

    -- Now set PracticeMode
    if PracticeMode ~= nil and CurrentOptions.PracticeMode ~= PracticeMode then
        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 113, -1, API.OFF_ACT_GeneralInterface_route)
        self:RandomSleep(600, 1000, "ms")
    end

    -- Now set HardMode
    if HardMode ~= nil and CurrentOptions.HardMode ~= HardMode then
        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 4, -1, API.OFF_ACT_GeneralInterface_route)
        self:RandomSleep(600, 1000, "ms")
    end

    self:RandomSleep(1000, 2000, "ms")

    CurrentOptions = self:GetInstanceInterfaceOptions() --Update options in case HM checkbox was checked, which makes MaxPlayers always 1 on the first read

    -- Set MaxPlayers
    if MaxPlayers and CurrentOptions.MaxPlayers then
        local Difference = MaxPlayers - CurrentOptions.MaxPlayers
        if Difference > 0 then
            for i = 1, Difference do
                API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 25, -1, API.OFF_ACT_GeneralInterface_route)
                self:RandomSleep(100, 300, "ms")
            end
        elseif Difference < 0 then
            for i = 1, math.abs(Difference) do
                API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 24, -1, API.OFF_ACT_GeneralInterface_route)
                self:RandomSleep(100, 300, "ms")
            end
        end
    end

    -- Set MinCombat
    if MinCombat and CurrentOptions.MinCombat then
        local Difference = MinCombat - CurrentOptions.MinCombat
        if Difference > 0 then
            for i = 1, Difference do
                API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 29, -1, API.OFF_ACT_GeneralInterface_route)
                self:RandomSleep(100, 300, "ms")
            end
        elseif Difference < 0 then
            for i = 1, math.abs(Difference) do
                API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 28, -1, API.OFF_ACT_GeneralInterface_route)
                self:RandomSleep(100, 300, "ms")
            end
        end
    end

    -- Set SpawnSpeed
    if SpawnSpeed then
        local SpawnSpeedMap = {["Standard"] = 1, ["Fast"] = 2, ["Fastest"] = 3}
        local CurrentSpeedMap = {["Standard"] = 1, ["Fast"] = 2, ["Fastest"] = 3}

        local TargetIndex = SpawnSpeedMap[SpawnSpeed]
        local CurrentIndex = CurrentSpeedMap[CurrentOptions.SpawnSpeed]

        if TargetIndex and CurrentIndex then
            local Difference = TargetIndex - CurrentIndex
            if Difference > 0 then
                for i = 1, Difference do
                    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 33, -1, API.OFF_ACT_GeneralInterface_route)
                    self:RandomSleep(100, 300, "ms")
                end
            elseif Difference < 0 then
                for i = 1, math.abs(Difference) do
                    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 32, -1, API.OFF_ACT_GeneralInterface_route)
                    self:RandomSleep(100, 300, "ms")
                end
            end
        end
    end

    -- Set Protection
    if Protection then
        local ProtectionMap = {["FFA"] = 1, ["PIN"] = 2, ["Friends only"] = 3, ["Friends Chat only"] = 4}

        -- Helper function to get protection index from current value
        local function GetProtectionIndex(ProtectionValue)
            if not ProtectionValue then
                return nil
            end

            if ProtectionValue == "FFA" then
                return 1
            elseif ProtectionValue:match("^PIN:") then -- Handles "PIN: 1", "PIN: 2", etc.
                return 2
            elseif ProtectionValue == "Friends only" then
                return 3
            elseif ProtectionValue == "Friends Chat only" then
                return 4
            end
            return nil
        end

        local TargetIndex = ProtectionMap[Protection]
        local CurrentIndex = GetProtectionIndex(CurrentOptions.Protection)

        if TargetIndex and CurrentIndex then
            local Difference = TargetIndex - CurrentIndex
            if Difference > 0 then
                for i = 1, Difference do
                    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 37, -1, API.OFF_ACT_GeneralInterface_route)
                    self:RandomSleep(100, 300, "ms")
                end
            elseif Difference < 0 then
                for i = 1, math.abs(Difference) do
                    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1591, 36, -1, API.OFF_ACT_GeneralInterface_route)
                    self:RandomSleep(100, 300, "ms")
                end
            end
        end
    end

    self:Info("[SetInstanceInterfaceOptions] Successfully applied interface settings")
    return true
end

-- Starts a new instance
---@return boolean
function Slib:InstanceStart()
    if not self:InstanceInterfaceIsOpen() then
        self:Error("[InstanceStart] Instance interface is not open")
        return false
    end

    API.DoAction_Interface(0x24, 0xffffffff, 1, 1591, 56, -1, API.OFF_ACT_GeneralInterface_route)
    self:Info("[InstanceStart] Started instance")

    return true
end

-- Joins another player's instance by typing their name
---@param PlayerName string The name of the player whose instance to join
---@return boolean Success True if join sequence completed successfully, false if interface not open or invalid name
function Slib:InstanceJoin(PlayerName)
    -- Validate interface state
    if not self:InstanceInterfaceIsOpen() then
        self:Error("[InstanceJoin] Instance interface is not open")
        return false
    end

    -- Validate PlayerName parameter
    if not self:ValidateParams({
        {PlayerName, "non_empty_string", "PlayerName"}
    }) then
        self:Error("[InstanceJoin] Invalid player name provided")
        return false
    end

    self:Info("[InstanceJoin] Initiating join to player: " .. PlayerName)
    
    -- Open text input dialog
    local Result = API.DoAction_Interface(0x24, 0xffffffff, 1, 1591, 108, -1, API.OFF_ACT_GeneralInterface_route)
    if not Result then
        self:Error("[InstanceJoin] Failed to open text input dialog")
        return false
    end

    -- Wait for text input interface to open
    local InputOpened = self:SleepUntil(function()
        return self:TextInputIsOpen()
    end, 10, 100)

    if not InputOpened then
        self:Error("[InstanceJoin] Text input interface failed to open within timeout")
        return false
    end

    -- Safety delay to ensure interface is fully loaded
    self:RandomSleep(2000, 4000, "ms")

    -- Type player name using TypeText function
    self:Info("[InstanceJoin] Typing player name: " .. PlayerName)
    if not self:TypeText(PlayerName) then
        self:Error("[InstanceJoin] Failed to type player name")
        return false
    end
    
    -- Confirm input with Enter key
    self:Info("[InstanceJoin] Confirming input with Enter key")
    local EnterResult = API.KeyboardPress2(0x0D, 50, 80) -- VK_RETURN
    if not EnterResult then
        self:Error("[InstanceJoin] Failed to send Enter key")
        return false
    end
    
    self:Info("[InstanceJoin] Successfully completed join sequence for: " .. PlayerName)
    return true
end

-- Rejoins an existing instance
---@return boolean
function Slib:InstanceRejoin()
    if not self:InstanceInterfaceIsOpen() then
        self:Error("[InstanceRejoin] Instance interface is not open")
        return false
    end
    
    API.DoAction_Interface(0x24, 0xffffffff, 1, 1591, 122, -1, API.OFF_ACT_GeneralInterface_route)
    self:Info("[InstanceRejoin] Rejoined instance")
        
    return true
end

-- Leaves the game to lobby
---@return boolean
function Slib:Lobby()
    if API.GetGameState2() == 3 then --In game
        API.DoAction_Interface(0xffffffff,0xffffffff,1,1431,0,7,API.OFF_ACT_GeneralInterface_route) --Config
        self:RandomSleep(1000, 3000, "ms")
        API.DoAction_Interface(0x24,0xffffffff,1,1433,69,-1,API.OFF_ACT_GeneralInterface_route) --Lobby
        self:RandomSleep(1000, 3000, "ms")

        return true
    end

    self:Error("[Lobby] Needs to be in game to leave to lobby.")
    return false    
end

--- High Alch an item or items
---@param ItemIds number|number[] The ID or IDs of the items to High Alch
---@return boolean success True if High Alch was successful, false if it failed
function Slib:HighAlch(ItemIds)
    -- Parameter validation
    if not self:Sanitize(ItemIds, {"number", "table_of_ids"}, "ItemIds") then
        return false
    end
    
    if self:GetSpellBook() ~= "Standard" then
        self:Error("[HighAlch] Must be on Standard spellbook to use High Alch")
        return false
    end

    local Runes = self:GetRuneAmounts()
    if Runes.Normal.Nature < 1 then
        self:Error("[HighAlch] Not enough Nature runes")
        return false
    end
    if Runes.Normal.Fire < 5 then
        self:Error("[HighAlch] Not enough Fire runes")
        return false
    end

    -- Convert to table for consistent processing
    local idTable = type(ItemIds) == "table" and ItemIds or {ItemIds}

    for _, itemId in ipairs(idTable) do
        if not Inventory:Contains(itemId) then
            goto skip
        end

        --API.DoAction_DontResetSelection()
        API.DoAction_Interface(0xffffffff,0xffffffff,0,1672,1,47,API.OFF_ACT_Bladed_interface_route) -- Select High Alch
        self:RandomSleep(50, 100, "ms")
        --API.DoAction_DontResetSelection()
        API.DoAction_Inventory1(itemId,0,0,API.OFF_ACT_GeneralInterface_route1)
        self:RandomSleep(50, 100, "ms")
        ::skip::
    end
    
    return true
end

--- Note an item or items
---@param ItemIds number|number[] The ID or IDs of the items to Note
---@return boolean success True if Note was successful, false if it failed
function Slib:Note(ItemIds)
    -- Parameter validation
    if not self:Sanitize(ItemIds, {"number", "table_of_ids"}, "ItemIds") then
        return false
    end

    -- Convert to table for consistent processing
    local idTable = type(ItemIds) == "table" and ItemIds or {ItemIds}

    for _, itemId in ipairs(idTable) do
        if not Inventory:Contains(30372) and not Inventory:Contains(43045) then
            self:Error("[Note] No notepaper.")
            return false
        end

        if not Inventory:Contains(itemId) then
            goto skip
        else
            API.DoAction_DontResetSelection()
            if Inventory:Contains(30372) then
                Inventory:UseItemOnItem(itemId, 30372)
            elseif Inventory:Contains(43045) then
                Inventory:UseItemOnItem(itemId, 43045)
            else --Redundant check, but just in case
                self:Error("[Note] No notepaper.")
                return false
            end
        end

        ::skip::
    end

    return true
end

--- Buff Up Keep
--- Possible values: "Overload", "Weapon Poison", "Luck Potion", "Aggression", "Charming Potion",
---                  "Vampyrism", "Penance", "Darkness", "Animate Dead", "Temporal Anomaly",
---                  "Powder of Defense", "Powder of Protection", "Powder of Item Protection",
---                  "Powder of Pulverising", "Powder of Burials", "Powder of Penance",
---                  "Guam", "Tarromin", "Marrentill", "Harralander",
---                  "Ranarr", "Toadflax", "Spirit Weed", "Irit", "Wergali",
---                  "Avantoe", "Kwuarm", "Bloodweed", "Snapdragon", "Cadantine",
---                  "Lantadyme", "Dwarf Weed", "Torstol", "Fellstalk"
---@param BuffNames string[] The name or names of the buffs to keep up inside of a table
---@return boolean success True if a buff was applied or everything is already up, false if something is missing or failed
function Slib:BuffUpKeep(BuffNames)
    if not self:Sanitize(BuffNames, {"table_of_strings"}, "BuffNames") then
        return false
    end

    local Buffs = API.Buffbar_GetAllIDs()
    if not Buffs then
        self:Warn("[BuffUpKeep] Failed to get buff bar information")
        return false
    end

    local AllGood = true  -- Tracks if everything is satisfied

    for _, BuffName in ipairs(BuffNames) do
        local Stick  = Slib.Items.IncenseSticks[BuffName]
        local Aspect = Slib.Buffs.Aspects[BuffName]
        local Powder = Slib.Buffs.Powders[BuffName]

        if BuffName == "Overload" then
            local ActiveOverload = nil
            for _, OverloadBuff in pairs(Slib.Buffs.Overloads) do
                if self:HasBuff(OverloadBuff.Id) then
                    ActiveOverload = OverloadBuff
                    break
                end
            end

            if not ActiveOverload then
                local Priority = {
                    { Buff = Slib.Buffs.Overloads.Elder,    Items = Slib.Items.ElderOverloads   },
                    { Buff = Slib.Buffs.Overloads.Supreme,  Items = Slib.Items.SupremeOverloads  },
                    { Buff = Slib.Buffs.Overloads.Overload, Items = Slib.Items.Overloads         },
                }
                for _, Entry in ipairs(Priority) do
                    local Ids = self:GetIDSFromTable(Entry.Items)
                    if Inventory:ContainsAny(Ids) then
                        self:Info("[BuffUpKeep] Drinking " .. Entry.Buff.Name .. "...")
                        API.DoAction_Inventory2(Ids, 0, 1, API.OFF_ACT_GeneralInterface_route)
                        return true
                    end
                end

                self:Warn("[BuffUpKeep] No overload potions found in inventory")
                AllGood = false
            end

        elseif BuffName == "Weapon Poison" then
            if not self:HasBuff(Slib.Buffs.WeaponPoisons.Poisonous.Id) then
                local Poisons = self:GetIDSFromTable(Slib.Items.WeaponPoisons)
                if Inventory:ContainsAny(Poisons) then
                    self:Info("[BuffUpKeep] Applying Weapon Poison...")
                    API.DoAction_Inventory2(Poisons, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    return true
                end

                self:Warn("[BuffUpKeep] No Weapon Poisons in inventory")
                AllGood = false
            end

        elseif Stick then
            local ActiveStick = nil
            for _, Object in ipairs(Buffs) do
                if Object.id == Stick.Id then
                    ActiveStick = Object
                    break
                end
            end

            local Time, Level = nil, nil
            if ActiveStick then
                Time, Level = string.match(tostring(ActiveStick.text or ""), "(%d+)%a* %((%d+)%)")
                Time  = tonumber(Time)
                Level = tonumber(Level)
            end

            if ActiveStick and (not Time or not Level) then
                self:Warn("[BuffUpKeep] Failed to parse buff info for " .. Stick.Name)
                AllGood = false

            elseif ActiveStick and Level >= 4 and Time < 10 then
                -- Potency is fine, only the duration needs a single stick
                if not Inventory:Contains(Stick.Id) then
                    self:Warn("[BuffUpKeep] " .. Stick.Name .. " not found in inventory")
                    AllGood = false
                else
                    self:Info("[BuffUpKeep] Extending " .. Stick.Name .. " (" .. Time .. "m left)...")
                    API.DoAction_Inventory1(Stick.Id, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    return true
                end

            elseif not ActiveStick or Level < 4 then
                -- Not burning at all, or burning below full potency, so a fresh set of sticks is needed
                local ActiveStickCount = 0
                for _, S in pairs(Slib.Items.IncenseSticks) do
                    for _, Object in ipairs(Buffs) do
                        if Object.id == S.Id then
                            ActiveStickCount = ActiveStickCount + 1
                            break
                        end
                    end
                end

                if not ActiveStick and ActiveStickCount >= 3 then
                    self:Warn("[BuffUpKeep] 3 incense sticks already active, skipping " .. Stick.Name)
                    AllGood = false
                elseif Inventory:GetItemAmount(Stick.Id) < 6 then
                    self:Warn("[BuffUpKeep] " .. Stick.Name .. " not found in required amount (>=6), skipping")
                    AllGood = false
                else
                    self:Info("[BuffUpKeep] Applying " .. Stick.Name .. "...")
                    API.DoAction_Inventory1(Stick.Id, 0, 2, API.OFF_ACT_GeneralInterface_route)
                    return true
                end
            end

        elseif BuffName == "Luck Potion" then
            local ActiveLuck = nil
            for _, LuckBuff in pairs(Slib.Buffs.LuckPotions) do
                if self:HasBuff(LuckBuff.Id) then
                    ActiveLuck = LuckBuff
                    break
                end
            end

            if not ActiveLuck then
                local Priority = {
                    { Buff = Slib.Buffs.LuckPotions.EnhancedLuckPotion, Item = Slib.Items.LuckPotions.EnhancedLuckPotion },
                    { Buff = Slib.Buffs.LuckPotions.LuckPotion,         Item = Slib.Items.LuckPotions.LuckPotion         },
                }
                for _, Entry in ipairs(Priority) do
                    if Inventory:Contains(Entry.Item.Id) then
                        self:Info("[BuffUpKeep] Drinking " .. Entry.Buff.Name .. "...")
                        API.DoAction_Inventory2({Entry.Item.Id}, 0, 1, API.OFF_ACT_GeneralInterface_route)
                        return true
                    end
                end

                self:Warn("[BuffUpKeep] No Luck Potions found in inventory")
                AllGood = false
            end

        elseif BuffName == "Aggression" then
            if not self:HasBuff(Slib.Buffs.AggressionPotions.Aggression.Id) then
                local Potions = self:GetIDSFromTable(Slib.Items.AggressionPotions)
                if Inventory:ContainsAny(Potions) then
                    self:Info("[BuffUpKeep] Drinking Aggression potion...")
                    API.DoAction_Inventory2(Potions, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    return true
                end

                self:Warn("[BuffUpKeep] No Aggression potions found in inventory")
                AllGood = false
            end

        elseif BuffName == "Charming Potion" then
            if not self:HasBuff(Slib.Buffs.CharmingPotions.Charming.Id) then
                local Potions = self:GetIDSFromTable(Slib.Items.CharmingPotions)
                if Inventory:ContainsAny(Potions) then
                    self:Info("[BuffUpKeep] Drinking Charming potion...")
                    API.DoAction_Inventory2(Potions, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    return true
                end

                self:Warn("[BuffUpKeep] No Charming potions found in inventory")
                AllGood = false
            end

        elseif Aspect then
            if not self:HasBuff(Aspect.Id) then
                if not self:CanCastAbility(Aspect.AbilityId) then
                    self:Warn("[BuffUpKeep] " .. Aspect.Name .. " cannot be cast right now")
                    AllGood = false
                else
                    self:Info("[BuffUpKeep] Casting " .. Aspect.Name .. "...")
                    if self:UseAbilityById(Aspect.AbilityId) then
                        return true
                    end

                    self:Warn("[BuffUpKeep] Failed to cast " .. Aspect.Name)
                    AllGood = false
                end
            end

        elseif Powder then
            if not self:HasBuff(Powder.Id) then
                if not Inventory:Contains(Powder.ItemId) then
                    self:Warn("[BuffUpKeep] " .. Powder.Name .. " not found in inventory")
                    AllGood = false
                else
                    self:Info("[BuffUpKeep] Using " .. Powder.Name .. "...")
                    API.DoAction_Inventory1(Powder.ItemId, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    return true
                end
            end
        
        else
            self:Error("[BuffUpKeep] Unknown buff name: " .. tostring(BuffName))
            AllGood = false
        end
    end

    return AllGood
end

DX.Slib = Slib

----------------------------------------------------------------------------------------------------
--# SECTION: DX.Herblore — potionmaking recipe database + crafting planner
--#   (merged from potionrecipes.lua; require("potionrecipes") still works via shim)
local Recipes = {}

-- ============================================================================
-- MAIN PRODUCT IDS
-- ============================================================================
local IDS = {
    -- UNFINISHED POTIONS
    RANARR_POTION_UNF          = 99,
    IRIT_POTION_UNF            = 101,
    AVANTOE_POTION_UNF         = 103,
    KWUARM_POTION_UNF          = 105,
    CADANTINE_POTION_UNF       = 107,
    DWARF_WEED_POTION_UNF      = 109,
    LANTADYME_POTION_UNF       = 2483,
    TOADFLAX_POTION_UNF        = 3002,
    SNAPDRAGON_POTION_UNF      = 3004,
    SPIRIT_WEED_POTION_UNF     = 12181,
    FELLSTALK_POTION_UNF       = 21628,
    BLOODWEED_POTION_UNF       = 37973,

    -- SUPER & STANDARD POTIONS
    PRAYER_POTION_3            = 139,
    SUPER_ATTACK_3             = 145,
    SUPER_STRENGTH_3           = 157,
    SUPER_DEFENCE_3            = 163,
    SUPER_RANGING_3            = 169,
    SUPER_ANTIPOISON_3         = 181,
    PRAYER_POTION_4            = 2434,
    SUPER_ATTACK_4             = 2436,
    SUPER_STRENGTH_4           = 2440,
    SUPER_DEFENCE_4            = 2442,
    SUPER_RANGING_4            = 2444,
    SUPER_ANTIPOISON_4         = 2448,
    ANTIFIRE_4                 = 2452,
    ANTIFIRE_3                 = 2454,
    SUPER_ENERGY_3             = 3018,
    SUPER_RESTORE_4            = 3024,
    SUPER_RESTORE_3            = 3026,
    SUPER_MAGIC_4              = 3040,
    SUPER_MAGIC_3              = 3042,
    SARADOMIN_BREW_4           = 6685,
    SARADOMIN_BREW_3           = 6687,
    ADRENALINE_POT_3           = 15301,
    PRAYER_RENEWAL_POTION_4    = 21630,
    PRAYER_RENEWAL_POTION_3    = 21632,
    AGGRESSION_POTION_3        = 37969,
    AGGRESSION_POTION_4        = 37971,
    SUPER_NECROMANCY_4         = 55316,
    SUPER_NECROMANCY_3         = 55318,

    -- EXTREME POTIONS & POWERBURSTS
    SUPER_ANTIFIRE_4           = 15304,
    SUPER_ANTIFIRE_3           = 15305,
    EXTREME_ATTACK_3           = 15309,
    EXTREME_STRENGTH_3         = 15313,
    EXTREME_DEFENCE_3          = 15317,
    EXTREME_MAGIC_3            = 15321,
    EXTREME_RANGING_3          = 15325,
    SUPER_ADRENALINE_3         = 39214,
    ADRENALINE_RENEWAL_POT     = 49079,
    POWERBURST_VITALITY        = 49095,
    EXTREME_NECROMANCY_3       = 55326,

    -- WEAPON POISONS
    WEAPON_POISON_PP_UNF       = 5939,
    WEAPON_POISON_PP_4         = 25501,
    WEAPON_POISON_PP_3         = 25503,
    WEAPON_POISON_PPP_4        = 49115,
    WEAPON_POISON_PPP_3        = 49117,

    -- OVERLOADS
    OVERLOAD_4                 = 15332,
    OVERLOAD_3                 = 15333,
    SUPREME_OVERLOAD           = 33210,
    PERFECT_PLUS_POTION        = 33234,
    HOLY_OVERLOAD              = 33246,
    AGGROVERLOAD               = 48239,
    ELDER_OVERLOAD             = 49039,
    HOLY_AGGROVERLOAD          = 50877,
    OVERLOAD_3_UNF             = 55953,
    SUPREME_OVERLOAD_UNF       = 55955,
    ELDER_OVERLOAD_UNF         = 55957,

    -- PSEUDO-IDS (Workbench Route)
    OVERLOAD_3_WORKBENCH       = 900001,
    SUPREME_OVERLOAD_WORKBENCH = 900002,
    ELDER_OVERLOAD_WORKBENCH   = 900003,
    OVERLOAD_4_WORKBENCH       = 900004,

    -- GRIMY HERBS
    GRIMY_GUAM                 = 199,
    GRIMY_MARRENTILL           = 201,
    GRIMY_TARROMIN             = 203,
    GRIMY_HARRALANDER          = 205,
    GRIMY_RANARR               = 207,
    GRIMY_IRIT                 = 209,
    GRIMY_AVANTOE              = 211,
    GRIMY_KWUARM               = 213,
    GRIMY_CADANTINE            = 215,
    GRIMY_DWARF_WEED           = 217,
    GRIMY_TORSTOL              = 219,
    GRIMY_LANTADYME            = 2485,
    GRIMY_TOADFLAX             = 3049,
    GRIMY_SNAPDRAGON           = 3051,
    GRIMY_SPIRIT_WEED          = 12174,
    GRIMY_WERGALI              = 14836,
    GRIMY_FELLSTALK            = 21626,
    GRIMY_BLOODWEED            = 37975,
    GRIMY_ARBUCK               = 48243,

    -- CLEAN HERBS
    CLEAN_GUAM                 = 249,
    CLEAN_MARRENTILL           = 251,
    CLEAN_TARROMIN             = 253,
    CLEAN_HARRALANDER          = 255,
    CLEAN_RANARR               = 257,
    CLEAN_IRIT                 = 259,
    CLEAN_AVANTOE              = 261,
    CLEAN_KWUARM               = 263,
    CLEAN_CADANTINE            = 265,
    CLEAN_DWARF_WEED           = 267,
    CLEAN_TORSTOL              = 269,
    CLEAN_LANTADYME            = 2481,
    CLEAN_TOADFLAX             = 2998,
    CLEAN_SNAPDRAGON           = 3000,
    CLEAN_SPIRIT_WEED          = 12172,
    CLEAN_WERGALI              = 14854,
    CLEAN_FELLSTALK            = 21624,
    CLEAN_BLOODWEED            = 37953,
    CLEAN_ARBUCK               = 48211,

    -- VIALS & FLASKS
    VIAL_OF_WATER              = 227,
    EMPTY_VIAL                 = 229,
    PESTLE_AND_MORTAR          = 233,
    CRYSTAL_FLASK              = 32843,
    POWERBURST_VIAL            = 48960,
    BOMB_VIAL                  = 48961,

    -- INGREDIENTS / BASES
    EYE_OF_NEWT                = 221,
    RED_SPIDERS_EGGS           = 223,
    LIMPWURT_ROOT              = 225,
    SNAPE_GRASS                = 231,
    UNICORN_HORN_DUST          = 235,
    WHITE_BERRIES              = 239,
    DRAGON_SCALE_DUST          = 241,
    WINE_OF_ZAMORAK            = 245,
    CHAOS_RUNE                 = 562,
    SOUL_RUNE                  = 566,
    CAVE_NIGHTSHADE            = 2398,
    MORT_MYRE_FUNGUS           = 2970,
    POTATO_CACTUS              = 3138,
    PHOENIX_FEATHER            = 4621,
    MUD_RUNE                   = 4698,
    BIRDS_NEST_EMPTY           = 5075,
    COCONUT_MILK               = 5935,
    PAPAYA_FRUIT               = 5972,
    COCONUT                    = 5974,
    COCONUT_OPEN               = 5976,
    POISON_IVY_BERRIES         = 6018,
    CRUSHED_NEST               = 6693,
    GROUND_MUD_RUNE            = 9594,
    GRENWALL_SPIKE             = 12539,
    ROCKTAIL                   = 15272,
    MORCHELLA_MUSHROOM         = 21622,
    CRYSTAL_TREE_BLOSSOM       = 32270,
    HARMONY_MOSS               = 32947,
    SEARING_ASHES              = 34159,
    CONGEALED_BLOOD            = 37227,
    ADRENALINE_CRYSTAL         = 39067,
    SPIDER_VENOM               = 43997,
    INERT_ADRENALINE_CRYSTAL   = 48575,
    POISON_SLIME               = 48921,
    SPARK_CHITIN               = 48923,
    BOTTLED_DINOSAUR_ROAR      = 48926,
    PRIMAL_EXTRACT             = 48962,
    PRIMAL_FRUIT_PULP          = 48966,
    MIASMA_RUNE                = 55340,
    GROUND_MIASMA_RUNE         = 55697,

    -- BOMBS
    VULNERABILITY_BOMB         = 48951,
}

Recipes.IDS = IDS

-- Array of all possible primal fruits for the script to scan
Recipes.PRIMAL_FRUITS = { 48771, 48578, 48584, 48580, 48588, 48582, 48586, 48773 }

-- ============================================================================
-- RECIPE DATABASE
-- ============================================================================
Recipes.Database = {
    -- CLEAN HERBS
    [IDS.CLEAN_GUAM]          = { name = "Clean guam", useMake = true, ingredients = { {id = IDS.GRIMY_GUAM, qty = 1} } },
    [IDS.CLEAN_MARRENTILL]    = { name = "Clean marrentill", useMake = true, ingredients = { {id = IDS.GRIMY_MARRENTILL, qty = 1} } },
    [IDS.CLEAN_TARROMIN]      = { name = "Clean tarromin", useMake = true, ingredients = { {id = IDS.GRIMY_TARROMIN, qty = 1} } },
    [IDS.CLEAN_HARRALANDER]   = { name = "Clean harralander", useMake = true, ingredients = { {id = IDS.GRIMY_HARRALANDER, qty = 1} } },
    [IDS.CLEAN_RANARR]        = { name = "Clean ranarr", useMake = true, ingredients = { {id = IDS.GRIMY_RANARR, qty = 1} } },
    [IDS.CLEAN_IRIT]          = { name = "Clean irit", useMake = true, ingredients = { {id = IDS.GRIMY_IRIT, qty = 1} } },
    [IDS.CLEAN_AVANTOE]       = { name = "Clean avantoe", useMake = true, ingredients = { {id = IDS.GRIMY_AVANTOE, qty = 1} } },
    [IDS.CLEAN_KWUARM]        = { name = "Clean kwuarm", useMake = true, ingredients = { {id = IDS.GRIMY_KWUARM, qty = 1} } },
    [IDS.CLEAN_CADANTINE]     = { name = "Clean cadantine", useMake = true, ingredients = { {id = IDS.GRIMY_CADANTINE, qty = 1} } },
    [IDS.CLEAN_DWARF_WEED]    = { name = "Clean dwarf weed", useMake = true, ingredients = { {id = IDS.GRIMY_DWARF_WEED, qty = 1} } },
    [IDS.CLEAN_TORSTOL]       = { name = "Clean torstol", useMake = true, ingredients = { {id = IDS.GRIMY_TORSTOL, qty = 1} } },
    [IDS.CLEAN_LANTADYME]     = { name = "Clean lantadyme", useMake = true, ingredients = { {id = IDS.GRIMY_LANTADYME, qty = 1} } },
    [IDS.CLEAN_TOADFLAX]      = { name = "Clean toadflax", useMake = true, ingredients = { {id = IDS.GRIMY_TOADFLAX, qty = 1} } },
    [IDS.CLEAN_SNAPDRAGON]    = { name = "Clean snapdragon", useMake = true, ingredients = { {id = IDS.GRIMY_SNAPDRAGON, qty = 1} } },
    [IDS.CLEAN_SPIRIT_WEED]   = { name = "Clean spirit weed", useMake = true, ingredients = { {id = IDS.GRIMY_SPIRIT_WEED, qty = 1} } },
    [IDS.CLEAN_WERGALI]       = { name = "Clean wergali", useMake = true, ingredients = { {id = IDS.GRIMY_WERGALI, qty = 1} } },
    [IDS.CLEAN_FELLSTALK]     = { name = "Clean fellstalk", useMake = true, ingredients = { {id = IDS.GRIMY_FELLSTALK, qty = 1} } },
    [IDS.CLEAN_BLOODWEED]     = { name = "Clean bloodweed", useMake = true, ingredients = { {id = IDS.GRIMY_BLOODWEED, qty = 1} } },
    [IDS.CLEAN_ARBUCK]        = { name = "Clean arbuck", useMake = true, ingredients = { {id = IDS.GRIMY_ARBUCK, qty = 1} } },

    -- UNFINISHED POTIONS
    [IDS.RANARR_POTION_UNF]      = { name = "Ranarr potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_RANARR, qty = 1} } },
    [IDS.IRIT_POTION_UNF]        = { name = "Irit potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_IRIT, qty = 1} } },
    [IDS.AVANTOE_POTION_UNF]     = { name = "Avantoe potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_AVANTOE, qty = 1} } },
    [IDS.KWUARM_POTION_UNF]      = { name = "Kwuarm potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_KWUARM, qty = 1} } },
    [IDS.CADANTINE_POTION_UNF]   = { name = "Cadantine potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_CADANTINE, qty = 1} } },
    [IDS.DWARF_WEED_POTION_UNF]  = { name = "Dwarf weed potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_DWARF_WEED, qty = 1} } },
    [IDS.LANTADYME_POTION_UNF]   = { name = "Lantadyme potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_LANTADYME, qty = 1} } },
    [IDS.TOADFLAX_POTION_UNF]    = { name = "Toadflax potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_TOADFLAX, qty = 1} } },
    [IDS.SNAPDRAGON_POTION_UNF]  = { name = "Snapdragon potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_SNAPDRAGON, qty = 1} } },
    [IDS.SPIRIT_WEED_POTION_UNF] = { name = "Spirit weed potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_SPIRIT_WEED, qty = 1} } },
    [IDS.FELLSTALK_POTION_UNF]   = { name = "Fellstalk potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_FELLSTALK, qty = 1} } },
    [IDS.BLOODWEED_POTION_UNF]   = { name = "Bloodweed potion (unf)", ingredients = { {id = IDS.VIAL_OF_WATER, qty = 1}, {id = IDS.CLEAN_BLOODWEED, qty = 1} } },

    -- SUPER POTIONS
    [IDS.PRAYER_POTION_3]         = { name = "Prayer potion (3)", ingredients = { {id = IDS.RANARR_POTION_UNF, qty = 1}, {id = IDS.SNAPE_GRASS, qty = 1} } },
    [IDS.SUPER_ATTACK_3]          = { name = "Super attack (3)", ingredients = { {id = IDS.IRIT_POTION_UNF, qty = 1}, {id = IDS.EYE_OF_NEWT, qty = 1} } },
    [IDS.SUPER_STRENGTH_3]        = { name = "Super strength (3)", ingredients = { {id = IDS.KWUARM_POTION_UNF, qty = 1}, {id = IDS.LIMPWURT_ROOT, qty = 1} } },
    [IDS.SUPER_DEFENCE_3]         = { name = "Super defence (3)", ingredients = { {id = IDS.CADANTINE_POTION_UNF, qty = 1}, {id = IDS.WHITE_BERRIES, qty = 1} } },
    [IDS.SUPER_RANGING_3]         = { name = "Super ranging (3)", ingredients = { {id = IDS.DWARF_WEED_POTION_UNF, qty = 1}, {id = IDS.WINE_OF_ZAMORAK, qty = 1} } },
    [IDS.ANTIFIRE_3]              = { name = "Antifire (3)", ingredients = { {id = IDS.LANTADYME_POTION_UNF, qty = 1}, {id = IDS.DRAGON_SCALE_DUST, qty = 1} } },
    [IDS.SUPER_ENERGY_3]          = { name = "Super energy (3)", ingredients = { {id = IDS.AVANTOE_POTION_UNF, qty = 1}, {id = IDS.MORT_MYRE_FUNGUS, qty = 1} } },
    [IDS.SUPER_RESTORE_3]         = { name = "Super restore (3)", ingredients = { {id = IDS.SNAPDRAGON_POTION_UNF, qty = 1}, {id = IDS.RED_SPIDERS_EGGS, qty = 1} } },
    [IDS.SUPER_MAGIC_3]           = { name = "Super magic (3)", ingredients = { {id = IDS.LANTADYME_POTION_UNF, qty = 1}, {id = IDS.POTATO_CACTUS, qty = 1} } },
    [IDS.SARADOMIN_BREW_3]        = { name = "Saradomin brew (3)", ingredients = { {id = IDS.TOADFLAX_POTION_UNF, qty = 1}, {id = IDS.CRUSHED_NEST, qty = 1} } },
    [IDS.ADRENALINE_POT_3]        = { name = "Adrenaline potion (3)", ingredients = { {id = IDS.SUPER_ENERGY_3, qty = 1}, {id = IDS.PAPAYA_FRUIT, qty = 1} } },
    [IDS.PRAYER_RENEWAL_POTION_3] = { name = "Prayer renewal potion (3)", ingredients = { {id = IDS.FELLSTALK_POTION_UNF, qty = 1}, {id = IDS.MORCHELLA_MUSHROOM, qty = 1} } },
    [IDS.AGGRESSION_POTION_3]     = { name = "Aggression potion (3)", ingredients = { {id = IDS.BLOODWEED_POTION_UNF, qty = 1}, {id = IDS.SEARING_ASHES, qty = 1} } },
    [IDS.SUPER_NECROMANCY_3]      = { name = "Super necromancy (3)", ingredients = { {id = IDS.SPIRIT_WEED_POTION_UNF, qty = 1}, {id = IDS.CONGEALED_BLOOD, qty = 1} } },
    [IDS.SUPER_ANTIPOISON_3]      = { name = "Super antipoison (3)", ingredients = { {id = IDS.IRIT_POTION_UNF, qty = 1}, {id = IDS.UNICORN_HORN_DUST, qty = 1} } },

    -- EXTREME POTIONS & POWERBURSTS
    [IDS.SUPER_ANTIFIRE_3]       = { name = "Super antifire (3)", ingredients = { {id = IDS.ANTIFIRE_3, qty = 1}, {id = IDS.PHOENIX_FEATHER, qty = 1} } },
    [IDS.EXTREME_ATTACK_3]       = { name = "Extreme attack (3)", ingredients = { {id = IDS.SUPER_ATTACK_3, qty = 1}, {id = IDS.CLEAN_AVANTOE, qty = 1} } },
    [IDS.EXTREME_STRENGTH_3]     = { name = "Extreme strength (3)", ingredients = { {id = IDS.SUPER_STRENGTH_3, qty = 1}, {id = IDS.CLEAN_DWARF_WEED, qty = 1} } },
    [IDS.EXTREME_DEFENCE_3]      = { name = "Extreme defence (3)", ingredients = { {id = IDS.SUPER_DEFENCE_3, qty = 1}, {id = IDS.CLEAN_LANTADYME, qty = 1} } },
    [IDS.EXTREME_MAGIC_3]        = { name = "Extreme magic (3)", useMake = false, ingredients = { {id = IDS.SUPER_MAGIC_3, qty = 1}, {id = IDS.GROUND_MUD_RUNE, qty = 1, stackable = true} } },
    [IDS.EXTREME_RANGING_3]      = { name = "Extreme ranging (3)", ingredients = { {id = IDS.SUPER_RANGING_3, qty = 1}, {id = IDS.GRENWALL_SPIKE, qty = 5, stackable = true} } },
    [IDS.SUPER_ADRENALINE_3]     = { name = "Super adrenaline potion", ingredients = { {id = IDS.ADRENALINE_POT_3, qty = 1}, {id = IDS.ADRENALINE_CRYSTAL, qty = 1} } },
    [IDS.ADRENALINE_RENEWAL_POT] = { name = "Adrenaline renewal potion", useMake = true, ingredients = { {id = IDS.PRIMAL_EXTRACT, qty = 1}, {id = IDS.SUPER_ADRENALINE_3, qty = 1}, {id = IDS.CLEAN_ARBUCK, qty = 1}, {id = IDS.BOTTLED_DINOSAUR_ROAR, qty = 1, stackable = true} } },
    [IDS.POWERBURST_VITALITY]    = { name = "Powerburst of vitality", useMake = true, ingredients = { {id = IDS.POWERBURST_VIAL, qty = 1, stackable = true}, {id = IDS.POISON_SLIME, qty = 1, stackable = true}, {id = IDS.PRIMAL_EXTRACT, qty = 1}, {id = IDS.SARADOMIN_BREW_3, qty = 1}, {id = IDS.ROCKTAIL, qty = 1} } },
    [IDS.EXTREME_NECROMANCY_3]   = { name = "Extreme necromancy (3)", useMake = false, ingredients = { {id = IDS.SUPER_NECROMANCY_3, qty = 1}, {id = IDS.GROUND_MIASMA_RUNE, qty = 1, stackable = true} } },

    -- OVERLOADS (Standard)
    [IDS.OVERLOAD_3]          = { name = "Overload (3)", ingredients = { {id = IDS.EXTREME_ATTACK_3, qty = 1}, {id = IDS.EXTREME_STRENGTH_3, qty = 1}, {id = IDS.EXTREME_DEFENCE_3, qty = 1}, {id = IDS.EXTREME_MAGIC_3, qty = 1}, {id = IDS.EXTREME_RANGING_3, qty = 1}, {id = IDS.EXTREME_NECROMANCY_3, qty = 1}, {id = IDS.CLEAN_TORSTOL, qty = 1} } },
    [IDS.SUPREME_OVERLOAD]    = { name = "Supreme overload", ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4, qty = 1}, {id = IDS.SUPER_ATTACK_4, qty = 1}, {id = IDS.SUPER_STRENGTH_4, qty = 1}, {id = IDS.SUPER_DEFENCE_4, qty = 1}, {id = IDS.SUPER_MAGIC_4, qty = 1}, {id = IDS.SUPER_RANGING_4, qty = 1}, {id = IDS.SUPER_NECROMANCY_4, qty = 1} } },
    [IDS.ELDER_OVERLOAD]      = { name = "Elder overload", ingredients = { {id = IDS.PRIMAL_EXTRACT, qty = 1}, {id = IDS.SUPREME_OVERLOAD, qty = 1}, {id = IDS.CLEAN_FELLSTALK, qty = 1} } },
    [IDS.PERFECT_PLUS_POTION] = { name = "Perfect plus potion", useMake = true, ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4, qty = 1}, {id = IDS.HARMONY_MOSS, qty = 1, stackable = true}, {id = IDS.CRYSTAL_TREE_BLOSSOM, qty = 1} } },
    [IDS.HOLY_OVERLOAD]       = { name = "Holy overload", useMake = true, ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4, qty = 1}, {id = IDS.PRAYER_RENEWAL_POTION_4, qty = 1} } },
    [IDS.AGGROVERLOAD]        = { name = "Aggroverload", useMake = true, ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4, qty = 1}, {id = IDS.AGGRESSION_POTION_4, qty = 1}, {id = IDS.CLEAN_ARBUCK, qty = 1} } },
    [IDS.HOLY_AGGROVERLOAD]   = { name = "Holy aggroverload", useMake = true, ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4, qty = 1}, {id = IDS.AGGRESSION_POTION_4, qty = 1}, {id = IDS.PRAYER_RENEWAL_POTION_4, qty = 1}, {id = IDS.SPIDER_VENOM, qty = 1} } },

    -- GRANNY PREP STEPS (Unfinished)
    [IDS.OVERLOAD_3_UNF]       = { name = "Overload (3) (unfinished)", isGranny = true, ingredients = { {id = IDS.EXTREME_ATTACK_3, qty = 1}, {id = IDS.EXTREME_STRENGTH_3, qty = 1}, {id = IDS.EXTREME_DEFENCE_3, qty = 1}, {id = IDS.EXTREME_MAGIC_3, qty = 1}, {id = IDS.EXTREME_RANGING_3, qty = 1}, {id = IDS.EXTREME_NECROMANCY_3, qty = 1}, {id = IDS.CLEAN_TORSTOL, qty = 1} } },
    [IDS.SUPREME_OVERLOAD_UNF] = { name = "Supreme overload (6) (unfinished)", isGranny = true, ingredients = { {id = IDS.CRYSTAL_FLASK, qty = 1}, {id = IDS.OVERLOAD_4_WORKBENCH, qty = 1}, {id = IDS.SUPER_ATTACK_4, qty = 1}, {id = IDS.SUPER_STRENGTH_4, qty = 1}, {id = IDS.SUPER_DEFENCE_4, qty = 1}, {id = IDS.SUPER_MAGIC_4, qty = 1}, {id = IDS.SUPER_RANGING_4, qty = 1}, {id = IDS.SUPER_NECROMANCY_4, qty = 1} } },
    [IDS.ELDER_OVERLOAD_UNF]   = { name = "Elder overload (6) (unfinished)", isGranny = true, ingredients = { {id = IDS.PRIMAL_EXTRACT, qty = 1}, {id = IDS.SUPREME_OVERLOAD_WORKBENCH, qty = 1}, {id = IDS.CLEAN_FELLSTALK, qty = 1} } },

    -- WORKBENCH BATCH STEPS
    [IDS.OVERLOAD_3_WORKBENCH]       = { name = "Overload (3) (from unfinished)", useWorkbench = true, useMake = true, menuID = 55960, makes = IDS.OVERLOAD_3, yield = 5, ingredients = { {id = IDS.OVERLOAD_3_UNF, qty = 4, stackable = true} } },
    [IDS.OVERLOAD_4_WORKBENCH]       = { name = "Overload (4) (workbench route)", isDecant = true, makes = IDS.OVERLOAD_4, ingredients = { {id = IDS.OVERLOAD_3_WORKBENCH, qty = 1} } },
    [IDS.SUPREME_OVERLOAD_WORKBENCH] = { name = "Supreme overload (from unfinished)", useWorkbench = true, useMake = true, makes = IDS.SUPREME_OVERLOAD, yield = 4, ingredients = { {id = IDS.SUPREME_OVERLOAD_UNF, qty = 3, stackable = true} } },
    [IDS.ELDER_OVERLOAD_WORKBENCH]   = { name = "Elder overload (from unfinished)", useWorkbench = true, useMake = true, makes = IDS.ELDER_OVERLOAD, yield = 5, ingredients = { {id = IDS.ELDER_OVERLOAD_UNF, qty = 4, stackable = true} } },

    -- WEAPON POISON CHAIN
    [IDS.COCONUT_OPEN]         = { name = "Coconut (open)", useMake7 = true, ingredients = { {id = IDS.COCONUT, qty = 1} } },
    [IDS.COCONUT_MILK]         = { name = "Coconut milk", ingredients = { {id = IDS.COCONUT_OPEN, qty = 1}, {id = IDS.EMPTY_VIAL, qty = 1} } },
    [IDS.WEAPON_POISON_PP_UNF] = { name = "Weapon poison++ (unfinished)", ingredients = { {id = IDS.COCONUT_MILK, qty = 1}, {id = IDS.CAVE_NIGHTSHADE, qty = 1} } },
    [IDS.WEAPON_POISON_PP_3]   = { name = "Weapon poison++ (3)", ingredients = { {id = IDS.WEAPON_POISON_PP_UNF, qty = 1}, {id = IDS.POISON_IVY_BERRIES, qty = 1} } },
    [IDS.WEAPON_POISON_PPP_3]  = { name = "Weapon poison+++ (3)", ingredients = { {id = IDS.WEAPON_POISON_PP_3, qty = 1}, {id = IDS.POISON_SLIME, qty = 1, stackable = true}, {id = IDS.PRIMAL_EXTRACT, qty = 1} } },

    -- DECANTING (4-DOSE)
    [IDS.PRAYER_POTION_4]         = { name = "Prayer potion (4)", isDecant = true, ingredients = { {id = IDS.PRAYER_POTION_3, qty = 1} } },
    [IDS.SUPER_ATTACK_4]          = { name = "Super attack (4)", isDecant = true, ingredients = { {id = IDS.SUPER_ATTACK_3, qty = 1} } },
    [IDS.SUPER_STRENGTH_4]        = { name = "Super strength (4)", isDecant = true, ingredients = { {id = IDS.SUPER_STRENGTH_3, qty = 1} } },
    [IDS.SUPER_DEFENCE_4]         = { name = "Super defence (4)", isDecant = true, ingredients = { {id = IDS.SUPER_DEFENCE_3, qty = 1} } },
    [IDS.SUPER_RANGING_4]         = { name = "Super ranging (4)", isDecant = true, ingredients = { {id = IDS.SUPER_RANGING_3, qty = 1} } },
    [IDS.ANTIFIRE_4]              = { name = "Antifire (4)", isDecant = true, ingredients = { {id = IDS.ANTIFIRE_3, qty = 1} } },
    [IDS.SUPER_RESTORE_4]         = { name = "Super restore (4)", isDecant = true, ingredients = { {id = IDS.SUPER_RESTORE_3, qty = 1} } },
    [IDS.SUPER_MAGIC_4]           = { name = "Super magic (4)", isDecant = true, ingredients = { {id = IDS.SUPER_MAGIC_3, qty = 1} } },
    [IDS.SARADOMIN_BREW_4]        = { name = "Saradomin brew (4)", isDecant = true, ingredients = { {id = IDS.SARADOMIN_BREW_3, qty = 1} } },
    [IDS.SUPER_ANTIFIRE_4]        = { name = "Super antifire (4)", isDecant = true, ingredients = { {id = IDS.SUPER_ANTIFIRE_3, qty = 1} } },
    [IDS.OVERLOAD_4]              = { name = "Overload (4)", isDecant = true, ingredients = { {id = IDS.OVERLOAD_3, qty = 1} } },
    [IDS.PRAYER_RENEWAL_POTION_4] = { name = "Prayer renewal potion (4)", isDecant = true, ingredients = { {id = IDS.PRAYER_RENEWAL_POTION_3, qty = 1} } },
    [IDS.AGGRESSION_POTION_4]     = { name = "Aggression potion (4)", isDecant = true, ingredients = { {id = IDS.AGGRESSION_POTION_3, qty = 1} } },
    [IDS.SUPER_NECROMANCY_4]      = { name = "Super necromancy (4)", isDecant = true, ingredients = { {id = IDS.SUPER_NECROMANCY_3, qty = 1} } },
    [IDS.SUPER_ANTIPOISON_4]      = { name = "Super antipoison (4)", isDecant = true, ingredients = { {id = IDS.SUPER_ANTIPOISON_3, qty = 1} } },
    [IDS.WEAPON_POISON_PP_4]      = { name = "Weapon poison++ (4)", isDecant = true, ingredients = { {id = IDS.WEAPON_POISON_PP_3, qty = 1} } },
    [IDS.WEAPON_POISON_PPP_4]     = { name = "Weapon poison+++ (4)", isDecant = true, ingredients = { {id = IDS.WEAPON_POISON_PPP_3, qty = 1} } },

    -- PROCESSING & INGREDIENTS
    [IDS.CRUSHED_NEST]       = { name = "Crushed nest", useMake = true, tool = IDS.PESTLE_AND_MORTAR, ingredients = { {id = IDS.BIRDS_NEST_EMPTY, qty = 1} } },
    [IDS.GROUND_MUD_RUNE]    = { name = "Ground mud runes", useMake = true, ingredients = { {id = IDS.MUD_RUNE, qty = 1, stackable = true} } },
    [IDS.ADRENALINE_CRYSTAL] = { name = "Adrenaline crystal", useMake = true, ingredients = { {id = IDS.INERT_ADRENALINE_CRYSTAL, qty = 1, stackable = false}, {id = IDS.SPARK_CHITIN, qty = 1, stackable = true}, {id = IDS.PRIMAL_EXTRACT, qty = 1} } },
    [IDS.PRIMAL_EXTRACT]     = { name = "Primal extract", useMake = true, yield = 3, ingredients = { {id = IDS.PRIMAL_FRUIT_PULP, qty = 1, stackable = true}, {id = IDS.EMPTY_VIAL, qty = 3} } },
    [IDS.PRIMAL_FRUIT_PULP]  = { name = "Primal fruit pulp", useMake = true, ingredients = { {id = 48771, qty = 1} } },
    [IDS.GROUND_MIASMA_RUNE] = { name = "Ground miasma rune", useMake = true, ingredients = { {id = IDS.MIASMA_RUNE, qty = 1, stackable = true} } },

    -- BOMBS
    [IDS.VULNERABILITY_BOMB] = { name = "Vulnerability bomb", useMake = true, ingredients = { {id = IDS.BOMB_VIAL, qty = 1, stackable = true}, {id = IDS.PRIMAL_EXTRACT, qty = 1}, {id = IDS.SOUL_RUNE, qty = 3, stackable = true}, {id = IDS.CHAOS_RUNE, qty = 3, stackable = true}, {id = IDS.BOTTLED_DINOSAUR_ROAR, qty = 1, stackable = true}, {id = IDS.CLEAN_DWARF_WEED, qty = 1} } },
}

-- ============================================================================
-- NAME MAPPING
-- ============================================================================
Recipes.NAMES = {
    [99]     = "Ranarr potion (unf)",
    [101]    = "Irit potion (unf)",
    [103]    = "Avantoe potion (unf)",
    [105]    = "Kwuarm potion (unf)",
    [107]    = "Cadantine potion (unf)",
    [109]    = "Dwarf weed potion (unf)",
    [139]    = "Prayer potion (3)",
    [145]    = "Super attack (3)",
    [157]    = "Super strength (3)",
    [163]    = "Super defence (3)",
    [169]    = "Super ranging (3)",
    [181]    = "Super antipoison (3)",
    [199]    = "Grimy guam",
    [201]    = "Grimy marrentill",
    [203]    = "Grimy tarromin",
    [205]    = "Grimy harralander",
    [207]    = "Grimy ranarr",
    [209]    = "Grimy irit",
    [211]    = "Grimy avantoe",
    [213]    = "Grimy kwuarm",
    [215]    = "Grimy cadantine",
    [217]    = "Grimy dwarf weed",
    [219]    = "Grimy torstol",
    [221]    = "Eye of newt",
    [223]    = "Red spiders' eggs",
    [225]    = "Limpwurt root",
    [227]    = "Vial of water",
    [229]    = "Empty vial",
    [231]    = "Snape grass",
    [235]    = "Unicorn horn dust",
    [239]    = "White berries",
    [241]    = "Dragon scale dust",
    [245]    = "Wine of Zamorak",
    [233]    = "Pestle and mortar",
    [249]    = "Clean guam",
    [251]    = "Clean marrentill",
    [253]    = "Clean tarromin",
    [255]    = "Clean harralander",
    [257]    = "Clean ranarr",
    [259]    = "Clean irit",
    [261]    = "Clean avantoe",
    [263]    = "Clean kwuarm",
    [265]    = "Clean cadantine",
    [267]    = "Clean dwarf weed",
    [269]    = "Clean torstol",
    [562]    = "Chaos rune",
    [566]    = "Soul rune",
    [1601]   = "Diamond",
    [1603]   = "Ruby",
    [1605]   = "Emerald",
    [1607]   = "Sapphire",
    [1615]   = "Dragonstone",
    [2398]   = "Cave nightshade",
    [2434]   = "Prayer potion (4)",
    [2436]   = "Super attack (4)",
    [2440]   = "Super strength (4)",
    [2442]   = "Super defence (4)",
    [2444]   = "Super ranging (4)",
    [2448]   = "Super antipoison (4)",
    [2452]   = "Antifire (4)",
    [2454]   = "Antifire (3)",
    [2481]   = "Clean lantadyme",
    [2483]   = "Lantadyme potion (unf)",
    [2485]   = "Grimy lantadyme",
    [2970]   = "Mort myre fungus",
    [2998]   = "Clean toadflax",
    [3000]   = "Clean snapdragon",
    [3002]   = "Toadflax potion (unf)",
    [3004]   = "Snapdragon potion (unf)",
    [3018]   = "Super energy (3)",
    [3024]   = "Super restore (4)",
    [3026]   = "Super restore (3)",
    [3040]   = "Super magic (4)",
    [3042]   = "Super magic (3)",
    [3049]   = "Grimy toadflax",
    [3051]   = "Grimy snapdragon",
    [3138]   = "Potato cactus",
    [4621]   = "Phoenix feather",
    [4698]   = "Mud rune",
    [5075]   = "Bird's nest (empty)",
    [5935]   = "Coconut milk",
    [5939]   = "Weapon poison++ (unfinished)",
    [5972]   = "Papaya fruit",
    [5974]   = "Coconut",
    [5976]   = "Coconut (open)",
    [6018]   = "Poison ivy berries",
    [6685]   = "Saradomin brew (4)",
    [6687]   = "Saradomin brew (3)",
    [6693]   = "Crushed nest",
    [9594]   = "Ground mud runes",
    [12172]  = "Clean spirit weed",
    [12174]  = "Grimy spirit weed",
    [12181]  = "Spirit weed potion (unf)",
    [12539]  = "Grenwall spike",
    [14836]  = "Grimy wergali",
    [14854]  = "Clean wergali",
    [15272]  = "Rocktail",
    [15301]  = "Adrenaline potion (3)",
    [15304]  = "Super antifire (4)",
    [15305]  = "Super antifire (3)",
    [15309]  = "Extreme attack (3)",
    [15313]  = "Extreme strength (3)",
    [15317]  = "Extreme defence (3)",
    [15321]  = "Extreme magic (3)",
    [15325]  = "Extreme ranging (3)",
    [15332]  = "Overload (4)",
    [15333]  = "Overload (3)",
    [21622]  = "Morchella mushroom",
    [21624]  = "Clean fellstalk",
    [21626]  = "Grimy fellstalk",
    [21628]  = "Fellstalk potion (unf)",
    [21630]  = "Prayer renewal potion (4)",
    [21632]  = "Prayer renewal potion (3)",
    [25501]  = "Weapon poison++ (4)",
    [25503]  = "Weapon poison++ (3)",
    [29268]  = "Attuned portent of restoration X",
    [32270]  = "Crystal tree blossom",
    [32843]  = "Crystal flask",
    [32947]  = "Harmony moss",
    [33210]  = "Supreme overload",
    [33234]  = "Perfect plus potion",
    [33246]  = "Holy overload",
    [34159]  = "Searing ashes",
    [36390]  = "Divine charge",
    [37227]  = "Congealed blood",
    [37953]  = "Clean bloodweed",
    [37969]  = "Aggression potion (3)",
    [37971]  = "Aggression potion (4)",
    [37973]  = "Bloodweed potion (unf)",
    [37975]  = "Grimy bloodweed",
    [39067]  = "Adrenaline crystal",
    [39214]  = "Super adrenaline potion",
    [43997]  = "Spider venom",
    [48211]  = "Clean arbuck",
    [48239]  = "Aggroverload",
    [48243]  = "Grimy arbuck",
    [48575]  = "Inert adrenaline crystal",
    [48578]  = "Avocado",
    [48580]  = "Mango",
    [48582]  = "Lychee",
    [48584]  = "Ciku",
    [48586]  = "Carambola",
    [48588]  = "Guarana",
    [48771]  = "Dragonfruit",
    [48773]  = "Golden dragonfruit",
    [48921]  = "Poison slime",
    [48923]  = "Spark chitin",
    [48926]  = "Bottled dinosaur roar",
    [48951]  = "Vulnerability bomb",
    [48960]  = "Powerburst vial",
    [48961]  = "Bomb vial",
    [48962]  = "Primal extract",
    [48966]  = "Primal fruit pulp",
    [49039]  = "Elder overload",
    [49079]  = "Adrenaline renewal potion",
    [49095]  = "Powerburst of vitality",
    [49115]  = "Weapon poison+++ (4)",
    [49117]  = "Weapon poison+++ (3)",
    [50877]  = "Holy aggroverload",
    [55316]  = "Super necromancy (4)",
    [55318]  = "Super necromancy (3)",
    [55326]  = "Extreme necromancy (3)",
    [55340]  = "Miasma rune",
    [55697]  = "Ground miasma rune",
    [55953]  = "Overload (3) (unfinished)",
    [55955]  = "Supreme overload (6) (unfinished)",
    [55957]  = "Elder overload (6) (unfinished)",
    [900001] = "Overload (3) (from unfinished)",
    [900002] = "Supreme overload (from unfinished)",
    [900003] = "Elder overload (from unfinished)",
    [900004] = "Overload (4) (workbench route)",
}

function Recipes.GetCraftingPlan(targetID)
    local plan = {}
    local visited = {}

    local function resolve(id)
        local recipe = Recipes.Database[id]
        if not recipe then return end

        for _, ing in ipairs(recipe.ingredients) do
            resolve(ing.id) 
        end

        if not visited[id] then
            table.insert(plan, id)
            visited[id] = true
        end
    end

    resolve(targetID)
    return plan
end

DX.Herblore = Recipes


return DX
