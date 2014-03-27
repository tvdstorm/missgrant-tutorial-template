module Examples

// Import these files in the console (copy-paste).
import Implode;
import AST;
import util::ValueUI;
import String;
import IO;
import Relation;

import vis::Figure;
import vis::Render;
import Node;
import Map;



// Paste expressions/statements from here in the console.
public void examples() {
  // load controller
  ast = load(|project://MissGrant/input/missgrant.ctl|);
  tree(ast);
  
  visit (ast) {
    case state(str name, _, _): println(name);
  }

  visit (ast) {
    case State s: println(s.name);
  }

  // rename all state names to "_"
  ast2 = visit (ast) { 
    case state(n, a, t) => state("<n>_", a, t) 
  }

  ast2 = visit (ast) { 
    case state(n, a, t) => state("<n>_", a, t) 
       when size(n) % 2 == 0
  }

  ast2 = visit (ast) { case State s => s[name="_"] }
  ast2 = visit (ast) { case State s: { s.name = "_"; insert s; } }
  tree(ast2);
  
  // collect set of state names
  qs = { s.name | State s <- ast.states };
  qs = { s.name | /State s <- ast };
  qs = { n | state(n, _, _) <- ast.states };
  qs = { n | /state(n, _, _) <- ast };
  
  // collect state names where length of name is odd
  qs = { n | /state(n, _, _) <- ast, size(n) % 2 == 0 };
  
  m = ( s.name: { t | /transition(_, t) <- s } | s <- ast.states );
}


public void rels() {
  // load controller
  ast = load(|project://MissGrant/input/missgrant.ctl|);
  rel[str,str] r = { <s.name, t> | s <- ast.states, /transition(_, t) <- s };
  
  iprintln(r);
  r<0>;
  r<1,0>;
  r["active"];
  r+;
  r*;
  domain(r) * range(r);
  carrier(r);
  
  mygraph(r);
  mygraph(r+);
}

public void comprehensions() {
   [ i | i <- [1..100], i % 2 == 0 ];

   ( i: i*i | i <- [1..10] );
   
   { <i, i*i*> | i <- [1..10] };
}

public void matching() {
  ast = load(|project://MissGrant/input/missgrant.ctl|);
  int x := 3;
  4 := 4;
  event(x, y) := event("a", "b");
  str x(_, _) := event("a", "b");
  event("c", "d") !:= event("a", "b");
  [*x, 1, *y] := [1,2,3];
  [*x, 1, *y] := [5, 6, 1, 1, 1, 3, 4];
  [*x, *y] := [1, 1, 1, 1, 1, 1] && x == y;
  {1, *x} := {4, 5, 6, 1, 2, 3};
  /transition(e, t) := ast;
  /transition(e, "idle") := ast;
  /state(x, _, /transition(_, x)) := ast;
  
  for (/transition(e, _) := ast) println(e);
  
  if (/s:state(x, _, /transition(_, x)) := ast) println("yes");
  
  x <- {1, 2, 3};
  
  for (x <- {1,2,3}) println(x);

  if (3 <- [1,2,3]) println("yes");
  
  for (x <- [1..100], x % 2 == 0) println(x);
  
    
  
}


@doc{Displays any value as a set of nested figures. EXPERIMENTAL!}
public void mygraph(value v) {
  render(toGraph(v));
}

Figure toGraph(value v) {
 props = [hcenter(),vcenter(),gap(5),width(0),height(0)];
 
  switch (v) {
    case bool b : return vis::Figure::text("<b>");
    case num i  : return vis::Figure::text("<i>");
    case str s  : return vis::Figure::text("<s>");
    case list[value] l : return box(pack([toGraph(e) | e <- l]), props);
    case rel[value from, value to] r : {
      int next = 0;
      int id() { next = next + 1; return next; }
      ids = ( e : "<id()>" | value e <- (r.from + r.to) );
      return box(graph([box(toGraph(e),[id(ids[e])] + props) | e <- ids],
                   [edge(ids[from],ids[to],toArrow(triangle(10))) | from <- r.from, to <- r[from]],hint("layered"),gap(40),width(1600),height(1600)));
    }
    case set[value] l :  return box(pack([toGraph(e) | e <- l]),[hcenter(),vcenter()]);
    case node x :  return box(vcat([text(getName(x),fontSize(20)), vcat([toGraph(c) | c <- x ])]),props);
    case map[value,value] x : return box(vcat([hcat([toGraph(key), toGraph(x[key])]) | key <- x],props)); 
    case tuple[value a, value b] t: return box(hcat([toGraph(t.a), toGraph(t.b)]),props);
    case tuple[value a, value b, value c] t: return box(hcat([toGraph(t.a), toGraph(t.b), toGraph(t.c)]),props);
    default: return text("<v>");
  }
}