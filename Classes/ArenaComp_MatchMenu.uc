// Added by arena.direct on 2026-11-23.
class ArenaComp_MatchMenu extends UTComp_Menu_MainMenu;

var automated GUIButton ReadyButton, PauseButton, SurrenderButton;
var automated GUILabel MatchStateLabel, VerifiedLabel, VoteLabel;
var ReplicationInfo MatchState, TeamVote;

function bool RefreshMatch(Canvas C)
{
    local PlayerController Player;
    local byte Phase, VoteKind;
    local int Seconds;
    Player = PlayerOwner();
    if (Player == None) return false;
    if (MatchState == None || MatchState.bDeleteMe) MatchState = class'ArenaComp_ClientState'.static.MatchFor(Player);
    if (MatchState != None)
    {
        Phase = byte(MatchState.GetPropertyText("Phase"));
        Seconds = int(MatchState.GetPropertyText("PhaseSeconds"));
    }
    MatchStateLabel.Caption = class'ArenaComp_ClientState'.static.PhaseLabel(Phase);
    if (Seconds > 0 && Phase != 4) MatchStateLabel.Caption $= "  " $ Seconds $ "s";
    if (TeamVote == None || TeamVote.bDeleteMe) TeamVote = class'ArenaComp_ClientState'.static.VoteFor(Player);
    if (TeamVote != None) VoteKind = byte(TeamVote.GetPropertyText("Kind"));
    VoteLabel.SetVisibility(VoteKind == 1 || VoteKind == 2);
    if (VoteKind == 1) VoteLabel.Caption = "Surrender vote";
    else if (VoteKind == 2) VoteLabel.Caption = "Pause vote";
    if (VoteKind != 0)
        VoteLabel.Caption $= "  " $ TeamVote.GetPropertyText("Yes") $ "/" $ TeamVote.GetPropertyText("Need")
            $ "  " $ TeamVote.GetPropertyText("Seconds") $ "s";
    VerifiedLabel.SetVisibility(class'ArenaComp_ClientState'.static.IsVerified(Player));
    ReadyButton.SetVisibility(Phase > 0 && Phase <= 3);
    PauseButton.SetVisibility(Phase == 4 || Phase == 6);
    SurrenderButton.SetVisibility(Phase >= 4 && Phase <= 6);
    return false;
}

function InitComponent(GUIController MyController, GUIComponent MyComponent)
{
    Super.InitComponent(MyController, MyComponent);

    if (PlayerOwner().GameReplicationInfo != None && PlayerOwner().GameReplicationInfo.bTeamGame)
        PauseButton.Caption = "Vote to pause";
    else
        PauseButton.Caption = "Request timeout";
}

function bool SendMatchAction(GUIComponent Sender)
{
    local string Command;

    if (Sender == ReadyButton)
        Command = "!ready";
    else if (Sender == SurrenderButton)
        Command = "!surrender";
    else if (PlayerOwner().GameReplicationInfo != None && PlayerOwner().GameReplicationInfo.bTeamGame)
        Command = "!pause";
    else
        Command = "!timeout";

    PlayerOwner().ServerSay(Command);
    Controller.CloseMenu(false);
    return true;
}

defaultproperties
{
    ActiveMenuButton=6
    OnPreDraw=RefreshMatch

    Begin Object Class=GUILabel Name=MatchStateText
        StyleName="WSLabelWhite"
        WinLeft=0.510
        WinTop=0.345
        WinWidth=0.340
        WinHeight=0.045
    End Object
    MatchStateLabel=GUILabel'MatchStateText'

    Begin Object Class=GUILabel Name=VerifiedText
        Caption="Verified by arena.direct"
        StyleName="WSLabelWhite"
        WinLeft=0.510
        WinTop=0.398
        WinWidth=0.340
        WinHeight=0.040
        bVisible=False
    End Object
    VerifiedLabel=GUILabel'VerifiedText'

    Begin Object Class=GUILabel Name=VoteText
        StyleName="WSLabelWhite"
        WinLeft=0.510
        WinTop=0.448
        WinWidth=0.340
        WinHeight=0.039
        bVisible=False
    End Object
    VoteLabel=GUILabel'VoteText'

    Begin Object Class=GUIButton Name=ReadyAction
        Caption="Ready"
        StyleName="WSButton"
        WinLeft=0.200
        WinTop=0.340
        WinWidth=0.270
        WinHeight=0.073
        OnClick=SendMatchAction
    End Object
    ReadyButton=GUIButton'ReadyAction'

    Begin Object Class=GUIButton Name=PauseAction
        StyleName="WSButton"
        WinLeft=0.200
        WinTop=0.430
        WinWidth=0.270
        WinHeight=0.073
        OnClick=SendMatchAction
    End Object
    PauseButton=GUIButton'PauseAction'

    Begin Object Class=GUIButton Name=SurrenderAction
        Caption="Surrender"
        StyleName="WSButton"
        WinLeft=0.200
        WinTop=0.520
        WinWidth=0.270
        WinHeight=0.073
        OnClick=SendMatchAction
    End Object
    SurrenderButton=GUIButton'SurrenderAction'
}
