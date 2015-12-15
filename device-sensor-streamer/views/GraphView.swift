import UIKit

@IBDesignable class GraphView: UIView {

    private var data = [[String: Float]]();
    func push(x: Float, y: Float, z: Float ) {
        data.append(["x":x, "y":y, "z":z]);

        while data.count > Int(self.bounds.width) {
            data.removeFirst();
        }

        self.setNeedsDisplay();
    }

    @IBInspectable var xColor: UIColor = UIColor.redColor()
    @IBInspectable var yColor: UIColor = UIColor.greenColor()
    @IBInspectable var zColor: UIColor = UIColor.blueColor()
    @IBInspectable var max = Float(3.0);
    @IBInspectable var min = Float(-3.0);

    override func drawRect(rect: CGRect) {

        let ctx = UIGraphicsGetCurrentContext()
        let translate = CGAffineTransformMakeTranslation(0, self.bounds.height / 2);
        let scale = CGAffineTransformMakeScale(1, self.bounds.height / CGFloat(max - min));

        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, 0.5);
        CGContextConcatCTM(ctx, translate);

        var i = 0;
        var xPrev = CGPoint(x: 0, y: 0);
        var yPrev = xPrev;
        var zPrev = xPrev;
        for datum in data {
            let x = CGPointApplyAffineTransform(CGPoint(x: CGFloat(i), y: CGFloat(datum["x"]!)), scale);
            let y = CGPointApplyAffineTransform(CGPoint(x: CGFloat(i), y: CGFloat(datum["y"]!)), scale);
            let z = CGPointApplyAffineTransform(CGPoint(x: CGFloat(i), y: CGFloat(datum["z"]!)), scale);


            CGContextSetStrokeColorWithColor(ctx, xColor.CGColor);
            CGContextSetFillColorWithColor(ctx, xColor.CGColor);
            CGContextMoveToPoint(ctx, xPrev.x, xPrev.y);
            CGContextAddLineToPoint(ctx, x.x, x.y);
            CGContextStrokePath(ctx);

            CGContextSetStrokeColorWithColor(ctx, yColor.CGColor);
            CGContextSetFillColorWithColor(ctx, yColor.CGColor);
            CGContextMoveToPoint(ctx, yPrev.x, yPrev.y);
            CGContextAddLineToPoint(ctx, y.x, y.y);
            CGContextStrokePath(ctx);

            CGContextSetStrokeColorWithColor(ctx, zColor.CGColor);
            CGContextSetFillColorWithColor(ctx, zColor.CGColor);
            CGContextMoveToPoint(ctx, zPrev.x, zPrev.y);
            CGContextAddLineToPoint(ctx, z.x, z.y);
            CGContextStrokePath(ctx);


            i++;
            xPrev = x;
            yPrev = y;
            zPrev = z;
        }

        CGContextRestoreGState(ctx);

    }
}

