module Desugar

import AST;


@doc{Desugaring reset events

Remove the resetEvents sections from the controller, and
for each reset event add a transition to each state
that transitions to the initial (= first) state.
}
public Controller desugar(Controller ctl) {
  init = ctl.states[0].name;
  newts = [ transition(e, init) | e <- ctl.resets ];
  return visit (ctl) {
    case state(n, as, trs) => state(n, as, trs + newts)
  }
}