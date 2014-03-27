module Parse

import Syntax;
import ParseTree;

public start[Controller] parse(str src, loc origin) = parse(#start[Controller], src, origin);

public start[Controller] parse(loc origin) = parse(#start[Controller], origin);
