//
// Program: 		Alfred Editor
//
// Description: 	This is a basic editor built using Node Webkit.
// 					This is more of a project to learn how to use
// 					Node Webkit, but I am finding that I really like
// 					the editor!
//
// Author: 			Richard Guay (raguay@customct.com)
// License: 		MIT
//

//
// Class: 			AlfredEditor
//
// Description: 	This class contains the information and functionality
//                  of the Alfred Editor. There should be only one instance
//                  of this class per editor.
//
// Class Variables:
// 					editor 		Keeps the Editor object
// 					menu 		keeps the menu object for the pop-up
// 					            menu.
// 					menuEdit 		Edit menu for the popup menu
// 					menuEditMain 	The Edit menu for the main menu
// 					menuFile 		File menu for the popup menu
// 					menuFileMain 	File menu for the main menu
// 					nativeMenuBar 	The menu bar for OSX Main menu
// 					hasWrite Access 	boolean for if the file is
// 					                    writable or not.
// 					AEDirectoroy 	Keeps the location of the
// 											Alfred editor files.
// 					AlfredBundleID 	The bundle for the Alfred Editor
// 					       			workflow.
// 					filesOpened 	Keeps a count of the number of
// 									opened files.
// 					origFileName 	Last file name opened.
// 					watch 			The node-watch library object.
// 					S 				The S library object.
// 					osenv 			The osenv library object.
// 					gui 			The Node Webkit gui library
// 									object.
// 					fs 				The fs library object.
// 					clipboard 		The clipboard library object.
// 					plist 			The plist library object.
// 					keyboard 		This keeps the type of keyboard mapping being used.
//
function AlfredEditor() {}

AlfredEditor.prototype.editor = null,
	AlfredEditor.prototype.menu = null,
	AlfredEditor.prototype.menuEdit = null,
	AlfredEditor.prototype.menuFile = null,
	AlfredEditor.prototype.menuEditMain = null,
	AlfredEditor.prototype.menuFileMain = null,
	AlfredEditor.prototype.nativeMenuBar = null,
	AlfredEditor.prototype.fileEntry = null,
	AlfredEditor.prototype.hasWriteAccess = false,
	AlfredEditor.prototype.AEDirectory = null,
	AlfredEditor.prototype.AlfredBundleID = null,
	AlfredEditor.prototype.filesOpened = 0,
	AlfredEditor.prototype.origFileName = "",
	AlfredEditor.prototype.theme = {},
	AlfredEditor.prototype.watch = require("node-watch"),
	AlfredEditor.prototype.osenv = require("osenv"),
	AlfredEditor.prototype.gui = require("nw.gui"),
	AlfredEditor.prototype.fs = require("fs"),
	AlfredEditor.prototype.plist = require("plist");
	AlfredEditor.prototype.keyboard = "vim";

var AE = new AlfredEditor();

AlfredEditor.prototype.clipboard = AE.gui.Clipboard.get();
AlfredEditor.prototype.win = AE.gui.Window.get();

