#!disableUnusedVars

#!define HAMSTER_SPAWN vect(148.75, 6, -46.40)

#!declareGlobal checkpointArray 0

#!declarePlayer currentCheckpoint 0
#!declarePlayer currentCheckpointEffect 1
#!declarePlayer currentCheckpointText 2
#!declarePlayer currentLap 3

@Rule "Hamster Race by Zencep#1489 (Blizzard) | Join me on Discord: bit.ly/TZDISCORD | twitch.tv/Zencep"
@Event global
disableScoring()

@Rule "Gamemode in development, please report any issues (or post suggestions) in the Discord."
@Event global
setMatchTime(9999)

@Rule "Setup Game"
@Event global
#debug(hostPlayer.getPosition())
hudHeader(getAllPlayers(), "Discord: bit.ly/TZDISCORD", Position.LEFT, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
hudHeader(getAllPlayers(), "twitch.tv/Zencep", Position.LEFT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
checkpointArray = [
    vect(138.78, 6.06, -46.53), 
    vect(117.17, 13.14, -57.96), 
    vect(105.9, -0.06, -45.91), 
    vect(95.58, 6.87, -49.99), 
    vect(75.54, 4.99, -100.96), 
    vect(65.03, 6.0, -93.40),
    vect(64.98, 10, -101.00),
    vect(63.49, 12.09, -83.27),
    vect(27.82, 10, -86.81),
    vect(3.73, 6, -96.26),
    vect(-29.29, 10, -98.4),
    vect(-38.65, 8.45, -71.05),
    vect(-54.87, 6, -76.74),
    vect(-92.91, 4, -87.05),
    vect(-52.8, 3.95, -28.03),
    vect(-43.28, 6, -38.84),
    vect(-15.75, 6, -42.64),
    vect(-22.95, 12, -51.16),
    vect(-12.03, 5.85, -79.36),
    vect(10.13, 7.8, -51.59),
    vect(34.19, 12.06, -58.71),
    vect(66.65, 11, -73.27),
    vect(82, 7, -25.73),
    vect(86.76, 12.05, -48.36),
    vect(105.1, 2.22, -32.47),
    vect(120.81, 4.79, -19.8),
    vect(138.58, 6, -29.64)
]



@Rule "On First Spawn"
@Event eachPlayer
if eventPlayer.hasSpawned():
    eventPlayer.startForcingHero(Hero.HAMMOND)
    eventPlayer.currentCheckpoint = 0
    eventPlayer.currentLap = 1
    #eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 9999)
    eventPlayer.teleport(HAMSTER_SPAWN)

    hudHeader(eventPlayer, "Lap {} / 3".format(eventPlayer.currentLap), Position.TOP, 0, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(eventPlayer, "Lap {} / 3".format(eventPlayer.currentLap), null, null, Position.TOP, 0, Color.SKY_BLUE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)

    createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, (checkpointArray[eventPlayer.currentCheckpoint] + (Vector.UP * 2)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.currentCheckpointEffect = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Checkpoint ({})".format(eventPlayer.currentCheckpoint + 1), (checkpointArray[eventPlayer.currentCheckpoint] + Vector.UP + Vector.UP), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.currentCheckpointText = getLastCreatedText()

@Rule "On Death"
@Event playerDied
victim.respawn()

@Rule "On Respawn"
@Event eachPlayer
if eventPlayer.isAlive():
    eventPlayer.teleport(HAMSTER_SPAWN)
    eventPlayer.setRespawnTime(9999)

@Rule "Check for Victory"
@Event eachPlayer
if isGameInProgress():
    do:
        if eventPlayer.currentLap > 3:
            declareTeamVictory(eventPlayer.getTeam())
        wait(0.016, Wait.IGNORE_CONDITION)
    while RULE_CONDITION

@Rule "Hit Checkpoint"
@Event eachPlayer
if distance(eventPlayer.getPosition(), checkpointArray[eventPlayer.currentCheckpoint] + (Vector.UP * 2)) <= 4:
    if eventPlayer.currentCheckpoint == (len(checkpointArray) - 1):
        eventPlayer.currentCheckpoint = 0
        eventPlayer.currentLap += 1
    else:
        eventPlayer.currentCheckpoint += 1
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 8)

    createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer.getPosition(), 300, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    destroyEffect(getLastCreatedEntity())
    destroyEffect(eventPlayer.currentCheckpointEffect)
    destroyInWorldText(eventPlayer.currentCheckpointText)

    createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, (checkpointArray[eventPlayer.currentCheckpoint] + (Vector.UP * 2)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.currentCheckpointEffect = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Checkpoint ({})".format(eventPlayer.currentCheckpoint + 1), (checkpointArray[eventPlayer.currentCheckpoint] + Vector.UP + Vector.UP), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.currentCheckpointText = getLastCreatedText()

