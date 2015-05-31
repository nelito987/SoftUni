﻿namespace Point
{
    using System;

    public class Point3D
    {
        private static readonly Point3D StartingPointConst = new Point3D(0, 0, 0);

        public Point3D(double x, double y, double z)
        {
            this.X = x;
            this.Y = y;
            this.Z = z;
        }

        public static Point3D StartingPoint
        {
            get { return StartingPointConst; }
        }

        public double X { get; set; }

        public double Y { get; set; }

        public double Z { get; set; }
     
        public override string ToString()
        {
            string result = string.Format("Point Coordinates:\nX: {0}\nY: {1}\nZ: {2}\n", this.X, this.Y, this.Z);

            return result;
        }
    }
}