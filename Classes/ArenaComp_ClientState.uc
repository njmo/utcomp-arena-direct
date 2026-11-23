// Added by arena.direct on 2026-11-23. Only reads public client projections.
class ArenaComp_ClientState extends Object;

static function ReplicationInfo MatchFor(PlayerController Player)
{
    local ReplicationInfo Info;
    if (Player == None) return None;
    foreach Player.DynamicActors(class'ReplicationInfo', Info)
        if (string(Info.Class) ~= "ArenaHUD2004Duel_v002.ArenaMatchInfo"
            || string(Info.Class) ~= "ArenaHUD2004Team_v002.ArenaTeamInfo")
            return Info;
    return None;
}

static function bool IsVerified(PlayerController Player)
{
    local ReplicationInfo Info;
    if (Player == None) return false;
    foreach Player.DynamicActors(class'ReplicationInfo', Info)
        if (Info.Owner == Player && string(Info.Class) ~= "ArenaHUD2004Core_v002.ArenaVerifiedInfo")
            return true;
    return false;
}

static function ReplicationInfo VoteFor(PlayerController Player)
{
    local ReplicationInfo Info;
    if (Player == None) return None;
    foreach Player.DynamicActors(class'ReplicationInfo', Info)
        if (Info.Owner == Player && string(Info.Class) ~= "ArenaHUD2004Team_v002.ArenaTeamVoteInfo")
            return Info;
    return None;
}

static function string ScoreboardName(string DisplayName, PlayerReplicationInfo PRI, byte Phase)
{
    if (Phase > 0 && Phase <= 3 && PRI != None && !PRI.bOnlySpectator && PRI.bReadyToPlay)
        return "[Ready] " $ DisplayName;
    return DisplayName;
}

static function string PhaseLabel(byte Phase)
{
    switch (Phase)
    {
        case 1: return "Waiting for players";
        case 2: return "Warmup";
        case 3: return "Starting";
        case 4: return "Playing";
        case 5: return "Paused";
        case 6: return "Resuming";
        case 7: return "Match finished";
    }
    return "Waiting for match state";
}