//
// Function: 		handleDocumentChange
//
// Description: 	This function is called whenever the document
// 					is changed. This function will get the title set,
// 					remove the old document name from the window
// 					list, set the syntax highlighting based on the
// 					file extension, and update the status line.
//
// Inputs:
// 			title 	Title of the new document
//
AlfredEditor.prototype.handleDocumentChange = function(title) {
	//
	// Setup the default syntax highlighting mode.
	//
	var mode = "javascript";
	var modeName = "JavaScript";
	if (title) {
		//
		// If there is a title, then setup everything by that title.
		// The title will be the file name.
		//
		title = title.match(/[^/]+$/)[0];
		if (AE.origFileName.indexOf(title) == -1) {
			//
			// Remove whatever the old file was loaded and put in
			// the new file.
			//
			var windows = AE.getFileContentsAlfredData("windows.txt").split('\n');
			if (windows.length > 1) {
				var wins = Array();
				var once = true;
				for (var i = 0; i < windows.length; i++) {
					if ((windows[i].indexOf(AE.origFileName) == -1) && (once)) {
						//
						// It's not the old title. Add it back in.
						//
						wins[i] = windows[i];
					} else {
						//
						// Only remove the title once.
						//
						once = false;
					}
				}
				windows = wins;
			} else {
				windows = [];
			}
			windows.push(title);
			AE.origFileName = title;
			AE.putFileContentsAlfredData("windows.txt", windows.join('\n'));
		}
		document.getElementById("title").innerHTML = title;
		document.title = title;

		//
		// Set the syntax highlighting mode based on extension of the file.
		//
		if (title.match(/\.json$/)) {
			mode = {
				name: "javascript",
				json: true
			};
			modeName = "JavaScript (JSON)";
		} else if (title.match(/\.html$/)) {
			mode = "htmlmixed";
			modeName = "HTML";
		} else if (title.match(/\.css$/)) {
			mode = "css";
			modeName = "CSS";
		} else if (title.match(/\.md$/)) {
			mode = "markdown";
			modeName = "Markdown";
		} else if (title.match(/\.ft$/)) {
			mode = "markdown";
			modeName = "FoldingText";
		} else if (title.match(/\.markdown$/)) {
			mode = "markdown";
			modeName = "Markdown";
		} else if (title.match(/\.php$/)) {
			mode = "php";
			modeName = "PHP";
		} else if (title.match(/\.go$/)) {
			mode = "go";
			modeName = "go";
		} else if (title.match(/\.tcl$/)) {
			mode = "tcl";
			modeName = "FoldingText";
		} else if (title.match(/\.sass$/)) {
			mode = "sass";
			modeName = "SASS";
		} else if (title.match(/\.scss$/)) {
			mode = "sass";
			modeName = "SCSS";
		} else if (title.match(/\.scheme$/)) {
			mode = "scheme";
			modeName = "Scheme";
		} else if (title.match(/\.py$/)) {
			mode = "python";
			modeName = "Python";
		} else if (title.match(/\.c$/)) {
			mode = "c";
			modeName = "C, C++";
		} else if (title.match(/\.plist$/)) {
			mode = "xml";
			modeName = "PList";
		} else if (title.match(/\.xml$/)) {
			mode = "xml";
			modeName = "XML";
		} else if (title.match(/\.sh$/)) {
			mode = "shell";
			modeName = "Shell";
		} else if (title.match(/\.lua$/)) {
			mode = "lua";
			modeName = "Lua";
		} else if (title.match(/\.sql$/)) {
			mode = "sql";
			modeName = "SQL";
		} else if (title.match(/\.haml$/)) {
			mode = "haml";
			modeName = "Haml";
		} else if (title.match(/\.jade$/)) {
			mode = "jade";
			modeName = "Jade";
		} else if (title.match(/\.coffee$/)) {
			mode = "coffee";
			modeName = "CoffeeScript";
		} else if (title.match(/\.lisp$/)) {
			mode = "lisp";
			modeName = "Lisp";
		} else if (title.match(/\.rb$/)) {
			mode = "ruby";
			modeName = "Ruby";
		} else if (title.match(/\.erl$/)) {
			mode = "erlang";
			modeName = "Erlang";
		} else if (title.match(/\.scala$/)) {
			mode = "scala";
			modeName = "Scala";
		} else if (title.match(/\.clj$/)) {
          	mode = "clojure";
          	modeName = "Clojure";
        } else if (title.match(/\.d$/)) {
          	mode = "d";
          	modeName = "D";
        } else if (title.match(/\.dart$/)) {
          	mode = "dart";
          	modeName = "Dart";
        } else if (title.match(/\.dylan$/)) {
          	mode = "dylan";
          	modeName = "Dylan";
        } else if (title.match(/\.groovy$/)) {
          	mode = "groovy";
          	modeName = "Groovy";
        } else if (title.match(/\.hs$/)) {
          	mode = "haskell";
          	modeName = "Haskell";
        } else if (title.match(/\.yaml$/)) {
          	mode = "yaml";
          	modeName = "YAML";
        }
	} else {
		document.getElementById("title").innerHTML = "[no document loaded]";
	}

	//
	// Tell the Editor and setup the status bar with the syntx highlight mode.
	//
	AE.editor.setOption("mode", mode);
	document.getElementById("mode").innerHTML = modeName;
}

//
// Function: 		newFile
//
// Description: 	This function is called to set the global
// 					variables properly for a new empty file.
//
// Inputs:
//
AlfredEditor.prototype.newFile = function() {
	AE.fileEntry = null;
	AE.hasWriteAccess = false;
	AE.handleDocumentChange(null);
	AE.setFile(null, false);
}

