# Export Godot to HTML5

[Back](https://alexduggan1.github.io/Guides)

## How to Export Godot to HTML5

### I. Export the Project

1. Go to the Godot Project you want to export.
2. Make a `build/web` folder in the project.
3. Go to `Project -> Export`.
4. Press `Add -> Web`.
5. Set the Export Path to be `build/web/index.html`.
6. Paste the following line into Head Include:

`<script src="coi-serviceworker.js"></script>`

7. Set the Canvas Resize Policy to Adaptive (this isn't required for it to run, but it's nice to have the canvas fill up the whole screen when it runs).
8. Press Export Project.


### II. Host the Project

9. Copy the folder containing the `project.godot` (your project folder) and paste it into the repository that's hosting it.
10. Go to the repository, you will be working from there from here on out.
11. Add `coi-serviceworker.js` and `enable-threads.js` in the `build/web` folder of the project.
12. Push your changes.
13. You should be done now. Go to where your project is hosted and try it out.


`coi-serviceworker.js` can be found at https://github.com/gzuidhof/coi-serviceworker/blob/master/coi-serviceworker.js
`enable-threads.js` can be found at https://github.com/josephrocca/clip-image-sorter/blob/main/enable-threads.js