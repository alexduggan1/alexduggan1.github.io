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

In the race menu, you can see your 

# Racing

Once on the racetrack


# Level Editor


# File Saving

## Rendering Solids of Revolution

### Methods

This program supports three methods for volumes of revolution: Disc, Washer, and Shell.


### Axis of Revolution

Choose to rotate around the x axis or the y axis. **Note:** only solids of revolution that revolve about the y axis can be exported.


### Volume

The volume box will show the current estimate of the volume of revolution, based on the volumes of the rendered cylinders.
The more cylinders (higher resolution) used to render the solid of revolution, the better the estimation of the volume of revolution is.


### Color

The color of the rendered solid of revolution can be freely changed. **Note:** that this has no effect on exporting or the color of any 3D prints.


### Title

The title bar is the name of the solid of revolution.
If it is not left empty, the solid of revolution is added to the history queue on the right.


### View Controls

Use `wasd` to rotate the camera around the generated solid.

Use `c` to pull the camera further away and `f` to push it closer.

Use the arrow keys to move the camera up, down, left, or right. This also moves the point the camera rotates around, so I don't necessarily recommend it.

Press `r` to reset the camera to its default settings.

The program tries its best to show the entire solid in frame when you press generate, but it doesn't always succeed.


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