//
// Function: 		setFile
//
// Description: 	This function sets a new file.
//
// Inputs:
// 				theFileEntry 	The name of the file
// 				isWritable 		boolean that defines writability
//
AlfredEditor.prototype.setFile = function(theFileEntry, isWritable) {
	AE.fileEntry = theFileEntry;
	AE.hasWriteAccess = isWritable;
}

//
// Function: 		readFileIntoEditor
//
// Description: 	This function handles the reading of the file
// 					contents into the editor. If reading fails, a
// 					log entry is created.
//
// Inputs:
// 				theFileEntry 	The path and file name
//
AlfredEditor.prototype.readFileIntoEditor = function(theFileEntry) {
	AE.fs.readFile(theFileEntry, function(err, data) {
		if (err) {
			console.log("Read failed: " + err);
			console.log(theFileEntry);
		}

		AE.handleDocumentChange(theFileEntry);
		AE.editor.setValue(String(data));
		AE.setFile(theFileEntry, true);
	});
}

//
// Function: 		writeEditorToFile
//
// Description: 	This function takes what is in the editor
// 					and writes it out to the file.
//
// Inputs:
// 			theFileEntry 	File to write the contents to.
//
AlfredEditor.prototype.writeEditorToFile = function(theFileEntry) {
	var str = AE.editor.getValue();
	AE.fs.writeFile(theFileEntry, str, function(err) {
		if (err) {
			console.log("Write failed: " + err);
			return;
		}
		console.log("Write completed.");
	});
}

//
// Function: 		openNewFile
//
// Description: 	This function should be used to open any new
// 					file. If it is the first file, then it is
// 					loaded into the editor directly. If not, the
// 					file is writen to the watched file for new file
// 					entry.
//
// Inputs:
// 				file 		The path to the file selected.
//
AlfredEditor.prototype.openNewFile = function(file) {
	if (AE.filesOpened === 0) {
		AE.readFileIntoEditor(file);
		AE.filesOpened++;
	} else {
		//
		// Open in a new window by writing the file to the command file.
		//
		AE.putFileContentsAlfredData("editfile.txt", file);
	}
}

//
// Function: 		initContextMenu
//
// Description: 	This function setups the right click menu used
// 					in the editor.
//
// Inputs:
//
AlfredEditor.prototype.initContextMenu = function() {
	AE.menu = new AE.gui.Menu();
	AE.menuFile = new AE.gui.Menu();
	AE.menuEdit = new AE.gui.Menu();
	AE.menuFile.append(new AE.gui.MenuItem({
		label: 'New',
		click: function() {
			AE.putFileContentsAlfredData("editfile.txt", "");
		}
	}));
	AE.menuFile.append(new AE.gui.MenuItem({
		label: 'Open',
		click: function() {
			$("#openFile").trigger("click");
		}
	}));
	AE.menuFile.append(new AE.gui.MenuItem({
		label: 'Save',
		click: function() {
			if (AE.fileEntry && AE.hasWriteAccess) {
				AE.writeEditorToFile(AE.fileEntry);
			} else {
				$("#saveFile").trigger("click");
			}
		}
	}));

	AE.menuEdit.append(new AE.gui.MenuItem({
		label: 'Copy',
		click: function() {
			AE.clipboard.set(AE.editor.getSelection());
		}
	}));
	AE.menuEdit.append(new AE.gui.MenuItem({
		label: 'Cut',
		click: function() {
			AE.clipboard.set(AE.editor.getSelection());
			AE.editor.replaceSelection('');
		}
	}));
	AE.menuEdit.append(new AE.gui.MenuItem({
		label: 'Paste',
		click: function() {
			AE.editor.replaceSelection(AE.clipboard.get());
		}
	}));

	AE.menuFileMain = new AE.gui.Menu();
	AE.menuEditMain = new AE.gui.Menu();
	AE.menuFileMain.append(new AE.gui.MenuItem({
		label: 'New',
		click: function() {
			AE.putFileContentsAlfredData("editfile.txt", "");
		}
	}));
	AE.menuFileMain.append(new AE.gui.MenuItem({
		label: 'Open',
		click: function() {
			$("#openFile").trigger("click");
		}
	}));
	AE.menuFileMain.append(new AE.gui.MenuItem({
		label: 'Save',
		click: function() {
			if (AE.fileEntry && AE.hasWriteAccess) {
				AE.writeEditorToFile(AE.fileEntry);
			} else {
				$("#saveFile").trigger("click");
			}
		}
	}));

	AE.menuEditMain.append(new AE.gui.MenuItem({
		label: 'Copy',
		click: function() {
			AE.clipboard.set(AE.editor.getSelection());
		}
	}));
	AE.menuEditMain.append(new AE.gui.MenuItem({
		label: 'Cut',
		click: function() {
			AE.clipboard.set(AE.editor.getSelection());
			AE.editor.replaceSelection('');
		}
	}));
	AE.menuEditMain.append(new AE.gui.MenuItem({
		label: 'Paste',
		click: function() {
			AE.editor.replaceSelection(AE.clipboard.get());
		}
	}));

	AE.menu.append(new AE.gui.MenuItem({
		label: 'File',
		submenu: AE.menuFile
	}));

	AE.menu.append(new AE.gui.MenuItem({
		label: 'Edit',
		submenu: AE.menuEdit
	}));

	//
	// Create the main Mac menu also.
	//
	AE.nativeMenuBar = new AE.gui.Menu({
		type: "menubar"
	});
	AE.nativeMenuBar.createMacBuiltin("Alfred Editor", {
		hideEdit: true,
		hideWindow: true
	});
	AE.nativeMenuBar.append(new AE.gui.MenuItem({
		label: 'File',
		submenu: AE.menuFileMain
	}));

	AE.nativeMenuBar.append(new AE.gui.MenuItem({
		label: 'Edit',
		submenu: AE.menuEditMain
	}));
	AE.win.menu = AE.nativeMenuBar;

	//
	// Add the menu to the contextmenu event listener.
	//
	document.getElementById("editor").addEventListener('contextmenu',
		function(ev) {
			ev.preventDefault();
			AE.menu.popup(ev.x, ev.y);
			return false;
		});
}


