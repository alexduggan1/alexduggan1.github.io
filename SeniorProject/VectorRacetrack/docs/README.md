# Vector Racetrack Docs

[Back](https://alexduggan1.github.io/SeniorProject/VectorRacetrack/)


# Menu Navigation

## Main Menu

On the left side is the list of tracks that you can race on. Click on one of these to preview the track. On the right side, there are buttons to create a new track or import a file from your computer.


## Track Preview

Press the `edit` button to open the level editor and edit the track.

Press the `race` button to open the race menu for the track.

Press the `remove` button on the bottom left to remove the track from the user directory.

Press the `export` button on the bottom right to download the track from the user directory to your computer.


## Race Menu

In the race menu, you can edit the list of players to participate in the race. You can add up to 20 players in a race. Each player can customize their name, color (of trail and car), and type of car.

Once all of the players are set up, press the `GO` button to start the race.


# Racing

Racing in this game is turn-based. On the right side, you can see the current round (turn), whose turn it is, and the list of player trackers in the race.

During each player's turn, they can left click with the mouse to choose a location to move to. There are nine options for where to move, and they are depend on your current momentum from your previous move. The options are centered at your current position + your momentum vector. Alternatively, you can undo your last move. Once a location is chosen or a move undone, your turn ends.

You can cross over unraceable terrain during your move, but 
you can't end up there.

**Note:** If none of your location options are on raceable terrain, you should press the `undo move` button.

If you end your turn in a blue zone, you finish the race. The amount of turns that it took each player to finish the race are listed on their player tracker.


# Level Editor

When editing a track, you can edit the name, width, height, walls, and starting positions.

## Name, Width, Height

To edit the name, select the text box with the name of the track.

To edit the width or height, edit the boxes labeled `width` and `height`. 

**Note:** If you resize the track while adding a wall, the wall placement will be cancelled.

**Note:** You will be prevented from decreasing the width or height if it would mean a wall point or starting point is outside of the bounds of the track.


## Wall Placement

To start adding a wall, press the `add wall` button, then `left click` on the grid where you want to start the wall.

While adding the wall, `left click` to add a point. You are not allowed to cross over other segments of the wall when placing the point. To complete placing the wall, click again on the first point of the wall.

**Note:** To cancel placing a wall in the middle, press `escape`.

On the right side, there will be a list of walls. Here, you can choose whether the zone within the wall is raceable, whether it is an ending zone, and the layer of the wall. Walls with a higher layer are prioritized when deciding whether a point is able to be raced on. You can also delete the wall.

If there is a wall segment, and at least one direction immediately around it is not able to be raced on, then that wall segment is not allowed to be raced on. If a racer lands on a point with a wall segment, and it is completely surrounded by raceable track, then it is a valid point for the racer to move to.


## Starting Points

Starting points are marked with a red dot on the grid. To add or remove a starting point, `right click` where you want to add or remove the starting point.


## Save File

To save the track file, press the `save track and close` button. If you don't want to save the track file, press the `close` button.

By default, the name of the saved file will be the name of the track.

Track files are saved in the user directory, which is stored in your browser.

The user directory is searched in for the list of tracks in the main menu. You can export a saved track from there.


# Track Files

Each track is saved in its own `.json` file.

The structure is as following:

    {
        "track_name":<string>, // name of the track
        "track_width":<int>, // width of the track
        "track_height":<int>, // height of the track
        "walls":[
            {
                "points":[
                    {
                        "x":<int>, // x coordinate of the point
                        "y":<int> // y coordinate of the point
                    }, // each point contains an x and y coordinate pair
                    {
                        "x":<int>,
                        "y":<int>
                    } // a wall can have many points
                ], // list of points on the wall
                "raceable":<bool>, // whether or not the wall can be raced on
                "layer":<int>, // the layer of the wall
                "endzone":<bool>
            }, // each wall contains a list of points, whether it is raceable or not, its layer, and whether it is an endzone or not
            {
                "points":[
                    {
                        "x":<int>,
                        "y":<int>
                    },
                    {
                        "x":<int>,
                        "y":<int>
                    },
                    {
                        "x":<int>,
                        "y":<int>
                    }
                ],
                "raceable":<bool>,
                "layer":<int>,
                "endzone":<bool>
            } // there can be many walls
        ], // list of walls in the track
        "starting_points":[
            {
                "x":<int>, // x coordinate of the starting point
                "y":<int> // y coordinate of the starting point
            }, // each starting point contains an x and a y coordinate pair
            {
                "x":<int>,
                "y":<int>
            } // there can be many starting points
        ] // list of starting points in the track
    }


# Known Limitations

This project can't be run on macOS on web, due to incompatibility between Godot 4 and macOS on web.

It has been tested and works on Windows (Firefox) and Chromebook (Google Chrome).