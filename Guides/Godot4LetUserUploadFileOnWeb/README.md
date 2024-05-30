# Godot 4 Let User Upload File On Web

[Back](https://alexduggan1.github.io/Guides)

# How to Let User Upload File On Web In Godot 4

(This tutorial was made based on a [project](https://alexduggan1.github.io/SeniorProject/VectorRacetrack) I made using Godot 4.1.1)

## I. Understand JavaScriptBridge

Godot 4 has a useful class called JavaScriptBridge which is usable when exporting to web.

JavaScriptBridge has a function `JavaScriptBridge.eval()` which basically just lets you run JavaScript code from Godot.

You can write your code in the form of a multiline string passed in as the argument of the eval function. Then for the second argument, I just said that it is true, and it worked, but I don't actually know how much it matters.

This will look something like this:

    JavaScriptBridge.eval(
        """
        // your JavaScript code here
        """
    , true)

`JavaScriptBridge.eval()` can also return a value if the JavaScript code you write is a value of certain types. One of these types is a string which we will be using in this guide.


## II. Set Up Godot Scene

We will let the user upload their file upon pressing an import button, so let's create that now.

Add a Button node to your scene. As children of that button, add a ConfirmationDialog node and a Timer node.

Set up the nodes to your liking. For me, this means that the ConfirmationDialog node's initial position is set to Center of Screen with Mouse Pointer.

Make sure the Timer node is set up like this:
 
> One Shot: true  
> Autostart: false

Now connect your nodes to a script in the scene, whatever script you want. I typically do a script in the root node of the scene.

Connect the `pressed()` signal of the Button node, the `confirmed()` signal of the ConfirmationDialog node, and the `timeout()` signal of the Timer node to the script. We will use all of these later.


# III. Writing Code To Let The User Upload The File

I used the code from this StackOverflow answer as a base for uploading a file via JavaScript: https://stackoverflow.com/a/36198572


    document.getElementById('import').onclick = function() {
        var files = document.getElementById('selectFiles').files;
    console.log(files);
    if (files.length <= 0) {
        return false;
    }
    
    var fr = new FileReader();
    
    fr.onload = function(e) { 
    console.log(e);
        var result = JSON.parse(e.target.result);
        var formatted = JSON.stringify(result, null, 2);
            document.getElementById('result').value = formatted;
    }
    
    fr.readAsText(files.item(0));
    };

This is specifically designed for JSON files, so that is what we will be doing now, but it can most likely be adapted for other file types by editing the text within

    fr.onload = function(e){

    }

In order to make the code work, though, we need the HTML elements to exist, which means we need to create them.

## III. a. Bringing up the File Dialog

In Godot, go to the function connected to the `pressed()` signal of your Button node. We will start writing our code here.

We begin by calling `JavaScriptBridge.eval()` to 
1. define the result variable for later
2. create the HTML elements, 
3. define the onclick function from the StackOverflow answer (edited to set our result variable to the file contents), and
4. simulate the click on the `selectFiles` HTML element:

        JavaScriptBridge.eval("""
        // 1
        var uploadedFile = "result";

        // 2
        if(document.getElementById('selectFiles') == null){
            g = document.createElement('input');
            g.setAttribute("id", "selectFiles");
            g.setAttribute("type", "file");
            g.setAttribute("value", "Import");
            document.body.append(g)
            console.log(g.getAttribute("id"))
            console.log(g.getAttribute("type"))
            console.log(g.getAttribute("value"))
        }
        
        if(document.getElementById('import') == null){
            g = document.createElement('button');
            g.setAttribute("id", "import");
            g.textContent = "Import";
            document.body.append(g)
            console.log(g.getAttribute("id"))
        }

        // 3
        document.getElementById('import').onclick = function() {
            var files = document.getElementById('selectFiles').files;
        console.log(files);
        if (files.length <= 0) {
            return false;
        }

        var fr = new FileReader();

        fr.onload = function(e) { 
        console.log(e);
            var result = e.target.result;
                console.log(result);
                uploadedFile = result;
                console.log(uploadedFile)
        }

        fr.readAsText(files.item(0));
        };

        // 4
        document.getElementById('selectFiles').click();
        """, true)

After the `JavaScriptBridge.eval()`, show the ConfirmationDialog node (for example, this would look something like `$ImportButton/ConfirmationDialog.show()`).

### III. b. Setting the Result Value

Go to the function connected to the `confirmed()` signal of your ConfirmationDialog node.

Here, we will first use `JavaScriptBridge.eval()` to simulate the user clicking the `import` HTML element:

    JavaScriptBridge.eval("""
    document.getElementById('import').click();
	""", true)

Then, we will start the timer so that the JavaScript has time to run, which will look something like this:

`$ImportButton/Timer.start(1.5)`

I gave the JavaScript code 1.5 seconds to run, but you can change this number. I don't know exactly how long it needs, so I just went with 1.5 seconds to be safe.

### III. c. Getting the Contents of the File in Godot

Go to the function connected to the `timeout()` function of your Timer node.

Here, we will get the Contents of the File using `JavaScriptBridge.eval()` to get the string value of the file (assuming it is a JSON or another text file - I don't know yet how it would work with other file types).

    var content = JavaScriptBridge.eval("uploadedFile", true)

    # check if it worked
    print(content) 

    # convert the content to a json
    var json = JSON.parse_string(content) 

Now you can use the `json` variable like you would any other JSON in Godot, and the `content` variable like any string.

# IV. Conclusion

With that, you've imported a file into Godot on the web! You can test this feature using the remote debug function of Godot.

While uploading a file to a Godot Web build is quite difficult, downloading a file from the Godot Web build is significantly easier, and it is done by using `JavaScriptBridge.download_buffer()`.

I'm sure there is much more that you can do with the `JavaScriptBridge.eval()` function, although I haven't looked into it that much. It increases the capabilities of Godot 4 Web builds by a great deal.

If you're trying to build a Godot 4 project for Web, and it is giving you issues when you try to run it, try looking at this other [guide](https://alexduggan1.github.io/Guides/ExportGodotToHTML5) I made, it might help.