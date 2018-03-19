package drivey;

import js.Browser;
import js.html.Element;
import js.html.KeyboardEvent;

import js.three.Object3D;
import js.three.PerspectiveCamera;
import js.three.OrthographicCamera;
import js.three.Scene;
import js.three.WebGLRenderer;

using Lambda;

class Screen {

    public var rgb:Color = 1;
    public var alpha:Float = 1;
    public var width(get, never):UInt;
    public var height(get, never):UInt;
    public var bg(get, set):Color;

    var element:Element;
    var camera:PerspectiveCamera;
    var orthoCamera:OrthographicCamera;
    var scene:Scene;
    var renderer:WebGLRenderer;

    var keysDown:Map<String, Bool> = new Map();
    var keysHit:Map<String, Bool> = new Map();

    var renderListeners:Array<Void->Void> = [];

    public function new() {
        element = Browser.document.createElement( 'div' );
        Browser.document.body.appendChild( element );

        scene = new Scene();

        camera = new PerspectiveCamera( 50, 1, 1, 1000 );
        scene.add( camera );
        orthoCamera = new OrthographicCamera(0, 0, 0, 0, 1, 1000);
        renderer = new WebGLRenderer( { antialias: true } );
        renderer.setPixelRatio( Browser.window.devicePixelRatio );
        Browser.window.addEventListener( 'resize', onWindowResize, false );
        onWindowResize();
        
        element.appendChild(renderer.domElement);

        Browser.document.addEventListener('keydown', onKeyDown);
        Browser.document.addEventListener('keyup', onKeyUp);

        animate();
    }

    function onWindowResize() {
        camera.aspect = width / height;
        camera.updateProjectionMatrix();

        var aspect = width / height;
        orthoCamera.left   = -100 * aspect / 2;
        orthoCamera.right  =  100 * aspect / 2;
        orthoCamera.top    =  100 / 2;
        orthoCamera.bottom = -100 / 2;
        orthoCamera.updateProjectionMatrix();

        renderer.setSize( width, height );
    }

    function animate() {
        untyped __js__('requestAnimationFrame({0})', animate);
        for (listener in renderListeners) listener();
        render();
        for (key in keysHit.keys()) keysHit.remove(key);
        
    }
    
    function render() {
        renderer.render( scene, false ? orthoCamera : camera );
    }

    function onKeyDown(event:KeyboardEvent) {
        event.preventDefault();
        var code = (cast event).code;
        if (!isKeyDown(code)) keysHit[code] = true;
        keysDown[code] = true;
    }

    function onKeyUp(event:KeyboardEvent) {
        event.preventDefault();
        keysDown.remove((cast event).code);
    }

    public function isKeyDown(code):Bool {
        return keysDown.get(code) == true;
    }

    public function isKeyHit(code):Bool {
        return keysHit.get(code) == true;
    }

    public function addRenderListener(func:Void->Void) {
        if (!renderListeners.has(func)) {
            renderListeners.push(func);
        }
    }

    public function drawObject(object:Object3D) {
        if (object.parent != scene) {
            scene.add(object);
        }
    }

    public function drawShape(shape:Shape) {
        // TODO
    }

    public function clear() {
        // TODO
    }

    public function cmd(s) {
        // TODO
    }

    public function setTint(fw:Color, fLow:Color, fHigh:Color) {
        // TODO
    }

    inline function get_width() {
        return Browser.window.innerWidth;
    }

    inline function get_height() {
        return Browser.window.innerHeight;
    }

    inline function get_bg():Color {
        return scene.background;
    }

    inline function set_bg(color:Color):Color {
        scene.background = color;
        return color;
    }

    public function print(message) {
        // TODO
        // trace(message);
    }
}