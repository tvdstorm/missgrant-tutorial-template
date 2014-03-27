module Extract

import AST;

@doc{Fact extraction

The first relation captures the transition structure of a state
machine: it contains tuples <s, t, s'>, where s is the source state,
t the triggering token, and s' the target state. The second relation
captures which tokens should be output upon entering a certain
state. Note that both relations use tokens and not the names of events
or actions. This means that in your extraction you should take care of
looking up event/command names to find the associated tokens. 
}
alias TransRel = rel[str state, str eventToken,  str toState];
alias ActionRel = rel[str state, str commandToken];


TransRel transRel(Controller ctl) 
  = { <s1, t.event, t.state> | /state(s1, _, ts) <- ctl, Transition t <- ts };

ActionRel commands(Controller ctl) 
  = { <s, a> | /state(s, as, _) <- ctl, a <- as }; 
