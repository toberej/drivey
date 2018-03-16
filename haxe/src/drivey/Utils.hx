package drivey;

class Utils {
    public inline static function min(a:Float, b:Float) return (a < b) ? a : b;
    public inline static function max(a:Float, b:Float) return (b < a) ? a : b;
    public inline static function lerp(a:Float, b:Float, t:Float) return a*(1-t) + b*t;
    public inline static function abs(a:Float) return (a < 0) ? -a : a;
    public inline static function sign(a:Float) return (a < 0) ? -1 : 1;
    public inline static function m2w(p:drivey.Vector2) return new Vector3(p.x, 0, p.y);
    public inline static function w2m(p:Vector3) return new drivey.Vector2(p.x, p.z);
}
