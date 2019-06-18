package core;

interface Swagger extends Spec {
    public var swagger:String;
    @:optional public var host:String;
    @:optional public var basePath:String;
    @:optional public var schemes:Array<Protocol>;
    @:optional public var consumes:Array<String>;
    @:optional public var produces:Array<String>;
    public var paths:Dynamic<Path>;
    @:optional public var definitions:Dynamic;
    @:optional public var parameters:Dynamic;
    @:optional public var responses:Dynamic;
    @:optional public var security:Array<Dynamic>;
    @:optional public var securityDefinitions:Dynamic;
}

interface Spec {
    public var info:Info;
    @:optional public var tags:Dynamic;
    @:optional public var externalDocs:ExternalDocs;
}

interface Path {
    @:optional public var get: Operation;
    @:optional public var put: Operation;
    @:optional public var post: Operation;
    @:optional public var delete: Operation;
    @:optional public var options: Operation;
    @:optional public var head: Operation;
    @:optional public var patch: Operation;
    @:optional public var parameters: Array<Parameter>;
}

interface Operation {
    @:optional public var tags: Array<String>;
    @:optional public var summary: String;
    @:optional public var description: String;
    @:optional public var externalDocs: ExternalDocs;
    public var operationId: String;
    @:optional public var consumes: Array<String>;
    @:optional public var produces: Array<String>;
    @:optional public var parameters: Array<Parameter>;
    public var responses: Dynamic<Response>;
    @:optional public var schemes: Array<Protocol>;
    @:optional public var deprecated: Bool;
    @:optional public var security: Array<Security>;
}

interface Response {
    public var description: String;
    @:optional public var schema: Schema;
    @:optional public var headers: Dynamic<Header>;
    @:optional public var examples: Dynamic<Example>;
}

interface BaseSchema {
      @:optional public var title: String;
      @:optional public var description: String;
      @:optional public var multipleOf: Float;
      @:optional public var maximum: Float;
      @:optional public var exclusiveMaximum: Float;
      @:optional public var minimum: Float;
      @:optional public var exclusiveMinimum: Float;
      @:optional public var maxLength: Float;
      @:optional public var minLength: Float;
      @:optional public var pattern: String;
      @:optional public var maxItems: Float;
      @:optional public var minItems: Float;
      @:optional public var uniqueItems: Bool;
      @:optional public var maxProperties: Float;
      @:optional public var minProperties: Float;
      @:optional public var items: BaseSchema;
    }

    interface Schema extends BaseSchema {
      @:optional public var type: DataType;
      @:optional public var format: DataFormat;
      @:optional public var allOf: Array<Schema>;
      @:optional public var additionalProperties: Any;
      @:optional public var properties: Dynamic<Schema>;
      @:optional public var discriminator: String;
      @:optional public var readOnly: Bool;
      @:optional public var xml: XML;
      @:optional public var externalDocs: ExternalDocs;
      @:optional public var example: Dynamic<Example>;
      @:optional public var required: Array<String>;
    }

interface Header extends BaseSchema{
    @:optional public var format: String;
    @:optional public var type: String;
}

interface XML {
      @:optional public var type: String;
      @:optional public var namespace: String;
      @:optional public var prefix: String;
      @:optional public var attribute: String;
      @:optional public var wrapped: Bool;
    }

interface Components {
    @:optional public var callbacks: Dynamic;
    @:optional public var examples: Dynamic;
    @:optional public var headers: Dynamic;
    @:optional public var links: Dynamic;
    @:optional public var parameters: Dynamic<Parameter>;
    @:optional public var requestBodies: Dynamic;
    @:optional public var responses: Dynamic<Response>;
    @:optional public var schemas: Dynamic;
    @:optional public var securitySchemes: Dynamic<Security>;
}

interface Server {
    public var url: String;
}

interface Info {
    public var title:String;
    @:optional public var version:String;
    @:optional public var description:String;
    @:optional public var termsOfService:String;
    @:optional public var contact:Contact;
    @:optional public var license:License;
}

interface Contact {
    @:optional public var name:String;
    @:optional public var email:String;
    @:optional public var url:String;
}

interface License {
    public var name:String;
    @:optional public var url:String;
}

interface ExternalDocs {
    public var url:String;
    @:optional public var description:String;
}

interface Tag {
    public var name:String;
    @:optional public var description:String;
    @:optional public var externalDocs:ExternalDocs;
}

typedef Example = Dynamic<Any>;

interface BaseParameter extends BaseSchema {
    public var name: String;
    @:optional public var required: Bool;
    public var description: String;
    public var schema: Schema;
    public var type: DataType;
    @:optional public var format: DataFormat;
}

typedef BodyParameter = BaseParameter;
typedef PathParameter = BaseParameter;
typedef HeaderParameter = BaseParameter;

interface QueryParameter extends BaseParameter {
    @:optional public var allowEmptyValue: Bool;
    @:optional public var collectionFormat: CollectionFormat;
}

interface FormDataParameter extends BaseParameter {
    @:optional public var collectionFormat: CollectionFormat;
}

typedef Parameter = BaseParameter;

enum abstract CollectionFormat(String) {
    var csv;
    var ssv;
    var tsv;
    var pipes;
    var multi;
}


enum abstract SupportedSpecMajorVersion(Int) {
    var v2=2;
    var v3=3;
}

enum abstract Protocol(String) { 
    var http;
    var https;
    var ws;
    var wss;
}

enum abstract DataFormat(String) {
    var int32;
    var int64;
    var float;
    var double;
    var binary;
    var date;
    var datetime='date-time';
    var password;
}

enum abstract DataType(String) {
    var integer;
    var Float;
    var boolean;
    var String;
    var array;
    var object;
}


interface BasicSecurity extends Security{
    
}
  
    interface ApiKeySecurity extends Security{
      var name: String;
    }
  
     interface OAuth2ImplicitSecurity extends Security{
      var flow:String;
      var authorizationUrl: String;
    }
  
     interface OAuth2PasswordSecurity extends Security{
      var flow:String;
      var tokenUrl: String;
      @:optional public var scopes: Array<OAuthScope>;
    }
  
     interface OAuth2ApplicationSecurity extends Security{
      var flow:String;
      var tokenUrl: String;
      @:optional public var scopes: Array<OAuthScope>;
    }
  
     interface OAuth2AccessCodeSecurity extends Security{
      var flow:String;
      var tokenUrl: String;
      var authorizationUrl: String;
      @:optional public var scopes: Array<OAuthScope>;
    }
  
     typedef OAuthScope = Dynamic<String>;
  
interface Security {
    var type:String;
    @:optional public var description: String;
}
