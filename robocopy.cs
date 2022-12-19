using Microsoft.Deployment.WindowsInstaller.Package;

namespace RoboCopyExample
{
    class Program
    {
        static void Main(string[] args)
        {
            // Set the source and destination folders
            string sourceFolder = "C:\\Source";
            string destinationFolder = "C:\\Destination";

            // Create a new instance of the RoboCopy class
            RoboCopy robocopy = new RoboCopy();

            // Set the source and destination folders
            robocopy.Source = sourceFolder;
            robocopy.Destination = destinationFolder;

            // Set the flags for the copy operation
            robocopy.CopySubdirectories = true;
            robocopy.IncludeEmptyDirectories = true;

            // Run the copy operation
            robocopy.Execute();
        }
    }
}
