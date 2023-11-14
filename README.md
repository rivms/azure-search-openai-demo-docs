# Usage
These scripts are derived from https://github.com/Azure-Samples/azure-search-openai-demo

Usage:
- Copy PDF files to be indexded into the data folder
- Copy the ```.env.template``` to a new file named ```.env```
- Fill in the various values for the keys listed in the ```.env``` file 
- Ensure the python is installed, if using Conda switch to the appropriate environment (the script installs packages using the Python interpreter on the path)
- From the root folder of the repository run
```
.\scripts\prepdocs2.ps1
```
- The PDF files will be uploaded to the blob storage account and document chunks added to the Azure Cognitive Search index together with embeddings

## Note
This script is sets a few defaults in ```prepdocs2.ps1```
- Only ```.pdf``` files are scanned from the ```data``` folder
- A local pdf parser is used rather than Form Recognizer, remove the line ```"--localpdfparser " + ``` from ```prepdocs2.ps1``` to use Form Recognizer
- The scripts are provided as-is and are intended for development use