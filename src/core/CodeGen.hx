package core;

import core.Swagger.BaseParameter;
import core.Swagger.BaseSchema;
import core.Swagger.DataType;
import core.Swagger.Operation;
import core.Swagger.Path;
import core.Swagger.Schema;
import haxe.Json;
import mustache.Context;
import mustache.View;
import sys.io.File;

class CodeGen {
    public function new() {}

    public function run(swaggerPath:String, className:String) {
        var swagger:Swagger = Json.parse(File.getContent(swaggerPath));
        var context = getContextForSwagger(swagger, className);
        var templates = Sys.getCwd() + '/src/templates/';
        var option = new Option();
        option.classTemplate = File.getContent(templates + 'haxe-class.mustache');
        option.methodTemplate = File.getContent(templates + 'haxe-method.mustache');
        option.typeTemplate = File.getContent(templates + 'haxe-defs.mustache');


        var source = Mustache.render(option.classTemplate, context, option);
        File.saveContent(className + ".hx", source);
    }

    private function getContextForSwagger(swagger:Swagger, className:String):Context {
        var methods = [];
        var authorizedMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'COPY', 'HEAD', 'OPTIONS', 'LINK', 'UNLIK', 'PURGE', 'LOCK', 'UNLOCK', 'PROPFIND'];
        var isSecure = (swagger.securityDefinitions != null);
        var domain:String = '';
        if (swagger.schemes != null && swagger.schemes.length > 0 && swagger.host != null && swagger.basePath != null) {
            var ereg:EReg = ~/\/+$/g;
            domain = swagger.schemes[0] + '://' + swagger.host + ereg.replace(swagger.basePath, '');
        }
        var data:View = {
            description: swagger.info.description,
            isSecure: isSecure,
            moduleName: null,
            className: className,
            imports: null,
            domain: domain,
            methods: [],
            definitions: []
        };

        // Paths
        var paths = Reflect.fields(swagger.paths);
        for (pathName in paths) {
            var api:Path = Reflect.getProperty(swagger.paths, pathName);
            var operations = Reflect.fields(api);
            for (operationName in operations) {
                var op:Operation = Reflect.getProperty(api, operationName);
                pathName = StringTools.replace(pathName,"{","$");
                pathName = StringTools.replace(pathName,"}","");
                var params = new Array<RequestParameter>();
                for(param in op.parameters){
                    params.push( new RequestParameter(param.name,Convert.getHaxeTypeByParameter(param),param.required));
                }
                var method = new Method(operationName, op.summary, op.description, pathName, op.operationId,params,"");
                data.methods.push(method);
            }
        }

        // TypeDef
        var defs = Reflect.fields(swagger.definitions);
        for (defName in defs) {
            var definition:Schema = Reflect.getProperty(swagger.definitions, defName);
            data.definitions.push(new Definition(defName, definition));
        }

        //

        return new Context(data);
    }
}

class Option {

    public var classTemplate:String;
    public var typeTemplate:String;
    public var methodTemplate:String;

    public function new() {}
}

class Definition {
    public var name:String;
    public var description:String;
    public var props:Array<Props>;

    public function new(name:String, definition:Schema) {
        this.name = name;
        this.description = definition.description;
        this.props = [];
        var propertiesName = Reflect.fields(definition.properties);
        for (propName in propertiesName) {
            var propSchema:Schema = Reflect.getProperty(definition.properties, propName);
            var prop = Props.fromSchema(propSchema, propName);
            if(definition.required != null && definition.required.indexOf(propName) > -1){
                prop.optionnal=false;
            }
            this.props.push(prop);
        }
    }

}

class Props {
    public var name:String;
    public var type:String;
    public var optionnal:Bool = true;

    public function new(name:String, type:String) {
        this.name = name;
        this.type = type;
    }

    public static function fromSchema(value:Schema, name:String):Props {
        var result = new Props(name, Convert.getHaxeType(value));
        return result;
    }

}

class Convert {

    public static function getHaxeType(value:BaseSchema):String {
        var result = "String";
        switch value.type{
            case DataType.integer : result = "Int";
            case DataType.number : result = "Float";
            case DataType.boolean : result = "Bool";
            case DataType.object : result = "Any";
            case DataType.string : result = "String";
            case DataType.array : result = "Array<" + getHaxeType(value.items) + ">";
            case null : result = null;
        }
        if(result == null){
            var ref:String = Reflect.getProperty(value,"$ref");
            if(ref != null){
                result = ref.split('/').pop();
            }
        }
        return result;
    }

    public static function getHaxeTypeByParameter(value:BaseParameter):String {
        var result = getHaxeType(value);
        if(result == null && value.schema != null){
            trace(value.schema);
            result = getHaxeType(value.schema);
        }
        return result;
    }

}

class Method {

    public var verb:String;
    public var summary:String;
    public var description:String;
    public var path:String;
    public var operationId:String;
    public var requestParameters:String= "";
    public var responseType:String;

    public function new(verb:String, summary:String, description:String, path:String, operationId:String, requestParameters:Array<RequestParameter>, responseType:String) {
        this.verb = verb;
        this.summary = summary;
        this.description = description;
        this.path = path;
        this.operationId = operationId;
        this.responseType = responseType;
        for(param in requestParameters) {
            if(this.requestParameters != ""){
                this.requestParameters += ",";
            }
            this.requestParameters += param.name + ":" + param.type;

        }
    }


}

class RequestParameter {
    public var name:String;
    public var type:String;
    public var required:Bool = true;

    public function new(name:String, type:String, required:Bool) {
        this.name = name;
        this.type = type;
        this.required = required;
    }

}