//
// Function: 		loadTheme
//
// Description: 	This function will load in the theme to be used. The json
//                  theme file is read and evaluated as a javascript function.
//                  This works, but is concidered risky.
//
// Inputs:
//
AlfredEditor.prototype.loadTheme = function() {
	var theme = AE.getFileContentsAlfredData("current.theme");
	AE.theme = eval("(function(){return " + AE.getFileContentsAlfredData("themes/" + theme + ".json") + ";})()");
	less.modifyVars(AE.theme.theme);
}

//
// Function: 		initPlugins
//
// Description: 	This will load in all plugins for the editor
// 					and initialize them.
//
// Inputs:
//
AlfredEditor.prototype.initPlugins = function() {

}

//
// Function: 		getAlfredBundleID
//
// Description: 	This function gets the bundle ID for the
// 					Alfred Editor. This is used to get to the
// 					directory of themes, plugins, and various
// 					utility files.
//
// Inputs:
//
AlfredEditor.prototype.getAlfredBundleID = function() {
	if (AE.AlfredBundleID === null) {
		var obj = AE.plist.parse(AE.fs.readFileSync('../info.plist', 'utf8'));
		AE.AlfredBundleID = obj.bundleid;
	}
	return (AE.AlfredBundleID);
}

//
// Function: 		getFileContentsAlfredData
//
// Description: 	This function will get the contents of a file
// 					in the Alfred Data area and return it's contents.
//
// Inputs:
// 					file 	File name to get
//
AlfredEditor.prototype.getFileContentsAlfredData = function(file) {
  var filen = AE.createFileNameAlfredData(file);
  if(AE.fs.existsSync(filen)) {
	return (AE.fs.readFileSync(filen, 'utf8').trim());
  } else {
    return("");
  }
}

//
// Function: 		createFileNameAlfredData
//
// Description: 	Ths function creates the full path to the file
// 					name given in the Alfred Data area.
//
// Inputs:
// 					file 	File name to get
//
AlfredEditor.prototype.createFileNameAlfredData = function(file) {
	return (AE.osenv.home() + "/Library/Application Support/Alfred 2/Workflow Data/" + AE.getAlfredBundleID() + "/" + file);
}

//
// Function: 		putFileContentsAlfredData
//
// Description: 	The function sets the given string into the specified file
//                  in the Alfred data area.
//
// Inputs:
//                  file        File to write
//                  contents    String to write into the file.
//
AlfredEditor.prototype.putFileContentsAlfredData = function(file, content) {
	AE.fs.writeFileSync(AE.createFileNameAlfredData(file), content);
}

