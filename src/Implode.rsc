module Implode

import Parse;
import AST;

import ParseTree;
import Node;

public Controller implode(Tree pt) = implode(#Controller, pt);

public Controller load(loc l) = implode(#Controller, parse(l));

