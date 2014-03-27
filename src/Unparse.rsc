module Unparse

import AST;
import Parse;
import Implode;
import List;
import ParseTree;

public test bool unparseMissgrant() = testHelper(|project://MissGrant/input/missgrant.ctl|);
public test bool unparseMoreMissgrant() = testHelper(|project://MissGrant/input/moremissgrant.ctl|);
public test bool unparseMisterJones() = testHelper(|project://MissGrant/input/misterjones.ctl|);

     
private bool testHelper(loc l) {
  ast = implode(parse(l));
  return implode(parse(unparse(ast), l)) == ast;
}

@doc{Unparsing

Fill in the right-hand sides of the unparse definitions.
The result does not have to be pretty, but parsing and
imploding should result in the same AST (as tested by the
tests above.

Use string interpolation using <> (with for, if, if needed)
and ' for setting a margin. The toplevel unparse is already
provided. 
}


str unparse(controller(es, rs, cs, ss)) =
  "<unparse(es)>
  '<unparse(rs)>
  '<unparse(cs)>
  '<unparse(ss)>";

str unparse(list[Event] es) =
  "events
  '  <for (e <- es) {>
  '  <unparse(e)>
  '  <}>
  'end";
  
str unparse(list[str] rs) = rs == [] ? "" :  
  "resetEvents
  '  <intercalate("\n", rs)>
  'end";  

str unparse(list[Command] cs) =
  "commands
  '  <for (c <- cs) {>
  '  <unparse(c)>
  '  <}>
  'end";

str unparse(list[State] ss) = intercalate("\n", [ unparse(s) | s <- ss ]);

str unparse(event(n, t)) = "<n> <t>";
str unparse(command(n, t)) = "<n> <t>";
str unparse(state(n, as, ts)) = 
  "state <n>
  '  <if (as != []) {>
  '  actions {<intercalate(" ", as)>}
  '  <}>
  '  <for (t <- ts) {>
  '  <unparse(t)>
  '  <}>
  'end";

str unparse(transition(e, t)) = "<e> =\> <t>";
