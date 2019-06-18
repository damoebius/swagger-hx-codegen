package core;

import core.Swagger.Operation;
import core.Swagger.Path;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;

class CodeGen {
    public function new(){}

    public function run(swaggerPath:String, className:String){
        var swagger:Swagger = Json.parse(File.getContent(swaggerPath));
        var view = getViewForSwagger(swagger,className);
        Sys.println(view);
        var templates = Sys.getCwd() + '/src/templates/';
        var option = new Option();
        option.classTemplate = File.getContent(templates + 'haxe-class.mustache'); 
        option.methodTemplate = File.getContent(templates + 'haxe-method.mustache');
        option.typeTemplate = File.getContent(templates + 'type.mustache');
        

        
        var source = Mustache.render(option.classTemplate, view, option);
        File.saveContent(className+".hx",source);
    }

    private function getViewForSwagger(swagger:Swagger, className:String):Dynamic{
        var methods = [];
        var authorizedMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'COPY', 'HEAD', 'OPTIONS', 'LINK', 'UNLIK', 'PURGE', 'LOCK', 'UNLOCK', 'PROPFIND'];
        var isSecure = (swagger.securityDefinitions != null);
        var domain:String = '';
        if(swagger.schemes != null && swagger.schemes.length > 0 && swagger.host != null && swagger.basePath != null) {
            var ereg:EReg = ~/\/+$/g;
            domain = swagger.schemes[0] + '://' + swagger.host + ereg.replace(swagger.basePath,'');
        }
        var data = {
            isNode: false,
            isES6: false,
            description: swagger.info.description,
            isSecure: isSecure,
            moduleName: null,
            className: className,
            imports: null,
            domain: domain,
            methods: [],
            definitions: []
        };

        var paths = Reflect.fields(swagger.paths);
        for(pathName in paths){
            var api:Path = Reflect.getProperty(swagger.paths,pathName);
            var operations = Reflect.fields(api);
            for(operationName in operations){
                var op:Operation = Reflect.getProperty(api,operationName);
                var secureTypes = [];
                if (swagger.securityDefinitions != null || op.security != null) {
                    var mergedSecurity = [].concat(swagger.security).concat(op.security).map( function(security){ return Reflect.fields(security); } );
                    if (swagger.securityDefinitions != null) {
                        var securDef = Reflect.fields(swagger.securityDefinitions);
                        for (sk in securDef) {
                            if (mergedSecurity.join(',').indexOf(sk) != -1) {
                                secureTypes.push(Reflect.getProperty(swagger.securityDefinitions,sk).type);
                            }
                        }
                    }
                }
            }
                
            
        }


        return data;
    }
}

class Option {

    public var classTemplate:String;
    public var typeTemplate:String;
    public var methodTemplate:String;

    public function new() {
        
    }
}