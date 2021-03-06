﻿namespace GithubIssueTracker.Interfaces
{
    using System.Collections.Generic;

    public interface ICommand
    {
        string Name { get; }

        IDictionary<string, string> Parameters { get; } 
    }
}