//
// Function: 		loadAlfredFile
//
// Description: 	This function will load the file passed to it in Alfred. It also
//                  sets up the watcher function for new file to be loaded.
//
// Inputs:
//
AlfredEditor.prototype.loadAlfredFile = function() {
	if (AE.AEDirectory === null)
		AE.AEDirectory = process.cwd();
	var windows = AE.getFileContentsAlfredData("windows.txt");
	var filePath = AE.getFileContentsAlfredData("editfile.txt");
	if (filePath.length > 2) {
		var files = filePath.split('\t');
		var firstFile = true;
		if (files.length > 0) {
			for (var i = 0; i < files.length; i++) {
				if (files[i].trim().length > 1) {
					var file = files[i].trim();
					if (firstFile) {
						//
						// Add this file to the window list.
						//
						AE.putFileContentsAlfredData("windows.txt", windows + "\n" + file.match(/[^/]+$/)[0]);
						firstFile = false;
					}

					//
					// Open the file.
					//
					AE.openNewFile(file);
				}
			}
		}
		AE.origFileName = file.match(/[^/]+$/)[0];
	} else {
		AE.putFileContentsAlfredData("windows.txt", windows + "\n" + "new window");
		AE.origFileName = "new window";
	}

	//
	// If this is the first window, setup the watcher on the
	// editfile. If it changes, open a new window for that file.
	//
	if (windows.length < 2) {
		AE.watch(AE.createFileNameAlfredData("editfile.txt"), function() {
			var x = window.screenX + 10;
			var y = window.screenY + 10;
			window.open('main.html', '_blank', 'screenX=' + x + ',screenY=' + y);
		});
	}
}

//
// Function: 		CodeMirror.commands.save
// 
// Description: 	This is over-riding CodeMirrors default save function
// 					to a function that works for Alfred Editor.
// 					
// Inputs:
// 					cm 		CodeMirror object
// 					
CodeMirror.commands.save = function(cm) {
	if (AE.fileEntry && AE.hasWriteAccess) {
		AE.writeEditorToFile(AE.fileEntry);
	} else {
		$("#saveFile").trigger("click");
	}
}

//
// Function: 		onChosenFileToOpen
//
// Description: 	This function is called whenever a open
//  				file dialog is closed with a file selection.
//  				This is an automatically made function in
//  				Node Webkit that needs to be set by your app.
//
// Inputs:
// 				theFileEntry 		The path to the file selected.
//
var onChosenFileToOpen = function(theFileEntry) {
	AE.setFile(theFileEntry, true);
	AE.openNewFile(theFileEntry);
};

//
// Function: 		onChosenFileToSave
//
// Description: 	When a file is selected to save into, this
// 					function is called. It is originally set by
// 					Node Webkit.
//
// Inputs:
// 				theFileEntry 		The path to the file selected.
//
var onChosenFileToSave = function(theFileEntry) {
	AE.setFile(theFileEntry, true);
	AE.writeEditorToFile(theFileEntry);
};

