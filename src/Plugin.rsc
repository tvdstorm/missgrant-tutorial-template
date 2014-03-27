module Plugin

import Syntax;
import Parse;
import Implode;
import Check;
import Desugar;
import Compile;
import Visualize;
import Extract;

import util::IDE;
import ParseTree;
import String;
import IO;

private str STM_LANG = "State machine";
private str STM_EXT = "stm";


public void main() {
  registerLanguage(STM_LANG, STM_EXT, Tree(str src, loc l) {
     return parse(src, l);
  });

  contribs = {
		     popup(
			       menu(STM_LANG,[

	    		     action("Visualize", void (start[Controller] pt, loc l) {
	    		       renderController(implode(pt));
	    		     })
	    		     
	    		 ])),

	    		 annotator(start[Controller] (start[Controller] pt) {
	    		   return pt[@messages = check(implode(pt))];
	    		 }),
	
	    		 builder(set[Message] (start[Controller] pt) {
	    		   ctl = desugar(implode(pt));
	    		   out = (pt@\loc)[extension="java"];
	    		   class = split(".", out.file)[0];
	    		   writeFile(out, compile(class, ctl));
       			   return {};
	    		 })
  };
  
  registerContributions(STM_LANG, contribs);
}



