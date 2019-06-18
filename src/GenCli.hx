package;

import tink.cli.*;
import tink.Cli;

class GenCli {
    static function main(){
        Cli.process(Sys.args(), new Command()).handle(Cli.exit);
    }
}

@:alias(false)
class Command {
	@:flag('-swagger')
	public var swagger:String;	

    @:flag('-help')
	public var help:String;	

    @:flag('-className')
	public var className:String;
	
	public function new() {}
	
	@:defaultCommand
	public function run(rest:Rest<String>) {
        if(swagger != null && className != null){
            var generator = new core.CodeGen();
            generator.run(swagger,className);
        } else {
             Sys.println('usage cmd -swagger swagger.json -className Api');
        }
		
	}
}