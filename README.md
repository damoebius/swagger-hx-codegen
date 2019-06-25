# Swagger to [Tinkerbell Web Routing](https://haxetink.github.io/tink_web/#/)

This package generates a Haxe class from a swagger specification file. The code is generated using mustache templates.


## Installation
```bash
haxelib install build.hxml
haxe build.hxml
```

## Usage
```bash
node cmd.js -swagger [myswagger.json] -className [myRouterClassName]
```

### exemple
```bash
node cmd.js -swagger swagger.json -className Api
```
will output Api.hx
