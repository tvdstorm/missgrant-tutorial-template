module Check

import AST;
import Message;
import List;
import Relation;
import Set;

@doc{Well-formedness checking

The list of things you could check for includes (but might not be
limited by) the following:

- Duplicate definitions of events/commands and their tokens.
- Duplicate state definitions.
- Reset events that are used in a transition.
- Non-determinism (two transitions from the same state that fire on
  the same token).
- Undeclared reset events, actions, events or states.
- Unreachable states.
}
set[Message] check(Controller ctl)
  = undefinedStates(ctl)
  + undefinedEvents(ctl)
  + undefinedCommands(ctl)
  + resetsInTransition(ctl)
  + duplicateStates(ctl)
  + duplicateEvents(ctl)
  + duplicateCommands(ctl)
  + unreachableStates(ctl)
  + nonDeterministicStates(ctl)
  + unusedEvents(ctl)
  + unusedCommands(ctl);

 
 set[Message] undefinedStates(Controller ctl)
  = { error("Undefined state", t@location) | 
           /t:transition(_, q) <- ctl, /state(q, _, _) !:= ctl };

set[Message] undefinedEvents(Controller ctl)
  = { /* todo */  };

set[Message] undefinedCommands(Controller ctl) 
  = { error("Undefined command", s@location) | 
           /s:state(_, as, _) <- ctl, a <- as, /command(a, _) !:= ctl };

set[Message] resetsInTransition(Controller ctl) 
  = { error("Reset used in transition", t@location) | 
        e <- ctl.resets, s <- ctl.states, t:transition(e, _) <- s.transitions }; 

set[Message] unusedEvents(Controller ctl) 
  = { warning("Unused event", e@location) | e:event(n, _) <- ctl.events, n notin ctl.resets,
           /transition(n, _) !:= ctl }; 

set[Message] unusedCommands(Controller ctl) 
  = { warning("Unused command", c@location) | c:command(n, _) <- ctl.commands, n notin as }
  when as := ( {} | it + toSet(s.actions) | s <- ctl.states ); 


set[Message] unreachableStates(Controller ctl) {
  g = { <s.name, t> | s <- ctl.states, /transition(_, t) <- s }*;
  q0 = ctl.states[0].name;
  return { error("Unreachable state", q@location) | q <- ctl.states, q.name notin g[q0] };
}

set[Message] nonDeterministicStates(Controller ctl) {
   rel[str,str] trans(State q) = { <e, t> | /transition(e, t) <- q };
   bool isDet(rel[str, str] r) = size(domain(r)) == size(r);
   return { error("Non-deterministic state", q@location) | q <- ctl.states, !isDet(trans(q)) };
}

set[Message] duplicateEvents(Controller ctl) 
  = { error("Duplicate event", l) | l <- locs }
  when locs := duplicates(ctl.events, str(Event e) { return e.name; },
                                   	   loc(Event e) { return e@location; });

set[Message] duplicateCommands(Controller ctl) 
  = { error("Duplicate command", l) | l <- locs }
  when locs := duplicates(ctl.commands, str(Command c) { return c.name; },
                                   	     loc(Command c) { return c@location; });

set[Message] duplicateStates(Controller ctl) 
  = { /* todo */ };

set[Message] deadendStates(Controller ctl)
  = { error("Dead-end state", s@location) | /State s <- ctl, s.transitions == [] }
  ;

set[&V] duplicates(list[&T] lst, &U(&T) fst, &V(&T) snd) {
  tuple[set[&U] xs, set[&V] ys] accu = <{}, {}>;
  accu = ( accu | fst(elt) in it.xs ? it[ys=it.ys + {snd(elt)}] : it[xs=it.xs + {fst(elt)}] | elt <- lst);
  return accu.ys;
}