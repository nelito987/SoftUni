﻿namespace Animal.Models
{
    using System;

    public class Frog : Animal
    {
        public Frog(string name, int age, Gender gender)
            : base(name, age, gender)
        {
        }

        public override void ProduceSound()
        {
            Console.WriteLine("ribbet-ribbet");
        }
    }
}