class MatchData {
  final String id;
  final String team1;
  final String team2;
  final double result1;
  final double result2;

  const MatchData(this.id, this.team1, this.team2, this.result1, this.result2);

  bool isTeam1Winner() {
    return result1 > result2;
  }

  bool isTeam2Winner() {
    return result2 > result1;
  }
}
