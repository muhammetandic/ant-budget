/// The kind of debt: money the user owes to others (`debt`) or money others
/// owe to the user (`claim`).
enum DebtType {
  /// Money the user owes to another person.
  debt,

  /// Money another person owes to the user.
  claim,
}
