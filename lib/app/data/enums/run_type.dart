enum RunType {
  batsman,
  bowler,
}

RunType toggleRunType(RunType runType) =>
    runType == RunType.batsman ? RunType.bowler : RunType.batsman;