//
// Function: 		onload
//
// Description: 	This function is setup by Node Webkit to be
// 					called when the page representing the application
// 					is loaded. The application overrides this by
// 					assigning it's own function.
//
// 					Here, we initialize everything needed for the
// 					Editor. It also loads the initial document for
// 					the editor, any plugins, and theme.
//
// Inputs:
//
onload = function() {
	//
	// Initialize the context menu.
	//
	AE.initContextMenu();

	//
	// Set the change function for saveFile and openFile.
	//
	$("#saveFile").change(function(evt) {
		onChosenFileToSave($(this).val());
	});
	$("#openFile").change(function(evt) {
		onChosenFileToOpen($(this).val());
	});

    //
    // Get and set the keyboard mapping. If the keyboard mapping
    // has not been set, then set it to vim keyboard.
    //
    AE.keyboard = AE.getFileContentsAlfredData("keyboard.txt");
    if(AE.keyboard == "") {
      AE.keyboard = 'vim';
    }
  
	//
	// Load up and configure Code Mirror editor.
	//
  	AE.editor = CodeMirror(
		document.getElementById("editor"), {
			mode: {
				name: "javascript",
				json: true
			},
			lineNumbers: true,
			theme: "aedefault",
			keyMap: AE.keyboard,
			matchBrackets: true,
			showCursorWhenSelecting: true,
			autoCloseBrackets: true,
			lineWrapping: false,
			matchTags: true,
			hint: false,
			highlightSelectionMatches: true,
			styleSelectedText: true,
			styleActiveLine: true,
			continueComments: true,
			foldGutter: true,
			autofocus: false,
			dragDrop: false,
			gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
			extraKeys: {
				"Cmd-S": function(cm) {
					//
					// Save the file.
					//
					if (AE.fileEntry && AE.hasWriteAccess) {
						AE.writeEditorToFile(AE.fileEntry);
					} else {
						$("#saveFile").trigger("click");
					}
				},
				"Cmd-C": function(cm) {
					//
					// Copy selection to clipboard.
					//
					AE.clipboard.set(AE.editor.getSelection());
				},
				"Cmd-X": function(cm) {
					//
					// Cut selection and place in clipboard.
					//
					AE.clipboard.set(AE.editor.getSelection());
					AE.editor.replaceSelection('');
				},
				"Cmd-V": function(cm) {
					//
					// Paste from clipboard.
					//
					AE.editor.replaceSelection(AE.clipboard.get());
				},
				"Ctrl-Q": function(cm) {
					//
					// Fold code under cursor.
					//
					AE.editor.foldCode(cm.getCursor());
				}
			}
		}
	);

	//
	// Setup on events listeners. The first one is listen for cursor
	// movements to update the position in the file in the status line.
	// Next, setup the listener for Vim mode changing to update the
	// status line. Lastly, run function on window closing to remove
	// the current file from the open file list.
	//
	AE.editor.on("cursorActivity", function(cm) {
		var cursor = cm.getCursor();
		document.getElementById("linenum").innerHTML = cursor.line + 1;
		document.getElementById("colnum").innerHTML = cursor.ch + 1;
	});

  
  	//
  	// If the Vim keyboard is not being used, set the edit mode to
  	// Insert. Otherwise, setup the editmode changing ability.
  	// 
  	if(AE.keyboard != "vim"){
      document.getElementById("editMode").innerHTML = "Insert";
    } else {
      	//
      	// On Vim mode change, change the status line's edit mode.
      	// 
		AE.editor.on("vim-mode-change", function(mode) {
			if (mode.mode == "normal") {
				document.getElementById("editMode").innerHTML = "Normal";
			} else if (mode.mode == "visual") {
				document.getElementById("editMode").innerHTML = "Visual";
			} else if (mode.mode == "insert") {
				document.getElementById("editMode").innerHTML = "Insert";
			}
		});      
    }

	AE.win.on("close", function() {
		var windows = AE.getFileContentsAlfredData("windows.txt").split('\n');
		if (windows.length > 1) {
			var wins = Array();
			var once = true;
			for (var i = 0; i < windows.length; i++) {
				if ((windows[i].indexOf(document.title) == -1) && (once)) {
					//
					// It's not the title. Add it back to the list.
					//
					wins[i] = windows[i];
				} else {
					//
					// Only remove the title once.
					//
					once = false;
				}
			}
			windows = wins;
		} else {
			windows = [];
		}
		//
		// Put the window list to the new list.
		//
		AE.putFileContentsAlfredData("windows.txt", windows.join('\n'));
		this.close(true);
	});

	//
	// Setup for having a new empty file loaded.
	//
	AE.newFile();
	onresize();

	//
	// Load any files given by Alfred and setup the file watcher.
	//
	AE.loadAlfredFile();

	//
	// Load all plugins.
	//
	AE.initPlugins();

	//
	// Load in the theme to be used.
	//
	AE.loadTheme();
	AE.watch(AE.createFileNameAlfredData("current.theme"), function() {
		//
		// Whenever the current.theme file changes, reload the theme.
		//
		AE.loadTheme();
	});

	//
	// Show the program and set the focus (focus does not work!).
	//
	AE.win.show();
	AE.win.focus();
};

//
// Function: 		onresize
//
// Description: Another Node Webkit function that is called everytime 
// the applicaton is resized. Get the new dimensions and resize the editor.
//
// Inputs:
//
onresize = function() {
	var container = document.getElementById('editor');
	var containerWidth = container.offsetWidth;
	var containerHeight = container.offsetHeight;

	var scrollerElement = AE.editor.getScrollerElement();
	scrollerElement.style.width = containerWidth + 'px';
	scrollerElement.style.height = containerHeight + 'px';

	AE.editor.refresh();
};
