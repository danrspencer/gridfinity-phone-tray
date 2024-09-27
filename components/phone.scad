
// Module to create 2D iPhone shape
module phone_2d_shape(length, width, curve, smoothness) {
    hull() {
        for (x = [-1, 1], y = [-1, 1]) {
            translate([x * (length/2 - curve), y * (width/2 - curve)])
            superellipse(curve, curve, smoothness);
        }
    }
}

// Module to create superellipse shape
module superellipse(a, b, n) {
    points = [for (t = [0:5:359]) [
        a * pow(abs(cos(t)), 2/n) * sign(cos(t)),
        b * pow(abs(sin(t)), 2/n) * sign(sin(t))
    ]];
    polygon(points);
}