--[[
#Script Name:   <devexitylib.lua>
# Description:  <Unified RS3 helper library: utilities, interfaces, prayers, necromancy, lodestones, bank and data tables>
# Autor:        <Devexity>
# Version:      <1.1.0>
# Datum:        <2026.11.23>
--]]

local API = require("api")
local DX = {}

DX.VERSION = "1.1.0"
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
DX.Lodestone.PRIFDDINAS = buildLodestone(36, FFPOINT.new(2208, 3360, 1))
DX.Lodestone.SEERS_VILLAGE = buildLodestone(19, FFPOINT.new(2689, 3482, 0))
DX.Lodestone.TAVERLEY = buildLodestone(20, FFPOINT.new(2878, 3442, 0))
DX.Lodestone.TIRANNWN = buildLodestone(31, FFPOINT.new(2254, 3149, 0))
DX.Lodestone.UM = buildLodestone(37, FFPOINT.new(1084, 1768, 1))
DX.Lodestone.VARROCK = buildLodestone(21, FFPOINT.new(3214, 3376, 0))
DX.Lodestone.WILDERNESS = buildLodestone(32, FFPOINT.new(3143, 3636, 0))
DX.Lodestone.YANILLE = buildLodestone(25, FFPOINT.new(2529, 3095, 0))

----------------------------------------------------------------------------------------------------
--# SECTION: DX.PlayerManager — player state, survival and buff management
-- Ported from sonsonmagro/Sonsons-Player-Manager v1.2.4; adapted to this client's API shapes
-- and conventions. Fixes upstream bugs: wrong inv_Container field names, dead critical-prayer
-- check, inverted teleport cooldown, triple GetABs_names read, global `debug` leak,
-- PlayerRegion().z used as plane (it is RegionId), missing status dispatch.
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

-- Bank toolbox (merged from bank.lua: "Bank Toolbox" v1.2.1 by Spectre011)
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

return DX
