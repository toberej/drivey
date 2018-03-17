import js.Browser;
import js.html.Element;

import js.three.*;
import Math;

class Playground
{
    var container:Element;
    var camera:PerspectiveCamera;
    var scene:Scene;
    var renderer:WebGLRenderer;
    var group:Group;
    var targetRotation:Float;
    var targetRotationOnMouseDown:Float;
    var mouseX:Float;
    var mouseXOnMouseDown:Float;
    var windowHalfX:Float;

    public static function run()
    {
        new Playground();
    }

    function new() {
        targetRotation = 0;
        targetRotationOnMouseDown = 0;
        mouseX = 0;
        mouseXOnMouseDown = 0;
        windowHalfX = Browser.window.innerWidth / 2;
        
        init();
        animate();
    }

    function init() {
        container = Browser.document.createElement( 'div' );
        Browser.document.body.appendChild( container );
        scene = new Scene();
        scene.background = new Color( 0xf0f0f0 );
        camera = new PerspectiveCamera( 50, Browser.window.innerWidth / Browser.window.innerHeight, 1, 1000 );
        camera.position.set( 0, 0, 500 );
        scene.add( camera );
        group = new Group();
        group.rotation.x = Math.PI * 0.55;
        scene.add( group );

        function addLineShape( shape:Path, color, x, y) {
            // lines
            shape.autoClose = true;
            var points:Array<Vector> = [for (point in shape.getPoints()) point];
            var spacedPoints:Array<Vector> = [for (point in shape.getSpacedPoints( 50 )) point];
            var geometryPoints:BufferGeometry = new BufferGeometry().setFromPoints( points );
            var geometrySpacedPoints = new BufferGeometry().setFromPoints( spacedPoints );
            // solid line
            var line = new Line( geometryPoints, new LineBasicMaterial( { color: color, linewidth: 3 } ) );
            line.position.set( x, y, 25 );
            group.add( line );
            // line from equidistance sampled points
            var line = new Line( geometrySpacedPoints, new LineBasicMaterial( { color: color, linewidth: 3 } ) );
            line.position.set( x, y, 75 );
            group.add( line );
            // vertices from real points
            var particles = new Points( geometryPoints, new PointsMaterial( { color: color, size: 4 } ) );
            particles.position.set( x, y, 25 );
            group.add( particles );
            // equidistance sampled points
            var particles = new Points( geometrySpacedPoints, new PointsMaterial( { color: color, size: 4 } ) );
            particles.position.set( x, y, 75 );
            group.add( particles );
        }

        function addShape( shape:Shape, extrudeSettings, color, x, y) {
            // flat shape
            var geometry = new ShapeBufferGeometry( shape );
            var mesh = new Mesh( geometry, new MeshBasicMaterial( { wireframe: false, color: color } ) );
            mesh.position.set( x, y, -75 );
            group.add( mesh );
            // extruded shape
            var geometry = new ExtrudeGeometry( shape, extrudeSettings );
            var mesh = new Mesh( geometry, new MeshBasicMaterial( { wireframe: false, color: color } ) );
            mesh.position.set( x, y, -25 );
            group.add( mesh );
            addLineShape( shape, color, x, y);
            if (shape.holes != null) {
                for (hole in shape.holes) {
                    addLineShape( hole, color, x, y);
                }
            }
        }
        
        // California
        var californiaPts = [];
        californiaPts.push( new Vector2( 610, 320 ) );
        californiaPts.push( new Vector2( 450, 300 ) );
        californiaPts.push( new Vector2( 392, 392 ) );
        californiaPts.push( new Vector2( 266, 438 ) );
        californiaPts.push( new Vector2( 190, 570 ) );
        californiaPts.push( new Vector2( 190, 600 ) );
        californiaPts.push( new Vector2( 160, 620 ) );
        californiaPts.push( new Vector2( 160, 650 ) );
        californiaPts.push( new Vector2( 180, 640 ) );
        californiaPts.push( new Vector2( 165, 680 ) );
        californiaPts.push( new Vector2( 150, 670 ) );
        californiaPts.push( new Vector2(  90, 737 ) );
        californiaPts.push( new Vector2(  80, 795 ) );
        californiaPts.push( new Vector2(  50, 835 ) );
        californiaPts.push( new Vector2(  64, 870 ) );
        californiaPts.push( new Vector2(  60, 945 ) );
        californiaPts.push( new Vector2( 300, 945 ) );
        californiaPts.push( new Vector2( 300, 743 ) );
        californiaPts.push( new Vector2( 600, 473 ) );
        californiaPts.push( new Vector2( 626, 425 ) );
        californiaPts.push( new Vector2( 600, 370 ) );
        californiaPts.push( new Vector2( 610, 320 ) );
        for(point in californiaPts) point.multiplyScalar( 0.25 );
        var californiaShape = new Shape( californiaPts );
        var x = 0, y = 0;
        // Square
        var sqLength = 80;
        var squareShape:Shape = new Shape();
        squareShape.moveTo( 0, 0 );
        squareShape.lineTo( 0, sqLength );
        squareShape.lineTo( sqLength, sqLength );
        squareShape.lineTo( sqLength, 0 );
        squareShape.lineTo( 0, 0 );
        // Rounded rectangle
        var roundedRectShape:Shape = new Shape();
        ( function roundedRect( ctx, x, y, width, height, radius ) {
            ctx.moveTo( x, y + radius );
            ctx.lineTo( x, y + height - radius );
            ctx.quadraticCurveTo( x, y + height, x + radius, y + height );
            ctx.lineTo( x + width - radius, y + height );
            ctx.quadraticCurveTo( x + width, y + height, x + width, y + height - radius );
            ctx.lineTo( x + width, y + radius );
            ctx.quadraticCurveTo( x + width, y, x + width - radius, y );
            ctx.lineTo( x + radius, y );
            ctx.quadraticCurveTo( x, y, x, y + radius );
        } )( roundedRectShape, 0, 0, 50, 50, 20 );
        // Track
        var trackShape:Shape = new Shape();
        trackShape.moveTo( 40, 40 );
        trackShape.lineTo( 40, 160 );
        trackShape.absarc( 60, 160, 20, Math.PI, 0, true );
        trackShape.lineTo( 80, 40 );
        trackShape.absarc( 60, 40, 20, 2 * Math.PI, Math.PI, true );
        // Arc circle
        var arcShape:Shape = new Shape();
        arcShape.moveTo( 50, 10 );
        arcShape.absarc( 10, 10, 40, 0, Math.PI * 2, false );
        var holePath = new Path();
        holePath.moveTo( 20, 10 );
        holePath.absarc( 10, 10, 30, 0, Math.PI * 2, true );
        arcShape.holes.push( holePath );
        var extrudeSettings = { amount: 8, bevelEnabled: false, curveSegments: 12 };
        // addShape( shape, color, x, y);
        addShape( californiaShape,  extrudeSettings, 0xf08000, -120,   0);
        addShape( trackShape,       extrudeSettings, 0x008000,  120,   0);
        addShape( roundedRectShape, extrudeSettings, 0x008080,  -80,   0);
        addShape( squareShape,      extrudeSettings, 0x0040f0,    0, 200);
        addShape( arcShape,         extrudeSettings, 0x804000,   80,   0);
        
        renderer = new WebGLRenderer( { antialias: true } );
        renderer.setPixelRatio( Browser.window.devicePixelRatio );
        renderer.setSize( Browser.window.innerWidth, Browser.window.innerHeight );
        container.appendChild( renderer.domElement );
        
        Browser.window.addEventListener( 'resize', onWindowResize, false );
    }

    function onWindowResize() {
        camera.aspect = Browser.window.innerWidth / Browser.window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize( Browser.window.innerWidth, Browser.window.innerHeight );
    }

    function animate() {
        render();
        untyped __js__('requestAnimationFrame({0})', animate);
    }
    
    function render() {
        group.rotation.z += Math.PI * 0.005;
        renderer.render( scene, camera );
    }
}
