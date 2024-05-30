# Vector Racetrack Docs

[Back](https://alexduggan1.github.io/SeniorProject/VectorRacetrack/)


# Menu Navigation

## Main Menu

On the left side is the list of tracks that you can race on. Select one of these to preview the track. On the right side there are buttons to create a new track or import a file from your computer.


## Track Preview

Press the `edit` button to open the level editor and edit the track.

Press the `race` button to open the race menu for the track.

Press the `remove` button on the bottom left to remove the track from the list of tracks that you can race on.

Press the `export` button on the bottom right to download the track to your computer.


## Race Menu

In the race menu, you can edit the list of players to participate in the race. You can add up to 20 players in a race. Each player can customize their name, color (of trail and car), and type of car.

Once all of the players are set up, press the `GO` button to start the race.


# Racing

Racing in this game is turn-based. On the right side, you can see the current round (turn), whose turn it is, and the list of players in the race.

During each player's turn, they can left click with the mouse to choose a location to move to. There are nine options for where to move, and they are depend on your current momentum from your previous move. The options are centered at your current position + your momentum vector.

You can cross over unraceable terrain during your move, but you can't end up there.


# Level Editor


# File Saving

## Exporting and Printing

You can only export solids that revolve about the y axis.


### History

The history queue shows all of the solids of revolution that have been generated during the current session, provided they were given a title when they were generated.

Double clicking on an item of the history queue will load the associated solid of revolution.

You can clear the history queue using the clear button at the bottom right of the queue.


### Export STL

Clicking the Export STL button will create a `.stl` file of the currently selected solid in the history queue. The name of the file will be the title of the solid.

This button works best for exporting solids generated with the disc method, and it usually works with solids generated with the washer method, too.
It is *not* recommended to use this button to export solids generated with the shell method, especially if they have any amount of concavity.


**Printing files exported with the Export STL button**

Begin by sending the `.stl` file onto the computer with the 3D printing software.

Once the `.stl` file is on the computer with the 3D printing software, import it into the 3D printing software.

If there is a warning symbol next to the name of the print (this will almost certainly occur while using PrusaSlicer/Slic3r), right click it to repair the `.stl` file before printing it.

Since the `.stl` files are generated sideways, you will need to rotate them properly before printing. They are also generated with millimeter units, so resizing may be necessary.

If slicing your `.stl` file fills in a hole that it shouldn't, use the Export Advanced button and follow those instructions instead. This is most likely due to your solid having concavity.

Press slice and begin the print.


### Export Advanced

Clicking the Export Advanced button will create a `.zip` archive of the currently selected solid in the history queue. The name of the archive will be the title of the solid. Within the archive, there will be a `.stl` file for each of the individual cylinders used to generate the solid.

This button is designed to export solids generated with the shell method, especially if they have any amount of concavity. It is most likely not necessary to use the button to export solids generated with the shell or washer method, but it would probably work.


**Printing files exported with the Export Advanced button**

Begin by sending the `.zip` archive to the computer with the 3D printing software.

Once the `.zip` archive is on the computer with the 3D printing software, extract the contents using 7zip. For some reason, the regular file explorer refuses to interact with these archives properly.

Open blender. Click `file > import > STL (.stl)`. Select all of the files that were extracted from the .zip archive and press Import STL.

The files will be imported sideways. To fix this, press `r`, then `x`, and rotate all of the files at once until they are oriented correctly. If the files get deselected, you can reselected all of them by pressing `a`. **Note:** blender must be in Object Mode for this to work. If you aren't in Object Mode, try pressing tab (it swaps between Object Mode and Edit Mode).

Press `n` to open the menu on the side of main viewer, and click on the panel labeled 3D-Print. Open the export section.

Select the destination location for your new `.stl` file, make sure the format is STL, then click Export. You can now close blender.


Import your new `.stl` file into the 3D printing software.

If there is a warning symbol next to the name of the print (this will almost certainly occur while using PrusaSlicer/Slic3r), right click it to repair the `.stl` file before printing it.

Since the `.stl` files are generated with millimeter units, resizing may be necessary.

Press slice and begin the print.



# Known Limitations

This project can't be run on macOS, due to incompatibility between Godot 4 and macOS