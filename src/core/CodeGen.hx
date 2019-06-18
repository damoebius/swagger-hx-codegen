package core;

import sys.io.File;
import haxe.Json;

class CodeGen {
    public function new(){}

    public function run(swaggerPath:String, className:String){
        var swagger:Swagger = Json.parse(File.getContent(swaggerPath));
        Sys.println(swagger.swagger);
    }
}