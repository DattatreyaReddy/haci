enum Team {
  redTeam,
  blueTeam,
}

Team toggleTeam(Team team) =>
    team == Team.redTeam ? Team.blueTeam : Team.redTeam;

String teamAsString(Team team) =>
    team == Team.redTeam ? "Red Team" : "Blue Team";
