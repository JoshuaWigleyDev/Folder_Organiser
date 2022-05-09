# Folder_Organiser
A PowerShell script that creates a folder structure of (..\Processed\YYYY\MM\DD) based on the creation date time of the files within a source directory.

**This script takes up to 4 arguments:**
1. Log Directory (UNC or Drive): User specified location where log file is stored and saves a transcript of the PS session. 
2. Source Directory (UNC or Drive): User specified location where the files that need organising are located
3. Destination Directory (UNC or Drive): The location where the user wants the files organised and moved too
      - If files of the same name already exist in the destination directory, then the script will append a datetime stamp on the source filename to prevent the destination document being overwritten.
4. Extension Type (Optional): User specified extension to ONLY move certain file types. If left blank, all files and folder from the source directory are moved.

**Demonstration**

1. Find the folder you wish to organise:

      ![image](https://user-images.githubusercontent.com/74862092/167418060-4cd83c1f-cc5f-4e70-97b4-2590540ff1b7.png)
  
2. Open up a PowerShell Session and call the script

3. Specify where you would like to save the log file:

      ![image](https://user-images.githubusercontent.com/74862092/167416735-3766881b-7b11-4eb5-bd5e-a0f1c7ac6235.png)

4. Specify the SOURCE location of your files:

      ![image](https://user-images.githubusercontent.com/74862092/167426376-b85c15a7-6d19-4a77-91b0-f0b82d0eab34.png)

5. Specify the DESTINATION location of your files:

      ![image](https://user-images.githubusercontent.com/74862092/167417044-86891c9a-a2f9-4384-b99e-5f2d7b01bbcd.png)

6. Specify an extension (If you don't supply an extension, you will be prompted to confirm this is correct)

      ![image](https://user-images.githubusercontent.com/74862092/167417204-98c8337b-ab66-48c8-a001-e73457855550.png)

7. The process will now begin to organise the folder

      ![image](https://user-images.githubusercontent.com/74862092/167417683-e5ed6dfe-b5b4-470a-a3eb-dcac5e40d2b5.png)

8. Files have now been organised to the destination folder

      ![image](https://user-images.githubusercontent.com/74862092/167417957-56c782f1-d5c1-486c-86db-62544fe967db.png)


