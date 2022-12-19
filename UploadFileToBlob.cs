/*
  Need to install Nuget packagae Azure.Storage.Blobs
  update local variable in local.settings.json
*/

using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Azure.Storage.Blobs;

namespace MyFunctionApp
{
    public static class UploadFileToBlob
    {
        [FunctionName("UploadFileToBlob")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            try
            {
                // Get the file from the request body
                var file = req.Form.Files[0];

                // Read the file content
                byte[] fileContent;
                using (var memoryStream = new MemoryStream())
                {
                    file.CopyTo(memoryStream);
                    fileContent = memoryStream.ToArray();
                }

                // Connect to Azure Storage
                string connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
                BlobServiceClient blobServiceClient = new BlobServiceClient(connectionString);

                // Get a reference to the container
                string containerName = "file-upload";
                BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);

                // Create the container if it doesn't exist
                await containerClient.CreateIfNotExistsAsync();

                // Get a reference to the blob
                string fileName = file.FileName;
                BlobClient blobClient = containerClient.GetBlobClient(fileName);

                // Upload the file to the blob
                using (MemoryStream stream = new MemoryStream(fileContent))
                {
                    await blobClient.UploadAsync(stream);
                }

                return new OkObjectResult($"File {fileName} uploaded to container {containerName}");
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error uploading file to blob storage");
                return new BadRequestObjectResult("Error uploading file to blob storage: " + ex.Message);
            }
        }
    }
}
