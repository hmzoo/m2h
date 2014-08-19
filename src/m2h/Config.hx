package m2h;

import yaml.Yaml;
import yaml.Parser;
import yaml.Renderer;
import yaml.util.ObjectMap;
import haxe.io.Bytes;

class Config {
	

	public static var siteName:String="";
	public static var siteSlogan:String="";

	public static var pathIn:String="documents";
	public static var pathOut:String="public_html";
	public static var template:String="default";

	public static var stylecss:String;
	public static var markdowncss:String;
	public static var templatemustache:String;

	public static var favicon_ico:Bytes;
	public static var favicon_png:Bytes;

	public static var forceRebuild:Bool=false;
	public static var format:String="html";

	public static var updated:String;
	public static var informations:String="";


	


	public static function load(){

		if(Fs.exists( pathOut+"/_config.yaml")){
			var data:AnyObjectMap = Yaml.read(pathOut+"/_config.yaml");
			if(data.exists('site_name')){siteName=data.get('site_name');}
			if(data.exists('site_slogan')){siteSlogan=data.get('site_slogan');}
			if(data.exists('template')){template=data.get('template');}
			if(data.exists('updated')){updated=data.get('updated');}
			if(data.exists('informations')){informations=data.get('informations');}



		}
		loadTemplate();

	}

	public  static function save(){

		var data:Dynamic={
			site_name:siteName,
			site_slogan:siteSlogan,
			updated:Date.now().getTime(),
			informations:informations,
			template:template
		};



		Yaml.write(pathOut+"/_config.yaml",data);

	}

	static function loadTemplate(){




		switch(template){




			default:
			stylecss=haxe.Resource.getString("default_style_css");
			markdowncss=haxe.Resource.getString("default_markdown_css");
			templatemustache=haxe.Resource.getString("default_template_mustache");
			favicon_ico=haxe.Resource.getBytes("favicon_ico");
			favicon_png=haxe.Resource.getBytes("favicon_png");


		}

		if(!forceRebuild){
		if(Fs.exists( pathOut+"/_markdown.css")){markdowncss=Fs.load( pathOut+"/_markdown.css" );}
		if(Fs.exists( pathOut+"/_style.css")){stylecss=Fs.load( pathOut+"/_style.css" );}
		if(Fs.exists( pathOut+"/_template.mustache")){templatemustache=Fs.load( pathOut+"/_template.mustache" );}
		if(Fs.exists( pathOut+"/_template.mustache")){templatemustache=Fs.load( pathOut+"/_template.mustache" );}
	}

	}





}