package m2h.tree;

class Leaf {


	private var parentArbo:Arbo;

	private var title:String;
	private var subtitles:Array<String>;
	private var ressources:Array<String>;

	private var content:String;


	private var vir_path:String;

	private var fileName:String;
	private var simpleName:String;

	private var index:Bool;


public function new(parentArbo:Arbo,fileName:String){

this.parentArbo=parentArbo;
this.fileName=fileName;
this.title=fileName;
this.simpleName="";

this.subtitles=[];
this.ressources=[];

}

public function setTitle(title:String){
		this.title=title;
}

public function getTitle():String{
		return this.title;
}

public function setSubtitles(subtitles:Array<String>){
		this.subtitles=subtitles;
}

public function getSubtitles():Array<String>{
		return this.subtitles;
}

public function setRessources(ressources:Array<String>){
		this.ressources=ressources;
}

public function getRessources():Array<String>{
		return this.ressources;
}

public function getParent():Arbo{
		return this.parentArbo;
}

public function setContent(content:String){
		this.content=content;
}

public function getContent():String{
		return this.content;
}

public function setFileName(fileName:String){
		this.fileName=fileName;
}

public function getFileName():String{
		return this.content;
}

public function setSimpleName(simpleName:String){
		this.simpleName=simpleName;
}

public function getSimpleName():String{
		return this.simpleName;
}


}