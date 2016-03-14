# RubyToolsDatavyu

Useful Ruby scripts for the video coding software [Datavyu](http://datavyu.org/).

**Main developer:** Julius Verrel (contributions indicated below and in scripts)

## General things

The tools need to be adjusted. 

Scripts that use tools provided here should define a global variable $rubyToolsDatavyuPath containing the path to these tools at the beginning, e.g., 

		$rubyToolsDatavyuPath = 'D:\Work\prog\Ruby\RubyToolsDatavyu'

Scripts can be called/included by the command (e.g.)

		load ($rubyToolsDatavyuPath + 'scriptName.rb')

Modules can be loaded by 

		require ($rubyToolsDatavyuPath + 'moduleName.rb')

See examples for more details.

## Tools

### Debugging 

**Purpose:** Debugging ruby scripts executed from Datavyu

**Developer:** Julius Verrel

**Main scripts:**

**Sample usage:**

#### How to debug your code

#### How to explore Datavyu's data structure 


### Auxiliary functions 

**Purpose:** Module with auxiliary functions: methods for accessing information about project, spreadsheet, media, ...
 

**Developer:** Julius Verrel

**Module name:**

**Sample usage:** 

#### Operating and file system

* access environment variables
* determine operating system

#### Project 

#### Spreadsheet

* selected column
* selected cell
* making columns/variables visible
* making columns/variables invisible
* 

#### Media


### Requesting user input



### Extracting video clips 

**Purpose:** Extracting video clips defined by cells in a given spreadsheet column (variable)

**Developers:** Laura Mandt, Julius Verrel, Robin Nehls

**Main script:**

**Sample usage:**


  
