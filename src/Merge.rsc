module Merge

import AST;
import IO;
import List;


@doc{Parallel merge

The states in the machine resulting from merging machines S1 and S2 are
identified by tuples of the states of both machines. Execution thus
starts in a the initial state <s0, u0> where s0 and u0 are the initial
states of S1 and S2 respectively. Running S1 and S2 in parallel then
entails the following:

- If in sate <s, u>, on event e, both S1 and S2 have transitions to
  s', and u', the combined machine transitions to <s', u'>.

- If in state <s, u>, on event e, only S1 has a transition to
  s', the combined machine transitions to <s', u>.

- If in state <s, u>, on event e, only S2 has a transition to
  u', the combined machine transitions to <s, u'>.
  
Note: you have to decide how commands, events and reset events are
combined and how, upon entering a combined state <s', u'>, the actions
of both s' and u' are combine

NB: we assume the eventnames in ctl1 and ctl2 are equal if their tokens are equal
this way, the eventnames can be used as the alphabet. Same for actions.
The controllers must also both be deterministic.
}
public Controller merge(Controller ctl1, Controller ctl2) {}

