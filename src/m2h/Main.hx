package m2h;

import cpp.Lib;
import arguable.ArgParser;
import hxcpp.StaticStd; 
import hxcpp.StaticRegexp;


/**
* ...
* @author HM Jean
* 
*/

class Main {

	

	static function slufe_error(err:String){
		Fs.alert("ERROR",err);
		slufe_exit();
	}

	static function slufe_exit(){
		Sys.exit(0);

	}


	static function show_help(){

		Lib.println("\nm2h MarkdownDirectory [-out HtmlDirectory] [Options]\n");

		var helpTexts:Array<String>= [
		"-h\t\t\tshow this help",
		"-reset\t\treset template",
		"-title  'Site title'\tspecify site title",
		"-slogan 'Site slogan'\tspecify site slogan",
		"-out htmlDirectoryOut\tspecify directory out for html files",
		"-tpl template\tspecify template"
		];


		for(i in 0...helpTexts.length){
			Lib.println("  "+helpTexts[i]);
		}

		slufe_exit(); 
	}



	static function main() {



		ArgParser.delimeter = '-' ;
		var results = ArgParser.parse( Sys.args() );

		if( results.has('h') ) {show_help();}


		if(results.invalid.length>0){ Config.pathIn= results.invalid[0].name;}
		if( results.has('out') ) {Config.pathOut=results.get('out').value;}

		Config.load();

		if( results.has('reset') ) {Config.forceRebuild=true;}
		if (results.has('title')){Config.siteName=results.get('title').value;}
		if (results.has('slogan')){Config.siteSlogan=results.get('slogan').value;}
		if (results.has('tpl')){Config.template=results.get('template').value;}


		if( !Fs.exists(Config.pathIn)||!Fs.isdir(Config.pathIn) ){slufe_error("Markdown directory in not found");}

		if(Config.siteName==""){Config.siteName=haxe.io.Path.withoutDirectory(sys.FileSystem.fullPath(Config.pathIn));}

		buildhtml();


	}




	static function buildhtml(){

		m2h.html.Site.build();
		Config.save();


	}










}